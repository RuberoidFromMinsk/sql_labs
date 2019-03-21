USE RAM_UNIVER;
--Task1
SELECT MAX(AUDITORIUM_CAPACITY)[MAX],
       MIN(AUDITORIUM_CAPACITY)[MIN],
	   AVG(AUDITORIUM_CAPACITY)[AVG],
	   SUM(AUDITORIUM_CAPACITY)[SUM]
FROM AUDITORIUM;

--Task2
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE[TYPE], 
       AUDITORIUM_TYPENAME[FULLNAME],
	   MAX(AUDITORIUM_CAPACITY)[MAX],
       MIN(AUDITORIUM_CAPACITY)[MIN],
	   COUNT(AUDITORIUM_TYPENAME)[COUNT],
	   SUM(AUDITORIUM_CAPACITY)[SUM]
FROM AUDITORIUM_TYPE INNER JOIN AUDITORIUM
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM_TYPENAME;

--Task3
SELECT * 
FROM (SELECT CASE WHEN NOTE = 10 THEN '10'
                  WHEN NOTE BETWEEN 8 AND 9 THEN '8-9'
				  WHEN NOTE BETWEEN 6 AND 7 THEN '6-7'
				  WHEN NOTE BETWEEN 4 AND 5 THEN '4-5'
				  ELSE '<4'
				  END [NOTES], COUNT(*)[COUNT]
      FROM PROGRESS
	  GROUP BY CASE WHEN NOTE = 10 THEN '10'
                    WHEN NOTE BETWEEN 8 AND 9 THEN '8-9'
				    WHEN NOTE BETWEEN 6 AND 7 THEN '6-7'
				    WHEN NOTE BETWEEN 4 AND 5 THEN '4-5'
				    ELSE '<4'
					END) AS T
	  ORDER BY CASE[NOTES]
	                WHEN '10' THEN 1
					WHEN '8-9' THEN 2
					WHEN '6-7' THEN 3
					WHEN '4-5' THEN 4
					ELSE 5
					END;
	    


--Task4
SELECT T1.FACULTY,
       T2.PROFESSION,
	   T3.IDGROUP,
	   ROUND(AVG(CAST(NOTE AS FLOAT(4))),2)
FROM FACULTY T1 INNER JOIN PROFESSION T2
ON T1.FACULTY = T2.FACULTY
INNER JOIN GROUPS T3
ON T2.PROFESSION = T3.PROFESSION
INNER JOIN STUDENT T4
ON T3.IDGROUP = T4.IDGROUP
INNER JOIN PROGRESS T5
ON T4.IDSTUDENT = T5.IDSTUDENT
GROUP BY T1.FACULTY,
         T2.PROFESSION,
	     T3.IDGROUP;


--Task5
SELECT T1.FACULTY,
       T2.PROFESSION,
	   T3.IDGROUP,
	   ROUND(AVG(CAST(NOTE AS FLOAT(4))),2)[AVG]
FROM FACULTY T1 INNER JOIN PROFESSION T2
ON T1.FACULTY = T2.FACULTY
INNER JOIN GROUPS T3
ON T2.PROFESSION = T3.PROFESSION
INNER JOIN STUDENT T4
ON T3.IDGROUP = T4.IDGROUP
INNER JOIN PROGRESS T5
ON T4.IDSTUDENT = T5.IDSTUDENT
WHERE T5.SUBJECT = '����' OR T5.SUBJECT = '��'
GROUP BY T1.FACULTY,
         T2.PROFESSION,
	     T3.IDGROUP;


--Task6
SELECT T3.PROFESSION,
       T5.SUBJECT,
	   ROUND(AVG(CAST(NOTE AS FLOAT(4))),2)[AVG]
FROM FACULTY T1 INNER JOIN PROFESSION T2
ON T1.FACULTY = T2.FACULTY
INNER JOIN GROUPS T3
ON T2.PROFESSION = T3.PROFESSION
INNER JOIN STUDENT T4
ON T3.IDGROUP = T4.IDGROUP
INNER JOIN PROGRESS T5
ON T4.IDSTUDENT = T5.IDSTUDENT
WHERE T1.FACULTY = '����'
GROUP BY T1.FACULTY,
         T3.PROFESSION,
	     T5.SUBJECT;
--CUBE - �������� Transact-SQL, ������� ��������� ���������� ��� ���� ��������� ������������ ����������

--Task7
SELECT T3.PROFESSION,
       T5.SUBJECT,
	   ROUND(AVG(CAST(NOTE AS FLOAT(4))),2)[AVG]
FROM FACULTY T1 INNER JOIN PROFESSION T2
ON T1.FACULTY = T2.FACULTY
INNER JOIN GROUPS T3
ON T2.PROFESSION = T3.PROFESSION
INNER JOIN STUDENT T4
ON T3.IDGROUP = T4.IDGROUP
INNER JOIN PROGRESS T5
ON T4.IDSTUDENT = T5.IDSTUDENT
WHERE T1.FACULTY = '����'
GROUP BY CUBE (T1.FACULTY,
         T3.PROFESSION,
	     T5.SUBJECT);


--Task8
 SELECT T1.IDSTUDENT, GROUPS.IDGROUP, T2.SUBJECT, T2.NOTE
 FROM STUDENT AS T1, PROGRESS AS T2, GROUPS
 WHERE GROUPS.FACULTY = '���'
UNION --������� ������ ���������� ������ � ��������
 SELECT T1.IDSTUDENT, GROUPS.IDGROUP, T2.SUBJECT, T2.NOTE
 FROM STUDENT AS T1, PROGRESS AS T2, GROUPS
 WHERE GROUPS.FACULTY = '���';


  SELECT T1.IDSTUDENT, GROUPS.IDGROUP, T2.SUBJECT, T2.NOTE
 FROM STUDENT AS T1, PROGRESS AS T2, GROUPS
 WHERE GROUPS.FACULTY = '���'
UNION ALL--������� ��� ��������� ��� ������, ���� �����
 SELECT T1.IDSTUDENT, GROUPS.IDGROUP, T2.SUBJECT, T2.NOTE
 FROM STUDENT AS T1, PROGRESS AS T2, GROUPS
 WHERE GROUPS.FACULTY = '���';


 --Task9-10
 SELECT T1.IDSTUDENT, GROUPS.IDGROUP, T2.SUBJECT, T2.NOTE
 FROM STUDENT AS T1, PROGRESS AS T2, GROUPS
 WHERE GROUPS.FACULTY = '����'
    INTERSECT
 SELECT T1.IDSTUDENT, GROUPS.IDGROUP, T2.SUBJECT, T2.NOTE
 FROM STUDENT AS T1, PROGRESS AS T2, GROUPS
 WHERE GROUPS.FACULTY = '���';


  SELECT T1.IDSTUDENT, GROUPS.IDGROUP, T2.SUBJECT, T2.NOTE
 FROM STUDENT AS T1, PROGRESS AS T2, GROUPS
 WHERE GROUPS.FACULTY = '���'
    EXCEPT 
 SELECT T1.IDSTUDENT, GROUPS.IDGROUP, T2.SUBJECT, T2.NOTE
 FROM STUDENT AS T1, PROGRESS AS T2, GROUPS
 WHERE GROUPS.FACULTY = '���';


 --Task10

SELECT DISTINCT P1.SUBJECT[�������], [������] = '8-9',
  (SELECT COUNT(*) FROM PROGRESS AS P2
   WHERE P1.SUBJECT = P2.SUBJECT AND P2.NOTE BETWEEN 8 AND 9)[���-��]
FROM PROGRESS AS P1
GROUP BY P1.SUBJECT, P1.NOTE
HAVING NOTE BETWEEN 8 AND 9;