select * from orders;

select * from order_items;

select * from order_payments;

select * from customers;

select * from products;

select * from order_reviews;

select * from geolocation;

select * from sellers;

select * from product_category_name;

--total revenue and total orders
select round(sum(p.payment_value), 2) as total_revenue,
       count(distinct o.order_id) as total_orders
from orders o
join order_payments p
on o.order_id=p.order_id;

--total customers
select count(distinct customer_id) as total_customers
from customers;

--average order value
select 
     round(sum(payment_value)/ count(distinct order_id), 2) as avg_order_value
from order_Payments;

--monthly revenue
select year(o.order_purchase_timestamp) as year,
       month(o.order_purchase_timestamp) as month,
       sum(op.payment_value) as revenue
from orders o
join order_payments op
on o.order_id=op.order_id
group by year(o.order_purchase_timestamp),
       month(o.order_purchase_timestamp) 
order by year,month;

--repeating customers
select c.customer_unique_id
from customers c
join orders o
on c.customer_id=o.customer_id
group by c.customer_unique_id
having count(o.order_id) > 1;

--customer retention
SELECT DISTINCT o1.customer_id
FROM orders o1
JOIN orders o2
    ON o1.customer_id = o2.customer_id
    AND DATEDIFF(MONTH, o1.order_purchase_timestamp, o2.order_purchase_timestamp) = 1;

--top N selling products
select top 10 product_id, count(order_id) as total_orders
from order_items
group by product_id
order by total_orders desc;

--revenue by product
select product_id, round(sum(price), 2) as revenue
from order_items
group by product_id
order by revenue desc;

--avg delivery time
select 
      avg(datediff(day,order_purchase_timestamp,order_estimated_delivery_date)) as avg_delivery_days
from orders;

--late deliveries
select count(*) as late_deliveries
from orders
where order_delivered_carrier_date>order_estimated_delivery_date;

--top sellers
select top 10 seller_id, round(sum(price), 2) as revenue
from order_items
group by seller_id
order by revenue desc;

--final table
SELECT 
    o.order_id,
    c.customer_unique_id,
    o.order_purchase_timestamp AS order_date,
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month_number,
    DATENAME(MONTH,o.order_purchase_timestamp) AS month_name,
    oi.product_id,
    pr.product_category_name,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    p.payment_value,
    r.review_score
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN order_payments p
ON o.order_id = p.order_id
LEFT JOIN products pr
ON oi.product_id = pr.product_id
LEFT JOIN order_reviews r
ON o.order_id=r.order_id;


