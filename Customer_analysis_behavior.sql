SELECT * FROM customer_behavior.customer;
--  1. what are the total revenue genereated by male vs female customer?

use customer_behavior;
select gender , sum(purchase_amount)as revenue
from customer
group by gender;

ALTER TABLE customer
CHANGE `new_column_name` purchase_amount  bigint;

ALTER TABLE customer
CHANGE `Customer ID` Customer_ID  bigint;

ALTER TABLE customer
CHANGE `Item Purchased` Item_Purchased  text;

ALTER TABLE customer
CHANGE `Review_Rating` Review_Rating  double;

ALTER TABLE customer
CHANGE `Subscription Status` Subscription_Status text;

ALTER TABLE customer
CHANGE `Shipping Type` Shipping_Type text;

ALTER TABLE customer
CHANGE `Discount_Applied`Discount_Applied text;

ALTER TABLE customer
CHANGE `Discount Applied`Discount_Applied text;

ALTER TABLE customer
CHANGE `Promo Code Used`Promo_Code_Used text;

ALTER TABLE customer
CHANGE `Previous Purchases`Previous_Purchases bigint;

ALTER TABLE customer
CHANGE `Payment Method`Payment_Method text;

ALTER TABLE customer
CHANGE `Frequency of Purchases`Frequency_of_Purchases text;
select * from customer;


-- 2.which customer used discount but still spent more than average purchase amount?

select `customer_id`, `purchase_amount`
from customer
where `Discount_Applied` ="yes" and purchase_amount > (select avg(purchase_amount) from customer);

-- 3.Which are the top 5  product with highest  avergae review rating?

select Item_Purchased, round(avg(review_rating),2)as "Average Product Rating"
from customer
group by Item_Purchased
order by avg(review_rating) desc
limit 5;

-- 4. Compare the average Purchase amount between standard and express shipping

select shipping_type ,round(avg(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type;

-- 5.Do subscribed customer spend more? Compare average spend and total 
--  revenue between  subsriber and non subsriber.

select Subscription_Status,
count(customer_id) as total_customer,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer
group by Subscription_Status
order by total_revenue,avg_spend desc;

-- 6.which 5 product have  the highest percentage of purchases with discount applied?

select item_purchased,
round(sum(case when discount_applied ='yes' then 1 else 0 end)/count(*) * 100,2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

-- 7.Segment customers into New, Returning, and Loyal based on their total number of previous purchases, and show the count of each segment

with customer_type as(

select customer_id , previous_purchases,
case
    when previous_purchases =1 then 'new'
    when previous_purchases between 2 and 10 then 'returning'
    else 'loyal'
    end as customer_segment
from customer
)
select customer_segment, count(*) as "number of customer"
from customer_type
group by customer_segment;
-- Q8. What are the top 3 most purchased products within each category?
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank, 
       category, 
       item_purchased, 
       total_orders
FROM item_counts
WHERE item_rank <= 3;
-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;
-- Q10. What is the revenue contribution of each age group?
SELECT age,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age
ORDER BY total_revenue DESC;