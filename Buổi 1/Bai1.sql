use master 

go
if DB_ID('QLUONGG') is not null
	drop database QLUONGG
go 

create database QLUONGG
on primary(
	Name ='QLUONGG_dat',
	Filename = 'D:\QLUONGG.mdf',
	Maxsize = 5MB,
	Filegrowth = 10MB
)
log on(
	Name = 'QLUONGG_log',
	Filename = 'D:\QLuongg.ldf',
	Maxsize = 5MB,
	Filegrowth = 20%
)

Go

Use QLUONGG
go
Create Table DonVi
(
MaDV char(10) Not Null Primary Key,
TenDV nvarchar(50),
DienThoai char(10) Check(DienThoai LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

go
Create Table ChucVu
(
MaCV char(10) Not Null Primary Key,
TenCV nvarchar(50), Check(TENCV IN(N'Trưởng Phòng', N'Phó Phòng', N'nhân viên')),
PhuCap real
)

go

Create Table NhanVien(
MaNV char(10) Not Null Primary Key,
HoTen nvarchar(50),
NgaySinh date check(year(getdate())- year(ngaysinh)>=18),
GioiTinh bit,
HSLuong real check(HSLuong>=1.86 and HSLuong <=8.8),
TrinhDo nvarchar(30) Default N'đại học',
MaDV char(10) Not Null,
MaCV char(10) Not Null,
Foreign Key(MaDV) References DonVi(MaDV) ON Delete Cascade On Update Cascade,
Foreign Key(MaCV) References DonVi(MaCV) ON Delete Cascade On Update Cascade
)

go
insert into DonVi values('dv5',N'Kinh Doanh','0968800581')
insert into DonVi values('dv6',N'To chuc','0968800481')

go
insert into ChucVu values('cv1',N'Trưởng phòng',500000)
insert into ChucVu values('cv2',N'Nhân viên',500000)
insert into ChucVu values('cv3',N'Phó phòng',500000)
insert into ChucVu values('cv4',N'Lao công',500000)

go
insert into NhanVien values('nv6',N'Lê Thị Thu Hà','12/21/2000',0,2.6,N'đại học','dv1','cv1')
insert into NhanVien values('nv8',N'Lê Thị Thuong','12/21/2003',0,1.6,N'đại học','dv3','cv2')
insert into NhanVien values('nv9',N'Lê Van Tran','12/21/2000',0,0.6,N'đại học','dv2','cv3')
insert into NhanVien values('nv4',N'Lê Thị Thu ','12/21/2000',0,3.6,N'đại học','dv1','cv1')
insert into NhanVien values('nv7',N'Vũ Thị Thanh Tâm','10/10/2000',0,1.9,N'thạc sĩ','dv2','cv1')
go
select MaNV, HoTen, NgaySinh, HSLuong, (HSLuong*830000+ PhuCap) as LUONG
from NhanVien, ChucVu
where ChucVu.MaCV = NhanVien.MaCV

select MaNV, HoTen, GioiTinh, HSLUONG,TrinhDo, TenDV
from NhanVien inner join DonVi on DonVi.MaDV = NhanVien.MaDV
where TrinhDo = N'đại học'
order by HSLUONG desc

--Cau 1 : Tang he so luong them 0.1 cho cac nhan vien co hsl < 2 -- bangnhanvien
update NhanVien
set HSLuong = HSLuong + 0.1
where HSLuong < 2
-- Cau 2: Tang 10% hsl cho cac nhan vien la truong phong  -- nhanvien chucvu, where noi 2 bang, inner join
--update NhanVien
--set HSLuong = HSLuong*10%
--from NhanVien INNER join ChucVu on NhanVien.MaCV = ChucVu.MaCV
--where TenCV = N'Trưởng Phòng'


-- cach Trung
update NhanVien
set HSLuong = HSLuong*1.1
from ChucVu
where TenCV = (select TenCV from ChucVu where TenCV = N'Trưởng phòng')
-- Cach anh Hoang
update NhanVien
set HSLuong = HSLuong*1.1
from ChucVu
where NhanVien.MaNV = ChucVu.MaCV and TenCV = N'Trưởng phòng'

-- Cau 3 : Xoa cac nhan vien thuoc 'phong ke toan'
--delete from NhanVien inner join DonVi on NhanVien.MaDV = ChucVu.MaDV
--where tenDV = 'Phong ke toan'

--delete from NhanVien
--where MaDV = (select MaDV from DonVi where TenDV = 'Kinh Doanh')
delete from DonVi
from DonVi
where DonVi.MaDV = NhanVien.MaDV and TenDV = N'Kinh Doanh'
-- Cau 4 : Xoa khoi bang DonVi nhung don vi nao khong co nhan vien nao
--đúnggg
--delete from DonVi
--where MaDV in (select DonVi.MaDV 
--from DonVi)
-- cách khác
delete from DonVi
where MaDV not in (select distinct MaDV from NhanVien)
--Bai 2 
-- cau a : Tao khung nhin gom cac thong tin sau :manv ho ten ngay sinh tendv ten cv luong
create view DSNV
as 
select MaNV, HoTen,TenDV, TenCV, (HSLuong * 8300000 + PhuCap) as Luong
from NhanVien nv join ChucVu cv on nv.MaCV = cv.MaCV join DonVi dv on dv.MaDV = nv.MaDV
--from NhanVien, ChucVu, DonVi
--where NhanVien.MaCV = ChucVu.MaCV and DonVi.MaDV = NhanVien.MaDV 

--câu b: Tao khung nhin gom cac thong tin sau :manv ho ten ngay sinh tendv songuoi tong luong
create view TK_DV
as 
select nv.MaDV, TenDV, count(MaNV) as SoNguoi, sum(HSLuong *8300000 + PhuCap) as TongLuong
from NhanVien nv join ChucVu cv on nv.MaCV = cv.MaCV join DonVi dv on dv.MaDV = nv.MaDV
group by nv.MaDV, TenDV

-- cau  c: tao view thong ke tong luong theo gioi tinh gom : gioig tinh, tong luong
create view TK_LTGT
as
select GioiTinh, sum(HSLuong*8300000 + PhuCap) as TongLuong
from NhanVien nv join ChucVu cv on nv.MaCV = cv.MaCV
group by GioiTinh

select *from  DSNV
select * from TK_LTGT
select *from TK_DV

-- LAPTRINH SQL
--Su Dung Bien
--khai bao bien : cu phap : declare @tenbien
 -- ex : declare @Tong int , @Ngay nvarchar(45)

 -- ex iinh tong luong nhan  vien
 --@declare @TL real
 --select @TL = Sum(HSLuong*83000 + PhuCap)
 --From NhanVien Nv, ChucVU CV
 --where NV.MaCV = CV.MaCV

--Create Function Tong_Luong(@x int,@y int)
--Returns int
--As
--Begin
--Declare @tongLuong int
--Select @tongLuong = @x*8300000 + @y
--From NhanVien Inner join ChucVu on NhanVien.MaCV = ChucVu.MaCV
--Return @tongLuong
--End

-- CAU 3
-- cau a ": tao ham dua ra ten dv khi nhap vao manv tu dung phim
create function timTenDV (@MaNV char(10))
returns varchar(50)
as 
begin 
	declare @TenDV varchar(50)
	select @TenDV = TenDV
	from DonVi dv inner join NhanVien nv on dv.MaDV = nv.MaDV
	where nv.MaNV = @MaNV
	return @TenDV
end
go

-- cau b : Xay dung ham dua ra tong luong cua mot don vi voi MaDV duoc nhap tu ban phim
create function TongLuong(@MaDV char(10))
return float
as
begin
	declare @TongLuong float
	set @TongLuong = (select sum(HSLuong + 8300000 + PhuCap)
	form NhanVien nv join ChucVu cv on cv.MaCV join DonVi dv on dv.MaDV = nv.MaDV
	where nv.MaDV = @MaDV group by nv.MaDv
	return @TongLuong
end

-- cau c  Xay dung ham tinh thu nhap cua moi nhan vien voi 2ts bao là manv va xep loai . Biet rang:..
create function 

/*
	Ham vô hướng
	- Hàm đọc bảng  - giống view - có tham số 
	gọi hàm select*from Tenham(đối số 1, đối số 2)

*/
/*
create function fn_DSSPNhapTheoNgay(@xTenHang nvarchar(20))
returns Table
as
begin 
	return(select MaSP)
*/

-- cau 1 Tao hàm đưa ra thông tin các nhân viên của đơn vị gồm : manv, hoten, hesoluong, tendv, với tên đơn vị nhập từ bàn phím

create function TT_DSNV(@TenDV nvarchar(50))
returns Table
as 
--begin
return (select MaNV, HoTen, HSLuong, TenDV
		from NhanVien inner join DonVi on NhanVien.MaDV = DonVi.MaDV 
		where TenDV = @TenDV)
--end

select *from dbo.TT_DSNV('Nhân Viên')
--Câu 2 : Tạo hàm đưa ra các thông tin MaDV, TenDV, so nguoi. Tong luong voi madv nhap tu ban phim
create function TIEN_LUONG(@MaDV nvarchar(50))
returns table
as
return (select nv.MaDV, TenDV,count(MaNV) 'So Nguoi',SUM(HSLuong*830000 + PhuCap) 'Tong Luong'
		from DonVi dv inner join NhanVien nv on dv.MaDV = nv.MaDV inner join ChucVu cv on cv.MaCV = nv.MaCV
		where nv.MaDV = @MaDV
		group by nv.MaDV, TenDV)

select *from dbo.TIEN_LUONG('nv1')

-- Cau 3 : Tao ham dua ra các thông tin nhân viên trong khoảng tuổi từ x đến y gồm manv, hoten, ngày sinh, hsluong, tendv, ten cv, xy nhap tu bàn phím

create function TT_NV(@x int, @y int)
returns table
as
return (select MaNV, HoTen, NgaySinh, HSLuong, TenDV, TenCV
		from DonVi dv inner join NhanVien nv on dv.MaDV = nv.MaDV inner join ChucVu cv on cv.MaCV = nv.MaCV
		where year(getdate()) - year(NgaySinh) between @x and @y

select *from dbo.TT_NV(10,30)

--- TAO THU TUC TRONG SQL
-- Cau 1 : Tao thu tuc in ra Luong cua mot nhan vien voi ma NV nhap tu ban phim. Goi thu tuc
create proc LUONG_NV @MaNV char(10)
as
select SUM(HSLuong*830000+PhuCap) 'Luong'
from DonVi dv inner join NhanVien nv on dv.MaDV = nv.MaDV inner join ChucVu cv on cv.MaCV = nv.MaCV
where nv.MaNV = @MaNV

exec LUONG_NV 'nv8'

-- Cau 2 : Tao thu tuc dua ra danh sach nhan vien trung ten(ho dem bat ky) cua mot don vi nao do, voi MaDV va ten nhan vien nhap 
-- tu ban phim. Danh sach gom : MaNV, HoTen, NgaySinh, TenDV. Gọi thủ tục
alter proc NHAN_VIEN @MaDV char(10), @HoTen nvarchar(50) 
as
select MaNV, HoTen, NgaySinh, TenDV
from NhanVien nv inner join DonVi dv on nv.MaDV = dv.MaDV
where dv.MaDV = @MaDV and HoTen like '%' + HoTen

exec NHAN_VIEN 'dv1', N'Lê Thị Thu Hà'

-- Cau 3 : Tao thu tuc nhap bang DonVi voi cac tham so MaDV, TenDV, DienThoai. Hay kiem tra xem DienThoai da ton tai truoc do hay chua ? Neu 
-- ton tai thi tra ve 0, neu da ton tai thi cho phep xoa va tra ve 1. Goi thu tuc
create proc CHECK(@MaDV char(10), @TenDV nvarchar(50), @DienThoai char(10), @kq int output)
as
	Begin
	if(exists(select*from DonVi where DienThoai = @DienThoai))
	begin 
		insert into DonVi values (@MaDV, @TenDV, @DienThoai)
		set @kq = 0
	end
	else 
		set @kq = 1
	end

Declare @KetQua int
exec CHECK 'dv12', 'Don Vi Moi', @KetQua output
select @KetQua
declare @KetQuan int 
exec CHECK 'dv13', 'Don Vi Moi', @KetQua output
select @KetQua

-- Cau 4
go
create proc Cau4(@MaNV char(10), @output in output)
as
begin
	if(not exists (select * from NhanVien where MaNV= @MaNV))
		set @output = 0;
	else 
	begin 
		declare NhanVien
		where MaNV = @MaNV
		set @output = 1 
	end
end
go
declare @KetQua int
exec Cau4 'nv1' @KetQua output
select @KetQua as N'ket qua tra ve'
go
declare @KetQua int
exec Cau4 'nv100', @KetQua output
select @KetQua as N'Ket quan tra ve'

-- Cau 5
go
create proc Cau5(@MaNV char(10), @HoTen nvarchar(50),@NgaySinh date, @GioiTinh bit, @HSLuong real, @TrinhDo nvarchar(20), @MaCV char(10), @output in output)
as
begin
	if(exists(select * from NhanVien where MaNV = @MaNV))
		set @output = 1
	else if(not exists (select *from DonVi where MaDV = @MaDV))
		set @output = 1
	else if(not exists (select * from ChucVu where MaCV = @MaCV))
		set @output = 1
	else if (year(getdate()) - year(@NgaySinh) < 18)
		set @output = 1
	else
		insert NhanVien values (@MaNV, @HoTen, @NgaySinh, @GioiTinh, @HSLuong, @TrinhDo, @MaDV, @MaCV)
		set @output = 0
end
go
declare @KetQua int
exec Cau5 'nv1',N'Le Thu Ha','12/01/2000',0,3.6,N'Dai hoc','dv1','cv1',@KetQua output
select @KetQua as N'Ma nhan vien da ton tai'
go
select @KetQua int
exec Cau5 'nv100',N'Le Thu Ha','12/01/2000',0,3.6,N'Dai hoc','dv200','cv3', @KetQua output
select @KetQua as N'Ma don vi khong ton tai'

go
decalre @KetQua int
exec Cau5 'nv100',N'Lê Thị Thu Hà','12/21/2009',0,2.6,N'đại học','dv1','cv1', @KetQua output
select @KetQua as N'Nhan vien duoi 18 tuoi '

go 
declare @KetQua int
exec Cau5 'nv100',N'Lê Thị Thu Hà','12/21/2009',0,2.6,N'đại học','dv1','cv1', @KetQua output
slect @KetQuan as 'Ket qua tra ve '


-- TRIGGER 
create trigger trg_vd1
on NHANVIEN
for insert
as
	begin
	   declare @maNV nchar(10) -- lay ma nhan vien can dung
	   set @maNV = select maNV from inserted -- Kiem tra maNV co ton tai trong bang hay khong
		if(not exists(select * from CHUCVU where maNV = @maNV)
			begin 
				raiserror ('Loi khong co nhan vien')
				rollback transaction
			end
				
	
		
