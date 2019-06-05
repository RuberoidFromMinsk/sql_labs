use RAM_UNIVER;

--1каждый столбец конфигурируется независимо с помощью имени псевдонима этого столбца
--Используя режим PATH, вы можете генерировать иерархию узлов XML.
go
select PULPIT.FACULTY[факультет/@код], TEACHER.PULPIT[факультет/кафедра/@код], 
    TEACHER.TEACHER_NAME[факультет/кафедра/преподаватель/@код]
	    from TEACHER inner join PULPIT
		    on TEACHER.PULPIT = PULPIT.PULPIT
			   where TEACHER.PULPIT = 'ИСиТ' for xml path, root('Список_преподавателей_кафедры_ИСиТ');


--2 структура XML документа создается автоматически
go
select AUDITORIUM.AUDITORIUM [Аудитория],
           AUDITORIUM.AUDITORIUM_TYPE [Наимменование_типа],
		   AUDITORIUM.AUDITORIUM_CAPACITY [Вместимость] 
		   from AUDITORIUM join AUDITORIUM_TYPE
		     on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК' for xml AUTO, root('Список_аудиторий'), elements;

--имена его атрибутов совпадают с именами столбцов результирующего набо-ра
--3
/*
Разработать XML-документ, содержащий дан-ные о трех новых учебных дисциплинах, кото-рые следует добавить в таблицу SUBJECT. 
Разработать сценарий, извлекающий данные о дисциплинах из XML-документа и добавля-ющий их в таблицу SUBJECT.
*/
go
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <дисциплины>
					     <дисциплина код="КГиГ1" название="Компьютерная геометрия и графика1" кафедра="ИСиТ" />
						 <дисциплина код="ОЗИ1" название="Основы защиты информации1" кафедра="ИСиТ" />
						 <дисциплина код="МП1" название="Математическое программирование 1" кафедра="ИСиТ" />
					  </дисциплины>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select[код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина',0)
    with([код] char(10), [название] varchar(100), [кафедра] char(20));

select * from SUBJECT

--4
/*
Используя таблицу STUDENT разработать XML-структуру, содержащую паспортные дан-ные студента: серию и номер паспорта, личный номер, дата выдачи и адрес прописки. 
Разработать сценарий, в который включен оператор INSERT, добавляющий строку с XML-столбцом.
Включить в этот же сценарий оператор UP-DATE, изменяющий столбец INFO у одной строки таблицы STUDENT 
*/
insert into STUDENT(IDGROUP, NAME, BDAY, INFO) values(22, 'Шляпик А.В', '01.05.1999',
                                                          '<студент>
														     <паспорт серия="МС" номер="1234567" дата="01.05.2013" />
															 <телефон>+375291802623</телефон>
															 <адрес>
															    <страна>Беларусь</страна>
																<город>Минск</город>
																<улица>Минская</улица>
																<дом>222</дом>
																<квартира>1919</квартира>
															 </адрес>
														  </студент>');
select * from STUDENT where NAME = 'Шляпик А.В';
update STUDENT set INFO = '<студент>
					           <паспорт серия="МС" номер="1234567" дата="01.05.2013" />
						       <телефон>+375291802623</телефон>
							   <адрес>
								  <страна>Беларусь</страна>
								  <город>Минск</город>
								  <улица>Минская</улица>
	         					  <дом>1</дом>
								  <квартира>1</квартира>
								</адрес>
							 </студент>'
where NAME = 'Шляпик А.В';
select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
	INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта],
	INFO.query('/студент/адрес')[Адрес]
		from  STUDENT
			where NAME = 'Ермаков К.А.';       

--5
go
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);

drop XML SCHEMA COLLECTION Student;

select Name, INFO from STUDENT where NAME='Шляпик А.В'