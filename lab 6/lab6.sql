1a) select *
       from dealer cross join client;
1b) select dealer.name as dealer, client.name as client, dealer.location as city, dealer.charge as grade, sell.id as sell_number, sell.date as date, sell.amount as amount
           from (dealer inner join sell on dealer.id = sell.dealer_id) join client on dealer.id = client.dealer_id and client.id = sell.client_id;
1c) select *
       from dealer inner join client on dealer.location = client.city;
1d) select sell.id as sell_id, client.name as client_name, dealer.location as city, sell.amount as amount
        from (dealer inner join client on dealer.id = client.dealer_id) inner join sell on (dealer.id = sell.dealer_id and client.id = sell.client_id and sell.amount between 100 and 500);

1e)     select *
        from dealer left join client on (dealer.id = client.dealer_id)
        group by (dealer.id, client.id)
        having (client.id is null or client.id is not null);

1f) select client.name as client_name, client.city as city, dealer.name as dealer_name, dealer.charge as commission
        from client join dealer on client.dealer_id = dealer.id;
1g) select client.name as clien_tname, client.city as city, dealer.name as dealer, dealer.charge as commission
        from client left join dealer on (client.dealer_id = dealer.id and dealer.charge > 0.12);
1h) select client.name as client, client.city, sell.id as sell_id, sell.date, sell.amount, dealer.name as dealer, dealer.charge as commission
    from (client full join dealer on client.dealer_id = dealer.id) full join sell on (sell.dealer_id = dealer.id and sell.client_id = client.id);
1i) select client.name as client, client.priority as grade , dealer.name as deaaler,sell.id as sell_id, sell.amount
    from (dealer join client on client.dealer_id = dealer.id) left join sell on (client_id = sell.client_id and dealer.id = sell.dealer_id)
    group by client.name, dealer.name, client.priority, sell.id, sell.amount
    having client.name is not null and(sell.amount > 2000 or sell.id is not null) and(client.priority is not null);


2a) create view clients as
        select client.name as client, sell.date as date, avg(sell.amount) as avg_purchase, sum(sell.amount) astotal_purchase
            from client join sell on client.id = sell.client_id and client.dealer_id = sell.dealer_id
            group by (client.name, sell.date);
2b) create view sells as
        select date, sum(amount) as total_amount
        from sell
        group by date
        order by sum(amount) desc
        limit 5;
2c) create view dealer_sell as
        select dealer.name, count(sell.id) as count_sell, avg(amount) as avg_amount, sum(amount) as sum_amount
        from dealer join sell on dealer.id = sell.dealer_id
        group by (dealer.name);
2d) create view;
        with loc_mon(id,location, earned_money) as
        (select dealer.id, dealer.location, sum(amount)
        from dealer join sell on dealer.id = sell.dealer_id
        group by (dealer.location, dealer.id))
        select location, sell.charge*earned_money
        from loc_mon join sell on sell.dealer_id = loc_mon.id;
2e) create view loc_sells as
        select dealer.location, count(sell.id) as count_sell, avg(amount) as avg_amount, sum(amount) as total_amount_sell
        from dealer join sell on dealer.id = sell.dealer_id
        group by dealer.location;
2f) create view city_sells as
        select client.city, count(sell.id) as count_sell, avg(amount) as avg_amount, sum(amount) as total_amount_expenses
        from client join sell on client.id = sell.client_id
        group by client.city;

2g) create view diff_total as
        select city, total_amount_sell, total_amount_expenses
        from loc_sells join city_sells on location = city
        where total_amount_expenses > total_amount_sell;
