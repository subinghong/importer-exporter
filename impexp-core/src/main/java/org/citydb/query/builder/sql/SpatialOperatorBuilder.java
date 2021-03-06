package org.citydb.query.builder.sql;

import java.sql.SQLException;
import java.util.Set;

import javax.measure.converter.ConversionException;
import javax.measure.converter.UnitConverter;
import javax.measure.unit.SI;
import javax.measure.unit.Unit;

import org.citydb.config.geometry.GeometryObject;
import org.citydb.config.project.database.DatabaseSrs;
import org.citydb.database.adapter.AbstractDatabaseAdapter;
import org.citydb.database.schema.mapping.FeatureType;
import org.citydb.database.schema.mapping.GeometryProperty;
import org.citydb.database.schema.mapping.MappingConstants;
import org.citydb.database.schema.mapping.SchemaMapping;
import org.citydb.database.schema.path.InvalidSchemaPathException;
import org.citydb.database.schema.path.SchemaPath;
import org.citydb.query.Query;
import org.citydb.query.builder.QueryBuildException;
import org.citydb.query.filter.selection.expression.ExpressionName;
import org.citydb.query.filter.selection.expression.ValueReference;
import org.citydb.query.filter.selection.operator.spatial.AbstractSpatialOperator;
import org.citydb.query.filter.selection.operator.spatial.BinarySpatialOperator;
import org.citydb.query.filter.selection.operator.spatial.Distance;
import org.citydb.query.filter.selection.operator.spatial.DistanceOperator;
import org.citydb.query.filter.selection.operator.spatial.DistanceUnit;
import org.citydb.query.filter.selection.operator.spatial.SpatialOperatorName;
import org.citygml4j.model.module.gml.GMLCoreModule;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.crs.CoordinateReferenceSystem;

import org.citydb.sqlbuilder.schema.Column;
import org.citydb.sqlbuilder.schema.Table;
import org.citydb.sqlbuilder.select.PredicateToken;
import org.citydb.sqlbuilder.select.ProjectionToken;
import org.citydb.sqlbuilder.select.Select;
import org.citydb.sqlbuilder.select.operator.comparison.ComparisonFactory;
import org.citydb.sqlbuilder.select.operator.logical.LogicalOperationFactory;

public class SpatialOperatorBuilder {
	private final Query query;
	private final SchemaPathBuilder schemaPathBuilder;
	private final Set<Integer> objectclassIds;
	private final SchemaMapping schemaMapping;
	private final AbstractDatabaseAdapter databaseAdapter;
	private final String schemaName;

	protected SpatialOperatorBuilder(Query query, SchemaPathBuilder schemaPathBuilder, Set<Integer> objectclassIds, SchemaMapping schemaMapping, AbstractDatabaseAdapter databaseAdapter, String schemaName) {
		this.query = query;
		this.schemaPathBuilder = schemaPathBuilder;
		this.objectclassIds = objectclassIds;
		this.schemaMapping = schemaMapping;
		this.databaseAdapter = databaseAdapter;
		this.schemaName = schemaName;
	}

	protected SQLQueryContext buildSpatialOperator(AbstractSpatialOperator operator, boolean negate) throws QueryBuildException {
		SQLQueryContext queryContext = null;

		switch (operator.getOperatorName()) {
		case BBOX:
		case EQUALS:
		case DISJOINT:
		case TOUCHES:
		case WITHIN:
		case OVERLAPS:
		case INTERSECTS:
		case CONTAINS:
			queryContext = buildBinaryOperator((BinarySpatialOperator)operator, negate);
			break;
		case DWITHIN:
		case BEYOND:
			queryContext = buildDistanceOperator((DistanceOperator)operator, negate);
			break;
		}

		return queryContext;
	}

	private SQLQueryContext buildBinaryOperator(BinarySpatialOperator operator, boolean negate) throws QueryBuildException {
		if (!SpatialOperatorName.BINARY_SPATIAL_OPERATORS.contains(operator.getOperatorName()))
			throw new QueryBuildException(operator.getOperatorName() + " is not a binary spatial operator.");

		ValueReference valueReference = null;
		GeometryObject spatialDescription = operator.getSpatialDescription();

		// we currently only support ValueReference as left operand	
		if (operator.getLeftOperand() != null && operator.getLeftOperand().getExpressionName() == ExpressionName.VALUE_REFERENCE)
			valueReference = (ValueReference)operator.getLeftOperand();

		if (valueReference == null && operator.getOperatorName() != SpatialOperatorName.BBOX)
			throw new QueryBuildException("The spatial " + operator.getOperatorName() + " operator requires a ValueReference pointing to the geometry property to be tested.");

		if (spatialDescription == null)
			throw new QueryBuildException("The spatial description may not be null.");

		if (valueReference == null)
			valueReference = getBoundedByProperty(query);

		// transform coordinate values if required
		DatabaseSrs targetSrs = databaseAdapter.getConnectionMetaData().getReferenceSystem();

		if (spatialDescription.getSrid() != targetSrs.getSrid()) {
			try {
				spatialDescription = databaseAdapter.getUtil().transform(spatialDescription, targetSrs);
			} catch (SQLException e) {
				throw new QueryBuildException("Failed to transform coordinates of test geometry: " + e.getMessage());
			}
		}

		// build the value reference and spatial predicate
		SQLQueryContext queryContext = schemaPathBuilder.buildSchemaPath(valueReference.getSchemaPath(), objectclassIds);

		GeometryProperty property = (GeometryProperty)valueReference.getSchemaPath().getLastNode().getPathElement();
		if (property.isSetInlineColumn()) {
			PredicateToken predicate = databaseAdapter.getSQLAdapter().getBinarySpatialPredicate(operator.getOperatorName(), queryContext.targetColumn, spatialDescription, negate);
			queryContext.select.addSelection(predicate);
		} else {
			if (operator.getOperatorName() == SpatialOperatorName.CONTAINS || operator.getOperatorName() == SpatialOperatorName.EQUALS)
				throw new QueryBuildException("The spatial " + operator.getOperatorName() + " operator is not supported for the geometry property '" + valueReference.getSchemaPath().getLastNode() + "'.");

			GeometryObject bbox = spatialDescription.toEnvelope();
			boolean all = operator.getOperatorName() == SpatialOperatorName.DISJOINT || operator.getOperatorName() == SpatialOperatorName.WITHIN;
			Table surfaceGeometry = new Table(MappingConstants.SURFACE_GEOMETRY, schemaName, schemaPathBuilder.getAliasGenerator());
			Table cityObject = getCityObjectTable(queryContext.select);

			Select inner = new Select()
					.addProjection(surfaceGeometry.getColumn(MappingConstants.ID))
					.addSelection(ComparisonFactory.equalTo(surfaceGeometry.getColumn(MappingConstants.ROOT_ID), queryContext.targetColumn))
					.addSelection(ComparisonFactory.isNotNull(surfaceGeometry.getColumn(MappingConstants.GEOMETRY)))
					.addSelection(databaseAdapter.getSQLAdapter().getBinarySpatialPredicate(operator.getOperatorName(), surfaceGeometry.getColumn(MappingConstants.GEOMETRY), spatialDescription, all));

			PredicateToken spatialPredicate = LogicalOperationFactory.AND(
					databaseAdapter.getSQLAdapter().getBinarySpatialPredicate(SpatialOperatorName.BBOX, cityObject.getColumn(MappingConstants.ENVELOPE), bbox, false),
					ComparisonFactory.exists(inner, all));

			if (negate)
				spatialPredicate = LogicalOperationFactory.NOT(spatialPredicate);

			queryContext.select
			.addSelection(ComparisonFactory.isNotNull(queryContext.getTargetColumn()))
			.addSelection(spatialPredicate);
		}

		// add optimizer hint if required
		if (databaseAdapter.getSQLAdapter().spatialPredicateRequiresNoIndexHint()
				&& queryContext.getTargetColumn().getName().equalsIgnoreCase(MappingConstants.ENVELOPE)) {
			queryContext.select.setOptimizerString(new StringBuilder("/*+ no_index(")
					.append(queryContext.getTargetColumn().getTable().getAlias())
					.append(" cityobject_objectclass_fkx) */").toString());
		}

		return queryContext;
	}

	private SQLQueryContext buildDistanceOperator(DistanceOperator operator, boolean negate) throws QueryBuildException {
		if (!SpatialOperatorName.DISTANCE_OPERATORS.contains(operator.getOperatorName()))
			throw new QueryBuildException(operator.getOperatorName() + " is not a distance operator.");

		ValueReference valueReference = null;
		GeometryObject spatialDescription = operator.getSpatialDescription();
		Distance distance = operator.getDistance();

		// we currently only support ValueReference as left operand	
		if (operator.getLeftOperand() != null && operator.getLeftOperand().getExpressionName() == ExpressionName.VALUE_REFERENCE)
			valueReference = (ValueReference)operator.getLeftOperand();
		else 
			valueReference = getBoundedByProperty(query);

		if (spatialDescription == null)
			throw new QueryBuildException("The spatial description may not be null.");

		// transform coordinate values if required
		DatabaseSrs targetSrs = databaseAdapter.getConnectionMetaData().getReferenceSystem();

		if (spatialDescription.getSrid() != targetSrs.getSrid()) {
			try {
				spatialDescription = databaseAdapter.getUtil().transform(spatialDescription, targetSrs);
			} catch (SQLException e) {
				throw new QueryBuildException("Failed to transform coordinates of test geometry: " + e.getMessage());
			}
		}

		// convert distance value into unit of srs
		Unit<?> srsUnit = null;
		DistanceUnit distanceUnit = distance.isSetUnit() ? distance.getUnit() : DistanceUnit.METER;
		UnitConverter converter = null;

		try {
			CoordinateReferenceSystem crs = databaseAdapter.getUtil().decodeDatabaseSrs(targetSrs);
			srsUnit = crs.getCoordinateSystem().getAxis(0).getUnit();
		} catch (FactoryException e) {
			// assume meter per default
			srsUnit = SI.METER;
		}

		try {
			converter = distanceUnit.toUnit().getConverterTo(srsUnit);
		} catch (ConversionException e) {
			throw new QueryBuildException("Cannot convert from the unit '" + distanceUnit + "' to the unit of the database SRS.");
		}

		double value = converter.convert(distance.getValue());

		// build the value reference and spatial predicate
		SQLQueryContext queryContext = schemaPathBuilder.buildSchemaPath(valueReference.getSchemaPath(), objectclassIds);		

		GeometryProperty property = (GeometryProperty)valueReference.getSchemaPath().getLastNode().getPathElement();
		if (property.isSetInlineColumn()) {
			PredicateToken predicate = databaseAdapter.getSQLAdapter().getDistancePredicate(operator.getOperatorName(), queryContext.targetColumn, spatialDescription, value, negate);
			queryContext.select.addSelection(predicate);
		} else {
			SpatialOperatorName operatorName = operator.getOperatorName();
			if (operatorName == SpatialOperatorName.BEYOND) {
				operatorName = SpatialOperatorName.DWITHIN;
				negate = !negate;
			}

			// get bbox of query geometry and buffer it by the distance
			GeometryObject bbox = spatialDescription.toEnvelope();
			double[] coords = bbox.getCoordinates(0);
			coords[0] -= value;
			coords[1] -= value;
			coords[bbox.getDimension()] += value;
			coords[bbox.getDimension() + 1] += value;

			Table surfaceGeometry = new Table(MappingConstants.SURFACE_GEOMETRY, schemaName, schemaPathBuilder.getAliasGenerator());
			Table cityObject = getCityObjectTable(queryContext.select);

			Select inner = new Select()
					.addProjection(surfaceGeometry.getColumn(MappingConstants.ID))
					.addSelection(ComparisonFactory.equalTo(surfaceGeometry.getColumn(MappingConstants.ROOT_ID), queryContext.targetColumn))
					.addSelection(ComparisonFactory.isNotNull(surfaceGeometry.getColumn(MappingConstants.GEOMETRY)))
					.addSelection(databaseAdapter.getSQLAdapter().getDistancePredicate(operatorName, surfaceGeometry.getColumn(MappingConstants.GEOMETRY), spatialDescription, value, false));

			PredicateToken spatialPredicate = LogicalOperationFactory.AND(
					databaseAdapter.getSQLAdapter().getBinarySpatialPredicate(SpatialOperatorName.BBOX, cityObject.getColumn(MappingConstants.ENVELOPE), bbox, false),
					ComparisonFactory.exists(inner, false));

			if (negate)
				spatialPredicate = LogicalOperationFactory.NOT(spatialPredicate);

			queryContext.select
			.addSelection(ComparisonFactory.isNotNull(queryContext.getTargetColumn()))
			.addSelection(spatialPredicate);
		}

		// add optimizer hint if required
		if (databaseAdapter.getSQLAdapter().spatialPredicateRequiresNoIndexHint()
				&& queryContext.getTargetColumn().getName().equalsIgnoreCase(MappingConstants.ENVELOPE)) {
			queryContext.select.setOptimizerString(new StringBuilder("/*+ no_index(")
					.append(queryContext.getTargetColumn().getTable().getAlias())
					.append(" cityobject_objectclass_fkx) */").toString());
		}

		return queryContext;
	}

	private ValueReference getBoundedByProperty(Query query) throws QueryBuildException {
		try {
			FeatureType superType = schemaMapping.getCommonSuperType(query.getFeatureTypeFilter().getFeatureTypes());	
			SchemaPath path = new SchemaPath(superType);	
			path.appendChild(superType.getProperty("boundedBy", GMLCoreModule.v3_1_1.getNamespaceURI(), true));
			return new ValueReference(path);
		} catch (InvalidSchemaPathException e) {
			throw new QueryBuildException(e.getMessage());
		}
	}

	private Table getCityObjectTable(Select select) throws QueryBuildException {	
		for (ProjectionToken token : select.getProjection()) {
			if (token instanceof Column && ((Column)token).getName().equals(MappingConstants.ID))
				return ((Column)token).getTable();
		}

		throw new QueryBuildException("Failed to retrieve cityobject table in query expression.");
	}

}
