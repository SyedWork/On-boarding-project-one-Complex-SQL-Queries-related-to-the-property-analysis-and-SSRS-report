--Property Analysis - On-boarding Task
--Server: mvpstudio.cdvkl5vm8weq.ap-southeast-2.rds.amazonaws.com

--Q.1A Display a list of all property names and their property id’s for Owner Id: 1426

SELECT OP.Id, OP.OwnerId, OP.PropertyId, P.Name
FROM OwnerProperty OP
INNER JOIN Property P
ON OP.PropertyId=P.Id
WHERE OP.OwnerID=1426

--Display result set:

Id	OwnerId	PropertyId	Name
2909	1426	5597	BI property 1
2949	1426	5637	BI property 2
2950	1426	5638	BI property 3

--Q.2B Display the current home value for each property in question A

SELECT OP.Id, OP.OwnerId, OP.PropertyId, P.Name, PHV.Value
FROM OwnerProperty OP
inner JOIN Property P
ON OP.PropertyId=P.Id
INNER JOIN PropertyHomeValue PHV
ON P.Id=PHV.PropertyId
WHERE OP.OwnerID=1426

--Display result set:

Id	OwnerId	PropertyId	Name	Value
2949	1426	5637	BI property 2	4500000.00
2909	1426	5597	BI property 1	45.00
2950	1426	5638	BI property 3	3000000.00
2950	1426	5638	BI property 3	2.00

--Q.C(1) i.	Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date. 

select OP.PropertyId, P.Name, TP.PaymentAmount, tpf.Code, 
tp.StartDate, tp.EndDate
from OwnerProperty OP
inner join Property P on OP.PropertyId=P.Id
inner join TenantProperty TP on P.Id=TP.PropertyId
inner join TenantPaymentFrequencies tpf on tp.PaymentFrequencyId=tpf.Id
where OwnerId= '1426'

--Display result set:

PropertyId	Name	PaymentAmount	Code	StartDate	EndDate
5597	BI property 1	300.00	Weekly	2018-01-01 00:00:00.000	2018-12-31 00:00:00.000
5637	BI property 2	400.00	Fortnightly	2018-01-01 00:00:00.000	2018-12-31 00:00:00.000
5638	BI property 3	1000.00	Monthly	2018-01-01 13:28:00.000	2018-12-31 13:28:00.000

--Q.C(2) ii.Display the yield. 

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

--Display result-set:

PropertyId	Name	PaymentAmount	Code	StartDate	EndDate	SumOfAllPayments
5597	BI property 1	300.00	Weekly	2018-01-01 00:00:00.000	2018-12-31 00:00:00.000	15599.999688
5637	BI property 2	400.00	Fortnightly	2018-01-01 00:00:00.000	2018-12-31 00:00:00.000	10399.999792
5638	BI property 3	1000.00	Monthly	2018-01-01 13:28:00.000	2018-12-31 13:28:00.000	11967.123168

--Q.D Display all the job available (Opening)?

select op.OwnerId, j.PropertyId, jq.Status
from OwnerProperty op
inner join Job j on op.PropertyId=j.PropertyId
inner join JobMedia jm on j.PropertyId=jm.PropertyId
inner join JobQuote jq on jq.ProviderId=j.ProviderId
where Status='Opening'

--Display result-set:

OwnerId PropertyId Status
368  	2558	   Opening
378	    4021	   Opening
500	    4218	   Opening
361	    3356	   Opening

--Q.1E Display all property names, current tenants first and last names and rental payments per week/ fortnight/month for the properties in question A)

SELECT distinct OP.OwnerId, OP.PropertyId, P.Name, tp.TenantId, tpf.Code 
FROM OwnerProperty OP
INNER JOIN Property P
ON OP.PropertyId=P.Id
inner join TenantProperty tp 
on p.Id=tp.PropertyId
inner join TenantPaymentFrequencies tpf
on tp.PaymentFrequencyId=tpf.Id

WHERE OP.OwnerID=1426

--Display result-set
OwnerId	PropertyId	Name	TenantId	Code
1426	5597	BI property 1	1425	Weekly
1426	5637	BI property 2	1475	Fortnightly
1426	5638	BI property 3	1475	Monthly

--Question Part 2 Query to build SSRS Report using Visual Studio
select Person.Id, Person.FirstName, OwnerProperty.PropertyId,
       pe.Amount, TenantPaymentFrequencies.Name, pe.Description as Expense, pe.Date, 
	   Property.AddressId, Property.Bedroom, Property.Bathroom,
	   Address.Number + ' ' + Address.Street + ' , ' + Address.Suburb as Address
from Person
inner join OwnerProperty
on Person.Id=OwnerProperty.OwnerId
inner join Property
on OwnerProperty.PropertyId=Property.Id
inner join Address
on Property.AddressId=Address.AddressId
inner join PropertyExpense pe on
pe.PropertyId=Property.Id
inner join TenantProperty
on TenantProperty.PropertyId=Property.Id
inner join TenantPaymentFrequencies
on TenantProperty.PaymentFrequencyId=TenantPaymentFrequencies.Id

where person.FirstName='ABDC'

--Display result-set
Id	FirstName	PropertyId	Amount	Name	Expense	        Date	      AddressId	       Bedroom  Bathroom	 Address
1480	ABDC	5643	300.00	Fortnightly	Rate assessment 2016-08-20 14:12:00.000	12723	2	      2          231 Great South Road , Drury
1480	ABDC	5643	300.00	Fortnightly	Rate assessment	2016-08-20 14:13:00.000	12723	2	      2	         231 Great South Road , Drury
1480	ABDC	5643	300.00	Fortnightly	Rate assessment	2016-08-20 14:13:00.000	12723	2	      2	         231 Great South Road , Drury
1480	ABDC	5643	300.00	Fortnightly	Rate assessment	2016-08-20 14:14:00.000	12723	2	      2	         231 Great South Road , Drury