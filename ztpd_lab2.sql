--zad 1
create table MOVIES
(
    ID NUMBER(12) PRIMARY KEY,
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50)
);

--zad 2
Insert into MOVIES 
select 
    d.ID, 
    d.TITLE, 
    d.category, 
    TRIM(d.year) as YEAR, 
    d.cast, 
    d.director, 
    d.story, 
    d.price,
    c.IMAGE,
    c.MIME_TYPE
from DESCRIPTIONS d
full outer join COVERS c
on d.ID = c.MOVIE_ID;

--zad 3
SELECT ID, title 
FROM movies 
WHERE COVER is null;

--zad 4
SELECT ID, title, length(cover) 
FROM movies 
WHERE COVER is not null;

--zad 5
SELECT ID, title, length(cover) 
FROM movies 
WHERE COVER is  null;

-- zad 6
SELECT * FROM ALL_DIRECTORIES;

-- zad 7
UPDATE MOVIES
SET
    COVER = EMPTY_BLOB(),
    MIME_TYPE = 'image/jpeg'
WHERE ID = 66;

--zad 8
SELECT ID, title, length(cover) 
FROM movies 
WHERE ID in (65,66);

-- zad 9
DECLARE
    lobd blob;
    fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN
    SELECT cover into lobd from movies
    where id=66
    FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
END;

--zad 10
CREATE TABLE TEMP_COVERS
(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

--zad 11
INSERT INTO temp_covers 
VALUES(65, BFILENAME('ZSBD_DIR','eagles.jpg'),'image/jpeg');
COMMIT;

--zad 12
SELECT movie_id, DBMS_LOB.GETLENGTH(image) 
FROM temp_covers;

-- zad 13
DECLARE
     mime VARCHAR2(50);
     image BFILE;
     lobd blob;
BEGIN
    SELECT mime_type INTO mime FROM temp_covers;
    SELECT image INTO image FROM temp_covers;
    
    dbms_lob.createtemporary(lobd, TRUE);
    DBMS_LOB.fileopen(image, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd, image, DBMS_LOB.GETLENGTH(image));
    DBMS_LOB.FILECLOSE(image);
    
    UPDATE movies
    SET cover = lobd,
    mime_type = mime
    WHERE id = 65;
    
    dbms_lob.freetemporary(lobd);
    COMMIT;
END;

-- zad 14
SELECT ID, title, length(cover) 
FROM movies 
WHERE ID in (65,66);

--zad 15
drop table MOVIES;
drop table TEMP_COVERS;