use KTHP

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
	foreign key(makhoa) references khoa(makhoa) on delete cascade on update cascade,
	phong int,
)

create table sinhvien
(
	masv char(10),
	hoten nvarchar(50),
	ngaysinh date,
	gioitinh bit,
	malop char(10),
	foreign key (malop) references lop(malop) on delete cascade on update cascade
)

insert into khoa values('k1', 'ten khoa 1', 'Now', '0968800581', 'khoa1@gmail.com')
insert into khoa values('k2', 'ten khoa 2', 'Now', '0968800681', 'khoa2@gmail.com')
insert into khoa values('k3', 'ten khoa 3', 'Now', '0968800581', 'khoa3@gmail.com')

insert into lop values('l1','ten lop 1', 50, 'k1', 20)
insert into lop values('l2','ten lop 2', 40, 'k2', 20)
insert into lop values('l3','ten lop 3', 30, 'k3', 10)

insert into sinhvien values('sv1','Tran Thi Huyen','10/10/2003', 1,'l1')
insert into sinhvien values('sv2','Tran Thi Huy','10/10/2003', 2,'l2')
insert into sinhvien values('sv3','Tran Thi Uyen','10/10/2003', 1,'l3')
insert into sinhvien values('sv4','Tran Thi En','10/10/2003', 1,'l1')
insert into sinhvien values('sv5','Tran Thi Hue','10/1/2003', 1,'l2')

create function cauhai(@tenkhoa nvarchar(50), @tenlop nvarchar(50))
returns table
as return (select masv, hoten, year(getdate()) - year(ngaysinh) as 'Tuoi'
			from sinhvien sv inner join lop l on sv.malop = l.malop inner join khoa k on l.makhoa = k.makhoa
			where tenlop = @tenlop and tenkhoa = @tenkhoa
)

select * from cauhai('ten khoa 1', 'ten lop 1')


create proc cauba(@tutuoi int, @dentuoi int)
as
	select  masv, hoten, ngaysinh, tenlop, tenkhoa, year(getdate())-year(ngaysinh) as 'Tuoi'
	from sinhvien sv inner join lop l on sv.malop = l.malop inner join khoa k on l.makhoa = k.makhoa
	where year(getdate()) - year(ngaysinh) between @tutuoi and @dentuoi

exec cauba 18,30

-- Cau 4
create trigger caubon
on sinhvien
for insert
as
	declare @malop char(10)
	set @malop = (select malop from inserted)
	declare @masv char(10)
	set @masv = (select masv from inserted)
	declare @siso int
	set @siso = (select siso from lop where malop = @malop)
	if(@siso > 60)
		begin
			raiserror('Vuot qua 60 rui khong them dau', 16,1)
			rollback transaction
		end
	else if(not exists(select*from sinhvien where masv = @masv))
		begin
		raiserror('Trung sinh vien roi', 16,1)
		rollback transaction
		end
	else 
		update lop set siso += 1 where malop = @malop
	drop trigger caubon
select* from lop
select*from sinhvien
insert into sinhvien values('sv8','Tran Thi Huyen','10/10/2003', 1,'l1')
select* from lop
select*from sinhvien

