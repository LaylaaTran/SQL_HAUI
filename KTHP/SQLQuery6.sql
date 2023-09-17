use de14668

create table ton
(
	mavt char(10) not null primary key,
	tenvt nvarchar(30),
	mausac nvarchar(10),
	sl int,
	giaban float,
	slton int
)

create table nhap
(
	sohdn char(10) not null primary key,
	mavt char(10),
	foreign key(mavt) references ton(mavt) on delete cascade on update cascade,
	sln int,
	dongian float,
	ngayn date
)

create table xuat
(
	sohdx char(10) not null primary key,
	mavt char(10),
	foreign key(mavt) references ton(mavt) on delete cascade on update cascade,
	slx int,
	ngayx date
)

insert into ton values('vt1','vtone', 'do', 30, 2000, 20)
insert into ton values('vt2','vttwo', 'tim', 10, 2000, 25)
insert into ton values('vt3','vtthree', 'do', 35, 3000, 10)
insert into ton values('vt4','vtfour', 'do', 30, 2000, 20)
insert into ton values('vt5','vtfive', 'do', 10, 1500, 10)

insert into nhap values('hdb1','vt1',5, 3000,'10/10/2022')
insert into nhap values('hdb2','vt2',2,4000,'1/10/2022')
insert into nhap values('hdb3','vt3',2,4000,'1/10/2022')


insert into xuat values('hdx1','vt1',1,'10/10/2023')
insert into xuat values('hdx2','vt2',1,'1/10/2023')
insert into xuat values('hdx3','vt3',1,'1/10/2023')

select * from nhap
select * from xuat
select * from ton

-- Cau 2 
create function cau2(@ngayx date, @mavt char(10))
returns table
as
	return(
		select mavt, tenvt 
	)


-- CAU 3
create proc cau3(@sohdx char(10), @slx int, @ngayx char(10),@mavt char(10))
as
	if(not exists(select * from xuat where mavt = @mavt))
		print('San pham khong ton tai')
	else
		print('San pham co ton tai')


exec cau3'hdx1',20,'20/10/2003','vt2'


