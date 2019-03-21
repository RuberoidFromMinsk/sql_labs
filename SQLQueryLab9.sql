--Task1
/*CREATE VIEW [�������������]
  AS SELECT TEACHER[���],
            TEACHER_NAME[��� �������������],
			GENDER[���],
			PULPIT[�������]
	 FROM TEACHER;*/
USE RAM_UNIVER;

SELECT * FROM [�������������];
--Task2
/*CREATE VIEW [���������� ������]
  AS SELECT FACULTY.FACULTY_NAME[���������],
            COUNT(PULPIT.PULPIT)[���������� ������]
	 FROM FACULTY JOIN PULPIT
	 ON FACULTY.FACULTY = PULPIT.FACULTY
	 GROUP BY FACULTY_NAME;*/
SELECT * FROM [���������� ������];
--Task3

/*CREATE VIEW [���������](���, ������)
   AS SELECT AUDITORIUM,
             AUDITORIUM_NAME
	  FROM AUDITORIUM
	  WHERE AUDITORIUM_TYPE LIKE '��%';

INSERT INTO [���������] VALUES('103-5', '103-5');*/
SELECT * FROM [���������];
--Task4
-- ��������� ��������� �����, ������� ��� � ����������
/*CREATE VIEW [����������_���������]
   AS SELECT AUDITORIUM,
             AUDITORIUM_NAME
	  FROM AUDITORIUM
	  WHERE AUDITORIUM_TYPE LIKE '��%' WITH CHECK OPTION;*/


--Task5
/*CREATE VIEW [����������]
    AS SELECT TOP 10 SUBJECT[���],
	          SUBJECT_NAME[������������ ����������],
			  PULPIT[��� �������]
	   FROM SUBJECT
	   ORDER BY SUBJECT_NAME;*/
SELECT * FROM [����������];
--Task6

/*ALTER VIEW [���������� ������] WITH SCHEMABINDING
  AS SELECT T1.FACULTY_NAME[���������],
            COUNT(T2.PULPIT)[���������� ������]
	 FROM FACULTY T1 JOIN PULPIT T2
	 ON T1.FACULTY = T2.FACULTY
	 GROUP BY T1.FACULTY_NAME;*/


/*����������� ������������� � ����� ������� ������� ��� ������. ���� �������� SCHEMABINDING ������, ������ �������� ������� ������� ��� ������� ����� ��������, 
������� ����� �������� �� ����������� �������������. 
������� ����� �������� ��� ������� ���� ������������� ��� ������ ������������ �� �������, ������� ��������� ��������. */