-------------1-------------

--1a
create or replace function f(a integer)
   returns integer as
$$
begin
    return a + 1;
end;
$$
    language plpgsql;
select f(5);

--1b
create or replace function f_2(a integer, b integer)
   returns integer as
$$
begin
    return a + b;
end;
$$
    language plpgsql;
select f_2(5, b:= 6);

--1c
create or replace function f_3(a integer)
   returns varchar as
$$
begin
    if a % 2 = 0 then
        return 'true';
    else
        return 'false';
    end if;
end;
$$
    language plpgsql;
select f_3(5);

--1d
create or replace function f_4(a varchar)
   returns varchar as
$$
begin
    if length(a) > 7 and a is not null then
        return 'the password is valid';
    else
        return 'the password is not valid';
    end if;
end;
$$
    language plpgsql;
select f_4('7858dcbk');

--1e
create or replace function f_5(variadic list numeric[], out sum_total numeric, out avg numeric)
   as
$$
begin
    select into sum_total sum(list[i])
    from generate_subscripts(list, 1) g(i);
    select into avg avg(list[i])
    from generate_subscripts(list, 1) g(i);
end;
$$
    language plpgsql;

select * from f_5(5, 4,8,7,2);

------------2-------------

--2a
create or replace function fun()
    returns trigger
    language plpgsql
as $$
begin
     if tg_op = 'DELETE' then
        insert into cus_audit select 'delete', now();
     elsif tg_op = 'UPDATE' then
        insert into cus_audit select 'update', now();
     elsif tg_op = 'INSERT' then
        insert into cus_audit select 'insert', now();
     end if;
     return new;
end;
$$;
drop trigger trig
on customers cascade;
create trigger trig
    after insert or delete or update
    on customers
    for each row
execute procedure fun();

create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table cus_audit(
    operation   varchar   not null,
    time        timestamp not null
);
INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');
insert into customers VALUES (204, 'Alice', '2021-11-12');
insert into customers VALUES (205, 'Den', '2021-11-30');
update customers set name = 'Marid' where id = 204;
select * from customers;
select * from cus_audit;
--2b
create or replace function fun_3()
    returns trigger
    language plpgsql
as $$
begin
     if tg_op = 'INSERT' then
         update age set age = age(date_birth) where date_birth = new.date_birth;
     end if;
     return new;
end;
$$;

drop trigger trig_2
on age cascade;

create trigger trig_3
    after insert
    on age
    for each row
execute procedure fun_3();

drop table age;
CREATE TABLE age (
         date_birth  timestamp,
         age interval
);
insert into age values('2006-08-09', null);
select * from age;
--2c
create or replace function fun_2()
    returns trigger
    language plpgsql
as $$
    declare
        a integer;
begin
     if tg_op = 'INSERT' then
         a := new.price;
         update products set price =  a + ((a * 12) / 100) where price = new.price;
     end if;
     return new;
end;
$$;

drop trigger trig_2
on products cascade;

create trigger trig_2
    after insert
    on products
    for each row
execute procedure fun_2();

CREATE TABLE products (
         id varchar PRIMARY KEY,
         name varchar UNIQUE NOT NULL,
         price double precision NOT NULL CHECK (price > 0)
);
INSERT INTO products (id, name, price) VALUES (2, 'PHONEe', 50000);
select * from products;

--2d
create or replace function fun_4()
    returns trigger
    language plpgsql
as $$
begin
     if tg_op = 'DELETE' then
        raise EXCEPTION 'Attempt to delete';
     end if;
     return OLD;
end;
$$;

drop trigger trig_2
on products cascade;

create trigger trig_4
    before delete
    on prod
    for each row
execute procedure fun_4();

CREATE TABLE prod (
         id varchar PRIMARY KEY,
         name varchar UNIQUE NOT NULL,
         price double precision NOT NULL CHECK (price > 0)
);
INSERT INTO prod (id, name, price) VALUES (1, 'PHONE', 50000);
select * from prod;
delete from prod where name = 'PHONE';
--2e

create or replace function fun_5()
    returns trigger
    language plpgsql
as $$
begin
     if tg_op = 'INSERT' then
     update pro set f_4 = (select f_4('78587890')) where id is not null;
     update pro set (f_5_sum, f_5_avg) = (select f_5(5, 4,8,7,2)) where id is not null;
     end if;
     return new;
end;
$$;

drop trigger trig_5
on pro cascade;

create trigger trig_5
    before insert
    on pro
    for each row
execute procedure fun_5();
drop table pro;
CREATE TABLE pro (
         id varchar PRIMARY KEY,
         f_4 varchar,
         f_5_sum numeric,
         f_5_avg numeric
);
INSERT INTO pro VALUES (1);
select * from pro;
------------3-------------
--In a procedure, unlike a function, you can work with a transaction.
------------4-------------
--4a
create or replace procedure p_1()
language plpgsql
as $$
    declare
    a integer;
begin
    select workexperince into a from task4 where workexperince >= 2;

    while a >= 2 loop
    update task4
    set salary = salary + (salary/10);
    a = a - 2;
    end loop;

    update task4
    set discount = discount + 10
    where workexperince >= 0;

    update task4
    set discount = discount + 1
    where workexperince >= 5;
end;
$$;
call p_1();

--4b
create or replace procedure p_2()
language plpgsql
as $$
    declare
        dis_const constant integer := 20;
begin
    update task4
    set salary = salary + ((salary/100)*15)
    where age >= 40;

    update task4
    set salary = salary + ((salary/100)*15)
    where task4.workexperince > 8;

    update task4
    set discount = dis_const
    where workexperince > 8;

end;
$$;
call p_2();
create table task4(
        id integer PRIMARY KEY,
        name varchar,
        date_of_birth date,
        age integer,
        salary integer,
        workexperince integer,
        discount integer
);
insert into task4 values (6, 'Ane', '2000-12-23', 50, 100000, 30, 0);
select * from task4;


------------5-------------
CREATE TABLE members (
         memid   integer PRIMARY KEY,
         surname varchar(200),
         firstname varchar(200),
         address varchar(200),
         zipcode integer,
         telephone varchar(200),
         recommendedby integer,
         timestamp timestamp
);

CREATE TABLE recomenders (
         memid   integer PRIMARY KEY,
         surname varchar(200),
         firstname varchar(200),
         address varchar(200),
         zipcode integer,
         telephone varchar(200),
         recommendedby integer,
         timestamp timestamp
);
CREATE TABLE facilities (
         facid integer PRIMARY KEY,
         name varchar(100),
         membercost numeric,
         guestcost numeric,
         initialoutlay numeric,
         monthlymaintenance numeric
);
CREATE TABLE booking (
         facid integer REFERENCES facilities (facid),
         memid integer REFERENCES members (memid),
         starttime timestamp,
         slots integer
);



with recursive recommenders(recommender, member) as (
	select recommendedby, memid
		from members
	union all
	select mems.recommendedby, recs.member
		from recommenders recs
		inner join members mems
			on mems.memid = recs.recommender
)
select recs.member member, recs.recommender, mems.firstname, mems.surname
	from recommenders recs
	inner join members mems
		on recs.recommender = mems.memid
	where recs.member = 22 or recs.member = 12
order by recs.member asc, recs.recommender desc