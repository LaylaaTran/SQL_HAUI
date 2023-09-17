use master

create database QLSINHVIEN

use QLSINHVIEN

create table	LOP(
	malop char(10) not null primary key,
	tenlop nvarchar(50),
	siso int,
)

create table SINHVIEN(
	masv char(10) not null primary key,
	hoten nvarchar(50),
	que nvarchar(50),
	malop char(10)
	foreign key(malop) references LOP on delete cascade on update cascade
)


insert into LOP values ('1','CSDL',20)
insert into LOP values ('2','HTML',30)
insert into LOP values ('3','SQL',10)

insert into SINHVIEN values('sv1','Thuong','Ha Noi',1)
 insert into SINHVIEN values('sv2','Dat','Nghe An',2)
 insert into SINHVIEN values('sv3','Dung','Ha Noi',3)

 -- Cau 1 : Tao trigger insert sinh vien, moi khi them sinh vien hay kiem tra xem malop co ton tai khong? Si so co vuot 70 khong? neu co hay tag si so len 1

 create trigger [dbo].[trg_themsv]
 on [dbo][SinhVien]
 for insert
 as
 begin
 declare @malop nchar(10)
 --Lay ma lop cua sv vua them
 set @malop = (select malop from inserted )
 -- kiem tra co trong bang lop hay khong
 if(not exists(selet * from LOP where malop + @malop))
 begin 
	raiserror('Khong co lop nay',16,1)
	rollback transaction
end
else
begin
	declare @siso int
	set @siso = (select siso from LOP where malop = @malop)
	if(@siso >=70)
	begin 
		raiserror('Lop da co > =70 sinh vien',16,1)
		rollback transaction
		end
		else
			update LOP set siso = siso + 1
			where malop = @,alop
		end
		end
	go

 -- Cau 2 : Tao trigger delete, moi kgi xoa 1 sinh vien hay thay doi siso sinh vien trong bang lop

 go
 create trigger trg_sinh
 on SINHVIEN
 for delete
 as
 begin
	update LOP set siso = siso - 1
	from LOP inner join deleted on LOP.malop = deleted.malop
end

select * from SINHVIEN
select * from LOP
delete from SINHVIEN where masv = 'sv1'
select * from SINHVIEN
select * from LOP

 -- cau 3 viet trigger update bang sinh vien thay doi malop cho sinh vien. Kiem tra xem lop moi co > 70 khong-> cap nhat lai si so lop cu -2, lop moi +1
 go
 create trigger
 on SINHVIEN
 as
	 begin
	 declare @truoc int
	 declare @sau int
	 declare @masv = (select masv from inserted)
	 set @masv = (select masv from inserted )
	 select @truoc = deleted.malop from deleted
	 select @sau = inserted.malop from inserted
	 declare @sisomoi int
	 set @sisomoi = (select siso from LOP where malop = @sau)
	if(@sisomoi >= 70)
	begin
		raiserror('Lop moi > 70 sinh vien', 16,1)
		rollback transaction
	end
	else
	begin
		update LOP set siso = siso - 1 where malop = @truoc
		update LOP set siso = siso + 1 where malop = @sau
	end
end

select* from SINHVIEN
select * from LOP
update LOP set siso = siso - 5 where malop = '2'
select* from SINHVIEN
select * from LOP
