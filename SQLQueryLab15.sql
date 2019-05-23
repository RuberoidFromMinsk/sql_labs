USE RAM_UNIVER;

--1
GO
CREATE FUNCTION COUNT_STUDENTS(@faculty varchar(20)) 
RETURNS INT
AS BEGIN
DECLARE @rc INT = 0;
SET @rc = (SELECT COUNT(*) FROM STUDENT A JOIN GROUPS B ON A.IDGROUP = B.IDGROUP JOIN FACULTY C ON B.FACULTY = C.FACULTY WHERE C.FACULTY = @faculty);
RETURN @rc;
END;

GO
DECLARE @count_students int = dbo.COUNT_STUDENTS('ХТиТ');
PRINT 'STUDENTS COUNT: ' + CAST(@count_students as varchar(3));


GO
ALTER FUNCTION dbo.COUNT_STUDENTS(@faculty varchar(20), @prof varchar(20))
RETURNS INT
AS BEGIN
DECLARE @rc INT = 0;
SET @rc = (SELECT COUNT(*) FROM STUDENT A JOIN GROUPS B ON A.IDGROUP = B.IDGROUP JOIN FACULTY C ON B.FACULTY = C.FACULTY WHERE C.FACULTY = @faculty AND B.PROFESSION = @prof);
RETURN @rc;
END;

GO
DECLARE @count_students int = dbo.COUNT_STUDENTS('ИДиП', '1-40 01 02          ');
PRINT 'STUDENTS COUNT: ' + CAST(@count_students as varchar(3));

--2
GO
CREATE FUNCTION FSUBJECTS(@p varchar(20))
RETURNS VARCHAR(300)
AS BEGIN
DECLARE @result VARCHAR(300) = 'Дисциплины: ';
DECLARE @t VARCHAR(30);
DECLARE myCursor CURSOR LOCAL FOR SELECT SUBJECT.SUBJECT FROM SUBJECT WHERE SUBJECT.PULPIT = @p;
OPEN myCursor;
FETCH myCursor INTO @t;
WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @result = @result + ', ' + rtrim(@t);         
    FETCH  myCursor into @t;
  END;
RETURN @result;
END;

GO
PRINT dbo.FSUBJECTS('ИСиТ');

--3
GO
CREATE FUNCTION FFACPUL(@faculty varchar(20), @pulpit varchar(20))
RETURNS TABLE
AS RETURN
(SELECT A.FACULTY, B.PULPIT FROM FACULTY A LEFT OUTER JOIN PULPIT B ON A.FACULTY = B.FACULTY
 WHERE A.FACULTY = ISNULL(A.FACULTY, @pulpit) AND B.PULPIT = ISNULL(@faculty, B.PULPIT));

 GO
 SELECT * FROM dbo.FFACPUL(NULL, NULL);
 SELECT * FROM dbo.FFACPUL('ИДиП', NULL);
 SELECT * FROM dbo.FFACPUL(NULL, 'БФ');
 SELECT * FROM dbo.FFACPUL('ИДиП', 'БФ');

 --4
 GO
 CREATE FUNCTION FCTEACHER(@pulpit varchar(20))
 RETURNS INT
 AS BEGIN
 DECLARE @count int = 0;
 SET @count = (SELECT COUNT(*) FROM TEACHER WHERE  PULPIT = ISNULL(@pulpit, PULPIT))
 RETURN @count;
 END;

 GO
 SELECT dbo.FCTEACHER(NULL) FROM TEACHER;

 --6
 GO
 CREATE FUNCTION PULPIT_COUNT(@faculty varchar(20))
 RETURNS INT
 AS BEGIN
 DECLARE @result int;
 SET @result = (select count(PULPIT) from PULPIT where FACULTY = @faculty);
 RETURN @result;
 END;

 GO
 CREATE FUNCTION GROUP_COUNT(@faculty varchar(20))
 RETURNS INT
 AS BEGIN
 DECLARE @result int;
 SET @result = (select count(IDGROUP) from GROUPS where FACULTY = @faculty);
 RETURN @result;
 END;

 GO
 CREATE FUNCTION PROFESSION_COUNT(@faculty varchar(20))
 RETURNS INT
 AS BEGIN
 DECLARE @result int;
 SET @result = (select count(PROFESSION) from PROFESSION where FACULTY = @faculty);
 RETURN @result;
 END;


 GO
 create function FACULTY_REPORT(@c int) returns @fr table
	                        ( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, 
	                                                                 [Количество студентов] int, [Количество специальностей] int )
	as begin 
                 declare cc CURSOR static for 
	       select FACULTY from FACULTY 
                                                    where dbo.COUNT_STUDENTS(FACULTY, default) > @c; 
	       declare @f varchar(30);
	       open cc;  
                 fetch cc into @f;
	       while @@fetch_status = 0
	       begin
	            insert @fr values( @f,  dbo.PULPIT_COUNT(@f),
	            dbo.GROUP_COUNT(@f),   dbo.COUNT_STUDENTS(@f, default),
	            dbo.PROFESSION_COUNT(@f)); 
	            fetch cc into @f;  
	       end;   
                 return; 
	end;
