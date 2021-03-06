/*
 * 3D City Database - The Open Source CityGML Database
 * http://www.3dcitydb.org/
 * 
 * Copyright 2013 - 2017
 * Chair of Geoinformatics
 * Technical University of Munich, Germany
 * https://www.gis.bgu.tum.de/
 * 
 * The 3D City Database is jointly developed with the following
 * cooperation partners:
 * 
 * virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
 * M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 *     
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.citydb.citygml.exporter.controller;

import org.citydb.citygml.common.database.cache.CacheTableManager;
import org.citydb.citygml.common.database.uid.UIDCacheManager;
import org.citydb.citygml.common.database.uid.UIDCacheType;
import org.citydb.citygml.common.database.xlink.DBXlink;
import org.citydb.citygml.exporter.CityGMLExportException;
import org.citydb.citygml.exporter.concurrent.DBExportWorkerFactory;
import org.citydb.citygml.exporter.concurrent.DBExportXlinkWorkerFactory;
import org.citydb.citygml.exporter.database.content.DBSplitter;
import org.citydb.citygml.exporter.database.content.DBSplittingResult;
import org.citydb.citygml.exporter.database.uid.FeatureGmlIdCache;
import org.citydb.citygml.exporter.database.uid.GeometryGmlIdCache;
import org.citydb.citygml.exporter.writer.FeatureWriteException;
import org.citydb.citygml.exporter.writer.FeatureWriter;
import org.citydb.citygml.exporter.writer.FeatureWriterFactory;
import org.citydb.citygml.exporter.writer.FeatureWriterFactoryBuilder;
import org.citydb.concurrent.PoolSizeAdaptationStrategy;
import org.citydb.concurrent.WorkerPool;
import org.citydb.config.Config;
import org.citydb.config.i18n.Language;
import org.citydb.config.project.database.DatabaseSrs;
import org.citydb.config.project.database.Workspace;
import org.citydb.config.project.exporter.TileNameSuffixMode;
import org.citydb.config.project.exporter.TileSuffixMode;
import org.citydb.config.project.exporter.TilingOptions;
import org.citydb.database.adapter.AbstractDatabaseAdapter;
import org.citydb.database.adapter.IndexStatusInfo.IndexType;
import org.citydb.database.connection.DatabaseConnectionPool;
import org.citydb.database.schema.mapping.SchemaMapping;
import org.citydb.event.Event;
import org.citydb.event.EventDispatcher;
import org.citydb.event.EventHandler;
import org.citydb.event.global.CounterEvent;
import org.citydb.event.global.CounterType;
import org.citydb.event.global.EventType;
import org.citydb.event.global.GeometryCounterEvent;
import org.citydb.event.global.InterruptEvent;
import org.citydb.event.global.ObjectCounterEvent;
import org.citydb.event.global.StatusDialogMessage;
import org.citydb.event.global.StatusDialogTitle;
import org.citydb.log.Logger;
import org.citydb.query.Query;
import org.citydb.query.builder.QueryBuildException;
import org.citydb.query.builder.config.ConfigQueryBuilder;
import org.citydb.query.filter.FilterException;
import org.citydb.query.filter.selection.Predicate;
import org.citydb.query.filter.selection.SelectionFilter;
import org.citydb.query.filter.selection.operator.logical.LogicalOperationFactory;
import org.citydb.query.filter.tiling.Tile;
import org.citydb.query.filter.tiling.Tiling;
import org.citydb.util.Util;
import org.citygml4j.builder.jaxb.CityGMLBuilder;
import org.citygml4j.model.citygml.cityobjectgroup.CityObjectGroup;
import org.citygml4j.model.gml.GMLClass;
import org.citygml4j.model.module.citygml.CityGMLModuleType;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.atomic.AtomicBoolean;

public class Exporter implements EventHandler {
	private final Logger log = Logger.getInstance();

	private final CityGMLBuilder cityGMLBuilder;
	private final AbstractDatabaseAdapter databaseAdapter;
	private final SchemaMapping schemaMapping;
	private final Config config;
	private final EventDispatcher eventDispatcher;
	private DBSplitter dbSplitter;

	private volatile boolean shouldRun = true;
	private AtomicBoolean isInterrupted = new AtomicBoolean(false);

	private WorkerPool<DBSplittingResult> dbWorkerPool;
	private WorkerPool<DBXlink> xlinkExporterPool;
	private CacheTableManager cacheTableManager;
	private UIDCacheManager uidCacheManager;
	private boolean useTiling;

	private HashMap<Integer, Long> objectCounter;
	private EnumMap<GMLClass, Long> geometryCounter;
	private HashMap<Integer, Long> totalObjectCounter;
	private EnumMap<GMLClass, Long> totalGeometryCounter;	

	public Exporter(CityGMLBuilder cityGMLBuilder, 
			SchemaMapping schemaMapping, 
			Config config, 
			EventDispatcher eventDispatcher) {
		this.cityGMLBuilder = cityGMLBuilder;
		this.schemaMapping = schemaMapping;
		this.config = config;
		this.eventDispatcher = eventDispatcher;

		databaseAdapter = DatabaseConnectionPool.getInstance().getActiveDatabaseAdapter();
		objectCounter = new HashMap<>();
		geometryCounter = new EnumMap<>(GMLClass.class);
		totalObjectCounter = new HashMap<>();
		totalGeometryCounter = new EnumMap<>(GMLClass.class);
	}

	public void cleanup() {
		eventDispatcher.removeEventHandler(this);
	}

	public boolean doProcess() throws CityGMLExportException {
		// adding listeners
		eventDispatcher.addEventHandler(EventType.OBJECT_COUNTER, this);
		eventDispatcher.addEventHandler(EventType.GEOMETRY_COUNTER, this);
		eventDispatcher.addEventHandler(EventType.INTERRUPT, this);

		// checking workspace
		Workspace workspace = config.getProject().getDatabase().getWorkspaces().getExportWorkspace();
		if (shouldRun && databaseAdapter.hasVersioningSupport() && 
				!databaseAdapter.getWorkspaceManager().equalsDefaultWorkspaceName(workspace.getName()) &&
				!databaseAdapter.getWorkspaceManager().existsWorkspace(workspace, true))
			return false;

		// build query from filter settings
		Query query = null;
		try {
			ConfigQueryBuilder queryBuilder = new ConfigQueryBuilder(schemaMapping, databaseAdapter);

			if (config.getProject().getExporter().isSetGenericQuery()) {
				log.info("Found generic filter settings in config file.");
				log.info("IGNORING filter settings in export dialog.");
				query = queryBuilder.buildQuery(config.getProject().getExporter().getGenericQuery(), config.getProject().getNamespaceFilter());
			} else
				query = queryBuilder.buildQuery(config.getProject().getExporter().getQuery(), config.getProject().getNamespaceFilter());

		} catch (QueryBuildException e) {
			throw new CityGMLExportException("Failed to build the export query expression.", e);
		}

		// create feature writer factory
		FeatureWriterFactory writerFactory = FeatureWriterFactoryBuilder.buildFactory(query, config);

		// set target reference system for export
		DatabaseSrs targetSRS = query.getTargetSRS();
		config.getInternal().setTransformCoordinates(targetSRS.isSupported() && 
				targetSRS.getSrid() != databaseAdapter.getConnectionMetaData().getReferenceSystem().getSrid());

		if (config.getInternal().isTransformCoordinates()) {
			if (targetSRS.is3D() == databaseAdapter.getConnectionMetaData().getReferenceSystem().is3D()) {
				log.info("Transforming geometry representation to reference system '" + targetSRS.getDescription() + "' (SRID: " + targetSRS.getSrid() + ").");
				log.warn("Transformation is NOT applied to height reference system.");
			} else {
				throw new CityGMLExportException("Dimensionality of reference system for geometry transformation does not match.");
			}
		}

		// check and log index status
		try {
			if ((query.isSetTiling() || (query.isSetSelection() && query.getSelection().containsSpatialOperators()))
					&& !databaseAdapter.getUtil().isIndexEnabled("CITYOBJECT", "ENVELOPE")) {
				log.error("Spatial indexes are not activated.");
				log.error("Please use the database tab to activate the spatial indexes.");
				return false;
			}

			for (IndexType type : IndexType.values())
				databaseAdapter.getUtil().getIndexStatus(type).printStatusToConsole();
		} catch (SQLException e) {
			throw new CityGMLExportException("Database error while querying index status.", e);
		}

		// check whether database contains global appearances and set internal flag
		try {
			config.getInternal().setExportGlobalAppearances(config.getProject().getExporter().getAppearances().isSetExportAppearance() && 
					databaseAdapter.getUtil().getNumGlobalAppearances(workspace) > 0);
		} catch (SQLException e) {
			throw new CityGMLExportException("Database error while querying the number of global appearances.", e);
		}

		// cache gml:ids of city objects in case we have to export groups
		config.getInternal().setRegisterGmlIdInCache(!config.getProject().getExporter().getCityObjectGroup().isExportMemberAsXLinks()
				&& query.getFeatureTypeFilter().containsFeatureType(schemaMapping.getFeatureType(query.getTargetVersion().getCityGMLModule(CityGMLModuleType.CITY_OBJECT_GROUP).getFeatureName(CityObjectGroup.class))));

		// tiling
		Tiling tiling = query.getTiling();
		TilingOptions tilingOptions = null;
		Predicate predicate = null;
		useTiling = query.isSetTiling();
		int rows = useTiling ? tiling.getRows() : 1;  
		int columns = useTiling ? tiling.getColumns() : 1;

		if (useTiling) {
			try {
				// transform tiling extent to database srs
				tiling.transformExtent(databaseAdapter.getConnectionMetaData().getReferenceSystem(), databaseAdapter);
				predicate = query.isSetSelection() ? query.getSelection().getPredicate() : null;
				tilingOptions = tiling.getTilingOptions() instanceof TilingOptions ? (TilingOptions)tiling.getTilingOptions() : new TilingOptions();
			} catch (FilterException e) {
				throw new CityGMLExportException("Failed to transform tiling extent.", e);
			}
		}

		// prepare files and folders
		File exportFile = new File(config.getInternal().getExportFileName());
		String fileName = exportFile.getName();
		String folderName = exportFile.getAbsoluteFile().getParent();

		String fileExtension = Util.getFileExtension(fileName);		
		if (fileExtension == null)
			fileExtension = "gml";
		else
			fileName = Util.stripFileExtension(fileName);

		File folder = new File(folderName);
		if (!folder.exists() && !folder.mkdirs())
			throw new CityGMLExportException("Failed to create folder '" + folderName + "'.");

		int remainingTiles = rows * columns;
		long start = System.currentTimeMillis();

		for (int i = 0; shouldRun && i < rows; i++) {
			for (int j = 0; shouldRun && j < columns; j++) {
				FeatureWriter writer = null;

				try {
					File file = null;

					if (useTiling) {
						Tile tile = null;

						try {
							tile = tiling.getTileAt(i, j);
							tiling.setActiveTile(tile);

							Predicate bboxFilter = tile.getFilterPredicate(databaseAdapter);
							if (predicate != null)
								query.setSelection(new SelectionFilter(LogicalOperationFactory.AND(predicate, bboxFilter)));
							else
								query.setSelection(new SelectionFilter(bboxFilter));

						} catch (FilterException e) {
							throw new CityGMLExportException("Failed to get tile at [" + i + "," + j + "].", e);
						}

						// create suffix for folderName and fileName
						TileSuffixMode suffixMode = tilingOptions.getTilePathSuffix();
						String suffix = "";

						double minX = tile.getExtent().getLowerCorner().getX();
						double minY = tile.getExtent().getLowerCorner().getY();
						double maxX = tile.getExtent().getUpperCorner().getX();
						double maxY = tile.getExtent().getUpperCorner().getY();

						switch (suffixMode) {
						case XMIN_YMIN:
							suffix = String.valueOf(minX) + '_' + String.valueOf(minY);
							break;
						case XMAX_YMIN:
							suffix = String.valueOf(maxX) + '_' + String.valueOf(minY);
							break;
						case XMIN_YMAX:
							suffix = String.valueOf(minX) + '_' + String.valueOf(maxY);
							break;
						case XMAX_YMAX:
							suffix = String.valueOf(maxX) + '_' + String.valueOf(maxY);
							break;
						case XMIN_YMIN_XMAX_YMAX:
							suffix = String.valueOf(minX) + '_' + String.valueOf(minY) + '_' + String.valueOf(maxX) + '_' + String.valueOf(maxY);
							break;
						default:
							suffix = String.valueOf(i) + '_' + String.valueOf(j);
						}

						File subfolder = new File(folderName, tilingOptions.getTilePath() + '_'  + suffix);
						if (!subfolder.exists() && !subfolder.mkdirs())
							throw new CityGMLExportException("Failed to create tiling subfolder '" + subfolder + "'.");

						if (tilingOptions.getTileNameSuffix() == TileNameSuffixMode.SAME_AS_PATH)
							file = new File(subfolder, fileName + '_'  + suffix + '.' + fileExtension);
						else // no suffix for filename
							file = new File(subfolder, fileName + '.' + fileExtension);
					}

					else // no tiling
						file = new File(folderName, fileName + '.' + fileExtension);

					config.getInternal().setExportFileName(file.getAbsolutePath());
					File path = new File(file.getAbsolutePath());
					config.getInternal().setExportPath(path.getParent());

					eventDispatcher.triggerEvent(new StatusDialogMessage(Language.I18N.getString("export.dialog.cityObj.msg"), this));
					eventDispatcher.triggerEvent(new StatusDialogTitle(file.getName(), this));
					eventDispatcher.triggerEvent(new CounterEvent(CounterType.REMAINING_TILES, --remainingTiles, this));

					// checking export path for texture images
					if (config.getProject().getExporter().getAppearances().isSetExportAppearance()) {
						String textureExportPath = null;
						boolean isRelative = config.getProject().getExporter().getAppearances().getTexturePath().isRelative();

						if (isRelative)
							textureExportPath = config.getProject().getExporter().getAppearances().getTexturePath().getRelativePath();
						else
							textureExportPath = config.getProject().getExporter().getAppearances().getTexturePath().getAbsolutePath();

						if (textureExportPath != null && textureExportPath.length() > 0) {
							File tmp = new File(textureExportPath);
							textureExportPath = tmp.getPath();

							if (isRelative) {
								File exportPath = new File(path.getParent(), textureExportPath);

								if (exportPath.isFile() || (exportPath.isDirectory() && !exportPath.canWrite())) {
									throw new CityGMLExportException("Failed to open texture files subfolder '" + exportPath.toString() + "' for writing.");
								} else if (!exportPath.isDirectory()) {
									boolean success = exportPath.mkdirs();

									if (!success)
										throw new CityGMLExportException("Failed to create texture files subfolder '" + exportPath.toString() + "'.");
									else
										log.info("Created texture files subfolder '" + textureExportPath + "'.");
								}

								config.getInternal().setExportTextureFilePath(textureExportPath);
							} else {
								File exportPath = new File(tmp.getAbsolutePath());
								if (!exportPath.exists() || !exportPath.isDirectory() || !exportPath.canWrite())
									throw new CityGMLExportException("Failed to open texture files folder '" + exportPath.toString() + "' for writing.");

								config.getInternal().setExportTextureFilePath(exportPath.toString());
							}
						}
					}

					// create output writer
					try {
						writer = writerFactory.createFeatureWriter(new OutputStreamWriter(new FileOutputStream(file), "UTF-8"));
					} catch (UnsupportedEncodingException | FileNotFoundException | FeatureWriteException e) {
						throw new CityGMLExportException("Failed to open file '" + fileName + "' for writing.", e);
					}

					// create instance of temp table manager
					try {
						cacheTableManager = new CacheTableManager(
								config.getProject().getExporter().getResources().getThreadPool().getDefaultPool().getMaxThreads(), 
								config);
					} catch (SQLException | IOException e) {
						throw new CityGMLExportException("Failed to initialize internal cache manager.", e);
					}

					// create instance of gml:id lookup server manager...
					uidCacheManager = new UIDCacheManager();

					// ...and start servers
					try {		
						uidCacheManager.initCache(
								UIDCacheType.GEOMETRY,
								new GeometryGmlIdCache(cacheTableManager, 
										config.getProject().getExporter().getResources().getGmlIdCache().getGeometry().getPartitions(),
										config.getProject().getDatabase().getUpdateBatching().getGmlIdCacheBatchValue()),
								config.getProject().getExporter().getResources().getGmlIdCache().getGeometry().getCacheSize(),
								config.getProject().getExporter().getResources().getGmlIdCache().getGeometry().getPageFactor(),
								config.getProject().getExporter().getResources().getThreadPool().getDefaultPool().getMaxThreads());

						uidCacheManager.initCache(
								UIDCacheType.OBJECT,
								new FeatureGmlIdCache(cacheTableManager, 
										config.getProject().getExporter().getResources().getGmlIdCache().getFeature().getPartitions(), 
										config.getProject().getDatabase().getUpdateBatching().getGmlIdCacheBatchValue()),
								config.getProject().getExporter().getResources().getGmlIdCache().getFeature().getCacheSize(),
								config.getProject().getExporter().getResources().getGmlIdCache().getFeature().getPageFactor(),
								config.getProject().getExporter().getResources().getThreadPool().getDefaultPool().getMaxThreads());
					} catch (SQLException e) {
						throw new CityGMLExportException("Failed to initialize internal gml:id caches.", e);
					}	

					// create worker pools
					// here we have an open issue: queue sizes are fix...
					xlinkExporterPool = new WorkerPool<DBXlink>(
							"xlink_exporter_pool",
							1,
							Math.max(1, config.getProject().getExporter().getResources().getThreadPool().getDefaultPool().getMaxThreads() / 2),
							PoolSizeAdaptationStrategy.AGGRESSIVE,
							new DBExportXlinkWorkerFactory(config, eventDispatcher),
							300,
							false);

					dbWorkerPool = new WorkerPool<DBSplittingResult>(
							"db_exporter_pool",
							config.getProject().getExporter().getResources().getThreadPool().getDefaultPool().getMinThreads(),
							config.getProject().getExporter().getResources().getThreadPool().getDefaultPool().getMaxThreads(),
							PoolSizeAdaptationStrategy.AGGRESSIVE,
							new DBExportWorkerFactory(
									schemaMapping,
									cityGMLBuilder,
									writer,
									xlinkExporterPool,
									uidCacheManager,
									cacheTableManager,
									query,
									config,
									eventDispatcher),
							300,
							false);

					// prestart pool workers
					xlinkExporterPool.prestartCoreWorkers();
					dbWorkerPool.prestartCoreWorkers();

					// fail if we could not start a single import worker
					if (dbWorkerPool.getPoolSize() == 0)
						throw new CityGMLExportException("Failed to start database export worker pool. Check the database connection pool settings.");

					// ok, preparations done. inform user...
					log.info("Exporting to file: " + file.getAbsolutePath());

					// get database splitter and start query
					dbSplitter = null;
					try {
						dbSplitter = new DBSplitter(
								schemaMapping,
								dbWorkerPool,
								query,
								uidCacheManager.getCache(UIDCacheType.OBJECT),
								cacheTableManager,
								eventDispatcher,
								config);

						if (shouldRun) {
							dbSplitter.setCalculateNumberMatched(true);
							dbSplitter.startQuery();
						}
					} catch (SQLException | QueryBuildException | FilterException e) {
						throw new CityGMLExportException("Failed to query the database.", e);
					}

					try {
						dbWorkerPool.shutdownAndWait();
						xlinkExporterPool.shutdownAndWait();
					} catch (InterruptedException e) {
						throw new CityGMLExportException("Failed to shutdown worker pools.", e);
					}

					eventDispatcher.triggerEvent(new StatusDialogMessage(Language.I18N.getString("export.dialog.finish.msg"), this));
				} finally {
					// close writer
					try {
						writer.close();
					} catch (FeatureWriteException e) {
						//
					}
					
					// clean up
					if (xlinkExporterPool != null && !xlinkExporterPool.isTerminated())
						xlinkExporterPool.shutdownNow();

					if (dbWorkerPool != null && !dbWorkerPool.isTerminated())
						dbWorkerPool.shutdownNow();

					try {
						eventDispatcher.flushEvents();
					} catch (InterruptedException e) {
						//
					}

					if (uidCacheManager != null) {
						try {
							uidCacheManager.shutdownAll();
						} catch (SQLException e) {
							throw new CityGMLExportException("Failed to clean gml:id caches.", e);
						}
					}

					if (cacheTableManager != null) {
						try {
							log.info("Cleaning temporary cache.");
							cacheTableManager.dropAll();
							cacheTableManager = null;
						} catch (SQLException e) {
							throw new CityGMLExportException("Failed to clean temporary cache.", e);
						}					
					}
				}

				// show exported features
				if (!objectCounter.isEmpty()) {
					log.info("Exported city objects:");
					Map<String, Long> typeNames = Util.mapObjectCounter(objectCounter, schemaMapping);					
					typeNames.keySet().stream().sorted().forEach(object -> log.info(object + ": " + typeNames.get(object)));			
				}

				// show processed geometries
				if (!geometryCounter.isEmpty())
					log.info("Processed geometry objects: " + geometryCounter.values().stream().reduce(0l, Long::sum));

				objectCounter.clear();
				geometryCounter.clear();
			}
		}

		// show totally exported features
		if (useTiling && (rows > 1 || columns > 1)) {
			if (!totalObjectCounter.isEmpty()) {
				log.info("Total exported CityGML features:");
				Map<String, Long> typeNames = Util.mapObjectCounter(totalObjectCounter, schemaMapping);
				typeNames.keySet().forEach(object -> log.info(object + ": " + typeNames.get(object)));	
			}

			if (!totalGeometryCounter.isEmpty())
				log.info("Total processed objects: " + totalGeometryCounter.values().stream().reduce(0l, Long::sum));
		}

		if (shouldRun)
			log.info("Total export time: " + Util.formatElapsedTime(System.currentTimeMillis() - start) + ".");

		return shouldRun;
	}

	@Override
	public void handleEvent(Event e) throws Exception {
		if (e.getEventType() == EventType.OBJECT_COUNTER) {
			HashMap<Integer, Long> counter = ((ObjectCounterEvent)e).getCounter();

			for (Entry<Integer, Long> entry : counter.entrySet()) {
				Long tmp = objectCounter.get(entry.getKey());
				objectCounter.put(entry.getKey(), tmp == null ? entry.getValue() : tmp + entry.getValue());

				if (useTiling) {
					tmp = totalObjectCounter.get(entry.getKey());
					totalObjectCounter.put(entry.getKey(), tmp == null ? entry.getValue() : tmp + entry.getValue());
				}
			}
		}

		else if (e.getEventType() == EventType.GEOMETRY_COUNTER) {
			HashMap<GMLClass, Long> counter = ((GeometryCounterEvent)e).getCounter();

			for (Entry<GMLClass, Long> entry : counter.entrySet()) {
				Long tmp = geometryCounter.get(entry.getKey());
				geometryCounter.put(entry.getKey(), tmp == null ? entry.getValue() : tmp + entry.getValue());

				if (useTiling) {
					tmp = totalGeometryCounter.get(entry.getKey());
					totalGeometryCounter.put(entry.getKey(), tmp == null ? entry.getValue() : tmp + entry.getValue());
				}
			}
		}

		else if (e.getEventType() == EventType.INTERRUPT) {
			if (isInterrupted.compareAndSet(false, true)) {
				shouldRun = false;
				InterruptEvent interruptEvent = (InterruptEvent)e;

				if (interruptEvent.getCause() != null) {
					Throwable cause = interruptEvent.getCause();

					if (cause instanceof SQLException) {
						Iterator<Throwable> iter = ((SQLException)cause).iterator();
						log.error("A SQL error occurred: " + iter.next().getMessage());
						while (iter.hasNext())
							log.error("Cause: " + iter.next().getMessage());
					} else {
						log.error("An error occurred: " + cause.getMessage());
						while ((cause = cause.getCause()) != null)
							log.error("Cause: " + cause.getMessage());
					}
				}

				String msg = interruptEvent.getLogMessage();
				if (msg != null)
					log.log(interruptEvent.getLogLevelType(), msg);

				if (dbSplitter != null)
					dbSplitter.shutdown();

				if (dbWorkerPool != null)
					dbWorkerPool.drainWorkQueue();

				if (xlinkExporterPool != null)
					xlinkExporterPool.drainWorkQueue();
			}
		}
	}
}
