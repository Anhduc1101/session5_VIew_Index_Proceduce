create table customer(
cID int primary key,
Name varchar(25),
cAge tinyint);

insert into  customer() values (1,'Minh Quan',10);
insert into  customer() values (2,'Ngoc Oanh',20);
insert into  customer() values (3,'Hong Ha',50);

create table orders(
oID int primary key,
cID int,
foreign key (cID) references customer (cID),
oDate datetime,
oTotalPrice float);

insert into orders() values (1,1,'2006-3-21',null);
insert into orders() values (2,2,'2006-3-23',null);
insert into orders() values (3,1,'2006-3-16',null);

create table product(
pID int primary key,
pName varchar(25),
pPrice int);

insert into product() values (1,'May Giat',3);
insert into product() values (2,'Tu Lanh',5);
insert into product() values (3,'Dieu Hoa',7);
insert into product() values (4,'Quat',1);
insert into product() values (5,'Bep Dien',2);

create table orderDetail(
oID int,
foreign key (oID) references orders (oID),
pID int,
foreign key (pID) references product (pID),
odQTY int);

insert into orderDetail() values (1,1,3);
insert into orderDetail() values (1,3,7);
insert into orderDetail() values (1,4,2);
insert into orderDetail() values (2,1,1);
insert into orderDetail() values (3,1,8);
insert into orderDetail() values (2,5,4);
insert into orderDetail() values (2,3,3);

-- 2.Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order, 
-- danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên : 
select *from orders order by oDate desc;

-- 3.Hiển thị tên và giá của các sản phẩm có giá cao nhất
select pName,pPrice from product
order by pPrice desc
limit 1;

-- 4.Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó
select c.Name,p.pName from customer c
join orderDetail od on c.cID=od.oID
join product p on p.pID=od.PID;

-- 5.Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
select customer.cID,customer.name from customer 
where cID NOT IN(select cID from orders);

-- 6.Hiển thị chi tiết của từng hóa đơn
select o.oID, o.oDate, od.odQTY,p.pName,p.pPrice from orders o
join orderdetail od on o.oID=od.oID
join product p on p.pID=od.pID;

-- 7.Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn 
-- (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. 
-- Giá bán của từng loại được tính = odQTY*pPrice) 
select o.oID,o.oDate,sum(od.odQTY*p.pPrice) as Total from orders o
join orderdetail od on o.oID=od.oID
join product p on p.pID=od.pID
group by o.oID;

-- 8.Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị 
create view Sales as select sum(od.odQTY*p.pPrice) as Sales from orderdetail od
join product p on od.pID=p.pID;
select* from Sales;

-- 9.Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng
alter table orderdetail drop foreign key orderdetail_ibfk_1;
alter table orderdetail drop foreign key orderdetail_ibfk_2;
alter table orders drop foreign key orders_ibfk_1;

-- 10.Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm,
--  strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số,
--  và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail:
DELIMITER //
CREATE PROCEDURE delProduct(in proName varchar(255))
BEGIN
  delete from orderdetail 
  where pID in (SELECT pID FROM product WHERE pName = proName);
END //
DELIMITER ;
call  delProduct('Quat');


