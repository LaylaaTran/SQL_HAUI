use SINHVIEN

create table khoa
(
	makhoa char(10) not null primary key,
	tenkhoa nvarchar(50),
	diachi nvarchar(50),
	sodt char(10),
	email char(20)
)


create table lop 
(
	malop char(10) not null primary key,
	tenlop nvarchar(50),
	siso int,
	makhoa char(10),
	foreign key (makhoa) references khoa(makhoa) on delete cascade on update cascade
)


create table sinhvien
(
	masv char(10) not null primary key,
	hoten nvarchar(50),
	ngaysinh date,
	gioitinh bit,
	malop char(10),
	foreign key (malop) references lop(malop) on delete cascade on update cascade
)

insert into khoa values('k1','CNTT','Tang9','0968800581','cntt.gmail')
insert into khoa values('k2','DT','Tang11','0948800581','dt.gmail')
insert into khoa values('k3','HOA','Tang2','0958800581','hoa.gmail')

insert into lop values('l1','HTTT', 80,'k1')
insert into lop values('l2','CNTT', 50,'k1')
insert into lop values('l3','TTT', 80,'k2')


insert into sinhvien values('sv1', 'TranThuong', '10/10/2003', 1, 'l1')
insert into sinhvien values('sv2', 'Tran huong', '10/8/2003', 0, 'l2')
insert into sinhvien values('sv3', 'Tran Thung', '10/9/2003', 1, 'l1')
insert into sinhvien values('sv4', 'Tran Thong', '1/10/2003', 0, 'l3')
insert into sinhvien values('sv5', 'Tran Tuong', '10/1/2003', 1, 'l2')
insert into sinhvien values('sv6', 'Tran Tuong', '10/1/2008', 1, 'l2')


select*from khoa
select*from lop
select*from sinhvien

-- Cau 2
create function cau2(@tenkhoa nvarchar(50))
returns table
as
	return (
	select masv, hoten, year(getdate()) - year(ngaysinh) as 'Tuoi'
	from khoa inner join lop on khoa.makhoa = lop.makhoa inner join sinhvien on lop.malop = sinhvien.malop
	where tenkhoa = @tenkhoa
)

select*from cau2('CNTT')

-- Cau 3
create proc cau3(@x int, @y int)
as
	begin
	select masv, hoten, ngaysinh, tenlop, tenkhoa, year(getdate()) - year(ngaysinh) as 'Tuoi'
	from khoa inner join lop on khoa.makhoa = lop.makhoa inner join sinhvien on lop.malop = sinhvien.malop
	where year(getdate()) - year(ngaysinh) between @x and @y
	end

exec cau3 18,40


-- Cau 4
create trigger cau4
on sinhvien
for insert
as
	declare @masv char(10)
	set @masv = (select masv from inserted)
	declare @malop char(10)
	set @malop = (select malop from inserted)
	declare @siso int
	set @siso = (select siso from lop where malop = @malop )
	if(@siso > 80)
		begin
		raiserror('Lop day Khong nhan nguoi nua', 16, 1)
		rollback transaction
		end
	else
		update lop set siso += 1 where malop = @malop


select*from sinhvien
select*from lop
insert into sinhvien values('sv8', 'Tran Tuong', '10/1/2008', 1, 'l2')
select*from sinhvien
select*from lop
