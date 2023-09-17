use KTHP

create table benhvien
(
	mabv char(10) not null primary key,
	tenbv nvarchar(50)
)


create table khoakham
(
	makhoa char(10) not null primary key,
	tenkhoa nvarchar(50),
	sobn int,
	mabv char(10),
	foreign key(mabv) references benhvien(mabv) on delete cascade on update cascade
)

create table benhnhan
(
	mabn char(10) not null primary key,
	hoten nvarchar(50),
	ngaysinh date,
	gioitinh bit,
	songaynv int,
	makhoa char(10),
	foreign key(makhoa) references khoakham(makhoa) on delete cascade on update cascade
)


insert into benhvien values('bv1', 'A')
insert into benhvien values('bv2', 'B')
insert into benhvien values('bv3', 'C')
insert into benhvien values('bv4', 'D')

insert into khoakham values('k1',N'khoa a', 10, 'bv1')
insert into khoakham values('k2',N'khoa b', 15, 'bv2')
insert into khoakham values('k3',N'khoa c', 5, 'bv3')

insert into benhnhan values('bn1',N'tran van hoa', '10/12/2004',1 , 10, 'k1')
insert into benhnhan values('bn2',N'tran van ha', '10/12/2004',0 , 10, 'k3')
insert into benhnhan values('bn3',N'tran thi hoa', '10/2/2002',1 , 5, 'k2')
insert into benhnhan values('bn4',N'tran van hong', '1/12/2004',0 , 10, 'k1')
insert into benhnhan values('bn5',N'tran van thoa', '10/1/2003',1 , 9, 'k3')
insert into benhnhan values('bn6',N'tran van hoa', '10/12/2000',1 , 10, 'k1')


create view cau2_2
as
	select kk.makhoa, tenkhoa,count(sobn) as 'So bn nu'
	from khoakham kk inner join benhnhan bn on kk.makhoa = bn.makhoa 
	where gioitinh = 1
	group by kk.makhoa, tenkhoa

create proc cau3_3(@makhoa char(10) )
as
	select makhoa, sum(songaynv*80000) as 'Tong tien thu duoc'
	from benhnhan 
	group by makhoa
	
exec cau3_3'k1'

select*from benhnhan

-- cau 4 : 
create trigger cau4_4
on benhnhan
for insert
as	
	declare @makhoa char(10)
	set @makhoa = (select makhoa from inserted )
	declare @sobn int
	set @sobn = (select sobn from khoakham where makhoa = @makhoa)
	if(@sobn > 100)
		begin
			raiserror('Qua tai roi', 16,1)
			rollback transaction
		end
	else
		update khoakham set sobn += 1

select*from khoakham
select*from benhnhan
insert into benhnhan values('bn7',N'tran van Hau', '10/12/2000',1 , 20, 'k1')
select*from khoakham
select*from benhnhan


	

