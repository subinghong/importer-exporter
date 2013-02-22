-- SIMPLE_INDEX.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Gerhard Koenig <gerhard.koenig@tu-berlin.de>
--              Claus Nagel <claus.nagel@tu-berlin.de>
--              Alexandra Stadler <stadler@igg.tu-berlin.de>
--
-- Conversion:  Laure Fraysse <Laure.fraysse@etumel.univmed.fr>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universitaet Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description     | Author | Conversion
-- 2.0.0     2012-05-21   PostGIS version    TKol     LFra
--                                           GKoe     FKun
--                                           CNag
--                                           ASta
--
CREATE INDEX ADDRESS_TO_BUILDING_FKX ON ADDRESS_TO_BUILDING (BUILDING_ID);
CREATE INDEX ADDRESS_TO_BUILDING_FKX1 ON ADDRESS_TO_BUILDING (ADDRESS_ID);

CREATE INDEX APPEARANCE_FKX ON APPEARANCE (CITYMODEL_ID);
CREATE INDEX APPEARANCE_FKX1 ON APPEARANCE (CITYOBJECT_ID);
CREATE INDEX APPEARANCE_INX ON APPEARANCE (GMLID, GMLID_CODESPACE);

CREATE INDEX BUILDING_FKX ON BUILDING (LOD1_GEOMETRY_ID);
CREATE INDEX BUILDING_FKX1 ON BUILDING (LOD2_GEOMETRY_ID);
CREATE INDEX BUILDING_FKX2 ON BUILDING (LOD3_GEOMETRY_ID);
CREATE INDEX BUILDING_FKX4 ON BUILDING (BUILDING_ROOT_ID);
CREATE INDEX BUILDING_FKX5 ON BUILDING (BUILDING_PARENT_ID);
CREATE INDEX BUILDING_FKX3 ON BUILDING (LOD4_GEOMETRY_ID);

CREATE INDEX BUILDING_FURNITURE_FKX ON BUILDING_FURNITURE (LOD4_GEOMETRY_ID);
CREATE INDEX BUILDING_FURNITURE_FKX1 ON BUILDING_FURNITURE (LOD4_IMPLICIT_REP_ID);
CREATE INDEX BUILDING_FURNITURE_FKX2 ON BUILDING_FURNITURE (ROOM_ID);

CREATE INDEX BUILDING_INSTALLATION_FKX ON BUILDING_INSTALLATION (LOD3_GEOMETRY_ID);
CREATE INDEX BUILDING_INSTALLATION_FKX1 ON BUILDING_INSTALLATION (ROOM_ID);
CREATE INDEX BUILDING_INSTALLATION_FKX2 ON BUILDING_INSTALLATION (LOD4_GEOMETRY_ID);
CREATE INDEX BUILDING_INSTALLATION_FKX3 ON BUILDING_INSTALLATION (LOD2_GEOMETRY_ID);
CREATE INDEX BUILDING_INSTALLATION_FKX4 ON BUILDING_INSTALLATION (BUILDING_ID);

CREATE INDEX CITYOBJECT_FKX ON CITYOBJECT (CLASS_ID);
CREATE INDEX CITYOBJECT_INX ON CITYOBJECT (GMLID, GMLID_CODESPACE);

CREATE INDEX CITYOBJECTGROUP_FKX ON CITYOBJECTGROUP (SURFACE_GEOMETRY_ID);
CREATE INDEX CITYOBJECTGROUP_FKX1 ON CITYOBJECTGROUP (PARENT_CITYOBJECT_ID);

CREATE INDEX CITYOBJ_GENERICATTRIB_FKX ON CITYOBJECT_GENERICATTRIB (CITYOBJECT_ID);
CREATE INDEX CITYOBJ_GENERICATTRIB_FKX1 ON CITYOBJECT_GENERICATTRIB (SURFACE_GEOMETRY_ID);

CREATE INDEX CITY_FURNITURE_FKX ON CITY_FURNITURE (LOD1_GEOMETRY_ID);
CREATE INDEX CITY_FURNITURE_FKX1 ON CITY_FURNITURE (LOD2_GEOMETRY_ID);
CREATE INDEX CITY_FURNITURE_FKX2 ON CITY_FURNITURE (LOD3_GEOMETRY_ID);
CREATE INDEX CITY_FURNITURE_FKX3 ON CITY_FURNITURE (LOD4_GEOMETRY_ID);
CREATE INDEX CITY_FURNITURE_FKX4 ON CITY_FURNITURE (LOD1_IMPLICIT_REP_ID);
CREATE INDEX CITY_FURNITURE_FKX5 ON CITY_FURNITURE (LOD2_IMPLICIT_REP_ID);
CREATE INDEX CITY_FURNITURE_FKX6 ON CITY_FURNITURE (LOD3_IMPLICIT_REP_ID);
CREATE INDEX CITY_FURNITURE_FKX7 ON CITY_FURNITURE (LOD4_IMPLICIT_REP_ID);

CREATE INDEX EXTERNAL_REFERENCE_FKX ON EXTERNAL_REFERENCE (CITYOBJECT_ID);

CREATE INDEX GENERIC_CITYOBJECT_FKX ON GENERIC_CITYOBJECT (LOD0_IMPLICIT_REP_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX1 ON GENERIC_CITYOBJECT (LOD1_IMPLICIT_REP_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX2 ON GENERIC_CITYOBJECT (LOD2_IMPLICIT_REP_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX3 ON GENERIC_CITYOBJECT (LOD3_IMPLICIT_REP_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX4 ON GENERIC_CITYOBJECT (LOD4_IMPLICIT_REP_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX5 ON GENERIC_CITYOBJECT (LOD0_GEOMETRY_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX6 ON GENERIC_CITYOBJECT (LOD1_GEOMETRY_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX7 ON GENERIC_CITYOBJECT (LOD2_GEOMETRY_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX8 ON GENERIC_CITYOBJECT (LOD3_GEOMETRY_ID);
CREATE INDEX GENERIC_CITYOBJECT_FKX9 ON GENERIC_CITYOBJECT (LOD4_GEOMETRY_ID);

CREATE INDEX IMPLICIT_GEOMETRY_FKX ON IMPLICIT_GEOMETRY (RELATIVE_GEOMETRY_ID);
CREATE INDEX IMPLICIT_GEOMETRY_INX ON IMPLICIT_GEOMETRY (REFERENCE_TO_LIBRARY);

CREATE INDEX LAND_USE_FKX ON LAND_USE (LOD0_MULTI_SURFACE_ID);
CREATE INDEX LAND_USE_FKX1 ON LAND_USE (LOD1_MULTI_SURFACE_ID);
CREATE INDEX LAND_USE_FKX2 ON LAND_USE (LOD2_MULTI_SURFACE_ID);
CREATE INDEX LAND_USE_FKX3 ON LAND_USE (LOD3_MULTI_SURFACE_ID);
CREATE INDEX LAND_USE_FKX4 ON LAND_USE (LOD4_MULTI_SURFACE_ID);

CREATE INDEX OBJECTCLASS_FKX ON OBJECTCLASS (SUPERCLASS_ID);

CREATE INDEX OPENING_FKX ON OPENING (ADDRESS_ID);
CREATE INDEX OPENING_FKX1 ON OPENING (LOD3_MULTI_SURFACE_ID);
CREATE INDEX OPENING_FKX2 ON OPENING (LOD4_MULTI_SURFACE_ID);

CREATE INDEX PLANT_COVER_FKX ON PLANT_COVER (LOD1_GEOMETRY_ID);
CREATE INDEX PLANT_COVER_FKX1 ON PLANT_COVER (LOD2_GEOMETRY_ID);
CREATE INDEX PLANT_COVER_FKX2 ON PLANT_COVER (LOD3_GEOMETRY_ID);
CREATE INDEX PLANT_COVER_FKX3 ON PLANT_COVER (LOD4_GEOMETRY_ID);

CREATE INDEX ROOM_FKX ON ROOM (BUILDING_ID);
CREATE INDEX ROOM_FKX1 ON ROOM (LOD4_GEOMETRY_ID);

CREATE INDEX SOLITARY_VEGETAT_OBJ_FKX1 ON SOLITARY_VEGETAT_OBJECT (LOD1_GEOMETRY_ID);
CREATE INDEX SOLITARY_VEGETAT_OBJ_FKX2 ON SOLITARY_VEGETAT_OBJECT (LOD2_GEOMETRY_ID);
CREATE INDEX SOLITARY_VEGETAT_OBJ_FKX3 ON SOLITARY_VEGETAT_OBJECT (LOD3_GEOMETRY_ID);
CREATE INDEX SOLITARY_VEGETAT_OBJ_FKX4 ON SOLITARY_VEGETAT_OBJECT (LOD4_GEOMETRY_ID);
CREATE INDEX SOLITARY_VEGETAT_OBJ_FKX5 ON SOLITARY_VEGETAT_OBJECT (LOD1_IMPLICIT_REP_ID);
CREATE INDEX SOLITARY_VEGETAT_OBJ_FKX6 ON SOLITARY_VEGETAT_OBJECT (LOD2_IMPLICIT_REP_ID);
CREATE INDEX SOLITARY_VEGETAT_OBJ_FKX7 ON SOLITARY_VEGETAT_OBJECT (LOD3_IMPLICIT_REP_ID);
CREATE INDEX SOLITARY_VEGETAT_OBJ_FKX8 ON SOLITARY_VEGETAT_OBJECT (LOD4_IMPLICIT_REP_ID);

CREATE INDEX SURFACE_DATA_INX ON SURFACE_DATA (GMLID, GMLID_CODESPACE);

CREATE INDEX APP_TO_SURF_DATA_FKX on APPEAR_TO_SURFACE_DATA (SURFACE_DATA_ID);
CREATE INDEX APP_TO_SURF_DATA_FKX1 on APPEAR_TO_SURFACE_DATA (APPEARANCE_ID);

CREATE INDEX SURFACE_GEOMETRY_FKX ON SURFACE_GEOMETRY (PARENT_ID);
CREATE INDEX SURFACE_GEOMETRY_FKX1 ON SURFACE_GEOMETRY (ROOT_ID);
CREATE INDEX SURFACE_GEOMETRY_INX ON SURFACE_GEOMETRY (GMLID, GMLID_CODESPACE);

CREATE INDEX TEXTUREPARAM_FKX ON TEXTUREPARAM (SURFACE_GEOMETRY_ID);
CREATE INDEX TEXTUREPARAM_FKX1 ON TEXTUREPARAM (SURFACE_DATA_ID);

CREATE INDEX THEMATIC_SURFACE_FKX ON THEMATIC_SURFACE (ROOM_ID);
CREATE INDEX THEMATIC_SURFACE_FKX1 ON THEMATIC_SURFACE (BUILDING_ID);
CREATE INDEX THEMATIC_SURFACE_FKX2 ON THEMATIC_SURFACE (LOD2_MULTI_SURFACE_ID);
CREATE INDEX THEMATIC_SURFACE_FKX3 ON THEMATIC_SURFACE (LOD3_MULTI_SURFACE_ID);
CREATE INDEX THEMATIC_SURFACE_FKX4 ON THEMATIC_SURFACE (LOD4_MULTI_SURFACE_ID);

CREATE INDEX TIN_RELIEF_FKX ON TIN_RELIEF (SURFACE_GEOMETRY_ID);

CREATE INDEX TRAFFIC_AREA_FKX ON TRAFFIC_AREA (LOD2_MULTI_SURFACE_ID);
CREATE INDEX TRAFFIC_AREA_FKX1 ON TRAFFIC_AREA (LOD3_MULTI_SURFACE_ID);
CREATE INDEX TRAFFIC_AREA_FKX2 ON TRAFFIC_AREA (LOD4_MULTI_SURFACE_ID);
CREATE INDEX TRAFFIC_AREA_FKX3 ON TRAFFIC_AREA (TRANSPORTATION_COMPLEX_ID);

CREATE INDEX TRAN_COMPLEX_FKX1 ON TRANSPORTATION_COMPLEX (LOD1_MULTI_SURFACE_ID);
CREATE INDEX TRAN_COMPLEX_FKX2 ON TRANSPORTATION_COMPLEX (LOD2_MULTI_SURFACE_ID);
CREATE INDEX TRAN_COMPLEX_FKX3 ON TRANSPORTATION_COMPLEX (LOD3_MULTI_SURFACE_ID);
CREATE INDEX TRAN_COMPLEX_FKX4 ON TRANSPORTATION_COMPLEX (LOD4_MULTI_SURFACE_ID);

CREATE INDEX WATERBODY_FKX1 ON WATERBODY (LOD2_SOLID_ID);
CREATE INDEX WATERBODY_FKX2 ON WATERBODY (LOD3_SOLID_ID);
CREATE INDEX WATERBODY_FKX3 ON WATERBODY (LOD4_SOLID_ID);
CREATE INDEX WATERBODY_FKX5 ON WATERBODY (LOD1_MULTI_SURFACE_ID);
CREATE INDEX WATERBODY_FKX4 ON WATERBODY (LOD0_MULTI_SURFACE_ID);
CREATE INDEX WATERBODY_FKX ON WATERBODY (LOD1_SOLID_ID);

CREATE INDEX WATERBOUNDARY_SURFACE_FKX ON WATERBOUNDARY_SURFACE (LOD2_SURFACE_ID);
CREATE INDEX WATERBOUNDARY_SURFACE_FKX1 ON WATERBOUNDARY_SURFACE (LOD3_SURFACE_ID);
CREATE INDEX WATERBOUNDARY_SURFACE_FKX2 ON WATERBOUNDARY_SURFACE (LOD4_SURFACE_ID);