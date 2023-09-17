create database SQLDBQuery
go
use SQLDBQuery

create table Teacher
(
	MaGV nvarchar(10),
	Name nvarchar(10)
)
go
--Xoa ten bang
drop table Teacher
go

-- Sua thong tin bang, alter database sua database
alter table Teacher add NgaySinh Date 

-- truncate table : go bang khoi thu vien
truncate table Student

create table Student
(
	MaHS nvarchar(10),
	TenHS nvarchar(20)
)
