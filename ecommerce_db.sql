CREATE DATABASE IF NOT EXISTS ecommere

CREATE TABLE products (
  id INT,
  name VARCHAR(50),
  price DECIMAL(10,2)
);

CREATE TABLE orders (
  id INT,
  customer_id INT,
  product_id INT,
  quantity INT,
  order_date DATE
);

CREATE TABLE customers (
  id INT,
  name VARCHAR(50)
);

INSERT INTO products (id, name, price)
VALUES (1, 'T-shirt', 10.00),
       (2, 'Hoodie', 25.00),
       (3, 'Sweatpants', 20.00),
       (4, 'Jacket', 40.00),
       (5, 'Baseball cap', 8.00);

INSERT INTO orders (id, customer_id, product_id, quantity, order_date)
VALUES (1, 1, 1, 2, '2022-02-01'),
       (2, 2, 3, 1, '2022-02-02'),
       (3, 3, 2, 3, '2022-02-02'),
       (4, 1, 4, 1, '2022-02-03'),
       (5, 4, 1, 1, '2022-02-03');

INSERT INTO customers (id, name)
VALUES (1, 'Alice'),
       (2, 'Bob'),
       (3, 'Charlie'),
       (4, 'David'),
       (5, 'Warner'),
       (6,'Smith'),
       (7,'Roy'),
       (8,'Cook');

SELECT *FROM products
SELECT *FROM orders
SELECT *FROM customers

-- 1. Total orders of feb2nd 
SELECT COUNT(*) AS 'feb_2nd_orders' FROM orders
WHERE order_date = '2022-02-02' 

-- 2. Total revenue generated through orders
SELECT SUM(orders.quantity * products.price) AS 'Total_revenue' 
FROM products
JOIN orders
ON products.id = orders.product_id

-- 3. Which products holds the highest price?
SELECT name, price FROM products 
WHERE price =  (SELECT max(price) FROM products)

-- 4. Total revenue of each order 
SELECT orders.id, (orders.quantity * products.price) AS 'Total_revenue' 
FROM products
JOIN orders
ON products.id = orders.product_id

-- 5. Which customer(s) have never placed an order?
SELECT customers.id, customers.name FROM customers
LEFT JOIN orders
ON customers.id = orders.id
WHERE orders.id IS NULL


-- 6. How many unique customers placed orders?
SELECT DISTINCT(customers.name) FROM orders
JOIN customers
ON orders.customer_id = customers.id

-- 7. Total amount spent on purchasing products by customers (top 3)
SELECT c.name, SUM(p.price * o.quantity) AS total_spending
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN products p ON o.product_id = p.id
GROUP BY c.id
ORDER BY total_spending DESC
LIMIT 3;

-- 8. Daily order count 
SELECT order_date, COUNT(*) as order_count
FROM orders
GROUP BY order_date

SELECT *FROM orders
SELECT *FROM PRODUCTS 
SELECT *FROM customers

-- 9. How many orders have been placed by each customer?
SELECT customer_id, customers.name, COUNT(*) AS total_orders FROM ORDERS
JOIN CUSTOMERS ON orders.customer_id = customers.id
GROUP BY CUSTOMER_ID
ORDER BY total_orders DESC

-- 10. Joining products table and order table
SELECT *FROM products
JOIN orders
ON products.id = orders.product_id

-- 11. What is the total revenue generated from each product?
SELECT  products.name, SUM(orders.quantity * products.price) AS revenue_generated FROM products
JOIN orders 
ON products.id = orders.product_id
GROUP BY 
products.name

-- 12. Sum of product quantity 
SELECT products.name, sum(orders.quantity) AS quantity FROM orders
JOIN products
ON orders.product_id = products.id 
GROUP BY products.name

-- 13.  What is the total revenue generated on each day?
SELECT orders.order_date, sum(orders.quantity * products.price) as total_revenue FROM orders
JOIN products
ON orders.product_id = products.id
GROUP BY orders.order_date
ORDER BY order_date ASC

-- 14. What is the most commonly purchased product by each customer?
SELECT customers.name AS customer, products.name AS most_common_product
FROM orders
JOIN customers ON orders.customer_id = customers.id
JOIN products ON orders.product_id = products.id
GROUP BY customers.id
HAVING COUNT(DISTINCT orders.product_id) = (
  SELECT COUNT(DISTINCT orders.product_id)
  FROM orders
  WHERE orders.customer_id = customers.id
  GROUP BY orders.customer_id
  ORDER BY COUNT(DISTINCT orders.product_id) DESC
  LIMIT 1)

-- 15 How many products have been purchased by each customer?
SELECT customers.id, customers.name, COUNT(*) AS total_products_purchased
FROM orders
JOIN customers ON orders.customer_id = customers.id
GROUP BY customers.id, customers.name
ORDER BY total_products_purchased DESC;
