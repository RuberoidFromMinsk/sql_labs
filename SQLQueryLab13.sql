USE RAM_UNIVER;
--♦ атомарность (Atomicity)
--♦ согласованность (Consistency)
--♦ изолированность (Isolation)
--♦ устойчивость (Durability)

--1 Неявная транзакция
SET IMPLICIT_TRANSACTIONS  ON

CREATE table X(K int );
INSERT X values (1),(2),(3);
PRINT @@TRANCOUNT;
commit;

SET IMPLICIT_TRANSACTIONS  OFF

--2 атомарность явной транзакции
begin try
  begin tran
    insert into AUDITORIUM (AUDITORIUM) values ('103-5');
    delete AUDITORIUM where AUDITORIUM.AUDITORIUM = '103-4';
  commit tran;
end try
begin catch
  print 'Error: ' + cast(error_number() as varchar(10)) + error_message();
end catch;

--3 SAVE TRAN
/*Если транзакция состоит из нескольких независимых блоков операторов T-SQL, 
изменя-ющих базу данных, то может быть использован оператор SAVE TRANSACTION, 
формиру-ющий контрольную точку транзакции.*/
COMMIT
declare @point varchar(32);
begin try
  begin tran
    delete AUDITORIUM where AUDITORIUM.AUDITORIUM = '103-4';
	set @point = 'p1'; save tran @point;
	insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY) values  ('224', '206-1','ЛБ-К', 15);
	set @point = 'p2'; save tran @point;
  commit tran;
end try
begin catch
  print 'Error: ' + cast(error_number() as varchar(10)) + error_message();
  if @@TRANCOUNT > 0
    begin
	  print 'Control point: ' + @point;
	  rollback tran @point;
	end;
end catch;




commit;
