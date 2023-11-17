create table Students(
StudentID int primary key auto_increment,
StudentName varchar(50),
Age int,
email varchar(50));

insert into students() values(1,'Nguyen Quang An',18,'an@yahoo.com');
insert into students() values(2,'Nguyen Cong Vinh',20,'vinh@gmail.com');
insert into students() values(3,'Nguyen Van Quyen',19,'quyen');
insert into students() values(4,'Pham Thanh Binh',25,'binh@.com');
insert into students() values(5,'Nguyen Van Tai Em',30,'taiem@sport.vn');

create table Classes(
ClassID int primary key auto_increment,
ClassName varchar(50));

insert into classes() values(1,'C0706L');
insert into classes() values(2,'C0708G');

create table ClassStudent(
StudentID int,
foreign key (StudentID) references Students (StudentID),
ClassID int,
foreign key (ClassID) references Classes (ClassID),
primary key (StudentID,ClassID));

insert into classstudent() values (1,1);
insert into classstudent() values (2,1);
insert into classstudent() values (3,2);
insert into classstudent() values (4,2);
insert into classstudent() values (5,2);

create table Subjects(
SubjectID int primary key auto_increment,
SubjectName varchar(50));

insert into Subjects() values(1,'SQL');
insert into Subjects() values(2,'Java');
insert into Subjects() values(3,'C');
insert into Subjects() values(4,'Visual Basic');

create table Marks(
Mark int,
SubjectID int,
foreign key (SubjectID) references Subjects (SubjectID),
StudentID int,
foreign key (StudentID) references Students (StudentID),
primary key (SubjectID,StudentID));

insert into marks () values(8,1,1);
insert into marks () values(4,2,1);
insert into marks () values(9,1,2);
insert into marks () values(7,1,3);
insert into marks () values(3,1,4);
insert into marks () values(5,2,5);
insert into marks () values(8,3,3);
insert into marks () values(1,3,5);
insert into marks () values(3,2,4);

-- 1.Hien thi danh sach tat ca cac hoc vien
select*from students;

-- 2.Hien thi danh sach tat ca cac mon hoc
select*from subjects;

-- 3.Tinh diem trung binh
select s.*,sb.*,avg(m.mark) AVG
from marks m
join students s on m.studentID=s.studentID
join subjects sb on sb.SubjectID=m.SubjectID
group by s.StudentID,sb.SubjectID;
 
-- 4.Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
select s.StudentName, sb.SubjectName,avg(m.mark) avgPoint 
from marks m
join students s on m.studentID=s.studentID
join subjects sb on sb.SubjectID=m.SubjectID
group by s.StudentID,sb.SubjectID
having avg(Mark)>=all(select avg(Mark) from marks group by marks.StudentID);

-- 5.Danh so thu tu cua diem theo chieu giam


-- 6.Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
alter table subjects modify column SubjectName nvarchar(255);

-- 7.Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
update subjects set SubjectName=concat("day la mon hoc",SubjectName);
select*from subjects;

-- 8.Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
alter table students add constraint check(age>15 and age<50);

-- 9.Loai bo tat ca quan he giua cac bang
alter table classstudent drop foreign key classstudent_ibfk_1;
alter table classstudent drop foreign key classstudent_ibfk_2;
alter table marks drop foreign key marks_ibfk_1;
alter table marks drop foreign key marks_ibfk_2;

-- 10.Xoa hoc vien co StudentID la 1
delete from students
where StudentID=1;

-- 11.Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
alter table students add column Status bit(1) default 1;

-- 12.Cap nhap gia tri Status trong bang Student thanh 0
update students set Status =0; 