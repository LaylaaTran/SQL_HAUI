-- su dung nhanh master
use master


--xem database đấy o chua, co thi xoa
go
if DB_ID('QuanLi') is not null
	drop database QuanLi

go
create database QuanLi

go

use QuanLi
-- Chia khoa huong vao dau thi viet bang do truoc
go 
create table DonVi
(
MaDV char(10) not null primary key,
TenDV nvarchar(50),
DienThoai char(10)
)

go
create table ChucVu
(
MaCV char(10)  not null primary key,
TenCV nvarchar(50),
PhuCap real
)

go
create table NhanVien
(
MaNV char(10)  not null primary key,
HoTen nvarchar(50),
NgaySinh date check(year(getdate()) - year(ngaysinh) >=18),
GioiTinh bit,
HSLuong real check(HSLuong >=1.86 and HSLuong <=8.8),
TrinhDo nvarchar(20) default N'Dai hoc',
MaDV char(10),
MaCV char(10),
foreign key(MaDV) references DonVi(MaDV) on delete cascade on update cascade,
foreign key(MaCV) references ChucVu(MaCV) on delete cascade on update cascade
)

go 
insert into DonVi values('dv1', N'Kinh doanh', '0968500581')
insert into DonVi values('dv2',N'To chuc', '0234233232')


go
insert into ChucVu values('cv1', N'Truong phong', 500000)
insert into ChucVu values('cv2', N'PhoPhong', 300000)
insert into ChucVu values('cv3', N'Nhan vien', 100000)

go 
insert into NhanVien values('cv1', N'Le Thi Thuong', '12/09/2022', 1, 4.8 , N'daihoc', 'dv1', 'cv1')
insert into  NhanVien values('cv2', N'Le Thi Hong', '12/09/2003', 1, 5.8 , N'daihoc', 'dv1', 'cv2')
insert into NhanVien values('cv3', N'Le Thi Huong', '12/09/2004', 0, 2.8 , N'daihoc', 'dv2', 'cv1')
insert into  NhanVien values('cv4', N'Le Thi Thong', '12/09/1992', 0, 3.0 , N'daihoc', 'dv2', 'cv3')

select * from NhanVien

-- Cau 1 : Dua ra thong tin manv, hoten ngay sinh hsl luong
-- cach 1
select MaNV, HoTen, NgaySinh, HSLuong, HSLuong*830000+PhuCap as Luong
from NhanVien,ChucVu 
where ChucVu.MaCV = NhanVien.MaCV 
-- cach 2
select MaNV, HoTen, NgaySinh, HSLuong, HSLuong*830000+PhuCap as Luong
from NhanVien inner  join ChucVu on NhanVien.MaCV = ChucVu.MaCV 

-- Cau 2: Dua ra cac nhan vien co trinh do DH duoc sxgiam theo hsl: manv, ho te,
-- gioii tinh , hsluong , trinh do, ten dv

select MaNV, HoTen, GioiTinh, HSLuong, TenDV
from NhanVien inner join DonVi on NhanVien.MaCV = DonVi.MaCV
where TrinhDo = N'daihoc'
order by HSLuong DESC

-- Cau 3 : Tao bang "NV_Nu" luu cac thanh vien la "nu" voi cac tohng tin : MaNV, HoTen, Tuoi
select MaNV, HoTen, Year(GETDATE()) - Year(NgaySinh) as TuoiNVNu
into NV_Nu
from NhanVien

-- cau 4 : Dua ra cac nhan vien co ten la Anh , cO HSL >2.67 va hsl <= 8.0
select *
from NhanVien
where HoTen like '%Anh' and HSLuong between 2.67 and 8.0


-- cau 5 : Dua ra nhung nhan vien den tuoi nghi huu . nam >=60 , nu >=55
select *
from NhanVien
where (GioiTinh = 1) And (Year(GETDATE())- Year(NgaySinh)) >=60
or (GioiTinh = 0) And (Year(GETDATE()) - Year(NgaySinh)) >= 55

-- cau 6: Thong ke so nhan vien trong tung don vi voi cac thong tin MaDV, TenDV, so nguoi
select nv.MaNV, TenDV, count(MaNV) as SoNguoi
from NhanVien nv inner join DonVi dv on nv.MaDV = dv.MaDV
group by nv.MaDV, TenDV


--Cau 7 : Thong ke tong luogn trong tung don vi voi cac thong tin : ma dv, tendv, tongluong
select nv.MaNV, TenDV, HSLuong*830000 + PhuCap as Luong
from NhanVien nv inner join DonVi dv on nv.MaDV = dv.MaDV inner join ChucVu cv on cv.MaCV = nv.MaNV
group by nv.MaDV, TenDV

-- cau 8 : Dua ra cac nhan vien co cung ngay sinh voi cac nhan vien co manv ='nv0012'
select *
from NhanVien
where NgaySinh = ( select NgaySinh from NhanVien where MaNV = 'nv0012')
-- where NgaySinh in (select Nga...)

--Cau 9  : Dua ra cac nhan vien co muc luong cao nhat

select *
from NhanVien nv inner join ChucVu cv on nv.MaCV = cv.MaCV
 where (HSLuong*830000 + PhuCap) = (Select Max(HSLuong*830000+PhuCap) 
									from NhanVien nv inner join ChucVu cv on nv.MaCV = cv.MaCV)

-- Cau 10 Dua ra do tuoi trung binh cua cac nhan vien co chuc vu truong phong
select TuoiTB = AVG(year(getdate())- year(NgaySinh))
from NhanVien  nv inner join ChucVu cv on nv.MaCV = cv.MaCV
where TenCV = N'Truong phong'


-- Cau 12 Dua ra don vi co nhieu nha vien nhat, gom cac thong tin madv, ten dv , tong luong

--- Bai 3
--1 Tăng hệ số lương thêm 0.1 cho các nhân viên có hệ số lương<2
--2. Tăng 10% hệ số lương cho các nhân viên là trưởng phòng
--3. Xoá các nhân viên thuộc ‘phòng kế toán’
--4. Xóa khỏi bảng DonVi những đơn vị không có nhân viên nào.

update NhanVien
set HSLuong = HSLuong + 0.1
where HSLuong < 2

update NhanVien
set HSLuong = HSLuong *1.1
from ChucVu inner join NhanVien on ChucVu.MaCV = NhanVien.MaCV
where TenCV = N'Truong phong'

delete from NhanVien 
from DonVi inner join NhanVien on DonVi.MaDV = NhanVien.MaDV
where TenDV = N'Ke toan'

delete from DonVi
where MaDV not in (select distinct MaDV from NhanVien)


--TAO VIEW
-- 1. Tạo view gồm các thông tin sau: manv, hoten, ngaysinh, tendv, tencv, Luong.
--2. Tạo view thống kê số người và tổng lương của từng đơn vị gồm các thông tin sau: madv, tendv, số
--người, tổng lương.
--3. Tạo view thống kê tổng lương theo giới tính gồm: giới tính(nam,nữ), tổng lương.

CREATE VIEW DanhSachNV 
as 
select MaNV, HoTen, NgaySinh, TenDV, SUM(HSLuong*830000+PhuCap) as Luong 
from ChucVu cv inner join NhanVien nv on cv.MaCV = nv.MaNV inner join DonVi dv on dv.MaDV= nv.MaDV
where dv.MaDV
select*from DanhSachNV