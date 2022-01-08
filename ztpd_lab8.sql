--Cz1 - Operator CONTAINS - Podstawy
--zad 1
CREATE TABLE CYTATY AS SELECT * FROM ZSBD_TOOLS.CYTATY;

SELECT * FROM CYTATY;

--zad 2
SELECT AUTOR, TEKST
FROM CYTATY
WHERE UPPER(TEKST) LIKE '%PESYMISTA%' AND UPPER(TEKST) LIKE '%OPTYMISTA%';

--zad 3
CREATE INDEX cytaty_tekst_indeks
ON CYTATY(TEKST)
INDEXTYPE IS CTXSYS.CONTEXT;

--zad 4
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'PESYMISTA AND OPTYMISTA', 1) > 0;

--zad 5
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'PESYMISTA ~ OPTYMISTA', 1) > 0;

--zad 6
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'NEAR((PESYMISTA, OPTYMISTA), 3)') > 0;

--zad 7
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'NEAR((PESYMISTA, OPTYMISTA), 10)') > 0;

--zad 8
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%', 1) > 0;

--zad 9
SELECT AUTOR, TEKST, SCORE(1) AS DOPASOWANIE
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%', 1) > 0;

--zad 10
SELECT AUTOR, TEKST, SCORE(1) AS DOPASOWANIE
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%', 1) > 0 AND ROWNUM <= 1;

--zad 11
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'FUZZY(problem,,,N)', 1) > 0;

--zad 12
INSERT INTO CYTATY VALUES(
    39,
    'Bertrand Russell',
    'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.'
);
COMMIT;

SELECT * FROM CYTATY;

--zad 13
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'głupcy', 1) > 0;
--Indeks CONTEXT nie jest odwiezany na biezaco, dlatego nie widnieje w nim jeszcze slowo 'głupcy'. (zadanie 14)

--zad 14
SELECT TOKEN_TEXT
FROM DR$cytaty_tekst_indeks$I
WHERE TOKEN_TEXT = 'głupcy';

--zad 15
DROP INDEX cytaty_tekst_indeks;

CREATE INDEX cytaty_tekst_indeks
ON CYTATY(TEKST)
INDEXTYPE IS CTXSYS.CONTEXT;

--zad 16
SELECT TOKEN_TEXT
FROM DR$cytaty_tekst_indeks$I
WHERE TOKEN_TEXT = 'głupcy';

SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'głupcy', 1) > 0;

--zad 17
DROP INDEX cytaty_tekst_indeks;

DROP TABLE CYTATY;

--Cz2 - Zaawansowane indeksowanie i wyszukiwanie
--zad 1
CREATE TABLE QUOTES AS SELECT * FROM ZSBD_TOOLS.QUOTES;

SELECT * FROM QUOTES;

--zad 2
CREATE INDEX QUOTES_TEXT_INDEX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT;

--zad 3
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'work', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '$work', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'working’', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '$working’', 1) > 0;

--zad 4
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'it', 1) > 0;

--system nie zwrócil żadnych wiyników, dlatego że 'it' jest na liście 'stopwords' 

--zad 5
SELECT * FROM CTX_STOPLISTS;

--system wykorzystal domyślna stopliste DEFAULT_STOPLIST

--zad 6
SELECT * FROM CTX_STOPWORDS;

--zad 7
DROP INDEX QUOTES_TEXT_INDEX;

CREATE INDEX QUOTES_TEXT_INDEX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

--zad 8
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'it', 1) > 0;
--tym razem system zwrócil wyniki

--zad 9
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND humans', 1) > 0;

--zad 10
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND computer', 1) > 0;

--zad 11
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND humans) WITHIN SENTENCE', 1) > 0;
--sekcja SENTENCE nie istnieje

--zad 12
DROP INDEX QUOTES_TEXT_INDEX;

--zad 13
BEGIN ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup',  'SENTENCE');
    ctx_ddl.add_special_section('nullgroup',  'PARAGRAPH');
END;

--zad 14
CREATE INDEX QUOTES_TEXT_INDEX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup');

--zad 15
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND humans) WITHIN SENTENCE', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND computer) WITHIN SENTENCE', 1) > 0;

--pierwsze zapytania zwraca pusty wynik, ale wzorce dzialaja

--zad 16
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans', 1) > 0;

--system zwrócil też cytaty  zawierajace przedrostek 'non-' ponieważ nie traktuje '-' jako prawdziwy znak

--zad 17
DROP INDEX QUOTES_TEXT_INDEX;

BEGIN ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m', 'printjoins', '-');
    ctx_ddl.set_attribute('lex_z_m', 'index_text', 'YES');
END;

CREATE INDEX QUOTES_TEXT_INDEX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('
    stoplist CTXSYS.EMPTY_STOPLIST
    section group nullgroup
    LEXER lex_z_m
    ');
    
--zad 18
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans', 1) > 0;
--system nie zwrócil cytatów zawierajacych przedrostek 'non-'

--zad 19
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'non\-humans', 1) > 0;


--zad 20
DROP TABLE QUOTES;

BEGIN
    ctx_ddl.drop_preference('lex_z_m');
END;