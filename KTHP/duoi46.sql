use KTHP

create table CONGTY
(
	mact char(10) not null primary key,
	tenct nvarchar(10),
	trangthai nvarchar(10),
	tp nvarchar(10)
)

create table SANPHAM
(
	masp char(10) not null primary key,
	tensp nvarchar(10),
	mausac nvarchar(10),
	sl int,
	giaban float
)


create table CUNGUNG 
(
	mact char(10),
	masp char(10),
	foreign key (mact) references CONGTY(mact) on delete cascade on update cascade,
	foreign key (masp) references SANPHAM(masp) on delete cascade on update cascade,
	slc int,
)

insert into CONGTY values('ct1',N'CONGTY 1', N'Tot', N'Ha Noi')
insert into CONGTY values('ct2',N'CONGTY 2', N'Tot', N'Ha Noi')
insert into CONGTY values('ct3',N'CONGTY 2', N'Tot', N'Ha Noi')

insert into SANPHAM values('sp1',N'SAN PHAM 1',N'Do', 100, 3000)
insert into SANPHAM values('sp2',N'SAN PHAM 2',N'Tim', 10, 300)
insert into SANPHAM values('sp3',N'SAN PHAM 3',N'Xanh', 20, 200)

insert into CUNGUNG values('ct1','sp1', 200)
insert into CUNGUNG values('ct2','sp2', 200)
insert into CUNGUNG values('ct3','sp3', 50)
insert into CUNGUNG values('ct3','sp2', 100)
insert into CUNGUNG values('ct1','sp3', 250)

select * from CONGTY
select *from SANPHAM
select * from CUNGUNG

create function cau2(@tenct nvarchar(10))
returns table as return (
	select tensp, mausac, sl, giaban 
	from SANPHAM sp inner join CUNGUNG cu on sp.masp = cu.masp inner join CONGTY ct on ct.mact = cu.mact
	where tenct = @tenct
)

select * from cau2(N'CONGTY 1')

create proc cau3(@mact char(10), @tensp nvarchar(10), @slc int)
as
	if(not exists(select tensp from SANPHAM where tensp = @tensp))
		print('Ma san pham khong ton tai!')
	else
		begin
		insert into CUNGUNG values('ct3','sp1',20)
		print ('SP da duoc them')
		end

select*from CUNGUNG
exec cau3'ct1',N'SAN PHAM 1',5
exec cau3 'ct1', N'CTON',10
select *from CUNGUNG


-- Cau 4
create trigger cau4
on CUNGUNG
for update
as
	declare @masp char(10)
	set @masp = (select masp from inserted)
	declare @sltruoc int
	set @sltruoc = (select sl from sanpham where masp = @masp)
	declare @slthem int
	set @slthem = (select slc from inserted)
	declare @slsau int
	set @slsau = @sltruoc - @slthem
	if(@slsau < 0)
		begin
			raiserror('Khong co du hang cung ung',16,1)
			rollback transaction
		end
	else 
		update sanpham set sl = @sltruoc - @slthem where masp = @masp

select*from cungung
select * from sanpham
update cungung set slc = 20 where masp = 'sp3'
select*from cungung
select * from sanpham
	


