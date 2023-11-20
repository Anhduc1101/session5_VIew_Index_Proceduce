use session05_Assignment;
create table Phim(
PhimID int primary key auto_increment,
Ten_phim nvarchar(30),
Loai_phim nvarchar(25),
Thoi_gian int);

insert into phim() values(1,'Em bé Hà Nội','Tâm lý',90);
insert into phim() values(2,'Nhiệm vụ bất khả thi','Hành động',100);
insert into phim() values(3,'Dị nhân','Viễn tưởng',90);
insert into phim() values(4,'Cuốn theo chiều gió','Tình cảm',120);

create table Phong(
PhongID int primary key auto_increment,
Ten_phong nvarchar(20),
Trang_thai tinyint);

insert into Phong() values (1,'Phòng chiếu 1',1);
insert into Phong() values (2,'Phòng chiếu 2',1);
insert into Phong() values (3,'Phòng chiếu 3',0);

create table Ghe(
GheID int primary key auto_increment,
PhongID int,
foreign key (PhongID) references Phong (PhongID),
So_ghe varchar(10));

insert into Ghe() values(1,1,'A3');
insert into Ghe() values(2,1,'B5');
insert into Ghe() values(3,2,'A7');
insert into Ghe() values(4,2,'D1');
insert into Ghe() values(5,3,'T2');

create table Ve(
PhimID int,
foreign key (PhimID) references Phim (PhimID),
GheID int,
foreign key (GheID) references Ghe (GheID),
Ngay_chieu datetime,
Trang_thai nvarchar(20));

insert into Ve() values(1,1,'2008-10-20','Đã bán');
insert into Ve() values(1,3,'2008-11-20','Đã bán');
insert into Ve() values(1,4,'2008-12-23','Đã bán');
insert into Ve() values(2,1,'2009-02-14','Đã bán');
insert into Ve() values(3,1,'2008-02-14','Đã bán');
insert into Ve() values(2,5,'2009-03-08','Chưa bán');
insert into Ve() values(2,3,'2009-03-08','Chưa bán');

-- 2.Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)
select *from Phim order by Thoi_gian asc;

-- 3.Hiển thị Ten_phim có thời gian chiếu dài nhất
select *from Phim order by Thoi_gian desc
limit 1;

-- 4.Hiển thị Ten_Phim có thời gian chiếu ngắn nhất
select *from Phim order by Thoi_gian asc
limit 1;
-- 5.Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’
select*from Ghe where So_ghe like 'A%';

-- 6.Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)
alter table Phong modify column Trang_thai nvarchar(25);

-- 7.Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:
-- Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’
-- Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’
-- Nếu Trang_thai=null thì gán Trang_thai=’Unknow’
-- Sau đó hiển thị bảng tblPhong

-- cách 1: CASE
update Phong set Trang_thai = case
when Trang_thai = 0 then 'Đang sửa'
when Trang_thai = 1 then 'Đang sử dụng'
when Trang_thai = null then 'unknown'
end;

-- cách 2: IF-ELSE
update Phong set Trang_thai = if(Trang_thai=0,'Đang sửa',if(Trang_thai = 1, 'Đang sử dụng', 'Unknown')); 

-- 8.Hiển thị danh sách tên phim mà có độ dài >15 và < 25 ký tự
-- cach 1: AND
select * from Phim where length(Ten_phim) >=15 and length(Ten_phim) <=25;

-- cach 2: BETWEEN
select * from Phim where length(Ten_Phim) between 15 and 25;

-- 9.Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
select p.Ten_phong,p.Trang_thai as 'Trạng thái phòng chiếu' from Phong p;

-- 10.Tạo bảng mới có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
create table Ranks(
STT int,
TenPhim varchar(30),
Thoi_gian int );

-- 11.Trong bảng tblPhim :
-- a. Thêm trường Mo_ta kiểu nvarchar(max)
alter table Phim add column Mo_ta nvarchar(255);
-- b. Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại ” + nội dung trường LoaiPhim
update Phim set Mo_ta = concat('Đây là bộ phim thể loại ',Loai_phim);
-- c. Hiển thị bảng tblPhim sau khi cập nhật
select * from Phim;
-- d. Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film”
update Phim set Mo_ta = replace(Mo_ta,'bộ phim','film');
-- e. Hiển thị bảng tblPhim sau khi cập nhật
select * from Phim;

-- 12.Xóa tất cả các khóa ngoại trong các bảng trên.
alter table Ghe drop foreign key ghe_ibfk_1; 
alter table Ve drop foreign key ve_ibfk_1; 
alter table Ve drop foreign key ve_ibfk_2; 

-- 13.Xóa dữ liệu ở bảng tblGhe
delete from Ghe;

-- 14.Hiển thị ngày giờ hiện tại và ngày giờ hiện tại cộng thêm 5000 phút
-- Hiển thị ngày giờ hiện tại
SELECT now() AS 'Ngày giờ hiện tại';
-- Hiển thị ngày giờ hiện tại cộng thêm 5000 phút
select date_add(now(),interval 5000 minute) as 'ngày giờ hiện tại cộng thêm 5000 phút';