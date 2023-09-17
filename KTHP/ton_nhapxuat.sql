use KTHP

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
	ngayx date,
	mavt char(10),
	foreign key(mavt) references Ton(mavt) on delete cascade on update cascade
)


insert into Ton values('1', 'One', 20)
insert into Ton values('2','Two', 30)
insert into Ton values('3', 'Three', 40)
insert into Ton values('4','Four', 50)

insert into Nhap values('n1',20,2000,'10/10/2020','1')
insert into NHap values('n2',30, 1500,'10/10/2020', '2')
insert into Nhap values('n3', 40, 4500,'10/10/2020', '3')

insert into Xuat values('x1', 10, 3000, '12/03/2022','1')
insert into Xuat values('x2', 8, 1000, '12/03/2022','2')
insert into Xuat values('x3', 15, 2500, '12/03/2022', '3')
insert into Xuat values('x5', 15, 2500, '12/03/2022', '1')
insert into Xuat values('x4', 15, 2500, '1/03/2022', '3')

select * from Ton
select * from Xuat
select * from Nhap

create function cau_hai(@mavt char(10), @ngayx date)
returns table
as
	return (select t.mavt, tenvt, slx*dongiax as 'Tien Ban'
			from Ton t inner join Xuat x on t.mavt = x.mavt
			where ngayx = @ngayx
			
)

select * from cau_hai('1', '1/03/2022')

create function cau_ba(@mavt char(10), @ngayn date)
returns table
as
	return (
		select t.mavt, n.sln*dongian as 'Tong tien vat tu'
		from Ton t inner join Nhap n on t.mavt = n.mavt
		where ngayn = @ngayn 
		
)

select * from cau_ba('1','1/03/2022')