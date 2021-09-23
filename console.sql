CREATE TABLE products (
         id varchar PRIMARY KEY,
         name varchar UNIQUE NOT NULL,
         description text,
         price double precision NOT NULL CHECK (price > 0)
);

CREATE TABLE customers (
         id integer PRIMARY KEY,
         full_name varchar(50) NOT NULL,
         timestamp timestamp NOT NULL,
         delivery_address text NOT NULL
);

CREATE TABLE orders (
         code integer PRIMARY KEY,
         customer_id integer REFERENCES customers (id),
         total_sum double precision NOT NULL CHECK (total_sum > 0),
         is_paid boolean NOT NULL
);

CREATE TABLE order_items (
         order_code integer REFERENCES orders (code),
         product_id varchar REFERENCES products (id),
         quantity integer NOT NULL CHECK (quantity > 0),
         primary key(order_code, product_id)
);

drop table  order_items CASCADE;

INSERT INTO customers (id, full_name, timestamp, delivery_address) VALUES (1, 'Tom Holland', '2021-08-12  12:02:22', 'street Astana 54');
UPDATE customers SET delivery_address = 'street Gogol 32' WHERE delivery_address = 'street Astana 54';
DELETE FROM customers WHERE full_name = 'Tom Holland';
INSERT INTO orders (code, customer_id, total_sum, is_paid) VALUES (1, 1, 5678, False);
INSERT INTO products (id, name, price) VALUES (1, 'tie', 2000);
INSERT INTO order_items (order_code, product_id, quantity) VALUES (1, 1, 200);

DROP TABLE department CASCADE;
CREATE TABLE department (
         dept_name varchar(20) PRIMARY KEY,
         building varchar(20)
);
select * from customers;
select timestamp as data
from customers;

INSERT INTO customers (id, full_name, timestamp, delivery_address) VALUES (2, 'Elena Zvezdnaya', '2021-08-12  12:02:22', 'street Pushkin 3');
