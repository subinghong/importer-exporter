-- BREAKLINE_RELIEF.sql
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
CREATE TABLE BREAKLINE_RELIEF (
	ID                        SERIAL NOT NULL,
	RIDGE_OR_VALLEY_LINES     GEOMETRY(MultiCurveZ,:SRSNO),
	BREAK_LINES               GEOMETRY(MultiCurveZ,:SRSNO) 
)
;

ALTER TABLE BREAKLINE_RELIEF
ADD CONSTRAINT BREAKLINE_RELIEF_PK PRIMARY KEY
(
ID
)
;