--zad1
--A
create table FIGURY(
    ID NUMBER(1) PRIMARY KEY,
    KSZTALT MDSYS.SDO_GEOMETRY
)

--B
INSERT INTO figury values(
    1, 
    MDSYS.SDO_GEOMETRY(
        2003,
        null,
        null,
        SDO_ELEM_INFO_ARRAY(1,1003,4),
        SDO_ORDINATE_ARRAY(3,5 ,5,3 ,7,5)
    )
);

INSERT INTO figury values(
    2,
    MDSYS.SDO_GEOMETRY(
        2003, 
        NULL, 
        NULL, 
        MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);	

INSERT INTO figury values(
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        null,
        null,
        SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1 ,5,2,2),
        SDO_ORDINATE_ARRAY(3,2 ,6,2 ,7,3 ,8,2, 7,1)
    )
);

--C
INSERT INTO figury values(
    4,
    MDSYS.SDO_GEOMETRY(
			2003, 
			NULL, 
			NULL, 
			MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
			MDSYS.SDO_ORDINATE_ARRAY(1,1, 1,1)
    )
);

--D
SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01)
FROM figury;
            
--E
DELETE FROM figury
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01) <> 'TRUE'

--F
COMMIT;