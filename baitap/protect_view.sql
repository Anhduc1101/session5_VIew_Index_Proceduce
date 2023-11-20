create database session05_protectedView;
use session05_protectedView;

create table Class(
ClassID int not null primary key auto_increment,
ClassName nvarchar(255) not null,
StartDate datetime,
Status bit);

insert into Class() values (1,'A1','2008-12-20',1);
insert into Class() values (2,'A2','2008-12-22',1);
insert into Class() values (3,'B3',current_date(),0);

create table Student(
StudentID int not null primary key,
StudentName nvarchar(30) not null,
Address nvarchar(50),
Phone varchar(20),
Status bit,
ClassID int not null);

insert into Student() values(1,'Hung','Ha Noi','0912113113',1,1);
insert into Student() values(2,'Hoa','Hai Phong','',1,1);
insert into Student() values(3,'Manh','HCM','0123123123',0,2);

create table Subject(
SubID int not null primary key auto_increment,
SubName nvarchar(30) not null,
Credit tinyint not null default 1 check(credit >= 1),
Status bit(1) default 1);

insert into Subject() values (1,'CF',5,1);
insert into Subject() values (2,'C',6,1);
insert into Subject() values (3,'HDJ',5,1);
insert into Subject() values (4,'RDBMS',10,1);

create table Mark(
MarkID int not null primary key auto_increment,
SubID int unique key,
StudentID int not null unique key,
Mark float default 0 check(Mark between 0 and 100),
ExamTimes tinyint default 1);

insert into Mark() values (1,1,1,8,1);
insert into Mark() values (2,3,2,10,2);
insert into Mark() values (3,2,3,12,1);

-- 3.Sử dụng câu lệnh sử đổi bảng để thêm các ràng buộc vào các bảng theo mô tả:
-- a. Thêm ràng buộc khóa ngoại trên cột ClassID của bảng Student, tham chiếu đến cột ClassID trên bảng Class.
alter table Student add foreign key (CLassID) references Class (ClassID);
-- b. Thêm ràng buộc cho cột StartDate của bảng Class là ngày hiện hành.

-- c. Thêm ràng buộc mặc định cho cột Status của bảng Student là 1.
alter table Student alter column Status set default 1;
-- d. Thêm ràng buộc khóa ngoại cho bảng Mark trên cột:
-- SubID trên bảng Mark tham chiếu đến cột SubID trên bảng Subject
alter table Mark add foreign key (SubID) references Subject (SubID);
-- StudentID tren bảng Mark tham chiếu đến cột StudentID của bảng Student.
alter table Mark add foreign key (StudentID) references Student (StudentID);

-- 4.Thêm dữ liệu vào các bảng.

-- 5.Cập nhật dữ liệu.
-- a.Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
update Student set ClassID = 2 where StudentName='Hung';
-- b. Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.
update Student set Phone = 'No Phone' where phone=''; 
-- c. Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
update Class set ClassName = concat('New ',ClassName) where Status = 0;
-- d. Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’.
update Class set ClassName = concat('Old ',ClassName) where Status = 1;
-- e. Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
update Class set Status = 0 where ClassID not in(select ClassID from Student); 
-- f. Cập nhật trạng thái của lớp học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.
update Subject set Status = 0 where SubID not in (select SubID from Mark); 

-- 6.Hiện thị thông tin.
-- .Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
select StudentID,StudentName from Student where StudentName like 'h%';
-- a. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
select * from Class where month(StartDate) = 12;
-- b. Hiển thị giá trị lớn nhất của credit trong bảng subject.
select credit from Subject order by credit desc limit 1;
-- c. Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
select * from Subject order by credit desc limit 1;
-- d. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
select * from Subject where Credit between 3 and 5;
-- e. Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student
select c.ClassID, c.ClassName, s.StudentName, s.Address from Class c
join Student s on c.ClassID=s.ClassID;
-- f. Hiển thị các thông tin môn học chưa có sinh viên dự thi.
select*from subject where SubID not in (select SubID from Mark);
-- g. Hiển thị các thông tin môn học có điểm thi lớn nhất.
select sj.*,m.Mark 
from subject sj
join mark m
on m.subID=sj.subID
having m.Mark >= all(select Mark from Mark m group by m.SubID);
-- h. Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
select s.*, m.Mark from student s join mark m on s.StudentID=m.StudentID;
-- i. Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)
select s.*, m.Mark, rank() over (order by m.Mark desc) 'Xep Hang'
from student s join mark m on s.StudentID = m.StudentID
group by  s.StudentID , m.StudentID;
-- j. Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
select s.*, m.Mark, rank() over (order by m.Mark desc) 'Xep Hang'
from student s join mark m on s.StudentID = m.StudentID
group by  s.StudentID , m.StudentID
having m.Mark >= 10;
-- k. Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
select s.StudentName, sj.SubName, m.Mark
from Mark m
join Subject sj on m.SubID = sj.SubID
join Student s on m.StudentID = s.StudentID
order by m.Mark desc;  

-- 7.Xóa dữ liệu.
-- .Xóa tất cả các lớp có trạng thái là 0.
delete from Class where status = 0 ;
-- a. Xóa tất cả các môn học chưa có sinh viên dự thi.
delete from Subject where SubID not in (select SubID from Mark);

-- 8.hay đổi.
-- .Xóa bỏ cột ExamTimes trên bảng Mark.
alter table Mark drop column ExamTimes;
-- a. Sửa đổi cột status trên bảng class thành tên ClassStatus.
alter table class rename column ClassStatus to  ClassStatus ;
-- b. Đổi tên bảng Mark thành SubjectTest.
alter table Mark rename to SubjectTest;