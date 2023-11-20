create database hong_son;
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

select s.Name,avg(st.Mark) as 'DTB',
case when avg(st.Mark)< 5 then 'Yeu'
when avg(st.Mark)>= 5 and avg(st.Mark<7) then 'TB'
else 'Gioi' 
 end  as 'Danh gia'
from student s
join studenttest st on st.RN=s.RN
group by s.Name;

create view vw_ok as
select s.Name,avg(st.Mark) as 'DTB',
case when avg(st.Mark)< 5 then 'Yeu'
when avg(st.Mark)>= 5 and avg(st.Mark<7) then 'TB'
else 'Gioi' 
 end  as 'Danh gia'
from student s
join studenttest st on st.RN=s.RN
group by s.Name;

select * from vw_ok;