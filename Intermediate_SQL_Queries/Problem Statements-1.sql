-------print meaningful comments----
create table input( id int, comment varchar(100), translation varchar(100) );

insert into input values (1,'very good',null)
insert into input values (2,'good',null)
insert into input values (3,'bad',null)
insert into input values (4,'ordinary',null)
insert into input values (5,'cdcdcdcd','very bad')
insert into input values (6,'execellent',null)
insert into input values (7,'ababab','statisfied')
insert into input values (8,'statisfied',null)
insert into input values (9,'aabbaabb','extraordinary')
insert into input values (10,'ccddccdd','medium')

select * from input

select case
 when translation is null then comment
 else translation
 end as output
from input
-----
select coalesce(translation,comment) from input;
----------------------------------------
----derive desired output-----------------

create table source(id int, name char);
create table target(id int, name char);

insert into source values(1,'A'),(2,'B'),(3,'C'),(4,'D');
insert into target values(1,'A'),(2,'B'),(4,'X'),(5,'F');

select * from source;
select * from target;

with  cte as(
select a.id,'mismatch'  as comment
from source as a
join target as b
on a.id=b.id and a.name <> b.name),

ct1 as(
select a.id,a.name,b.name, case
when b.name is null  then 'new in source' 
end as comment
from source as a
left join target as b
on a.id=b.id),

ct2 as(
select b.id,a.name,b.name, case
when a.name is null  then 'new in target' 
end as comment
from source as a
right join target as b
on a.id=b.id)

/*select id, comment from ct1 where comment is not null
select id, comment from ct2 where comment is not null
select id, comment from cte  */

select id, comment from ct1 where comment is not null
union
select id, comment from ct2 where comment is not null
union
select id, comment from cte
order by id
---or------
select 	a.id, 'Mismatch' as comment from source as a
join target as b
on a.id=b.id and a.name <> b.name
union
select a.id, 'New in Source' as comment from source as a
left join target as b
on a.id=b.id
where b.id is null
union
select b.id, 'New in Target' as comment from source as a
right join target as b
on a.id=b.id
where a.id is null
order by id
-------or fill outer / full join-- combination left and right--> gaves matching, null, not match result
select case 
 when a.id is null then b.id
 when b.id is null then a.id
 when a.id=b.id and a.name<>b.name then a.id
 end as id,
case 
 when a.id is null then 'New in Target'
 when b.id is null then 'New in Source'
 when a.id=b.id and a.name<>b.name then 'Mismatch'
 end as Comment
from source a
full join target b
on a.id=b.id
where a.id is null or b.id is null or a.name <> b.name

-----------------IPL Matches-----
create table if not exists teams
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );
insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderbad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');
--------------
--** whenever we receiver any case to compare records in same table then --> self join
select 'Chennai Super Kings' as name, case 
when team_name <> 'Chennai Super Kings' then team_name 
end as opponent
from teams
---single match with other team---
select a.team_name, b.team_name from teams as a
join teams as b
on a.team_name < b.team_name
order by a.team_name

---twice match with other team---
select a.team_name, b.team_name from teams as a
join teams as b
on a.team_name <> b.team_name
order by a.team_name

---more understanding
with matches as(
select row_number() over(order by team_code) as id,
* from teams)

select team.team_name, opponent.team_name  from matches as team
join matches as opponent
on team.id<opponent.id
order by team.team_name 

-------
with matches as(
select row_number() over(order by team_code) as id,
* from teams)

select team.team_name, opponent.team_name  from matches as team
join matches as opponent
on team.id<>opponent.id
order by team.team_name 

