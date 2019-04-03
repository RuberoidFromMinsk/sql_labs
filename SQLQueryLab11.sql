USE RAM_UNIVER;

--Task1
EXEC sp_helpindex 'AUDITORIUM';

--Task2
CREATE TABLE #HELPINDEX
(
TIND INT,
TFIELD VARCHAR(100)
);

--Fill in the table
SET NOCOUNT ON;
DECLARE @I INT = 0;
WHILE @I < 1000
  BEGIN
     INSERT INTO #HELPINDEX(TIND, TFIELD) VALUES (FLOOR(20000*RAND()), REPLICATE('STRING', 10));
	 IF(@I % 100 = 0) PRINT @I;
	 SET @I = @I + 1;
  END;

--The buff has been cleaned
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
CREATE CLUSTERED INDEX #HELPINDEX_CL ON #HELPINDEX(TIND ASC);--Creating index
SELECT * FROM #HELPINDEX WHERE TIND BETWEEN 1000 AND 3000 ORDER BY TIND;

--Task3
CREATE TABLE #EX
(
TKEY INT,
CC INT IDENTITY(1,1),
TF VARCHAR(100)
);

SET NOCOUNT ON;
DECLARE @C INT = 0;
WHILE @C < 15000
  BEGIN
    INSERT INTO #EX(TKEY, TF) VALUES (FLOOR(20000*RAND()), REPLICATE('SERBIA', 10));
	SET @C = @C + 1;
  END;

CREATE INDEX #EX_NONCLU ON #EX(TKEY, CC);
SELECT * FROM #EX WHERE TKEY BETWEEN 1000 AND 3000 AND CC < 10000 ORDER BY TKEY, CC;
SELECT * FROM #EX ORDER BY TKEY, CC;
SELECT * FROM #EX WHERE TKEY = 666 AND CC > 100;

--Task4
CREATE TABLE #LOCAL
(
TKEY INT,
TVALUE VARCHAR(100)
);

SET NOCOUNT ON;
DECLARE @II INT = 0;
  WHILE @II < 15000
    BEGIN
	  INSERT INTO #LOCAL VALUES (FLOOR(10000*RAND()), REPLICATE('SERB', 10));
	  SET @II = @II + 1;
	END;

CREATE INDEX #EX_TKET_EX ON #LOCAL(TKEY) INCLUDE(TVALUE);
SELECT TVALUE FROM #LOCAL WHERE TKEY BETWEEN 5000 AND 5005;

--Task5
CREATE INDEX #LOCAL_WHERE ON #LOCAL(TKEY) WHERE (TKEY > 1000 AND TKEY < 5000);
SELECT TKEY FROM #LOCAL WHERE TKEY = 3333;
SELECT TKEY FROM #LOCAL WHERE TKEY BETWEEN 2000 AND 3000;

--Task6
CREATE INDEX #EX_TKEY ON #EX(TKEY);
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'RAM_UNIVER'), 
        OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
        WHERE name is not null;

INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;

ALTER index #EX_TKEY on #EX reorganize;
ALTER index #EX_TKEY on #EX rebuild with (online = off);

DBCC SHOWCONTIG('STUDENT');

--Task 7
DROP index #EX_TKEY on #EX;
CREATE index #EX_TKEY on #EX(TKEY) with (fillfactor = 80);

INSERT top(50)percent INTO #EX(TKEY, TF) SELECT TKEY, TF  FROM #EX;
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
       FROM sys.dm_db_index_physical_stats(DB_ID(N'RAM_UNIVER'),    
       OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
                                     ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  
                                                                                          WHERE name is not null;
