Use LastochkinUniverLab3;

/*CREATE table RESULTS
(
ID int identity(1,1) primary key,
NAME nvarchar(30) not null,
BIOLOGY int,
PHYSIK int,
SUMM as BIOLOGY + PHYSIK
);*/

INSERT INTO RESULTS(NAME, BIOLOGY, PHYSIK)
            VALUES ('Petrov', 6, 10),
			       ('Filisyr', 3, 5);

SELECT * FROM RESULTS;