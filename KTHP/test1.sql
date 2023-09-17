use QLKHO

create table Ton
(
	mavt char(10) not null primary key,
	tenvt nvarchar(20),
	sln int
)


create table Nhap(
	sohdn char(10) not null primary key,
	sln int,
	dongian float,
	ngayn date,
	mavt char(10),
	foreign key(mavt) references Ton(mavt) on delete cascade on update cascade
)

create table Xuat(
	sohdx char(10) not null primary key,
	slx int,
	dongiax float,
	ngayx date
)

insert into Ton values('1', 'One', 20)
insert into Ton values('2','Two', 30)
insert into Ton values('3', 'Three', 40)
insert into Ton values('4','Four', 50)

insert into Nhap values('n1',20,2000,'10/10/2020','1')
insert into NHap values('n2',30, 1500,'10/10/2020', '2')
insert into Nhap values('n3', 40, 4500,'10/10/2020', '3')

insert into Xuat values('x1', 10, 3000, '12/03/2022')
insert into Xuat values('x2', 8, 1000, '12/03/2022')
insert into Xuat values('x3', 15, 2500, '12/03/2022')


select*from Ton
select*from Nhap
select*from Xuat

