--Task 1 (a) Display a list of all property names and their property id’s for Owner Id: 1426
-- We need to find two tables where we can get these columns.

--Server Name: mvpstudio.cdvkl5vm8weq.ap-southeast-2.rds.amazonaws.com 

USE Keys
GO

select * from [dbo].[OwnerProperty]
select * from [dbo].[Property]

SELECT OP.Id, OP.OwnerId, OP.PropertyId, P.Name
FROM OwnerProperty OP
INNER JOIN Property P
ON OP.PropertyId=P.Id
WHERE OP.OwnerID=1426

2909	1426	5597	BI property 1
2949	1426	5637	BI property 2
2950	1426	5638	BI property 3

--1 (b) Display the current home value for each property in question (a) 
select * from [dbo].[PropertyHomeValue]

SELECT OP.Id, OP.OwnerId, OP.PropertyId, P.Name, PHV.Value
FROM OwnerProperty OP
INNER JOIN Property P
ON OP.PropertyId=P.Id
INNER JOIN PropertyHomeValue PHV
ON P.Id=PHV.PropertyId
WHERE OP.OwnerID=1426

2949	1426	5637	BI property 2	4500000.00
2909	1426	5597	BI property 1	45.00
2950	1426	5638	BI property 3	3000000.00
2950	1426	5638	BI property 3	2.00

--(C) For each property in question (A), return the following:                                                                      
--i.	Using rental payment amount, rental payment frequency, tenant start date, and tenant end date to write a query that returns the sum of all payments from start date to end date. 
--ii.	Display the yield. 

--Q.C(i)

select * from dbo.OwnerProperty
select * from [dbo].[Property]
select * from [dbo].[TenantProperty]
select * from [dbo].[TenantPaymentFrequencies]

select OP.PropertyId, P.Name, TP.PaymentAmount, tpf.Code, 
tp.StartDate, tp.EndDate
from OwnerProperty OP
inner join Property P on OP.PropertyId=P.Id
inner join TenantProperty TP on P.Id=TP.PropertyId
inner join TenantPaymentFrequencies tpf on tp.PaymentFrequencyId=tpf.Id
where OwnerId= '1426'

5597	BI property 1	300.00	Weekly	     2018-01-01 00:00:00.000	2018-12-31 00:00:00.000
5637	BI property 2	400.00	Fortnightly	 2018-01-01 00:00:00.000	2018-12-31 00:00:00.000
5638	BI property 3	1000.00	Monthly	     2018-01-01 13:28:00.000	2018-12-31 13:28:00.000

--Q.C(ii) Display the yield. 

select * from dbo.OwnerProperty
select * from [dbo].[Property]
select * from [dbo].[TenantProperty]
select * from [dbo].[TenantPaymentFrequencies]

select OP.PropertyId, P.Name, TP.PaymentAmount, tpf.Code, 
tp.StartDate, tp.EndDate,
(CASE 
When tpf.Id = 1 then 
tp.PaymentAmount/7 * DATEDIFF(D,tp.StartDate,tp.EndDate
)
When tpf.Id =2  
then tp.PaymentAmount/14 * DATEDIFF(D, tp.StartDate, tp.EndDate)
else tp.PaymentAmount*12/365 * DATEDIFF(D,tp.StartDate,tp.EndDate) END) AS SumOfAllPayments
from OwnerProperty OP
inner join Property P on OP.PropertyId=P.Id
inner join TenantProperty TP on P.Id=TP.PropertyId
inner join TenantPaymentFrequencies tpf on tp.PaymentFrequencyId=tpf.Id
where OwnerId= '1426'