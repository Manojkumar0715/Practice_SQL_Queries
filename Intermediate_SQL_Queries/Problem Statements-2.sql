--Write a SQL Query to fetch all the duplicate records in a table.

create table users(
	user_id int, user_name varchar(40), email varchar(50));
	
insert into users values(1,'Sumit','sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

select * from users
---- self join --
select a.user_id,a.user_name,a.email from users a
join users b
on a.user_name=b.user_name
where a.user_id > b.user_id
---row num---
select user_id,user_name,email from 
 (select row_number() over(partition by user_name order by user_id) as rn, *
  from users) as b
where rn > 1

----- Write a SQL query to fetch the second last record from employee table.

create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

---
select * from employee

select * from employee
where salary not in (select max(salary) from employee)
order by emp_id desc
limit 1
----
select emp_id,emp_name,dept_name,salary from
 (select row_number() over (order by emp_id desc) as rn, * from employee) a
where rn =2
----
--From the doctors table, fetch the details of doctors who work in the same hospital but in different speciality.
create table IF NOT EXISTS doctors 
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);
insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;
--Same hospital different speciality
select a.name, a.speciality, a.hospital from doctors a
join doctors b
on a.hospital=b.hospital and a.speciality<>b.speciality
and a.id<>b.id

-- Same hospital irrespective of speciality
select a.name, a.speciality, a.hospital from doctors a
join doctors b
on a.hospital=b.hospital and a.id<>b.id

----From the login_details table, fetch the users who logged in consecutively 3 or more times.

drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

select * from login_details

with cte as(
select user_name, count(lead) over(partition by lead) as d from(
select user_name, lead(user_name) over(partition by user_name order by login_id)from login_details) a)


select distinct user_name from cte
where d > 2

-----------------------------------------------
select distinct repeated_names
from (
select *,
case when user_name = lead(user_name) over(order by login_id)
and  user_name = lead(user_name,2) over(order by login_id)
then user_name else null end as repeated_names
from login_details) x
where x.repeated_names is not null;
-----------------------------------------------------
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

select * from students;

select *, case
when id%2=0 then lag(student_name) over(order by id)
when id%2<>0 then coalesce (lead(student_name) over(order by id),student_name)
end as new_student_name
from students
-----
select *, case
when id%2=0 then lag(student_name) over(order by id)
when id%2<>0 then (lead(student_name,1,student_name) over(order by id))
end as new_student_name
from students

--- From the weather table, fetch all the records when London had extremely cold temperature
--for 3 consecutive days or more.

create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
insert into weather values
(1, 'London', -1, to_date('2021-01-01','yyyy-mm-dd')),
(2, 'London', -2, to_date('2021-01-02','yyyy-mm-dd')),
(3, 'London', 4, to_date('2021-01-03','yyyy-mm-dd')),
(4, 'London', 1, to_date('2021-01-04','yyyy-mm-dd')),
(5, 'London', -2, to_date('2021-01-05','yyyy-mm-dd')),
(6, 'London', -5, to_date('2021-01-06','yyyy-mm-dd')),
(7, 'London', -7, to_date('2021-01-07','yyyy-mm-dd')),
(8, 'London', 5, to_date('2021-01-08','yyyy-mm-dd'));

select * from weather;

select *, case 
when temperature < lag(temperature,1,temperature) over(order by day) and 
temperature < lead(temperature,2,temperature) over(order by day) then temperature
end as v
from (
select * from weather where temperature < 0) c
limit 3 offset 2;

---------------------------------------------------------------
select id,city,temperature,day from
(select *, case 
 when temperature < 0 and lead(temperature) over(order by id) <0
 and lead(temperature,2) over(order by id) < 0
 then 'Yes'
 when temperature < 0 and lead(temperature) over(order by id) <0
 and lag(temperature) over(order by id) < 0
 then 'Yes'
 when temperature < 0 and lag(temperature) over(order by id) <0
 and lag(temperature,2) over(order by id) < 0
 then 'Yes'
 else null
 end as flag
from weather
) a
where a.flag='Yes'

----From the following 3 tables (event_category, physician_speciality, patient_treatment), 
--write a SQL query to get the histogram of specialties of the unique physicians 
--who have done the procedures but never did prescribe anything.

create table event_category
(
  event_name varchar(50),
  category varchar(100)
);

drop table physician_speciality;
create table physician_speciality
(
  physician_id int,
  speciality varchar(50)
);

drop table patient_treatment;
create table patient_treatment
(
  patient_id int,
  event_name varchar(50),
  physician_id int
);


insert into event_category values ('Chemotherapy','Procedure');
insert into event_category values ('Radiation','Procedure');
insert into event_category values ('Immunosuppressants','Prescription');
insert into event_category values ('BTKI','Prescription');
insert into event_category values ('Biopsy','Test');


insert into physician_speciality values (1000,'Radiologist');
insert into physician_speciality values (2000,'Oncologist');
insert into physician_speciality values (3000,'Hermatologist');
insert into physician_speciality values (4000,'Oncologist');
insert into physician_speciality values (5000,'Pathologist');
insert into physician_speciality values (6000,'Oncologist');


insert into patient_treatment values (1,'Radiation', 1000);
insert into patient_treatment values (2,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 1000);
insert into patient_treatment values (3,'Immunosuppressants', 2000);
insert into patient_treatment values (4,'BTKI', 3000);
insert into patient_treatment values (5,'Radiation', 4000);
insert into patient_treatment values (4,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 5000);
insert into patient_treatment values (6,'Chemotherapy', 6000);


select * from patient_treatment;
select * from event_category;
select * from physician_speciality;

select c.speciality, count(*) as speciality_count from PATIENT_TREATMENT a
join EVENT_CATEGORY b
on a.event_name =b.event_name
join PHYSICIAN_SPECIALITY c
on a.physician_id=c.physician_id
where b.category = 'Procedure' and 
a.physician_id not in (select d.physician_id from PATIENT_TREATMENT d
join EVENT_CATEGORY e
on d.event_name =e.event_name
where category='Prescription')
group by c.speciality

---Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, to_date('02-01-2020','dd-mm-yyyy'), 100);
insert into patient_logs values (1, to_date('27-01-2020','dd-mm-yyyy'), 200);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (1, to_date('04-03-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 450);

select * from patient_logs;

with cte as(
select account_id,case 
when mon=1 then 'January'
else 'March'
end as month, patient_id from(
select distinct extract(month from  date) as mon, account_id, patient_id from patient_logs
) a )

select month,account_id,count(*) as no_of_unique_patients  from cte
where account_id <3
group by month, account_id
order by no_of_unique_patients desc, account_id asc

-----------------------------------------------
select a.month, a.account_id, a.no_of_unique_patients
from (
		select x.month, x.account_id, no_of_unique_patients,
			row_number() over (partition by x.month order by x.no_of_unique_patients desc) as rn
		from (
				select pl.month, pl.account_id, count(1) as no_of_unique_patients
				from (select distinct to_char(date,'month') as month, account_id, patient_id
						from patient_logs) pl
				group by pl.month, pl.account_id) x
     ) a
where a.rn < 3;
-------------------------------------------------------------

--SQL Query to fetch “N” consecutive records from a table based on a certain condition

--10a. when the table has a primary key
--drop table weather
create table if not exists weather
	(
		id 					int 				primary key,
		city 				varchar(50) not null,
		temperature int 				not null,
		day 				date				not null
	);

--delete from weather;
insert into weather values
	(1, 'London', -1, to_date('2021-01-01','yyyy-mm-dd')),
	(2, 'London', -2, to_date('2021-01-02','yyyy-mm-dd')),
	(3, 'London', 4, to_date('2021-01-03','yyyy-mm-dd')),
	(4, 'London', 1, to_date('2021-01-04','yyyy-mm-dd')),
	(5, 'London', -2, to_date('2021-01-05','yyyy-mm-dd')),
	(6, 'London', -5, to_date('2021-01-06','yyyy-mm-dd')),
	(7, 'London', -7, to_date('2021-01-07','yyyy-mm-dd')),
	(8, 'London', 5, to_date('2021-01-08','yyyy-mm-dd')),
	(9, 'London', -20, to_date('2021-01-09','yyyy-mm-dd')),
	(10, 'London', 20, to_date('2021-01-10','yyyy-mm-dd')),
	(11, 'London', 22, to_date('2021-01-11','yyyy-mm-dd')),
	(12, 'London', -1, to_date('2021-01-12','yyyy-mm-dd')),
	(13, 'London', -2, to_date('2021-01-13','yyyy-mm-dd')),
	(14, 'London', -2, to_date('2021-01-14','yyyy-mm-dd')),
	(15, 'London', -4, to_date('2021-01-15','yyyy-mm-dd')),
	(16, 'London', -9, to_date('2021-01-16','yyyy-mm-dd')),
	(17, 'London', 0, to_date('2021-01-17','yyyy-mm-dd')),
	(18, 'London', -10, to_date('2021-01-18','yyyy-mm-dd')),
	(19, 'London', -11, to_date('2021-01-19','yyyy-mm-dd')),
	(20, 'London', -12, to_date('2021-01-20','yyyy-mm-dd')),
	(21, 'London', -11, to_date('2021-01-21','yyyy-mm-dd'));


select * from weather;

with cte as
(  select *, row_number() over(order by id) as rn,
   id-row_number() over(order by id) as diff
   from
    (
     select * from weather where temperature<0
    )a
),
ct1 as (select *,count(*) over(partition by diff) as flag  from cte)

--select * from ct1 

select id,city,temperature,day from ct1 where flag >=4

-- Query 10b
-- Finding n consecutive records where temperature is below zero. And table does not have primary key.
-- if we dont have any primary key, over clause no need to gave anu partition/order by


create view VW_WEATHER as 
select city, temperature from weather
--drop view VW_WEATHER
select * from VW_WEATHER

with w as 
 (select *, row_number() over() as id from VW_WEATHER),
cte as
(  select *, row_number() over(order by id) as rn,
   id-row_number() over(order by id) as diff
   from w where temperature < 0
),
ct1 as (select *,count(*) over(partition by diff) as flag  from cte)

select id,city,temperature from ct1 where flag =4


--Query 10c
-- Finding n consecutive records with consecutive date value.

--Table Structure:
drop table if exists orders cascade;
create table if not exists orders
  (
    order_id    varchar(20) primary key,
    order_date  date        not null
);


insert into orders values
  ('ORD1001', to_date('2021-Jan-01','yyyy-mon-dd')),
  ('ORD1002', to_date('2021-Feb-01','yyyy-mon-dd')),
  ('ORD1003', to_date('2021-Feb-02','yyyy-mon-dd')),
  ('ORD1004', to_date('2021-Feb-03','yyyy-mon-dd')),
  ('ORD1005', to_date('2021-Mar-01','yyyy-mon-dd')),
  ('ORD1006', to_date('2021-Jun-01','yyyy-mon-dd')),
  ('ORD1007', to_date('2021-Dec-25','yyyy-mon-dd')),
  ('ORD1008', to_date('2021-Dec-26','yyyy-mon-dd'));

select * from orders;

with w as
  (select *, extract(day from order_date) as day, row_number() over() as rn from orders),
cte as (select *, rn -day as diff from w),
ct1 as (select *,count(*) over(partition by diff)as flag from cte)

select order_id,order_date from ct1 where flag >2
order by order_date;

---------------
--rn:: int / cast(rn ,int)
with cte as
 (Select *,  row_number() over(order by order_id) as rn,
 order_date - row_number() over(order by order_id)::int as diff from orders),
ct1 as (select *,count(*) over(partition by diff) as flag from cte)

select order_id,order_date from ct1 where flag >2


