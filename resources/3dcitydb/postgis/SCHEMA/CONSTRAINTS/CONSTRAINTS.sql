-- CONSTRAINTS.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <kolbe@igg.tu-berlin.de>
--              Gerhard Koenig <gerhard.koenig@tu-berlin.de>
--              Claus Nagel <nagel@igg.tu-berlin.de>
--              Alexandra Stadler <stadler@igg.tu-berlin.de>
--
-- Conversion:  Laure Fraysse <Laure.fraysse@etumel.univmed.fr>
--              Felix Kunde <felix-kunde@gmx.de>
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
--//ADDRESS_TO_BUILDING CONSTRAINTS

ALTER TABLE ADDRESS_TO_BUILDING
ADD CONSTRAINT ADDRESS_TO_BUILDING_FK FOREIGN KEY (BUILDING_ID)
REFERENCES BUILDING (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ADDRESS_TO_BUILDING
ADD CONSTRAINT ADDRESS_TO_BUILDING_ADDRESS_FK FOREIGN KEY (ADDRESS_ID)
REFERENCES ADDRESS (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//APPEARANCE CONSTRAINTS

ALTER TABLE APPEARANCE
ADD CONSTRAINT APPEARANCE_CITYMODEL_FK FOREIGN KEY (CITYMODEL_ID)
REFERENCES CITYMODEL (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE APPEARANCE
ADD CONSTRAINT APPEARANCE_CITYOBJECT_FK FOREIGN KEY (CITYOBJECT_ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//APPEAR_TO_SURFACE_DATA CONSTRAINT

ALTER TABLE APPEAR_TO_SURFACE_DATA
ADD CONSTRAINT APPEAR_TO_SURFACE_DATA_FK1 FOREIGN KEY (APPEARANCE_ID)
REFERENCES APPEARANCE (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE APPEAR_TO_SURFACE_DATA
ADD CONSTRAINT APPEAR_TO_SURFACE_DATA_FK FOREIGN KEY (SURFACE_DATA_ID)
REFERENCES SURFACE_DATA (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//BREAKLINE_RELIEF CONSTRAINT

ALTER TABLE BREAKLINE_RELIEF
ADD CONSTRAINT BREAKLINE_RELIEF_FK FOREIGN KEY (ID)
REFERENCES RELIEF_COMPONENT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//BUILDING CONSTRAINT

ALTER TABLE BUILDING
ADD CONSTRAINT BUILDING_SURFACE_GEOMETRY_FK FOREIGN KEY (LOD1_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING
ADD CONSTRAINT BUILDING_SURFACE_GEOMETRY_FK3 FOREIGN KEY (LOD4_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING
ADD CONSTRAINT BUILDING_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING
ADD CONSTRAINT BUILDING_SURFACE_GEOMETRY_FK1 FOREIGN KEY (LOD2_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING
ADD CONSTRAINT BUILDING_SURFACE_GEOMETRY_FK2 FOREIGN KEY (LOD3_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING
ADD CONSTRAINT BUILDING_BUILDING_FK FOREIGN KEY (BUILDING_PARENT_ID)
REFERENCES BUILDING (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING
ADD CONSTRAINT BUILDING_BUILDING_FK1 FOREIGN KEY (BUILDING_ROOT_ID)
REFERENCES BUILDING (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//BUILDING_FURNITURE CONSTRAINT

ALTER TABLE BUILDING_FURNITURE
ADD CONSTRAINT BUILDING_FURNITURE_FK1 FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING_FURNITURE
ADD CONSTRAINT BUILDING_FURNITURE_FK2 FOREIGN KEY (LOD4_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING_FURNITURE
ADD CONSTRAINT BUILDING_FURNITURE_FK FOREIGN KEY (LOD4_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING_FURNITURE
ADD CONSTRAINT BUILDING_FURNITURE_ROOM_FK FOREIGN KEY (ROOM_ID)
REFERENCES ROOM (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//BUILDING_INSTALLATION CONSTRAINT

ALTER TABLE BUILDING_INSTALLATION
ADD CONSTRAINT BUILDING_INSTALLATION_FK3 FOREIGN KEY (LOD3_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING_INSTALLATION
ADD CONSTRAINT BUILDING_INSTALLATION_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING_INSTALLATION
ADD CONSTRAINT BUILDING_INSTALLATION_ROOM_FK FOREIGN KEY (ROOM_ID)
REFERENCES ROOM (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING_INSTALLATION
ADD CONSTRAINT BUILDING_INSTALLATION_FK4 FOREIGN KEY (LOD4_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT; 

ALTER TABLE BUILDING_INSTALLATION
ADD CONSTRAINT BUILDING_INSTALLATION_FK1 FOREIGN KEY (BUILDING_ID)
REFERENCES BUILDING (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE BUILDING_INSTALLATION
ADD CONSTRAINT BUILDING_INSTALLATION_FK2 FOREIGN KEY (LOD2_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//CITYOBJECT CONSTRAINT

ALTER TABLE CITYOBJECT
ADD CONSTRAINT CITYOBJECT_OBJECTCLASS_FK FOREIGN KEY (CLASS_ID)
REFERENCES OBJECTCLASS (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//CITYOBJECTGROUP CONSTRAINT

ALTER TABLE CITYOBJECTGROUP
ADD CONSTRAINT CITYOBJECT_GROUP_FK FOREIGN KEY (SURFACE_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITYOBJECTGROUP
ADD CONSTRAINT CITYOBJECTGROUP_CITYOBJECT_FK FOREIGN KEY (PARENT_CITYOBJECT_ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITYOBJECTGROUP
ADD CONSTRAINT CITYOBJECTGROUP_CITYOBJECT_FK1 FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//CITYOBJECT_GENERICATTRIB CONSTRAINT

ALTER TABLE CITYOBJECT_GENERICATTRIB
ADD CONSTRAINT CITYOBJECT_GENERICATTRIB_FK FOREIGN KEY (CITYOBJECT_ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITYOBJECT_GENERICATTRIB
ADD CONSTRAINT CITYOBJECT_GENERICATTRIB_FK1 FOREIGN KEY (SURFACE_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//CITYOBJECT_MEMBER CONSTRAINT

ALTER TABLE CITYOBJECT_MEMBER
ADD CONSTRAINT CITYOBJECT_MEMBER_CITYMODEL_FK FOREIGN KEY (CITYMODEL_ID)
REFERENCES CITYMODEL (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITYOBJECT_MEMBER
ADD CONSTRAINT CITYOBJECT_MEMBER_FK FOREIGN KEY (CITYOBJECT_ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//CITY_FURNITURE CONSTRAINT

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_FK FOREIGN KEY (LOD1_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_FK1 FOREIGN KEY (LOD2_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_FK2 FOREIGN KEY (LOD3_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_FK3 FOREIGN KEY (LOD4_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_FK4 FOREIGN KEY (LOD1_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_FK5 FOREIGN KEY (LOD2_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_FK6 FOREIGN KEY (LOD3_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_FK7 FOREIGN KEY (LOD4_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CITY_FURNITURE
ADD CONSTRAINT CITY_FURNITURE_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//EXTERNAL_REFERENCE CONSTRAINT

ALTER TABLE EXTERNAL_REFERENCE
ADD CONSTRAINT EXTERNAL_REFERENCE_FK FOREIGN KEY (CITYOBJECT_ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//GENERALIZATION CONSTRAINT

ALTER TABLE GENERALIZATION
ADD CONSTRAINT GENERALIZATION_FK1 FOREIGN KEY (GENERALIZES_TO_ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERALIZATION
ADD CONSTRAINT GENERALIZATION_FK FOREIGN KEY (CITYOBJECT_ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//GENERIC_CITYOBJECT CONSTRAINT

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK FOREIGN KEY (LOD0_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK1 FOREIGN KEY (LOD1_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK2 FOREIGN KEY (LOD2_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK3 FOREIGN KEY (LOD3_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK4 FOREIGN KEY (LOD4_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK5 FOREIGN KEY (LOD0_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK6 FOREIGN KEY (LOD1_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK7 FOREIGN KEY (LOD2_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK8 FOREIGN KEY (LOD3_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK9 FOREIGN KEY (LOD4_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GENERIC_CITYOBJECT
ADD CONSTRAINT GENERIC_CITYOBJECT_FK10 FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//GROUP_TO_CITYOBJECT CONSTRAINT

ALTER TABLE GROUP_TO_CITYOBJECT
ADD CONSTRAINT GROUP_TO_CITYOBJECT_FK FOREIGN KEY (CITYOBJECT_ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE GROUP_TO_CITYOBJECT
ADD CONSTRAINT GROUP_TO_CITYOBJECT_FK1 FOREIGN KEY (CITYOBJECTGROUP_ID)
REFERENCES CITYOBJECTGROUP (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE IMPLICIT_GEOMETRY
ADD CONSTRAINT IMPLICIT_GEOMETRY_FK FOREIGN KEY (RELATIVE_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//LAND_USE CONSTRAINT

ALTER TABLE LAND_USE
ADD CONSTRAINT LAND_USE_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE LAND_USE
ADD CONSTRAINT LAND_USE_SURFACE_GEOMETRY_FK FOREIGN KEY (LOD0_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE LAND_USE
ADD CONSTRAINT LAND_USE_SURFACE_GEOMETRY_FK1 FOREIGN KEY (LOD1_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE LAND_USE
ADD CONSTRAINT LAND_USE_SURFACE_GEOMETRY_FK2 FOREIGN KEY (LOD2_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE LAND_USE
ADD CONSTRAINT LAND_USE_SURFACE_GEOMETRY_FK3 FOREIGN KEY (LOD3_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE LAND_USE
ADD CONSTRAINT LAND_USE_SURFACE_GEOMETRY_FK4 FOREIGN KEY (LOD4_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//MASSPOINT_RELIEF CONSTRAINT

ALTER TABLE MASSPOINT_RELIEF
ADD CONSTRAINT MASSPOINT_RELIEF_FK FOREIGN KEY (ID)
REFERENCES RELIEF_COMPONENT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//OBJECTCLASS CONSTRAINT

ALTER TABLE OBJECTCLASS
ADD CONSTRAINT OBJECTCLASS_OBJECTCLASS_FK FOREIGN KEY (SUPERCLASS_ID)
REFERENCES OBJECTCLASS (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//OPENING CONSTRAINT

ALTER TABLE OPENING
ADD CONSTRAINT OPENING_SURFACE_GEOMETRY_FK1 FOREIGN KEY (LOD4_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE OPENING
ADD CONSTRAINT OPENING_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE OPENING
ADD CONSTRAINT OPENING_SURFACE_GEOMETRY_FK FOREIGN KEY (LOD3_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE OPENING
ADD CONSTRAINT OPENING_ADDRESS_FK FOREIGN KEY (ADDRESS_ID)
REFERENCES ADDRESS (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//OPENING_TO_THEM_SURFACE CONSTRAINT

ALTER TABLE OPENING_TO_THEM_SURFACE
ADD CONSTRAINT OPENING_TO_THEMATIC_SURFACE_FK FOREIGN KEY (OPENING_ID)
REFERENCES OPENING (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE OPENING_TO_THEM_SURFACE
ADD CONSTRAINT OPENING_TO_THEMATIC_SURFAC_FK1 FOREIGN KEY (THEMATIC_SURFACE_ID)
REFERENCES THEMATIC_SURFACE (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//PLANT_COVER CONSTRAINT

ALTER TABLE PLANT_COVER
ADD CONSTRAINT PLANT_COVER_FK FOREIGN KEY (LOD1_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PLANT_COVER
ADD CONSTRAINT PLANT_COVER_FK1 FOREIGN KEY (LOD2_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PLANT_COVER
ADD CONSTRAINT PLANT_COVER_FK3 FOREIGN KEY (LOD4_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PLANT_COVER
ADD CONSTRAINT PLANT_COVER_FK2 FOREIGN KEY (LOD3_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PLANT_COVER
ADD CONSTRAINT PLANT_COVER_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//RASTER_RELIEF CONSTRAINT
ALTER TABLE RASTER_RELIEF
ADD CONSTRAINT RASTER_RELIEF_FK FOREIGN KEY (RELIEF_ID)
REFERENCES RELIEF (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//RELIEF_COMPONENT CONSTRAINT

ALTER TABLE RELIEF_COMPONENT
ADD CONSTRAINT RELIEF_COMPONENT_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE RELIEF_COMPONENT
ADD CONSTRAINT RELIEF_COMPONENT_CHK1 CHECK (LOD>=0 AND LOD<5);


--//RELIEF_FEATURE CONSTRAINT

ALTER TABLE RELIEF_FEATURE
ADD CONSTRAINT RELIEF_FEATURE_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE RELIEF_FEATURE
ADD CONSTRAINT RELIEF_FEATURE_CHK1 CHECK (LOD>=0 AND LOD<5);


--//RELIEF_FEAT_TO_REL_COMP CONSTRAINT

ALTER TABLE RELIEF_FEAT_TO_REL_COMP
ADD CONSTRAINT RELIEF_FEAT_TO_REL_COMP_FK FOREIGN KEY (RELIEF_COMPONENT_ID)
REFERENCES RELIEF_COMPONENT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE RELIEF_FEAT_TO_REL_COMP
ADD CONSTRAINT RELIEF_FEAT_TO_REL_COMP_FK1 FOREIGN KEY (RELIEF_FEATURE_ID)
REFERENCES RELIEF_FEATURE (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//ROOM CONSTRAINT

ALTER TABLE ROOM
ADD CONSTRAINT ROOM_BUILDING_FK FOREIGN KEY (BUILDING_ID)
REFERENCES BUILDING (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ROOM
ADD CONSTRAINT ROOM_SURFACE_GEOMETRY_FK FOREIGN KEY (LOD4_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ROOM
ADD CONSTRAINT ROOM_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//SOLITARY_VEGETAT_OBJECT CONSTRAINT

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK1 FOREIGN KEY (LOD1_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK2 FOREIGN KEY (LOD2_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK3 FOREIGN KEY (LOD3_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK4 FOREIGN KEY (LOD4_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK5 FOREIGN KEY (LOD1_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK6 FOREIGN KEY (LOD2_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK7 FOREIGN KEY (LOD3_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
ADD CONSTRAINT SOLITARY_VEGETAT_OBJECT_FK8 FOREIGN KEY (LOD4_IMPLICIT_REP_ID)
REFERENCES IMPLICIT_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//SURFACE_GEOMETRY CONSTRAINT

ALTER TABLE SURFACE_GEOMETRY
ADD CONSTRAINT SURFACE_GEOMETRY_FK FOREIGN KEY (PARENT_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SURFACE_GEOMETRY
ADD CONSTRAINT SURFACE_GEOMETRY_FK1 FOREIGN KEY (ROOT_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//TEXTUREPARAM CONSTRAINT

ALTER TABLE TEXTUREPARAM
ADD CONSTRAINT TEXTUREPARAM_SURFACE_GEOM_FK FOREIGN KEY (SURFACE_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TEXTUREPARAM
ADD CONSTRAINT TEXTUREPARAM_SURFACE_DATA_FK FOREIGN KEY (SURFACE_DATA_ID)
REFERENCES SURFACE_DATA (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//THEMATIC_SURFACE CONSTRAINT

ALTER TABLE THEMATIC_SURFACE
ADD CONSTRAINT THEMATIC_SURFACE_ROOM_FK FOREIGN KEY (ROOM_ID)
REFERENCES ROOM (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE THEMATIC_SURFACE
ADD CONSTRAINT THEMATIC_SURFACE_BUILDING_FK FOREIGN KEY (BUILDING_ID)
REFERENCES BUILDING (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE THEMATIC_SURFACE
ADD CONSTRAINT THEMATIC_SURFACE_FK FOREIGN KEY (LOD2_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE THEMATIC_SURFACE
ADD CONSTRAINT THEMATIC_SURFACE_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE THEMATIC_SURFACE
ADD CONSTRAINT THEMATIC_SURFACE_FK2 FOREIGN KEY (LOD4_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE THEMATIC_SURFACE
ADD CONSTRAINT THEMATIC_SURFACE_FK1 FOREIGN KEY (LOD3_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//TIN_RELIEF CONSTRAINT

ALTER TABLE TIN_RELIEF
ADD CONSTRAINT TIN_RELIEF_SURFACE_GEOMETRY_FK FOREIGN KEY (SURFACE_GEOMETRY_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TIN_RELIEF
ADD CONSTRAINT TIN_RELIEF_RELIEF_COMPONENT_FK FOREIGN KEY (ID)
REFERENCES RELIEF_COMPONENT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//TRAFFIC_AREA CONSTRAINT

ALTER TABLE TRAFFIC_AREA
ADD CONSTRAINT TRAFFIC_AREA_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAFFIC_AREA
ADD CONSTRAINT TRAFFIC_AREA_FK FOREIGN KEY (LOD2_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAFFIC_AREA
ADD CONSTRAINT TRAFFIC_AREA_FK1 FOREIGN KEY (LOD3_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAFFIC_AREA
ADD CONSTRAINT TRAFFIC_AREA_FK2 FOREIGN KEY (LOD4_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAFFIC_AREA
ADD CONSTRAINT TRAFFIC_AREA_FK3 FOREIGN KEY (TRANSPORTATION_COMPLEX_ID)
REFERENCES TRANSPORTATION_COMPLEX (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//TRANSPORTATION_COMPLEX CONSTRAINT

ALTER TABLE TRANSPORTATION_COMPLEX
ADD CONSTRAINT TRANSPORTATION_COMPLEX_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRANSPORTATION_COMPLEX
ADD CONSTRAINT TRANSPORTATION_COMPLEX_FK1 FOREIGN KEY (LOD1_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRANSPORTATION_COMPLEX
ADD CONSTRAINT TRANSPORTATION_COMPLEX_FK2 FOREIGN KEY (LOD2_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRANSPORTATION_COMPLEX
ADD CONSTRAINT TRANSPORTATION_COMPLEX_FK3 FOREIGN KEY (LOD3_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRANSPORTATION_COMPLEX
ADD CONSTRAINT TRANSPORTATION_COMPLEX_FK4 FOREIGN KEY (LOD4_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//WATERBODY CONSTRAINT

ALTER TABLE WATERBODY
ADD CONSTRAINT WATERBODY_CITYOBJECT_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBODY
ADD CONSTRAINT WATERBODY_SURFACE_GEOMETRY_FK1 FOREIGN KEY (LOD2_SOLID_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBODY
ADD CONSTRAINT WATERBODY_SURFACE_GEOMETRY_FK2 FOREIGN KEY (LOD3_SOLID_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBODY
ADD CONSTRAINT WATERBODY_SURFACE_GEOMETRY_FK3 FOREIGN KEY (LOD4_SOLID_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBODY
ADD CONSTRAINT WATERBODY_SURFACE_GEOMETRY_FK4 FOREIGN KEY (LOD0_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBODY
ADD CONSTRAINT WATERBODY_SURFACE_GEOMETRY_FK5 FOREIGN KEY (LOD1_MULTI_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBODY
ADD CONSTRAINT WATERBODY_SURFACE_GEOMETRY_FK FOREIGN KEY (LOD1_SOLID_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;


--//WATERBOD_TO_WATERBND_SRF CONSTRAINT

ALTER TABLE WATERBOD_TO_WATERBND_SRF
ADD CONSTRAINT WATERBOD_TO_WATERBND_FK FOREIGN KEY (WATERBOUNDARY_SURFACE_ID)
REFERENCES WATERBOUNDARY_SURFACE (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBOD_TO_WATERBND_SRF
ADD CONSTRAINT WATERBOD_TO_WATERBND_FK1 FOREIGN KEY (WATERBODY_ID)
REFERENCES WATERBODY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBOUNDARY_SURFACE
ADD CONSTRAINT WATERBOUNDARY_SRF_CITYOBJ_FK FOREIGN KEY (ID)
REFERENCES CITYOBJECT (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBOUNDARY_SURFACE
ADD CONSTRAINT WATERBOUNDARY_SURFACE_FK FOREIGN KEY (LOD2_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBOUNDARY_SURFACE
ADD CONSTRAINT WATERBOUNDARY_SURFACE_FK1 FOREIGN KEY (LOD3_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE WATERBOUNDARY_SURFACE
ADD CONSTRAINT WATERBOUNDARY_SURFACE_FK2 FOREIGN KEY (LOD4_SURFACE_ID)
REFERENCES SURFACE_GEOMETRY (ID)
ON UPDATE CASCADE ON DELETE RESTRICT;