USE RAM_UNIVER;

--1
GO
CREATE PROCEDURE PSUBJECT
AS 
BEGIN
DECLARE @count int;
SET @count = (SELECT COUNT(*) FROM SUBJECT);
SELECT * FROM SUBJECT;
RETURN @count;
END;

DECLARE @ex int = 0;
EXECUTE @ex = PSUBJECT;
PRINT 'Amount of goods: ' + CAST(@ex as varchar(5));

--2
GO
ALTER PROCEDURE PSUBJECT @p varchar(20), @c int output
AS 
BEGIN
DECLARE @count int;
SET @count = (SELECT COUNT(*) FROM SUBJECT WHERE PULPIT = @p);
SELECT * FROM SUBJECT WHERE PULPIT = @p;
SET @c = @@ROWCOUNT;
RETURN @count;
END;

GO
DECLARE @ex2 int = 0, @r int = 0, @p varchar(20);
EXECUTE @ex2 = PSUBJECT @p = 'ИСиТ', @c = @r output;
PRINT 'Total amount: ' + CAST(@ex2 as varchar(5));
--PRINT 'Total from pulpit ' + CAST(@p as varchar(5)) + ': ' + CAST(@ex2 as varchar(5));

--3
CREATE TABLE #SUBJECT
(
SUBJECT nvarchar(100),
SUBJECT_NAME nvarchar(100),
PULPIT nvarchar(50)
);

GO
ALTER PROCEDURE PSUBJECT @p nvarchar(20)
AS SELECT * FROM SUBJECT WHERE PULPIT = @p;

INSERT INTO #SUBJECT EXECUTE PSUBJECT @p = 'ИСиТ';
SELECT * FROM #SUBJECT;

--4
GO
CREATE PROCEDURE PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10)
AS DECLARE @rc int = 1;
BEGIN TRY
INSERT INTO AUDITORIUM(AUDITORIUM.AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY) VALUES(@a, @n, @t, @c);
RETURN @rc;
END TRY
BEGIN CATCH
PRINT 'Error: ' + CAST(error_number() as varchar(10));
PRINT 'Procedure name: ' + error_procedure();
return -1;
END CATCH;


GO
DECLARE @rc int;
EXECUTE @rc = PAUDITORIUM_INSERT @a = '12345', @n = '12345', @t = 'ЛК', @c = 90;
PRINT 'Error: ' + CAST(@rc as varchar(3));

--5
GO
CREATE PROCEDURE SUBJECT_REPORT @p CHAR(20)
AS
DECLARE @rc int = 0;
BEGIN TRY
  DECLARE @t nvarchar(30);
  DECLARE myCursor CURSOR FOR
  SELECT SUBJECT.SUBJECT FROM SUBJECT WHERE PULPIT = @p;
  OPEN myCursor;
  FETCH myCursor into @t;
  PRINT 'SUBJECTS: ';
  WHILE @@FETCH_STATUS = 0
    BEGIN 
	  SET @t = RTRIM(@t) + ',' + @t;
	  SET @rc = @rc + 1;
	  FETCH myCursor into @t;
	END;
  PRINT @t;
  CLOSE myCursor;
  return @rc;
END TRY
BEGIN CATCH
  print 'ошибка в параметрах' 
  if error_procedure() is not null   
    print 'имя процедуры : ' + error_procedure();
  return @rc;
END CATCH;

GO
DECLARE @rc int;
EXECUTE @rc = SUBJECT_REPORT @p = 'ПОиСОИ';
PRINT 'количество предметов = ' + cast(@rc as varchar(3)); 


--6
GO
CREATE PROCEDURE PAUDITORIUM_INSERTX @a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50)
AS
DECLARE @rc int = 1;
BEGIN TRY
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN
INSERT INTO AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) VALUES(@t, @tn);
EXECUTE @rc = PAUDITORIUM_INSERT @a, @n, @t, @c;
COMMIT TRAN;
RETURN @rc;
END TRY
BEGIN CATCH
PRINT 'Error: ' + CAST(error_number() as varchar(10));
PRINT 'Procedure name: ' + error_procedure();
END CATCH;

GO
DECLARE @rc int;
EXEC @rc = PAUDITORIUM_INSERTX @a = '12345', @n = '12345', @t = 'ЛК-EQл', @c = 90, @tn = 'Лекционная ауд.';
COMMIT