/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP 1000 [Наименование]
      ,[Цена]
      ,[Количество]
  FROM [Lastochkin ПРОДАЖИ].[dbo].[ТОВАРЫ]

  SELECT * FROM [Lastochkin ПРОДАЖИ].[dbo].[ТОВАРЫ] WHERE Цена<1000 AND Цена>800;/*task 2*/

  SELECT Заказчик, Наименование_товары FROM [Lastochkin ПРОДАЖИ].[dbo].[ЗАКАЗЫ] WHERE Наименование_товары='Смартфон';/*task 3*/

  SELECT Дата_поставки, Наименование_товары FROM [Lastochkin ПРОДАЖИ].[dbo].[ЗАКАЗЫ] WHERE Дата_поставки between '2018-12-01' and '2019-01-01'; /*task 1*/

  SELECT Дата_поставки, Наименование_товары, Заказчик FROM [Lastochkin ПРОДАЖИ].[dbo].[ЗАКАЗЫ] WHERE Заказчик = 'Магазин 1' ORDER BY Дата_поставки DESC;/*task 4*/


