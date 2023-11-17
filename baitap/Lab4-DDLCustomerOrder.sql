-- 1.Tạo 4 bảng và chèn dữ liệu như hình dưới đây:
create table Customer(
cID int primary key,
Name varchar(25),
cAge tinyint);

insert into customer() values(1,'Minh Quan',10);
insert into customer() values(2,'Ngoc Oanh',20);
insert into customer() values(3,'Hong Ha',50);

create table Product(
pID int primary key,
pName varchar(25),
pPrice int);

insert into product() values (1,'May Giat',3);
insert into product() values (2,'Tu Lanh',5);
insert into product() values (3,'Dieu Hoa',7);
insert into product() values (4,'Quat',1);
insert into product() values (5,'Bep Dien',2);

create table Orders(
oID int primary key,
cID int,
foreign key (cID) references customer (cID),
oDate datetime,
oTotalPrice int);

insert into orders() values(1,1,'2006-3-21',null);
insert into orders() values(2,2,'2006-3-23',null);
insert into orders() values(3,1,'2006-3-16',null);

create table OrderDetail(
oID int,
foreign key (oID) references orders (oID),
pID int,
foreign key (pID) references product (pID),
odQTY int);

insert into orderdetail() values(1,1,3);
insert into orderdetail() values(1,3,7);
insert into orderdetail() values(1,4,2);
insert into orderdetail() values(2,1,1);
insert into orderdetail() values(3,1,8);
insert into orderdetail() values(2,5,4);
insert into orderdetail() values(2,3,3);

-- 2.Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng,
--  hóa đơn mới hơn nằm trên như hình sau:
select oID,oDate,oTotalPrice from orders
order by oDate desc;

-- 3.Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau
select pName, pPrice from product
having pPrice>=all(select pPrice from product group by product.pID);

-- 4.Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau:
select c.Name,o.oID,o.oDate,od.odQTY 
from orderdetail od
join orders o on o.oID=od.oID
join customer c on c.cID=o.oID

-- 5.Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau:
select customer.cID,customer.name from customer where cID NOT IN(select cID from orders);

-- 6.Hiển thị chi tiết của từng hóa đơnnhư sau :
select od.*,p.pName, p.pPrice from orderdetail od
join product p on p.pID=od.oID;

-- 7.Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn.
--  Giá bán của từng loại được tính = odQTY*pPrice) như sau:
select od.oID,o.oDate, sum(od.odQTY*p.pPrice)as  o_total_price from orderdetail od
JOIN orders o ON  o.oID=od.oID
JOIN product p ON p.pID=od.pID 
GROUP BY od.oID,o.oDate;