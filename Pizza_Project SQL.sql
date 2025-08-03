--: Pizzas Project :--

-- Basic --

-- 1):- Retrieve the total number of orders placed.
SELECT count(order_id)as Total_Order FROM orders


-- 2):- Calculate the total revenue generated from pizza sales.
SELECT round(sum(o.quantity*p.price),0) as Total_Sales
FROM pizzas p
join order_details o on p.pizza_id = o.pizza_id


-- 3):- Identify the highest priced pizza.
SELECT top 1 pt.pizza_type_id, pt.name, round(p.price , 2) as Price
FROM pizzas p
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
ORDER BY price desc


-- 4):- Identify the most common pizza size ordered.
SELECT top 1 p.size, count(o.pizza_id) as Pizza_Count
from pizzas p
join order_details o on p.pizza_id = o.pizza_id
GROUP BY size 
ORDER BY Pizza_Count desc


-- 5):- List the top 5 most ordered pizza types along with their quantities.
SELECT top 5 pt.name, sum(od.quantity) as Quantity
FROM pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id 
join order_details od on od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Quantity desc


--: Intermediate :--

-- 6):- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, sum(od.quantity) Quantity
FROM pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id 
join order_details od on od.pizza_id = p.pizza_id
GROUP BY pt.category


-- 7):- Determine the distribution of orders by hour of the day.
SELECT distinct DATEPART(HOUR, time), count(order_id) as Orders
FROM orders 
GROUP BY time


-- 8):- Join relevant tables to find the category-wise distribution of pizzas.
SELECT category, count(name) as Count_Pizzas_Name
FROM pizza_types 
GROUP BY category


-- 9):- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT avg(Quantity)as Perday_Avg_Qty FROM
(SELECT  o.date, sum(od.quantity) as Quantity
FROM orders o
join order_details od on o.order_id = od.order_id
GROUP BY o.date) as Order_Quantity;


-- 10):- Determine the top 3 most ordered pizza types based on revenue.
SELECT top 3 pt.pizza_type_id,(pt.name), round(sum(p.price*od.quantity),2)as Total_Revenue
FROM pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id 
GROUP BY pt.name, pt.pizza_type_id
ORDER BY Total_Revenue desc;



--: Advanced :--

-- 11):- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.category ,(sum(p.price*od.quantity) / 
(SELECT sum(p.price*od.quantity)as Total_Sales
FROM order_details od
join pizzas p on p.pizza_id = od.pizza_id) )*100 as Revenue_Percentage
FROM pizza_types pt
join pizzas p on p.pizza_type_id = pt.pizza_type_id
join order_details od on od.pizza_id = p.pizza_id 
GROUP BY pt.category
ORDER BY Revenue_Percentage desc ;




-- 12):- Analyze the top 10 cumulative revenue generated over time.
SELECT top 10 date, sum(Revenue)
over (order by date) as Cum_Revenue
FROM
(SELECT o.date, round(sum(p.price * od.quantity),2) as Revenue
FROM orders o
join order_details od on o.order_id = od.order_id 
join pizzas p on p.pizza_id = od.pizza_id
GROUP BY o.date) as Sales ;


-- 13):- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT Top 3 category, name, Revenue 
FROM (select category, name , Revenue,
rank() over(partition by category ORDER BY Revenue desc) as rn
FROM (SELECT pt.category, pt.name , round(SUM(p.price * od.quantity),0) as Revenue
FROM pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id
join order_details od on od.pizza_id = p.pizza_id
GROUP BY pt.category, pt.name ) as a) b
where rn <= 3 ;



