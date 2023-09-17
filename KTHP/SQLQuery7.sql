use de14668

create table sanpham
(
	masp char(10) not null primary key,
	tensp nvarchar(10),
	mausac char(10),
	sl int,
	giaban float
)

create table congty
(
	mact char(10) not null primary key,
	tenct nvarchar(50),
	trangthai nvarchar(20),
	thehong char(20)

)

create table cungung
(
	mact char(10),
	masp char(10),
	foreign key (masp) references sanpham(masp) on delete cascade on update cascade,
	foreign key (mact) references congty(mact) on delete cascade on update cascade,
	slcu int
)

insert into congty values('ct1', 'congty1', 'tot', 'no')
insert into congty values('ct2', 'congty2', 'tot', 'no')
insert into congty values('ct3', 'congty3', 'tot', 'no')


insert into sanpham values('sp1', 'sanpham1', 'do', 100, 1000)
insert into sanpham values('sp2', 'sanpham2', 'do', 10, 100)
insert into sanpham values('sp3', 'sanpham3', 'do', 200, 2000)

insert into cungung values('ct1', 'sp1', 100)
insert into cungung values('ct2', 'sp3', 500)
insert into cungung values('ct3', 'sp2', 200)

select*from sanpham
select*from cungung
select*from congty


create view cau2
as
	select top 2 sp.masp, tensp, mausac, sl, giaban 
	from sanpham sp inner join cungung cu on sp.masp = cu.masp
	order by slcu desc


select*from cau2


-- Cau 3
create proc cau_ba(@tenct nvarchar(10))
as
	if(not exists (select tenct from congty where tenct = @tenct))
		print('Khong ton tai')
	else 
		select tensp, mausac, sl, giaban 
		from sanpham sp  inner join cungung cu on sp.masp = cu.masp inner join  congty ct on cu.mact = ct.mact 
		where tenct = @tenct

exec cau_ba'congty1'
