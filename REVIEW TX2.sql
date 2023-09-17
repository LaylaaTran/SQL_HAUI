use test

create table DonVi
(
MaDV char(10) not null primary key,
TenDV nvarchar(10),
DienThoai char(10) check (DienThoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

create table ChucVu
(
MaCV char(10) not null primary key,
TenCV nvarchar(50),
PhuCap real
)

create table NhanVien
(
MaNV char(10) not null primary key,
HoTen nvarchar(50),
NgaySinh date,
GioiTinh bit,
HSLuong real,
TrinhDo nvarchar(20),
MaDV char(10) not null,
MaCV char(10) not null,
Foreign Key(MaDV) references DonVi(MaDV) on delete cascade on update cascade,
Foreign key(MaCV) references ChucVu(MaCV) on delete cascade on update cascade
)

insert into ChucVu values('cv1',N'Nhan vien',5000000)
insert into ChucVu values('cv2',N'Truong Phong',5000000)
insert into ChucVu values('cv3',N'Pho Phong',5000000)

alter table DonVi alter column TenDV nvarchar(50)

insert into DonVi values('dv1','Phong Kinh Doanh','0968804541')
insert into DonVi values('dv2', N'Phong Kế toán','0948800181')
insert into DonVi values('dv3',N'Phong Sale','0368800591')
insert into DonVi values('dv4',N'Phong Buôn','0568800521')

insert into NhanVien values('nv1',N'Trần Thị Thuong','10/10/2003', 1 ,3.6, 'Dai hoc','dv1','cv1')
insert into NhanVien values('nv2',N'Trần Thị Huyen','10/10/2003', 1 ,5.6, 'Dai hoc','dv4','cv1')
insert into NhanVien values('nv3',N'Trần Van Dung','10/10/2003',0 ,7.6, 'Dai hoc','dv3','cv3')
insert into NhanVien values('nv5',N'Trần Van Dat','10/10/2003', 0 ,1.6, 'Dai hoc','dv2','cv2')

--PHAN HAM-------
-- HAM DOC BANG
-- cau 1 Tao hàm đưa ra thông tin các nhân viên của
--đơn vị gồm : manv, hoten, hesoluong, tendv, với tên đơn vị nhập từ bàn phím
create function thongTin(@TenDV nvarchar(50))
	returns table
	as
	--begin 
	return(select MaNV,HoTen,HSLuong,TenDV 
			from DonVi dv inner join NhanVien nv on dv.MaDV = nv.MaNV
			where TenDV = @TenDV)
	--end

select*from thongTin('Phong Sale')

--Câu 2 : Tạo hàm đưa ra các thông tin MaDV, TenDV, so nguoi. voi madv nhap tu ban phim
create function cau2(@MaDV char(10))
	returns table
	as
	return(select MaDV, TenDV, count(MaDV) as 'So Nguoi'
			from DonVi
			where MaDV = @MaDV
			group by MaDV, TenDV)

select*from cau2('dv1')

--Câu 4 : Tạo hàm đưa ra các thông tin MaDV, TenDV, so nguoi. voi madv nhap tu ban phim
create function cau4(@MaDV char(10))
	returns table
	as
	return(select nv.MaDV, TenDV, count(nv.MaNV) as 'So Nguoi', sum(HSLuong*830000 + PhuCap) as 'Tong Luong'
			from DonVi dv inner join NhanVien nv on nv.MaDV = dv.MaDV inner join ChucVu cv on cv.MaCV = nv.MaCV
			where nv.MaDV = @MaDV
			group by nv.MaDV, TenDV
			)

select*from cau4('dv2')

-- Cau 3 : Tao ham dua ra các thông tin nhân viên trong khoảng tuổi từ x đến y gồm manv, hoten, ngày sinh, hsluong, tendv, ten cv, xy nhap tu bàn phím
create function cau5(@x int, @y int)
returns table
as
return (
	select MaNV, HoTen, NgaySinh, HSLuong, TenDV, TenCV
	from ChucVu cv inner join NhanVien nv on cv.MaCV = nv.MaNV inner join DonVi dv on nv.MaDV = dv.MaDV
	where year(getdate()) - year(NgaySinh) between @x and @y
)

select*from cau5(18,50)

-- TAO THU TUC
-- Cau 1 : Tao thu tuc in ra Luong cua mot nhan vien voi ma NV nhap tu ban phim. Goi thu tuc
	create proc cau11(@MaNV char(10))
	as
		select HSLuong*830000 + PhuCap as 'Luong'
		from DonVi dv inner join NhanVien nv on dv.MaDV = nv.MaNV inner join ChucVu cv on nv.MaCV = cv.MaCV
		where MaNV = @MaNV
		
	exec cau11 'nv1'

-- Cau 2 : Tao thu tuc dua ra danh sach nhan vien trung ten(ho dem bat ky) cua mot don vi nao do
--, voi MaDV va ten nhan vien nhaptu ban phim. Danh sach gom : MaNV, HoTen, NgaySinh, TenDV.
--Gọi thủ tục

create proc cau2(@MaDV char(10), @TenNV nvarchar(50))
as
	select nv.MaNV, HoTen, NgaySinh, TenDV
	from NhanVien nv inner join DonVi dv on nv.MaDV = dv.MaDV 
	where nv.MaDV = @MaDV and HoTen = @TenNV

exec cau2'dv1','Trần Thị Thuong'
	

-- Cau 3 : Tao thu tuc nhap bang DonVi voi cac tham so MaDV, TenDV, DienThoai.
--Hay kiem tra xem DienThoai da ton tai truoc do hay chua ? Neu 
--  chua ton tai thi tra ve 0, neu da ton tai thi cho phep xoa va tra ve 1.
--Goi thu tuc

create proc cau3(@MaDV char(10),@TenDV nvarchar(50), @DienThoai char(10))
as
	if(exists(select*from DonVi where DienThoai = @DienThoai))
		print'Dien thoai da ton tai'
	else
		insert into DonVi values(@MaDV, @TenDV, @DienThoai)
		print'Insert successful'

select*from DonVi
exec cau3'dv5','HOHO','0968804541'

select*from DonVi

-- CAU3 THEM XOA
create proc cau33(@MaDV char(10), @TenDV nvarchar(50), @DienThoai char(10))
as
	if(exists(select*from DonVi where MaDV = @MaDV))
		print'Ma DV da ton tai'
	else
		insert into DonVi values(@MaDV, @TenDV, @DienThoai)

select*from DonVi
exec cau33'dv5','HEHE','0968804541'

create proc cau3_n(@MaDV char(10), @TenDV nvarchar(50), @DienThoai char(10), @KQ int output)
as
	if(exists(select*from DonVi where TenDV = @TenDV))
		set @KQ = 1
	else 
		insert into DonVi values(@MaDV, @TenDV, @DienThoai)
		set @KQ = 0  
	return @KQ

select*from DonVi
declare @KETQUA int
exec cau3_n'dv7','HEHE','0968804541', @KETQUA output
select @KETQUA
-- Câu 4 : Tạo thủ tục xoá dữ liệu bảng NhanVien với tham số Manv nhập từ bàn phím.
--Hãy kiểm tra xem Manv đã tồn tại trước đó hay chưa? Nếu chưa trả về 0, rồi xoá và 1
-- gọi thủ tục

create proc cau4(@MaNV char(10), @KQ int output)
as
	if(exists(select *from NhanVien where MaNV = @MaNV))
		set @KQ = 1
	else
		delete from NhanVien where MaNV = @MaNV
		set @KQ = 0
	return @KQ 

select*from NhanVien
declare @KETQUA int
exec cau4'nv1', @KETQUA output
select @KETQUA

select*from NhanVien
--Câu 5 : Tạo thủ tục thêm mới dữ liệu cho bảng NhanVien. Thủ tục kiểm tra tính hợp lệ của dữ liệu trước khi thêm
--(khong hop le tra ve 0, hợp lệ trả veef 1)
-- MaNV là duy nhẩt. MaDV phải có trong bảng DonVi. MaCV phai co ChucVu. NhanVien >= 18t.
--GOi thu tuc trong cac truong hop

create proc cau5(
	@MaNV char(10), 
	@HoTen nvarchar(50),
	@NgaySinh date,
	@GioiTinh bit,
	@HSLuong real,
	@TrinhDo nvarchar(20),
	@MaDV char(10),
	@MaCV char(10),
	@KQ int output
)

as 
	if(exists(select*from NhanVien where MaNV = @MaNV))
		set @KQ = 1
	else if(exists(select*from DonVi where MaDV = @MaDV))
		set @KQ = 1
	else if(exists(select*from ChucVu where MaCV = @MaCV))
		set @KQ = 1
	else if( year(getdate()) - year(@NgaySinh) < 18)
		set @KQ = 1
	else
		insert into NhanVien values(@MaNV,@HoTen,@NgaySinh,@GioiTinh,@HSLuong, @TrinhDo,@MaDV, @MACV)   
		set @KQ = 0;
	return @KQ

select*from DonVi dv inner join NhanVien nv on dv.DienThoai = nv.MaNV inner join ChucVu cv on nv.MaNV = cv.MaCV
declare @KETQUA int 
exec cau5'nv1',N'THUONG','10/10/2001',1,3.6,N'Dai hoc','dv8','cv9', @KETQUA output
select @KETQUA as 'Ket qua'

-- TRIGGER
-- Cau 1:
 --Tạo trigger kiểm soát việc insert hoá đơn, trước khi insert, hãy kiểm tra xem
 /*
 - MaNV co ton tai trong bang NhanVien hay khong? Neu khong dua ra thong bao
  MaDV phải có trong bảng DonVi. MaCV phai co ChucVu.
  NhanVien >= 18t.
--Cập nhật bảng NhanVien với Soluong = s
 */
