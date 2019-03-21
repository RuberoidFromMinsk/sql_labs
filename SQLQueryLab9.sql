--Task1
/*CREATE VIEW [Преподаватель]
  AS SELECT TEACHER[код],
            TEACHER_NAME[имя преподавателя],
			GENDER[пол],
			PULPIT[кафедры]
	 FROM TEACHER;*/
USE RAM_UNIVER;

SELECT * FROM [Преподаватель];
--Task2
/*CREATE VIEW [Количество кафедр]
  AS SELECT FACULTY.FACULTY_NAME[факультет],
            COUNT(PULPIT.PULPIT)[количество кафедр]
	 FROM FACULTY JOIN PULPIT
	 ON FACULTY.FACULTY = PULPIT.FACULTY
	 GROUP BY FACULTY_NAME;*/
SELECT * FROM [Количество кафедр];
--Task3

/*CREATE VIEW [Аудитории](КОД, НАИМЕН)
   AS SELECT AUDITORIUM,
             AUDITORIUM_NAME
	  FROM AUDITORIUM
	  WHERE AUDITORIUM_TYPE LIKE 'ЛК%';

INSERT INTO [Аудитории] VALUES('103-5', '103-5');*/
SELECT * FROM [Аудитории];
--Task4
-- запрещает изменение строк, которых нет в подзапросе
/*CREATE VIEW [Лекционные_аудитории]
   AS SELECT AUDITORIUM,
             AUDITORIUM_NAME
	  FROM AUDITORIUM
	  WHERE AUDITORIUM_TYPE LIKE 'ЛК%' WITH CHECK OPTION;*/


--Task5
/*CREATE VIEW [Дисциплины]
    AS SELECT TOP 10 SUBJECT[код],
	          SUBJECT_NAME[наименование дисциплины],
			  PULPIT[код кафедры]
	   FROM SUBJECT
	   ORDER BY SUBJECT_NAME;*/
SELECT * FROM [Дисциплины];
--Task6

/*ALTER VIEW [Количество кафедр] WITH SCHEMABINDING
  AS SELECT T1.FACULTY_NAME[факультет],
            COUNT(T2.PULPIT)[количество кафедр]
	 FROM FACULTY T1 JOIN PULPIT T2
	 ON T1.FACULTY = T2.FACULTY
	 GROUP BY T1.FACULTY_NAME;*/


/*Привязывает представление к схеме базовой таблицы или таблиц. Если аргумент SCHEMABINDING указан, нельзя изменить базовую таблицу или таблицы таким способом, 
который может повлиять на определение представления. 
Сначала нужно изменить или удалить само представление для сброса зависимостей от таблицы, которую требуется изменить. */