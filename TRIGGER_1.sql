use master

create database QLBANHANG

use QLBANHANG

create table HANG(
	mahang char(10) not null primary key,
	tenhang nvarchar(50),
	soluong int,
	giaban float
)

create table HOADON(
	mahd char(10) not null primary key,
	soluongban int,
	ngayban date,
	mahang char(10) 
	foreign key(mahang) references HANG on delete cascade on update cascade
)

insert into HANG values ('mh1','Bim bim', 10,10)
insert into HANG values ('mh2','Keo', 1,1)
insert into HANG values ('mh3','Banh ', 9,7)

insert into HOADON values('hd1',3,'10/10/2003', 'mh1')
insert into HOADON values('hd2',3,'7/9/2003', 'mh1')
insert into HOADON values('hd5',4,'15/1/2003', 'mh2')
 
 /*
 Cau 1 : Tao trigger kiem soat viec insert hoa don, truojt khi insert, hay kiem tra xem:
 mahang can ban co ton tai trong bang HANG hay khong, neu khong dua ra thong bao
 neu thoa man hay kiem tra xem soluongban <=sluong? neu khong hay dua ra thong bao
 nguoc lai cap nhat bangr hang voi soluong = soluong - soluong ban
 */
create trigger trg_themhd
on HOADON
for insert
as begin
	declare @mahang char(10) --lay ma hang can ban
	set @mahang = (select mahang from inserted)
	if(not exists(select * from HANG where mahang = @mahang)) -- kiem tra xem ma hang co trong bang hay khong
		begin
			raiserror('Loi khong co hang',16,1)
			rollback transaction
		end
	else 
		begin
		declare @soluong int
		declare @soluongban int 
		set @soluong = (select soluong from hang 
		where mahang = @mahang)
		set @soluongban = (select soluongban from inserted)
		if(@soluong < @soluongban )
			begin
			raiserror('Ban khong du hang',16,1)
			rollback transaction
		end
		else
		update HANG set soluong = soluong - @soluongban where mahang = @mahang
		end
	end

	select * from HANG
	select * from HOADON

	insert into HOADON values('hd4',2,'1/10/2003', 'mh1')
	select * from HOADON

	/*
		Tạo trigger kiểm soát việc delete HOADON , lúc này bảng HANG sẽ được cập nhật : 
		soluong= soluong + delete.soluongban
	*/

create trigger trg_capnhathoadon
on HOADON
for delete
as
begin
	update HANG set soluong = soluong + deleted.soluongban
	from HANG inner join deleted
	on HANG.mahang = deleted.mahang
end

select * from HANG
select * from HOADON
delete from HOADON where mahd ='hd1'
select * from HANG
select * from HOADON

/*
 Cau 3: Tạo trigger kiem soat viec update hoá đơn, khi đó cần update số lượng trong bảng hàng

*/

create trigger trg_capnhathoadno
on HOADON
for update
as
begin
	declare @truoc int
	declare @sau int
	declare @mahang char(10)
	set @mahang = (select mahang from deleted)
	select @truoc = deleted.soluongban from deleted
	select @sau = inserted.soluongban from inserted
	update hang set soluong = soluong - (@sau - @truoc)
	where mahang = @mahang
end

-- test
select * from HANG
select * from HOADON

update HOADON set soluongban = soluongban - 5
where mahang = 'mh2'

select * from HANG
select * from HOADON

