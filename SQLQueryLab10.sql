USE RAM_UNIVER;

DECLARE @first_var int = 10,
        @char_var char = 'H',
		@varchar_var varchar(2),
		@date_var datetime;

	SELECT @date_var = GETDATE();

		SET @varchar_var = 'PO';
		SET @date_var = GETDATE();

DECLARE
		@smallint_int smallint = 1000,
		@tinyint_var tinyint = 255,
		@numeric_var numeric(3,1) = 12.1;

SELECT @date_var date_var, @char_var char_var, @first_var first_var;
PRINT 'DATE = ' + CAST(@date_var as varchar(20));

--Task2
DECLARE @Y1 INT = (SELECT CAST(SUM(AUDITORIUM_CAPACITY) AS numeric(8,3)) FROM AUDITORIUM),
        @Y2 INT,
		@Y3 NUMERIC(8,3),
		@Y4 INT,
		@Y5 INT;
IF @Y1 > 200
BEGIN
  SET @Y2 = (SELECT COUNT(AUDITORIUM_NAME) FROM AUDITORIUM);
  SET @Y3 = (SELECT CAST(AVG(AUDITORIUM_CAPACITY) AS numeric(8,3)) FROM AUDITORIUM);
  SET @Y4 = (SELECT CAST(COUNT(*) AS numeric(8,3)) FROM AUDITORIUM WHERE AUDITORIUM_CAPACITY < @Y3);
  SET @Y5 = ((100*@Y4)/@Y2);

  PRINT '����� ���������: ' + CAST(@Y2 AS VARCHAR(10));
  PRINT '����� ������� �����������: ' + CAST(@Y3 AS VARCHAR(10));
  PRINT '����������� ��������� ������ �������:  ' + CAST(@Y4 AS VARCHAR(10));
  PRINT '������� ���� ���������: ' + CAST(@Y5 AS VARCHAR(10));
END
ELSE
  PRINT '����� ����������� ����� ' + CAST(@Y1 AS VARCHAR(10));


--Task3
PRINT '����� ���. ����� ' + CAST(@@ROWCOUNT AS VARCHAR(5));
PRINT @@VERSION;
PRINT @@SPID;
PRINT @@ERROR;
PRINT @@SERVERNAME;
PRINT @@TRANCOUNT;
PRINT @@FETCH_STATUS;
PRINT @@NESTLEVEL;

--Task4
--���������� ���������
DECLARE @T FLOAT = 0.7, @X FLOAT = 0.4, @Z FLOAT;
IF(@T > @X)
  SET @Z = POWER(SIN(@T),2);
ELSE IF(@T < @X)
  SET @Z = 4*(@T + @X);
ELSE
  SET @Z = 1 - EXP(@X - 2);

PRINT 'Z �����: ' + CAST(@Z AS VARCHAR(10));

--����� ���������
DECLARE @BIRTHDAY INT = (MONTH(GETDATE()) + 1);
SELECT * FROM STUDENT WHERE MONTH(BDAY) = @BIRTHDAY;

--����� ��� ������ ��������
SELECT DISTINCT SUBJECT[�������], DATEPART(WEEKDAY,PDATE)[���� ������] FROM PROGRESS WHERE SUBJECT = '����';

--Task5
DECLARE @TEACHERS INT = (SELECT COUNT(TEACHER) FROM TEACHER);
IF(@TEACHERS > 10)
   PRINT '� ���� ������ 10 ��������������: ' + CAST(@TEACHERS AS VARCHAR(10));
ELSE
   PRINT '� ���� ������ 10 ��������������: ' + CAST(@TEACHERS AS VARCHAR(10));

--Task6
SELECT CASE
       WHEN NOTE BETWEEN 0 AND 3 THEN '����'
	   WHEN NOTE BETWEEN 4 AND 6 THEN '��'
	   WHEN NOTE BETWEEN 7 AND 8 THEN '���'
	   WHEN NOTE BETWEEN 9 AND 10 THEN '���'
	   ELSE 'WRONG DATA'
	   END ������, COUNT(NOTE)[���-��]
FROM PROGRESS
GROUP BY CASE
         WHEN NOTE BETWEEN 0 AND 3 THEN '����'
	     WHEN NOTE BETWEEN 4 AND 6 THEN '��'
	     WHEN NOTE BETWEEN 7 AND 8 THEN '���'
	     WHEN NOTE BETWEEN 9 AND 10 THEN '���'
		 ELSE 'WRONG DATA'
		 END;


--Task7
/*CREATE table #EXample
 (   TIND int,  
     TFIELD varchar(100)
 );

SET NOCOUNT ON;
DECLARE @I INT = 0;
WHILE @I < 1000
BEGIN
INSERT #EXample(TIND, TFIELD) VALUES(FLOOR(30000*RAND()), REPLICATE('������', 10));
IF(@I%100=0)
  PRINT @I;
SET @I = @I + 1;
END;*/

--Task8
--����������, ��������� ����� RETURN, �� �����������.
PRINT 'IT IS WRITTING'
RETURN
PRINT 'IT IS NOT WRITTING';


--Task9
BEGIN TRY
      DECLARE @SAMPLE INT = 0;
	  DECLARE @ERR INT = 10/@SAMPLE;
END TRY
BEGIN CATCH
      PRINT ERROR_NUMBER();
	  PRINT ERROR_MESSAGE();
	  PRINT ERROR_LINE();
	  PRINT ERROR_PROCEDURE(); --��� ��������� ��� NULL
	  PRINT ERROR_SEVERITY(); --������� ����������� ������
	  PRINT ERROR_STATE(); --����� ������
END CATCH;