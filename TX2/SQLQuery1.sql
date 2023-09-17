use TX2

create table Lop
(
MaLop char(10) not null primary key,
TenLop nvarchar(30),
Siso int
)

create table SinhVien
(
MaSV char(10) not null primary key,
HoTen nvarchar(50),
Que nvarchar(30),
MaLop char(10)
foreign key(MaLop) references Lop(MaLop) on delete cascade on update cascade
)

insert into Lop values('1','Toan',20)
insert into Lop values('2','Van',10)
insert into Lop values('3','Anh',30)
insert into Lop values('4','Hoa',10)
insert into Lop values('5','Lich su',10)

insert into SinhVien values('sv1','Tran Thi Thuong','Ha Noi','1')
insert into SinhVien values('sv2','Tran Thi Huong','Ha Noi','2')
insert into SinhVien values('sv3','Tran Thi Tuong','Ha Noi','3')
insert into SinhVien values('sv4','Tran Thi Tung','Ha Noi','1')
insert into SinhVien values('sv5','Tran Thi Dung','Ha Noi','2')

-- TRIGGER
/*
Cau 1: Tao trigger insert sinh vien,
moi khi them sinh vien hay kiem tra xem malop co ton tai khong>
Si so co vuot qua 70 khong. neu thoa man hay tang si so len1 
*/

create trigger themSV on SinhVien
for insert 
as 
	declare @MaLop char(10)
	set @MaLop = (select MaLop from inserted)
	if(not exists(select*from Lop where MaLop = @MaLop))
		begin
		raiserror('Khong co lop nay',16,1)
		rollback transaction
		end
	else
		declare @SISO int
		set @SISO = (select SiSo from Lop where MaLop = @MaLop)
			if(@SiSo >= 70)
			begin
				raiserror('Lop da co 70 sinh vien',16,1)
				rollback transaction
				end
			else
				update Lop set SiSo = SiSo + 1
				where MaLop = @MaLop


				-- GOi trigger
			select * from SinhVien 
			select*from Lop
			Insert into SinhVien values('sv6','Tran Dung','Ha Noi','3')
			select * from SinhVien 
			select*from Lop

/*
Tao trigger delete, moi khi xoa 1 sinh vien, hay thay doi siso sinh vien trong bang Lop
*/
create trigger XoaSV 
on SinhVien
for delete
as
	update Lop set siso = siso - 1 
	from SINHVIEN sv inner join deleted hd on sv.MaLop = hd.MaLop
	
		select * from SinhVien 
		select*from Lop
		delete from SinhVien where MaSV = 'sv1'
		select * from SinhVien 
		select*from Lop

/*
Viet trigger update bang sinh vien thay doi ma lop cho sinh vien.Kiem tra xem lop mio co >70 khong
-> cap nhat lai si so lop cu-1, lop moi +1
*/

create trigger UPSV
on SinhVien
for update
as
	declare @siso int
	set @siso = (select siso from Lop)
	if(@siso >=70)
		begin
			raiserror('Si so qua 70 khong',16,1)
			rollback transaction
		end
	else 
	declare @truoc int
	declare @sau int
	declare @malop char(10)
	set @truoc = (select siso from Lop)
	update @sau = truoc - 1 wh
