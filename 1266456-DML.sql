Use Doctor_Appointment_System

Insert into Specialist(Specialist_ID,Specialist) Values(1,'EYE'),
                                                        (2,'Orthopaedics'),
							                            (3,'medicine'),
							                            (4,'Neuro'),
							                            (5,'Cancer Specialist'),
														(6,'Anatomy');

 Insert into Doctor(Doctor_ID,Doctor_Name,Specialist_ID,Doctor_Mobile)
                                             Values(1,'Farida',4,1234),
                                                    (2,'Murad',5,1235),
				                                    (3,'Mukta',1,1236),
				                                    (4,'Mawa',3,1237),
				                                    (5,'Lamisha',2,1238),
				                                    (6,'Mahi',6,1239),
				                                    (7,'Fabiha',3,1230);

 Insert into Doctor_Degree(Degree_ID,Degree_Name)
                  Values(1,'MBBS,Fellow Ratina & Laser(German)'),
                        (2,'FCPS,DA,MBBS'),
				        (3,'MBBS,DA'),
					    (4,'Cardiovascular'),
						(5,'MBBS<MD(Cardiology'),
						(6,'Dental Surgery');
                                 
 Insert into Service_Type(Service_ID,Service_Type,Cost)
                               Values(1,'Offline',2000),
                                     (2,'Online',1500);
										
 Insert into Schedule(Schedule_ID,Serial_No,Caller_Phn,Schedule_DateTime)
                      Values(1,1,4567,'01/01/2022'),
                            (2,2,4568,'01/01/2022'),
							(3,3,4569,'10/02/2022'),
							(4,4,4560,'10/02/2022'),
							(5,5,4561,'15/03/2022'),
							(6,6,4562,'15/03/2022');
 Insert into Appointment(Appointment_ID,Appointment_DateTime,Patient_Name,[Description],Doctor_ID,Degree_ID,Service_ID,Schedule_ID) 
                         Values(1,'2/4/22','Tanu','Fever',1,1,1,1),
                               (2,'2/4/22','Muna','Covid 19',2,2,1,2),
							   (3,'2/4/22','Tina','Cough',5,4,1,3),
							   (4,'2/4/22','Anisha','Fever',1,1,2,4),
							   (5,'10/4/22','Tanha','Covid 19',2,2,2,5),
							   (6,'10/4/22','Farja','Fever',3,3,2,6);

Select * from Specialist
Select * from Doctor
Select * from Doctor_Degree
Select * from Service_Type
Select * from Schedule
Select * from Appointment


----CHAPTER-3(Clause,Operator)---

-------------Distinct------------
SELECT DISTINCT Specialist FROM Specialist
-------------Top------------
SELECT TOP 3 * FROM Specialist;

-------------Where Clause------------
SELECT * FROM Specialist where Specialist_ID=2

-------------In------------
SELECT * FROM Specialist
WHERE Specialist IN ('EYE','medicine','Anatomy');

-------------Not In------------
SELECT * FROM Specialist
WHERE Specialist Not IN ('EYE','medicine','Anatomy');

-------------Or------------
SELECT * FROM Specialist
WHERE Specialist='EYE' OR Specialist='medicine';

-------------And------------
SELECT * FROM Specialist
WHERE Specialist='Orthopaedics' AND Specialist_ID=2;

-------------Not------------
SELECT * FROM Specialist
WHERE NOT Specialist='Anatomy';

-------------Order by------------
SELECT * FROM Specialist
ORDER BY Specialist DESC

-------------Like------------
SELECT * FROM Specialist
WHERE Specialist LIKE 'a%';

-------------Is Not Null------------
SELECT * FROM Specialist
WHERE Specialist IS Not Null


     ----CHAPTER-4-(JOIN)---
-------------Inner Join------------
Select D.Doctor_Name,S.Specialist,ST.Cost,A.Appointment_ID
From Doctor D inner join Specialist S 
On D.Doctor_ID=S.Specialist_ID
inner join Service_Type ST
On D.Doctor_ID=ST.Service_ID
inner join Appointment A
on D.Doctor_ID=A.Appointment_ID
GO

   --CHAPTER-5(Aggregate Function)--

-------------Count------------
SELECT COUNT(Doctor_ID) as [ID]
FROM Doctor;
-------------Avg------------
SELECT Avg(cost)as cost from Service_Type
-------------Sum------------
SELECT Sum(cost)as cost from Service_Type
-------------Max------------
SELECT Max(cost)as cost from Service_Type
-------------Min------------
SELECT Min(cost)as cost from Service_Type
-------------Group By------------
SELECT COUNT(Specialist_ID) as [number]
FROM Specialist
GROUP BY Specialist_ID;
-------------Having------------
SELECT COUNT(Specialist_ID) as [number]
FROM Specialist;

-------------Rollup------------
SELECT Service_ID,Min(Cost) FROM Service_Type
GROUP BY rollup (Service_ID);
-------------Cube------------
SELECT Service_ID,Min(Cost)FROM Service_Type
GROUP BY CUBE(Service_ID);
-------------Over------------
SELECT  Doctor_Name,Doctor_Mobile,COUNT(*) OVER() as OverColumn
 FROM Doctor;
-------------Grouping Sets---------
SELECT Doctor_ID,Doctor_Name,Doctor_Mobile
FROM Doctor
GROUP BY grouping sets (Doctor_ID,Doctor_Name,Doctor_Mobile);


-------CHAPTER-6(sub query,CTE)-----
-------------Sub Query------------
select D.Doctor_ID ,D.Doctor_name,S.Specialist 
from Doctor D,Specialist S
where D.Doctor_ID=S.Specialist_ID and S.Specialist in
(select Specialist from Specialist where Specialist_ID=5);
GO
---------------CTE-1-----------
--WITH Appoint_Duration(Schedule_ID,Serial_No,Caller_Phn,[Current date],Schedule_DateTime)
--  AS (SELECT Schedule_ID,Serial_No,Caller_Phn,Getdate(),
--  (Year(Schedule_DateTime)-Year(Getdate())) FROM Schedule)
--  SELECT Schedule_ID,Serial_No,Caller_Phn,[Current date],Schedule_DateTime
--  FROM Appoint_Duration WHERE Schedule_DateTime between'01/01/22'and'10/02/22';
-- GO

 -------------CTE-2-----------
 with CTE_Cost(Service_ID,Service_Type,Cost) as
 (select Service_ID,Service_Type,Cost-500
 from Service_Type)
 select Service_ID,Service_Type,Cost
 from CTE_Cost
 GO

     ------CHAPTER-7------
  -------------Merge Query------------
merge into Backup_Service_Type as B
using Service_Type as S
on B.Service_ID=S.Service_ID
when matched then 
update set B.Service_Type=S.Service_Type
when not matched then
insert values(S.Service_ID,S.Service_Type,Cost);
GO
select * from Backup_Service_Type

     ------CHAPTER-8-----
-------------Cast------------
select cast('01-june-2021 10:00:00' as time);

-------------Convert------------
select datetime =convert(date, '01-june-2021 10:00:00');

      -----CHAPTER-9----
  -----------Case------------

SELECT Service_Type,
CASE
    WHEN Service_Type = 'Offline' THEN 2000
    WHEN Service_Type = 'Online' THEN 1500
    ELSE 1000
END AS Cost
from Service_Type

-------------LEN---------------
SELECT Specialist,LEN(Specialist) as LengthOfSpecialist
FROM Specialist;

-------------SUBSTRING------------
SELECT SUBSTRING(Specialist,1,5) AS ExtractString
FROM Specialist;

-------------REPLACE------------
SELECT REPLACE('US-Software','T','M');

-------------REVERSE------------
SELECT REVERSE('SQL');

-------------UPPER------------
SELECT upper('sql');
-------------LOWER------------
SELECT LOWER('SQL');
-------------CHARINDEX------------
SELECT CHARINDEX('r', 'Farida') AS Position;
-------------PATINDEX------------
SELECT PATINDEX('%Da%', 'Farida') AS position;


-------------CHAPTER-12------------
-------------Cluster Index------------
Create clustered index IX_Service_ID on dbo.Backup_Service_Type(Service_ID);
-------------NonCluster Index------------
Create Nonclustered index IX_Service_Type on dbo.Backup_Service_Type(Service_Type);

-------------Drop Index-----------
Drop index IX_Service_ID on Backup_Service_Type;
Drop index IX_Service_Type on Backup_Service_Type;
