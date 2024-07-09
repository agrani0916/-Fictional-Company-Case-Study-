
-- Create the 'categories' table
CREATE TABLE techmart.categories (
	category_id INT PRIMARY KEY,
	category_name VARCHAR(50)
);
-- Insert data into the 'categories' table
INSERT INTO techmart.categories (category_id, category_name) VALUES
(1, 'Laptops'),
(2, 'Smartphones'),
(3, 'Tablets'),
(4, 'Accessories'),
(5, 'Cameras');

-- Create the 'products' table
CREATE TABLE techmart.products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category_id INT,
  unit_price DECIMAL(10, 2),
  stock_quantity INT
);

-- Insert data into the 'products' table
INSERT INTO techmart.products (product_id, product_name, category_id, unit_price, stock_quantity) VALUES
(101, 'Dell XPS 13', 1, 1200.00, 50),
(102, 'iPhone 12', 2, 999.99, 100),
(103, 'Samsung Galaxy S21', 2, 899.00, 80),
(104, 'iPad Pro', 3, 799.00, 60),
(105, 'Logitech Wireless Mouse', 4, 29.99, 200),
(106, 'JBL Bluetooth Speaker', 4, 89.99, 150),
(107, 'Nikon D850 DSLR Camera', 5, 2499.00, 30),
(108, 'Sony Alpha A7 III', 5, 1999.00, 40),
(109, 'Vivo Z1 pro', 2, 3999.00, 50),
(110, 'HP Pavillion 15', 1, 4999.00, 60);

-- Create the 'orders' table
CREATE TABLE techmart.orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE
);

-- Insert data into the 'orders' table
INSERT INTO techmart.orders (order_id, customer_id, order_date) VALUES
(1001, 5001, '2023-07-01'),
(1002, 5002, '2023-07-15'),
(1003, 5001, '2023-05-20'),
(1004, 5003, '2023-07-22'),
(1005, 5004, '2023-07-25'),
(1006, 5005, '2023-08-16'),
(1007, 5006, '2023-08-25');

-- Create the 'order_items' table
CREATE TABLE techmart.order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  total_price DECIMAL(10, 2)
);

-- Insert data into the 'order_items' table
INSERT INTO techmart.order_items (order_item_id, order_id, product_id, quantity, total_price) VALUES
(2001, 1001, 101, 2, 2400.00),
(2002, 1001, 102, 1, 999.99),
(2003, 1002, 104, 3, 2397.00),
(2004, 1003, 103, 2, 1798.00),
(2005, 1003, 105, 5, 149.95),
(2006, 1003, 106, 2, 179.98),
(2007, 1004, 107, 1, 2499.00),
(2008, 1004, 106, 3, 269.97),
(2009, 1005, 102, 2, 1999.98),
(2010, 1005, 108, 1, 1999.00),
(2011, 1005, 105, 2, 59.98),
(2012, 1005, 103, 1, 1299.00),
(2013, 1006, 103, 3, 1197.00),
(2014, 1007, 103, 2, 9998.00),
(2015, 1006, 103, 4, 11999.00),
(2016, 1007, 103, 3, 1197.00);

--------------------------------------------------------------------------------------------------

--**Case Study Challenges:**
----------------------------------------------
/*
**1. Retrieve Product Information: (Medium)**
	 Write a SQL query to retrieve the product_id, product_name, unit_price, and stock_quantity
	 for all products in the "Laptops" category.
*/

SELECT
	product_id, 
	product_name,
	unit_price, 
	stock_quantity
FROM techmart.products
WHERE category_id = (SELECT 
					 	category_id 
					 FROM techmart.categories 
					 WHERE category_name = 'Laptops')
;

-- ANOTHER WAY
SELECT 
	product_id, 
	product_name, 
	unit_price, 
	stock_quantity
FROM techmart.products tp
JOIN techmart.categories tc
ON tp.category_id = tc.category_id
WHERE category_name = 'Laptops';

--------------------------------------------------------
/*
**2. Top Selling Categories: (Medium)**
Write a SQL query to determine the top 3 product categories based on the total quantity of 
products sold. The result should include the category_id, category_name, and the total quantity 
sold across all orders.

*/

SELECT 
	c.category_id, 
	c.category_name, 
	SUM(O.quantity) AS total_quantity_sold 
FROM techmart.categories c
JOIN techmart.products p ON c.category_id = p.category_id
JOIN techmart.order_items o ON p.product_id = o.product_id
GROUP BY c.category_id
ORDER BY total_quantity_sold DESC
LIMIT 3;

--ANOTHER WAY

CREATE TABLE techmart.newtable AS(
	SELECT 
		category_id, 
		SUM(O.quantity) AS total_quantity_sold 
FROM techmart.products p
	JOIN techmart.order_items o ON p.product_id = o.product_id
	GROUP BY p.category_id
	ORDER BY total_quantity_sold DESC)

SELECT * FROM techmart.newtable n
JOIN techmart.categories c ON c.category_id = N.category_id
LIMIT 3;

----------------------------------------------------------
/*
**3. Customer Purchase History: (Medium)**
Write a SQL query that shows the order_id, order_date, product_id, 
product_name, and quantity for each product purchased by a specific customer 
with customer_id = 1001.
*/

--SELECT o.order_id, o.order_date, p.product_id, p.product_name, oi.quantity 
--FROM techmart.orders o
--JOIN techmart.order_items oi ON o.order_id = oi.order_id
--JOIN techmart.products p ON oi.product_id = p.product_id
--WHERE o.order_id = '1001';


SELECT o.order_id, o.order_date, p.product_id, p.product_name, oi.quantity, o.customer_id
FROM techmart.orders o
JOIN techmart.order_items oi ON o.order_id = oi.order_id
JOIN techmart.products p ON oi.product_id = p.product_id
WHERE o.customer_id = '5001';
----------------------------------------------------------------------
/*
**4. Revenue by Category: (Advanced)**
Write a SQL query to calculate the total revenue generated by each product category, 
considering the unit price and quantity sold for each product. The result should display the category_id, 
category_name, and total revenue.
*/

SELECT 
	c.category_id, 
	c.category_name, 
	SUM(oi.quantity * p.unit_price) AS total_revenue 
FROM techmart.categories c
JOIN techmart.products p ON c.category_id = p.category_id
JOIN techmart.order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_id;
-----------------------------------------------------------------------
/*
**5. Monthly Sales Growth: (Advanced)**
Write an SQL query to calculate the monthly sales growth percentage for TechMart.
The result should include the month and year of the orders and the corresponding 
sales growth percentage compared to the previous month.

*/
CREATE TABLE techmart.monthly_revenue AS(SELECT 
	EXTRACT(MONTH FROM order_date) AS month, 
	EXTRACT(YEAR FROM order_date) AS year,
	SUM(total_price) AS revenue
From techmart.orders o
JOIN techmart.order_items oi ON  o.order_id = oi.order_id
GROUP BY month,year);

SELECT month,
	   revenue,
	   revenue - LAG(revenue) OVER (ORDER BY month ASC) AS revenue_growth,
	   (revenue - LAG(revenue) OVER (ORDER BY month ASC))/LAG(revenue) OVER (ORDER BY month ASC)*100 AS revenue_percentage_growth,
	   LEAD (REVENUE,12)OVER (ORDER BY month ASC) AS next_year_revenue
FROM  techmart.monthly_revenue;
------------------------------------------------------------------------
/*
**6. Rank Customers by Total Spending: (Advanced)**
	 Write a SQL query to rank TechMart's customers based on their total spending
	 (sum of total_price) in descending order. The result should display the 
	 customer_id and their respective rank.

*/
SELECT customer_id, RANK() OVER(ORDER BY total_spending DESC) AS customer_rank, total_spending
FROM(SELECT 
		customer_id, 
	 	SUM(total_price)AS total_spending 
	FROM techmart.orders o
	JOIN techmart.order_items oi ON o.order_id = oi.order_id
	GROUP BY customer_id
	)
ORDER BY customer_rank;


-------------------------------------------------------------------------
/*
**7. Product Recommendations: (Advanced)**
Write a SQL query that suggests three product recommendations to customers who have purchased 
products in the "Smartphones" category. The recommendations should be based on the purchasing 
history of other customers who bought products from the same category.

*/
SELECT 
	p.product_id,
	p.product_name,
	SUM(oi.quantity) AS total_quantity
FROM techmart.categories c
JOIN techmart.products p ON c.category_id = p.category_id
JOIN techmart.order_items oi ON p.product_id = oi.product_id
WHERE c.category_name='Smartphones'
GROUP BY p.product_id,p,product_name
ORDER BY total_quantity DESC
LIMIT 3;
