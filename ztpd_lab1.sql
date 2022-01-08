-- zad1
CREATE TYPE samochod AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10, 2)
);

desc samochod;

CREATE TABLE samochody of samochod;

SELECT * FROM samochody;

INSERT INTO samochody VALUES (NEW samochod('FIAT', 'BRAVA', 60000, DATE'1999-11-30', 25000));
INSERT INTO samochody VALUES (NEW samochod('FORD', 'MONDEO', 80000, DATE'1997-05-10', 45000));
INSERT INTO samochody VALUES (NEW samochod('MAZDA', '323', 12000, DATE'2000-09-22', 52000));

SELECT * FROM samochody;
--zad 2
CREATE TABLE wlasciciele(imie VARCHAR2(100), nazwisko VARCHAR2(100), auto samochod);

desc wlasciciele;

INSERT INTO wlasciciele VALUES('JAN', 'KOWALSKI', samochod('FIAT', 'SEICENTO', 30000, DATE'0010-12-01', 19500));
INSERT INTO wlasciciele VALUES('ADAM', 'NOWAK', samochod('OPEL', 'ASTRA', 34000, DATE'0009-06-01', 33700));

SELECT * FROM wlasciciele;

-- zad 3
    
ALTER TYPE samochod REPLACE AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10, 2),
    MEMBER FUNCTION wartosc RETURN NUMBER
);

desc samochod;

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        BEGIN
            RETURN cena*power(0.9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
        END wartosc;
END;

SELECT s.marka, s.cena, s.wartosc() FROM samochody s;

--zad 4
ALTER TYPE samochod ADD MAP MEMBER FUNCTION metoda_odwzorujaca
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        BEGIN
            RETURN cena*power(0.9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
        END wartosc;
    MAP MEMBER FUNCTION metoda_odwzorujaca RETURN NUMBER IS
        BEGIN
            RETURN kilometry + 10000*(EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
        END metoda_odwzorujaca;
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

-- zad 5
CREATE TYPE wlasciciel AS OBJECT (
    imie VARCHAR2(20),
    nazwisko VARCHAR2(20)
);
desc wlasciciel;

desc samochod;

ALTER TYPE samochod ADD ATTRIBUTE osoba REF wlasciciel CASCADE;

CREATE TABLE wlasciciele2 OF wlasciciel;

INSERT INTO wlasciciele2 VALUES (NEW wlasciciel('JANUSZ', 'KOWALSKI'));

SELECT * FROM wlasciciele2;

UPDATE samochody s
SET s.osoba = (
SELECT REF(w) FROM wlasciciele2 w
WHERE w.imie = 'JANUSZ'
);

SELECT * FROM samochody

--zad 6

SET SERVEROUTPUT ON;
DECLARE
TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
moje_przedmioty t_przedmioty := t_przedmioty('');

BEGIN
moje_przedmioty(1) := 'MATEMATYKA';
moje_przedmioty.EXTEND(9);
FOR i IN 2..10 LOOP
    moje_przedmioty(i) := 'PRZEDMIOT_' || i;
END LOOP;
FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
END LOOP;
moje_przedmioty.TRIM(2);
FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
moje_przedmioty.EXTEND();moje_przedmioty(9) := 9;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
moje_przedmioty.DELETE();DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

--zad 7

SET SERVEROUTPUT ON;
DECLARE
TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
moje_ksiazki t_ksiazki := t_ksiazki('');

BEGIN
moje_ksiazki(1) := 'KSIAZKA';
moje_ksiazki.EXTEND(8);
FOR i IN 2..8 LOOP
    moje_ksiazki(i) := 'KSIAZKA nr' || i;
END LOOP;
FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;
moje_ksiazki.TRIM(1);
FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
moje_ksiazki.EXTEND();moje_ksiazki(8) := 'wstawiona ksiazka';
FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

-- zad 8
SET SERVEROUTPUT ON;
DECLARE
TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
moi_wykladowcy.EXTEND(2);
moi_wykladowcy(1) := 'MORZY';
moi_wykladowcy(2) := 'WOJCIECHOWSKI';
moi_wykladowcy.EXTEND(8);
FOR i IN 3..10 LOOP
moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
END LOOP;
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END LOOP;
moi_wykladowcy.TRIM(2);
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END LOOP;
moi_wykladowcy.DELETE(5,7);
DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
IF moi_wykladowcy.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END IF;
END LOOP;
moi_wykladowcy(5) := 'ZAKRZEWICZ';
moi_wykladowcy(6) := 'KROLIKOWSKI';
moi_wykladowcy(7) := 'KOSZLAJDA';
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
IF moi_wykladowcy.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- zad 9

SET SERVEROUTPUT ON;
DECLARE
TYPE t_miesiace IS TABLE OF VARCHAR2(20);
moje_miesiace t_miesiace := t_miesiace();
BEGIN
moje_miesiace.EXTEND(12);
moje_miesiace(1) := 'STYCZEN';
moje_miesiace(2) := 'LUTY';
moje_miesiace(3) := 'MARZEC';
moje_miesiace(4) := 'KWIECIEN';
moje_miesiace(5) := 'MAJ';
moje_miesiace(6) := 'CZERWIEC';
moje_miesiace(7) := 'LIPIEC';
moje_miesiace(8) := 'SIERPIEN';
moje_miesiace(9) := 'WRZESIEN';
moje_miesiace(10) := 'PAZDZIERNIK';
moje_miesiace(11) := 'LISTOPAD';
moje_miesiace(12) := 'GRUDZIEN';
FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
END LOOP;
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
moje_miesiace.DELETE(5,7);
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());

FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
IF moje_miesiace.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
END IF;
END LOOP;
END;

--zad 10

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
nazwa VARCHAR2(50),
kraj VARCHAR2(30),
jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
numer NUMBER,
egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';


--zad 11

CREATE TYPE KOSZYK_PRODUKTOW AS TABLE OF VARCHAR2(20);
/
CREATE TYPE ZAKUPY AS OBJECT (
numer NUMBER,
produkty KOSZYK_PRODUKTOW );
/
CREATE TABLE przykladowe_zakupy OF ZAKUPY
NESTED TABLE produkty STORE AS tab_produkty;

INSERT INTO przykladowe_zakupy VALUES
(zakupy(1,koszyk_produktow('SZYNKA','SER','CHLEB')));
INSERT INTO przykladowe_zakupy VALUES
(zakupy(2,koszyk_produktow('COLA','WODA')));
INSERT INTO przykladowe_zakupy VALUES
(zakupy(3,koszyk_produktow('SZYNKA','CHLEB')));



SELECT p_z.numer, p.*
FROM przykladowe_zakupy p_z, TABLE(p_z.produkty) p;

SELECT p.*
FROM przykladowe_zakupy p_z, TABLE(p_z.produkty) p;

DELETE FROM przykladowe_zakupy 
WHERE numer IN (
SELECT numer 
FROM przykladowe_zakupy p_z, TABLE (p_z.produkty) p 
WHERE p.column_value='CHLEB'
);

SELECT p_z.numer, p.*
FROM przykladowe_zakupy p_z, TABLE(p_z.produkty) p;

-- zad 12

CREATE TYPE instrument AS OBJECT (
nazwa VARCHAR2(20),
dzwiek VARCHAR2(20),
MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
/
CREATE TYPE BODY instrument AS
MEMBER FUNCTION graj RETURN VARCHAR2 IS
BEGIN
RETURN dzwiek;
END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
material VARCHAR2(20),
OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
/
CREATE OR REPLACE TYPE BODY instrument_dety AS
OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
BEGIN
RETURN 'dmucham: '||dzwiek;
END;
MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
BEGIN
RETURN glosnosc||':'||dzwiek;
END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
producent VARCHAR2(20),
OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
/
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
BEGIN
RETURN 'stukam w klawisze: '||dzwiek;
END;
END;
/
DECLARE
tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','ping-
ping','steinway');
BEGIN
dbms_output.put_line(tamburyn.graj);
dbms_output.put_line(trabka.graj);
dbms_output.put_line(trabka.graj('glosno'));
dbms_output.put_line(fortepian.graj);
END;

--zad 13
CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
 
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
 
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;

SET SERVEROUTPUT ON;
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

--zad 14
DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

--zad 15
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;

--zad 16
CREATE TABLE PRZEDMIOTY (
 NAZWA VARCHAR2(50),
 NAUCZYCIEL NUMBER REFERENCES PRACOWNICY(ID_PRAC)
);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',230);

--zad 17
CREATE TYPE ZESPOL AS OBJECT (
 ID_ZESP NUMBER,
 NAZWA VARCHAR2(50),
 ADRES VARCHAR2(100)
);

--zad 18
CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY;

--zad 19
drop type PRACOWNIK;

CREATE TYPE PRZEDMIOTY_TAB AS TABLE OF VARCHAR2(100);

CREATE TYPE PRACOWNIK AS OBJECT (
 ID_PRAC NUMBER,
 NAZWISKO VARCHAR2(30),
 ETAT VARCHAR2(20),
 ZATRUDNIONY DATE,
 PLACA_POD NUMBER(10,2),
 MIEJSCE_PRACY REF ZESPOL,
 PRZEDMIOTY PRZEDMIOTY_TAB,
 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY PRACOWNIK AS
 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER IS
 BEGIN
 RETURN PRZEDMIOTY.COUNT();
 END ILE_PRZEDMIOTOW;
END;

--zad 20
CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK
WITH OBJECT IDENTIFIER (ID_PRAC)
AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
 MAKE_REF(ZESPOLY_V,ID_ZESP),
 CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS
PRZEDMIOTY_TAB )
FROM PRACOWNICY P;

--zad 21
SELECT *
FROM PRACOWNICY_V;
SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA
FROM PRACOWNICY_V P;
SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW()
FROM PRACOWNICY_V P;
SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );
SELECT NAZWISKO, CURSOR( SELECT PRZEDMIOTY
FROM PRACOWNICY_V
WHERE ID_PRAC=P.ID_PRAC)
FROM PRACOWNICY_V P;

--zad 22
CREATE TABLE PISARZE (
 ID_PISARZA NUMBER PRIMARY KEY,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE );
 
CREATE TABLE KSIAZKI (
 ID_KSIAZKI NUMBER PRIMARY KEY,
 ID_PISARZA NUMBER NOT NULL REFERENCES PISARZE,
 TYTUL VARCHAR2(50),
 DATA_WYDANIE DATE );

INSERT INTO PISARZE VALUES(10,'SIENKIEWICZ',DATE '1880-01-01');
INSERT INTO PISARZE VALUES(20,'PRUS',DATE '1890-04-12');
INSERT INTO PISARZE VALUES(30,'ZEROMSKI',DATE '1899-09-11');

desc ksiazki;

INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(10,10,'OGNIEM I MIECZEM',DATE '1990-01-05');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(20,10,'POTOP',DATE '1975-12-09');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(30,10,'PAN WOLODYJOWSKI',DATE '1987-02-15');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(40,20,'FARAON',DATE '1948-01-21');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(50,20,'LALKA',DATE '1994-08-01');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(60,30,'PRZEDWIOSNIE',DATE '1938-02-02');

select * from Pisarze;
select * FROM Ksiazki;

DROP TYPE pisarz;
DROP TYPE ksiazka;

CREATE TYPE ksiazki_tab AS TABLE OF VARCHAR2(100);

CREATE OR REPLACE TYPE pisarz AS OBJECT (
    id_pisarza NUMBER,
    nazwisko   VARCHAR2(20),
    data_ur    DATE,
    ksiazki    KSIAZKI_TAB,
    MEMBER FUNCTION liczba_ksiazek RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY pisarz AS
    MEMBER FUNCTION liczba_ksiazek RETURN NUMBER IS
    BEGIN
        RETURN ksiazki.COUNT();
    END liczba_ksiazek;
END;

CREATE OR REPLACE TYPE ksiazka AS OBJECT (
    id_ksiazki   NUMBER,
    autor        REF pisarz,
    tytul        VARCHAR2(20),
    data_wydania DATE,
    MEMBER FUNCTION wiek RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY ksiazka AS
    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        RETURN extract(YEAR FROM current_date) - extract(YEAR FROM data_wydania);
    END wiek;
END;

desc ksiazka;

CREATE OR REPLACE VIEW ksiazki_view OF ksiazka 
    WITH OBJECT IDENTIFIER (id_ksiazki)
AS SELECT id_ksiazki, make_ref(pisarze_view, id_pisarza), tytul, data_wydania FROM Ksiazki;

CREATE OR REPLACE VIEW pisarze_view OF pisarz
WITH OBJECT IDENTIFIER(id_pisarza)
AS SELECT id_pisarza, nazwisko, data_ur, CAST(MULTISET(SELECT tytul FROM ksiazki WHERE id_pisarza=p.id_pisarza) AS ksiazki_tab) FROM pisarze p;


select * from pisarze_view;

--zad 23
DROP TYPE auto;

CREATE TYPE AUTO AS OBJECT (
 MARKA VARCHAR2(20),
 MODEL VARCHAR2(20),
 KILOMETRY NUMBER,
 DATA_PRODUKCJI DATE,
 CENA NUMBER(10,2),
 MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY AUTO AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 WIEK NUMBER;
 WARTOSC NUMBER;
 BEGIN
 WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
 WARTOSC := CENA - (WIEK * 0.1 * CENA);
 IF (WARTOSC < 0) THEN
 WARTOSC := 0;
 END IF;
 RETURN WARTOSC;
 END WARTOSC;
END;

CREATE TABLE AUTA OF AUTO;

INSERT INTO AUTA VALUES (AUTO('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
INSERT INTO AUTA VALUES (AUTO('FORD','MONDEO',80000,DATE '1997-05-10',45000));
INSERT INTO AUTA VALUES (AUTO('MAZDA','323',12000,DATE '2000-09-22',52000));

SELECT * FROM AUTA;

drop type auto_osobowe;
drop type auto_ciezarowe;

CREATE OR REPLACE TYPE auto_osobowe UNDER AUTO (
    liczba_miejsc NUMBER,
    czy_klimatyzacja VARCHAR2(3),
    OVERRIDING MEMBER FUNCTION wartosc RETURN NUMBER
);

desc auto_osobowe;

CREATE OR REPLACE TYPE BODY auto_osobowe AS
    OVERRIDING MEMBER FUNCTION wartosc RETURN NUMBER IS
        wartosc NUMBER;
    BEGIN
        wartosc := (SELF AS AUTO).wartosc();
        IF (czy_klimatyzacja = 'TAK') THEN
            wartosc := wartosc * 1.5;
        END IF;
        RETURN wartosc;
    END;
END;

CREATE TYPE auto_ciezarowe UNDER AUTO (
    maksymalna_ladownosc NUMBER,
    OVERRIDING MEMBER FUNCTION wartosc RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY auto_ciezarowe AS
    OVERRIDING MEMBER FUNCTION wartosc RETURN NUMBER IS
        wartosc NUMBER;
    BEGIN
        wartosc := (SELF AS AUTO).wartosc();
        IF (maksymalna_ladownosc > 10000) THEN
            wartosc := wartosc * 2;
        END IF;
        RETURN wartosc;
    END;
END;

INSERT INTO auta VALUES (auto_osobowe('Ford', 'Focus', 60000, DATE '2015-01-01', 50000, 5, 'TAK'));
INSERT INTO auta VALUES (auto_osobowe('Skoda', 'Octavia', 80000, DATE '2018-01-01', 50000, 5, 'NIE'));
INSERT INTO auta VALUES (auto_ciezarowe('Volvo', 'FMX', 100000, DATE '2021-01-01', 50000, 10000));
INSERT INTO auta VALUES (auto_ciezarowe('Scania', 'R', 120000, DATE '2021-01-01', 50000, 12000));

SELECT a.marka, a.wartosc() FROM auta a;