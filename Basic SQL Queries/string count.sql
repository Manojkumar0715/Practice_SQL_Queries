/*-----------string count-------------*/
create table string (name varchar(50) );

insert into string values('Ankit Bansal'),('Raghul'),('Ram Kumar Verma'),('Akshay Kumar Ak K');
--alter table string alter column name type char

select Length(name) from string
select  Length(name) - length(replace(name,'m','')) from string

why / means ak is word----> if we didnt divide will get count 4, but actually it ccurs twice.
select length(name)-length(replace(name,'Ak',''))) from string
--crct one
select (length(name)-length(replace(name,'Ak','')))/length('ak') from string
