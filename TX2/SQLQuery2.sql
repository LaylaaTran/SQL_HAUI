use TX2

create table HANG
(
mahang char(10) not null primary key,
tenhang nvarchar(10),
sl int,
giaban float
)

create table HOADON
(
mahd char(10) not null primary key,
slb int,
ngayban date,
mahang char(10),
foreign key(mahang) references HANG(mahang) on delete cascade on update cascade
)

insert into HANG values('1','Bim',100, 2000)
insert into HANG values('2','Banh',200, 3000)
insert into HANG values('3','Keo',50, 2000)
insert into HANG values('4','Nuoc',70, 10000)
insert into HANG values('5','Mi',30, 6000)

insert into HOADON values('hd1',40,'10/10/2003','1')
insert into HOADON values('hd2',20,'1/10/2003','2')
insert into HOADON values('hd3',30,'10/09/2003','3')
insert into HOADON values('hd4',30,'10/09/2003','3')
insert into HOADON values('hd5',30,'10/05/2003','2')

select *from HOADON
select *from HANG

/*
Tạo trigger kiểm soát việc insert hóa đơn, trước khi insert, hãy kiểm tra xem:
• mahang cần bán có tồn tại trong bảng HANG hay không? nếu không đưa ra thông báo.
• Nếu thỏa mãn hãy kiểm tra xem soluongban<=soluong? nếu không hãy đưa ra thông báo
• Ngược lại cập nhật bảng HANG với: soluong = soluong – soluongban
*/
create trigger ThemHang
on HOADON 
for insert
as
declare @mahang char(10)
set @mahang = (select mahang from inserted)
if(not exists(select*from HANG where mahang = @mahang))
	begin
		raiserror('Loi khong co hang',16,1)
		rollback transaction
	end
else
	begin
		declare @soluong int
		declare @soluongban int
		set @soluong = (select sl from HANG where mahang = @mahang)
		set @soluongban = (select slb from inserted)
			if(@soluong < @soluongban)
			begin
				raiserror('Khong du hang',16,1)
				rollback transaction
			end
			else 
			update HANG set sl = sl - @soluongban 
			where mahang = @mahang
	end

			select *from HANG
			select*from HOADON
			insert into HOADON values('hd6',40,'10/10/2003','1')
			select *from HANG
			select*from HOADON


/*
Câu 2. Tạo trigger kiểm soát việc delete hóa đơn, lúc này bảng HANG sẽ được cập nhật:
soluong =soluong + deleted.soluongban
*/
create trigger XoaHD 
on HOADON
for delete 
as
	begin
	declare @slb int
	set @slb = (select slb from deleted)
	update HANG set sl = sl + @slb
	from HANG h inner join deleted hd on h.mahang = hd.mahang
	end
select *from HANG
select*from HOADON
delete from HOADON where mahd ='hd1'
select *from HANG
select*from HOADON

/*
Câu 3. Tạo trigger kiểm soát việc update hóa đơn, khi đó cần update soluong trong bảng hàng
*/

create trigger UPHOADON
on HOADON
for update
as
	declare @truoc int
	declare @sau int
	declare @mahang char(10)
	set @mahang = (select mahang from inserted)
	select @truoc = deleted.slb from deleted
	select @sau = inserted.slb from inserted
	update HANG set sl = sl - (@sau - @truoc)
	where mahang = @mahang

select *from HANG
select*from HOADON
update HOADON set slb = slb - 5 where mahang ='1'
select *from HANG
select*from HOADON