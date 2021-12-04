create table product(
    prod_id integer primary key,
    store_id integer references store(store_id),
    bill_of_lading_number varchar references warehouse(id),
    prod_name varchar unique,
    category varchar,
    type_of_product varchar,
    manufacture varchar,
    price integer,
    currency varchar
);

create type street as(
    street_name varchar,
    apartment_number integer
);
create type address as(
    country varchar,
    city varchar,
    postal_code varchar,
    street street
);
create table store(
    store_id integer primary key,
    address address,
    phone_number bigint
);
insert into store values (1, ROW('USA', 'California', '90026', ROW('Camel Back',800)), 54682928245);

create table customer(
    customer_id integer primary key
);
create table card_details(
    card_number varchar primary key,
    owners_name varchar,
    data varchar,
    cvv integer,
    brend varchar
);

create table online_customer(
    customer_id integer primary key references customer(customer_id),
    address address,
    phone_number bigint,
    date_of_birth timestamp,
    card_number varchar references card_details(card_number)
);
create type bonus_card as(
    card_number varchar,
    amount_of_bonuses integer
);
create table offline_customer(
    customer_id integer primary key references customer(customer_id),
    bonus_card bonus_card
);
create table shipping_company(
    name_company varchar primary key,
    delivery_method varchar
);

create table information_of_purchase(
    tracking_number varchar primary key,
    delivery_time timestamp,
    date_of_purchase timestamp,
    season varchar,
    customer_id integer references customer(customer_id),
    store_id integer references store(store_id),
    prod_id integer references product(prod_id),
    shipping_company varchar references shipping_company(name_company),
    method_of_payment varchar,
    currency varchar,
    time_of_receipt_of_the_parcel timestamp,
    year integer
);
create table warehouse(
    id varchar primary key,
    delivery_date timestamp,
    quantity integer
);
create table provider(
    provider_id integer primary key,
    legal_address varchar,
    phone_number varchar
);
create table request(
    request_number integer primary key,
    bill_of_lading_number varchar references warehouse(id),
    request_quantity integer,
    provider_id integer references provider(provider_id)
);
create table contract(
    provider_id integer primary key,
    customer_id integer references customer(customer_id),
    account_number varchar,
    duration varchar
);

-----------------------------------------------------------------------

insert into product values(1, 1, 1,'Iphone 11', 'phones and gadgets','smartphones', 'Apple', 400000, 'tenge');
insert into product values(2, 1, 2,'Samsung Galaxy A12', 'phones and gadgets','smartphones', 'Samsung', 75000, 'tenge');
insert into product values(3, 2, 3, 'Iphone 13', 'phones and gadgets','smartphones', 'Apple', 1000, 'dollar');
insert into product values(4, 2, 4,'Mac Air 13 Z1240004P', 'computers','monoblocks', 'Apple', 1500, 'dollar');
insert into product values(5, 3, 5,'iMac 24 2021 A2438 Z132000BV', 'computers','monoblocks', 'Apple', 2100, 'dollar');
insert into product values(6, 3, 6,'Samsung Galaxy Tab A7 Lite 8.7', 'computers','tablets', 'Samsung', 250, 'dollar');
insert into product values(7, 3, 7,'Samsung UE7969757579', 'TV, audio, video','TV', 'Samsung', 200000, 'tenge');
insert into product values(8, 3, 8,'Canon EOS 600D Kit', 'TV, audio, video','cameras', 'Canon', 300, 'dollar');
insert into product values(9, 3, 9,'Apple AirPods Pro', 'TV, audio, video', 'headphones', 'Apple', 250, 'dollar');
insert into product values(10, 3, 10,'LG GA-B379 SLUL', 'home appliances','refrigerators', 'LG', 200000, 'tenge');
insert into product values(11, 2, 11,'Haier HW60-BP109', 'home appliances','washing machines', 'Haier', 140000, 'tenge');
insert into product values(12, 2, 12,'Bosch HBF113BA0Q', 'home appliances','ovens', 'Bosch', 170000, 'KZ');
insert into product values(13, '', 5,'iMac 24 2021 A2438 Z132000BV', 'computers','monoblocks', 'Apple', 2100, 'dollar');
insert into product values(14, '', 6,'Samsung Galaxy Tab A7 Lite 8.7', 'computers','tablets', 'Samsung', 250, 'dollar');
insert into product values(15, '', 7,'Samsung UE7969757579', 'TV, audio, video','TV', 'Samsung', 200000, 'tenge');
insert into product values(16, '', 8,'Canon EOS 600D Kit', 'TV, audio, video','cameras', 'Canon', 300, 'dollar');
insert into product values(17, '', 9,'Apple AirPods Pro', 'TV, audio, video', 'headphones', 'Apple', 250, 'dollar');
insert into product values(18,'', 10,'LG GA-B379 SLUL', 'home appliances','refrigerators', 'LG', 200000, 'tenge');
insert into product values(19, '', 11,'Haier HW60-BP109', 'home appliances','washing machines', 'store', 140000, 'tenge');
insert into product values(20, '', 12,'Bosch HBF113BA0Q', 'home appliances','ovens', 'Bosch', 170000, 'KZ');

insert into customer values (1);
insert into customer values (2);
insert into customer values (3);
insert into customer values (4);
insert into customer values (5);
insert into customer values (6);
insert into customer values (7);
insert into customer values (8);
insert into customer values (9);
insert into customer values (10);
insert into customer values (11);
insert into customer values (12);
insert into customer values (13);
insert into customer values (14);
insert into customer values (15);
insert into customer values (16);
insert into customer values (17);
insert into card_details values ('4401-6753-4678-4467', 'Blake Jon', )
insert into online_customer values (1,ROW('USA', 'California', '90026', ROW('Camel Back',868)),9186031420, '1997-08-22', '4401-6753-4678-4467');
---------------------------------------------------------------------------------------------------
select information_of_purchase.tracking_number, information_of_purchase.shipping_company, online_customer.customer_id, online_customer.phone_number
from information_of_purchase natural join online_customer where information_of_purchase.tracking_number = '123456' and information_of_purchase.shipping_company = 'USPS';

insert into information_of_purchase values ()
;
------------------
select customer_id, sum(product.price)
from customer natural join (product natural join information_of_purchase) where year = 2021
group by customer_id
order by sum(product.price)
limit 1;
------------------
select prod_id, sum(price)
from product natural join information_of_purchase where year = 2020 and currency = 'dollar'
group by prod_id
order by sum(price)
limit 2;
-------------------
select prod_id, sum(price)
from product natural join information_of_purchase where year = 2020
group by prod_id
order by sum(price)
limit 2;
-------------------
select prod_id
from product natural join store where address.city <> 'California';
-------------------

select tracking_number
from information_of_purchase where date_of_purchase <>  time_of_receipt_of_the_parcel;
