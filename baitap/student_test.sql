CREATE TABLE Student(
RN int primary key,
Name varchar(20),
Age tinyint
);

CREATE TABLE Test(
TestID int primary key,
Name varchar(20)
);

CREATE TABLE StudentTest(
RN int,
TestID int,
Date datetime,
Mark float,
foreign key(RN) references Student(RN),
foreign key(TestID) references Test(TestID)
);

insert into Student values(1,'nguyen hong ha',20);
insert into Student values(2,'truong ngoc anh',30);
insert into Student values(3,'tuan minh',25);
insert into Student values(4,'dan tuong',22);

insert into Test values(1,'QQQ');
insert into Test values(2,'EEWWE');
insert into Test values(3,'SDDSSD');
insert into Test values(4,'HGHGH');

insert into StudentTest values(1,1,'2006-7-17',8);
insert into StudentTest values(1,2,'2006-7-18',5);
insert into StudentTest values(1,3,'2006-7-19',7);
insert into StudentTest values(2,1,'2006-7-17',7);
insert into StudentTest values(2,2,'2006-7-18',4);
insert into StudentTest values(2,3,'2006-7-19',2);
insert into StudentTest values(3,1,'2006-7-17',10);
insert into StudentTest values(3,3,'2006-7-18',1);

-- 2.Sử dụng alter để sửa đổi
-- a. Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55
alter table student add constraint check(Age>15 and Age<55);
-- b. Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
alter table studenttest 
alter column mark set default 0;
-- c. Thêm khóa chính cho bảng studenttest là (RN,TestID)
alter table studenttest add primary key (RN,TestID);
-- d. Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
alter table test add constraint unique(name);
-- e. Xóa ràng buộc duy nhất (unique) trên bảng Test
alter table test 
drop index name;

-- 3.Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi 
select DENSE_RANK() OVER (ORDER BY avg(st.mark) DESC) AS XepHang,s.Name,t.Name,st.Mark,st.Date
from studenttest st
join student s on s.RN=st.RN
join test t on t.TestID=st.TestID
group by st.RN,st.TestID;

-- 4.Hiển thị danh sách các bạn học viên chưa thi môn nào
select s.RN,s.Name,s.Age from student s
left join studenttest st on st.RN=s.RN
where st.RN is null;

-- 5.Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5) 
select DENSE_RANK() OVER (ORDER BY avg(st.mark) DESC) AS XepHang,s.Name,t.Name,st.Mark,st.Date
from studenttest st
join student s on s.RN=st.RN
join test t on t.TestID=st.TestID
group by st.RN,st.TestID
having st.Mark<5;

-- 6.Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi.
--  Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần(nếu không sắp xếp thì chỉ được ½ số điểm)
select dense_rank() over(order by avg(st.mark) desc) as "",s.Name,avg(st.mark) avgMark
from student s
join studenttest st on st.RN=s.RN
group by st.RN,s.RN
order by avg(mark) desc;

-- 7.Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất
select dense_rank() over(order by avg(st.mark) desc) as "",s.Name,avg(st.mark) avgMark
from student s
join studenttest st on st.RN=s.RN
group by st.RN,s.RN
-- limit 1;
having avg(mark)>=all(select avg(mark) from studenttest st group by st.RN);

-- 8.Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học
select dense_rank() over(order by avg(st.mark) desc)as"",t.Name as "Test Name",max(st.Mark) as "Max Mark"
from studenttest st
join test t on t.TestID=st.TestID
group by t.Name;

-- 9.Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null
select dense_rank() over(order by avg(st.mark) desc)as"",s.Name as "Student Name",t.Name as "Test Name"
from student s 
left join studenttest st on st.RN=s.RN
left join test t on t.TestID=st.TestID
group by s.Name,t.Name;

-- 10.Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update student set Age=Age+1;

-- 11.Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table student add column Status varchar(10);

-- 12.Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’,
 -- trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student
 -- cach 1
 update student set Status =  if(Age<30,'Young','Old') ;
 -- cach 2
 update student SET Status = CASE WHEN Age < 30 THEN 'Young' ELSE 'Old' END;

-- 13.Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi
select s.Name,t.Name,st.Mark,st.Date
from studenttest st 
join test t on t.TestID=st.TestID
join student s on s.RN=st.RN
group by s.Name,t.Name,st.Mark,st.Date
order by st.Date asc;

-- 14.Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5.
-- Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
select s.Name,s.Age,avg(st.mark)
from student s
join studenttest st on st.RN=s.RN
group by s.Name,s.Age
having s.Name like 't%' and avg(st.mark)>4.5;

-- 15.Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng).
-- Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1.
select s.*,avg(st.Mark),dense_rank() over(order by avg(st.mark) desc)as"Xep Hang"
from student s
join studenttest st on st.RN=s.RN
group by s.RN;

-- 16.Sủa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)
alter table student modify column name nvarchar(255); 

-- 17.Cập nhật (sử dụng phương thức write) cột name trong bảng student với yêu cầu sau:
-- a. Nếu tuổi >20 -> thêm ‘Old’ vào trước tên (cột name)
-- b. Nếu tuổi <=20 thì thêm ‘Young’ vào trước tên (cột name)
-- cach 1:
update student set name = concat(if(Age>20,'Old','Young'),name);
-- cach 2
update student set name = case when Age>20 then concat('Old',name) else concat('Young',name) end;

-- 18.Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi
-- cach 1
delete from test where TestID not in (select TestID from studenttest);
-- cach 2
delete from test
where TestID=(
select t.TestID 
from test t 
join studenttest st on st.TestID=t.TestID
where st.TestID is null);

-- 19.Xóa thông tin điểm thi của sinh viên có điểm <5
delete from studenttest where mark<5;
