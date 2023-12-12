
----Removing Duplicate records
----2 types=---either all rows will be duplicate / only some will be duplicate

create table if not exists cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

select * from cars
order by model, brand;

select * from cars where (model, brand, id) not in(
select model, brand,max(id) from cars
group by model, brand
having count(*)>1)
--------------------------
--1-> dup based on some cols

-->delete usiongh unique identifier
delete from cars
where id in (
select max(id)
from cars
group by model, brand
having count(*)>1);

select * from cars;

--->using self join
delete from cars where id in
(
 select c1.id from cars c1
 join cars c2
 on c1.model=c2.model and c1.brand=c2.brand
 where c1.id>c2.id
);

select * from cars;

---window function
delete from cars where id in 
 (select id from
   (select *, row_number() over(partition by model, brand) as rn from cars) a
  where rn>1
  );

----->min function. works for multiple records too  ******efficient*********
---above 3 we try to find duplicate and remove it
--here finding unique records

delete from cars 
where id not in
  ( select min(id) from cars
   group by model, brand
  );

---------->backup table--- (for performance based) ---> not applicable for prod***************because dropping
--easiet way compare to delete---ex: if we have 1000 of records it would take more tinme delete
--where 1=2---> for copying structure of table
create table car_bkp
as
select * from cars where 1=2

insert into car_bkp
select* from cars 
where id  in
  ( select min(id) from cars
   group by model, brand
  );

drop table cars;
alter table car_bkp rename to cars

------using backup withdropping car table
create table car_bkp
as
select * from cars where 1=2

insert into car_bkp
select* from cars 
where id  in
  ( select min(id) from cars
   group by model, brand
  );
truncate table cars

insert into cars
select * from car_bkp

drop table car_bkp

--2-> dup based on all cols
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);

select * from cars
order by model, brand;

----delete using CTID ---only in postgresql,   oracle--rowid,    mysql--not there
--in postgresql whenerver cr table inside postgresql cr sudocol called CTID--> basically assigned unique rol_id in 
--every single record in table

select *,ctid from cars	

delete from cars
where ctid in (
select max(ctid)
from cars
group by model, brand
having count(*)>1);

---rest all sol applicable for all sql ebgine
-- by creating temporary unique id col

alter table cars add column row_num int generated always as identity;

delete from cars
where row_num in (
select max(row_num)
from cars
group by model, brand
having count(*)>1); 

select * from cars	
alter table cars drop column row_num;

-- creating backup table
 create table car_bkp as (
 select distinct * from cars );
 
 select * from car_bkp
 drop table cars
 alter table car_bkp rename to cars;
 
 ------using backup withdropping car table
  create table car_bkp as (
 select distinct * from cars );
 
 truncate table cars;
 
 insert into cars
 select * from car_bkp;
 
 select * from cars;
 