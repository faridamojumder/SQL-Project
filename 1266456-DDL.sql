IF DB_ID('Doctor_Appointment_System') IS NOT NULL
Drop database Doctor_Appointment_System
GO

Create database Doctor_Appointment_System


 ON PRIMARY

 (NAME=N'Doctor_Appointment_System
_DATA_1',
 FILENAME=N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Doctor_Appointment_System_DATA_1.mdf',
 SIZE=25MB,MAXSIZE=100,FILEGROWTH=5%)

 LOG ON

 (NAME=N'Doctor_Appointment_System
_LOG_1',
 FILENAME=N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Doctor_Appointment_System_DATA_1.ldf',
 SIZE=2MB,MAXSIZE=50,FILEGROWTH=1MB);
 GO
 Use Doctor_Appointment_System

 Create table Specialist
 (
  Specialist_ID int primary key not null,
  Specialist varchar(50)
 );
 GO

 Create table Doctor
 (
  Doctor_ID int primary key not null,
  Doctor_Name varchar(50),
  Specialist_ID int references Specialist(Specialist_ID),
  Doctor_Mobile int
 );
 GO

Create table Doctor_Degree
 (
  Degree_ID int primary key not null,
  Degree_Name varchar(50)
 );
 GO

 Create table Service_Type
 (
  Service_ID int primary key not null,
  Service_Type varchar(50),
  Cost money
 );
 GO

 Create table Schedule
 (
  Schedule_ID int primary key not null,
  Serial_No int,
  Caller_Phn int,
  Schedule_DateTime varchar(50)
 );
 GO
 
Create table Appointment
 (
  Appointment_ID int primary key not null,
  Appointment_DateTime Datetime,
  Patient_Name varchar(50),
  [Description] varchar(100),
  Doctor_ID int references Doctor(Doctor_ID),
  Degree_ID int references Doctor_Degree(Degree_ID),
  Service_ID int references Service_Type(Service_ID),
  Schedule_ID int references Schedule(Schedule_ID)
 );
 GO

       ---Table For Merge---
Create Table Backup_Service_Type
(
  Service_ID int,
  Service_Type varchar(50),
  Cost money
 );
 GO

 -------CHAPER-13------
-------------View------------
 Create View vw_Specialist as 
  (select D.Doctor_ID ,D.Doctor_name,S.Specialist 
  from Doctor D,Specialist S
  where D.Doctor_ID=S.Specialist_ID and S.Specialist in
  (select Specialist from Specialist where Specialist_ID=5));

select * from vw_Specialist

---------CHAPTER-14--------
IF OBJECT_ID('tempdb.dbo.##globalTempTable') IS NOT NULL
DROP TABLE ##globalTempTable;
Create table ##globalTempTable(id int,name varchar(50));
insert into ##globalTempTable(id,name)
values(1,'global value');
select * from ##globalTempTable


IF OBJECT_ID('tempdb.dbo.#localTempTable') IS NOT NULL
DROP TABLE #localTempTable; 
Create table #localTempTable(id int,name varchar(50));
insert into #localTempTable(id,name)
values(1,'local value');
select * from #localTempTable

-------------Print------------
Print 'Complete Succesfully';

 ----------CHAPTER-15-------
---Store Procedure without Parameters----

Create Procedure SP_Specialist
  as
  select * from Specialist Where Specialist_ID=2
  go

  exec Sp_Specialist

---Store Procedure with Parameters-(Insert)---

Create procedure SP_InsertSpecialist
@Specialist_ID int,
@Specialist varchar(50)
As 
insert into Specialist(Specialist_ID,Specialist)
Values(@Specialist_ID,@Specialist);
Go
Exec SP_InsertSpecialist 7,'Biochemistry'

---Store Procedure with Parameters-(Update)---

Create procedure SP_updateSpecialist
@Specialist_ID int,
@Specialist varchar(50)
As 
Update Specialist Set Specialist=@Specialist where Specialist_ID=@Specialist_ID;
Go

---Store Procedure with Parameters-(Delete)---
create procedure SP_DeleteSpecialist
@Specialist_ID int,
@Specialist varchar(50)
As 
Delete Specialist where Specialist_ID=@Specialist_ID;
Go

-------------Table Value Function------------

Create function FN_Specialist()
returns table
return(select * from Specialist where Specialist_ID=2)

Select * from FN_Specialist()


-------------Scalare Value Function------------

Create function SF_Specialist()
returns int
begin
     declare @a int;
	 select @a= count(*) from Specialist;
	 Return @a;
end;

select dbo.SF_Specialist();

------Multi statement function-----

 create function fn_Service_Type()
	Returns @outTable 
	table(Service_ID int,Service_Type nvarchar(50), 
	Cost money,Cost_extent money)
	begin
		insert into @outTable(Service_ID,Service_Type,Cost,Cost_extent) 
		select Service_ID,Service_Type,Cost,Cost_Increase =Cost+200
		from Service_Type;
		return;
	end;

	select * from dbo.fn_Service_Type()


--------Table for Trigger------------
Create Table Another_Bac_Service_Type
(
  Service_ID int,
  Service_Type varchar(50),
  Cost money
 );
 GO
 select * from Another_Bac_Service_Type
------------After Triggers----------------
Create Trigger Tr_Service_insert
On Backup_Service_Type
After Insert, Update
As
Insert Into Another_Bac_Service_Type
(Service_ID,Service_Type,Cost)
Select 
i.Service_ID,i.Service_Type,Cost From inserted i;
Go
insert into Backup_Service_Type(Service_ID,Service_Type,Cost)
values(3,'Office Emp',500);
Select * from Backup_Service_Type

---------Table For Trigger--------
Create table Doctor_Salary
 (
  Salary_ID int,
  Salary int
 );
 GO
 insert into Doctor_Salary values(1,50000),
                                 (2,40000),
								 (3,30000),
								 (4,20000),
								 (5,15000);
    select * from Doctor_Salary

 Create table backup_Salary
 (
  Salary_ID int,
  Salary int
 );
 GO


---------Instead Of Trigger--------
create TRIGGER dbo.Doctor_Salary_InsteadOfDELETE
       ON dbo.Doctor_Salary
INSTEAD OF DELETE
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @Salary_ID int,@Salary int
 
       SELECT @Salary_ID = DELETED.Salary_ID,@Salary=DELETED.Salary      
       FROM DELETED
 
       IF @Salary_ID = 2
       BEGIN
              RAISERROR('ID 2 record cannot be deleted',16 ,1)
              ROLLBACK
              INSERT INTO backup_Salary
              VALUES(@Salary_ID,404)
       END
       ELSE
       BEGIN
              DELETE FROM Doctor_Salary
              WHERE Salary_ID = @Salary_ID
 
              INSERT INTO backup_Salary
              VALUES(@Salary_ID, @Salary)
       END
END

select * from Doctor_Salary
select * from backup_Salary

Delete from Doctor_Salary where Salary_ID=4
