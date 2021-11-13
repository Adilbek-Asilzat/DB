create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);
create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');

-- 1)

-- Large objects (photos, videos, CAD files, etc.) are stored as a large object:
-- • blob: binary large object -- object is a large collection of
-- uninterpreted binary data (whose interpretation is left to
-- an application outside of the database system)
-- • clob: character large object -- object is a large collection
-- of character data

--2.1
create role accountant;
create role administrator;
create role support;
grant select, insert on accounts, transactions to accountant;
grant all privileges on accounts, transactions, customers to administrator;
grant select, insert, update, delete on accounts, customers to support;
--2.2
create user Alice;
create user Roman;
create user Jhon;

grant administrator to Alice;
grant accountant to Roman;
grant support to John;

--2.3
create user David;
grant all privileges on accounts, transactions, customers to  David with grant option;
--2.4
revoke all privileges on accounts, transactions, customers from David;

--3.2
alter table  accounts
    alter column account_id set not null;
alter table  customers
    alter column name set not null;
alter table  accounts
    alter column balance set not null;

--5.1
create index cus_currency on accounts(customer_id, currency);

--5.2
create index  cur_balance on accounts(currency, balance);

--6
DO $$DECLARE
        b int;
        l int;
    BEGIN
        update accounts
        set balance = balance - 100
        where account_id = 'NK90123';
        update accounts
        set balance = balance + 100
        where account_id = 'AB10203';
        select balance into b from accounts where account_id = 'NK90123';
        select accounts.limit into l from accounts where account_id = 'NK90123';
        if b < l then
            rollback;
            update transactions set status = 'rollback' where id = 3;
        else
            commit;
            update transactions set status = 'commit' where id = 3;
        END if;
END$$;


