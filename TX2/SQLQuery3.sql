
---- ĐỀ 1------------

use TX2

create table SANPHAM
(
masp char(10) not null primary key,
tensp nvarchar(50),
sl int,
dongia float,
mausac char(10)
)

create table NHAP
(
sohd char(10) not null primary key,
masp char(10)
foreign key(masp) references SANPHAM(masp) on delete cascade on update cascade,
ngayn date,
sln int,
dongian float
)

create table XUAT
(
sohdx char(10) not null primary key,
masp char(10)
foreign key(masp) references SANPHAM(masp) on delete cascade on update cascade,
ngayx date,
slx int
)

insert into SANPHAM values('1',N'Bim',20,2000,'Cam')
insert into SANPHAM values('2',N'Banh',10,1000,'Do')
insert into SANPHAM values('3',N'Nuoc',30,20000,'Do')
insert into SANPHAM values('4',N'Keo',200,22000,'Tim')
insert into SANPHAM values('5',N'Cay',2,2000,'Cam')

insert into NHAP values('n1','1','10/10/2022',100,1000)
insert into NHAP values('n2','2','10/10/2022',300,800)
insert into NHAP values('n3','3','10/10/2022',200,10000)

insert into XUAT values('x1','1','11/10/2022',50)
insert into XUAT values('x2','2','11/10/2022',40)
insert into XUAT values('x3','3','11/10/2022',20)

select * from SANPHAM
select*from NHAP
select*from XUAT

-- Tao ham thong ke tien xuat (tien xuat = soluongx*dongia cua mat hang co tensp va ngay x nhap tu ban phim
create function thongKe(@tensp nvarchar(50), @ngayxuat date)
returns table
as
	return(select slx*dongia as 'Tien xuat'
	from SANPHAM sp inner join XUAT x on sp.masp = x.masp
	where tensp = @tensp and ngayx = @ngayxuat)

select*from thongKe('Bim','11/10/2022')

/*
-- Tao thu tuc cap nhat du lieu cho bang NHAP voi cac tham bien truyen vao la
sohdn, masp.sln,dongian
Hay kiem tra xem MaSP co torng bang SANPHAM hay khong. Neu khogn thi chua ra TB, 
Nguoc lai cap nhat theo so hoa son

*/
create proc cau3_3(@sohd char(10), @masp char(10), @sln int, @dongian float)
as
	if(not exists(select*from SANPHAM where masp = @masp))
		print'Khong ton tai ma sp '
	else
		update NHAP set sohd = @sohd , masp = @masp ,  sln = @sln, dongian = @dongian
		where masp = @masp


select*from NHAP
exec cau3_3'n5','1',99,222
select*from NHAP

/*
Cau 4: Tao trigger kiem soat viec cap nhat lai slx trong bang XUAT,
Hay ktr MASP can UXat co trong bang SAN PHAM hay khong?
slx cap nhaa co < soluong k
neu khong dua ra tb, nguoc lai cho phep xuat va cap nhat sl trong bang san paham
*/

create trigger cau_4
on XUAT
for update
as
	declare @masp char(10)
	set @masp = (select masp from inserted)
	declare @slx int
	set @slx = (select slx from inserted)
	declare @slc int
	set @slc = (select sl from SANPHAM  where masp = @masp )
	if(not exists (select*from SANPHAM where masp = @masp))
		begin
			raiserror('Khong co san pham',16,1)
			rollback transaction
		end
	else if(@slx > @slc)
		begin
			raiserror('Khong co du so luong de xuat',16,1)
			rollback transaction
		end
	else 
		update SANPHAM set sl = sl - @slx where masp = @masp
	
update XUAT set slx = 1000 where masp = '1'
select*from SANPHAM
select*from XUAT
update XUAT set slx = 10 where masp = '1'
select*from SANPHAM
select*from XUAT


/*
CAu 2 : Tao ham dua ra masp, tensp,mausac, slx, dongia, tienban(slx*dongia) cua
casc mat hang co ngay xuat duoc nhap tu ban phim
*/
go 
create function cauhai(@ngayxuat date)
returns table
as
	return (select x.masp, tensp, mausac, slx, dongia, slx*dongia as 'Tien ban' 
			from XUAT x inner join SANPHAM sp on x.masp = sp.masp 
			where ngayx = @ngayxuat)

select*from cauhai('11/10/2022')

/*
Cau 3 : Tao thu tuc cap nhat du lieu cho bang NHAP voi cac tham bien truyen vao la
so hoa don nhap, masp,sln,dongian. Hay kiem tra xem masp co trong bang SANPHAM hay k?
Neu khong tra ve 1, nguoc lai cho phep cap nhat theo so hoa don nhap va tra ve 0
*/

create proc cauba(@sohd char(10), @masp char(10), @sln int, @dongian float, @KQ int output )
as
	if( not exists(select*from SANPHAM where masp = @masp))
		set @KQ = 1
	else 
	begin
		update NHAP  set sohd = @sohd , masp = @masp , sln = @sln , dongian = @dongian where masp = @masp
		set @KQ = 0
		end

select*from NHAP
declare @kqq int
exec cauba'n2','1',999,888, @kqq output
select @kqq

/*
Cau 4 :
Tao trigger kiem soat viec NHAP, hay ktra ma	nhap co trong bang SANPHAM hay khong?
Hay ktra xem dongian < dongia k?
Neu khong dua ra TB, nguoc lai cho phep nhap vaf cap nhat lai so luong trong bang SANPHAM
*/

create trigger caubonnn
on SANPHAM
for insert
as
	declare @masp char(10)
	set @masp = (select masp from inserted)
	declare @dongian float
	set @dongian = (select dongian from NHAP)
	declare @dongia float
	set @dongia = (select dongia from SANPHAM)
	if( exists (select *from SANPHAM where masp = @masp))
		begin
		raiserror('San pham co',16,1)
		rollback transaction
		end
	else if(@dongian < @dongia)
		begin
		raiserror('Gia re qua',16,1)
		rollback transaction
		end
	else 
		update NHAP set sln = sln + 1 where masp = @masp
		
select*from SANPHAM

INSERT INTO SANPHAM VALUES ('10', N'Bim', 20, 2000, 'Cam')
--insert into SANPHAM values('10','Bim',20,2000,'Cam')
select*from SANPHAM