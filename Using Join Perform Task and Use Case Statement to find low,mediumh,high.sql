--Create table and assign value and forget to add primaray key add below
Create Table Customer(Customer_id int,Customer_name Varchar(30));
Insert INTO Customer(Customer_id ,Customer_name )
Values
(1,"Ali"),
(2,"Ahmed"),
(3,"Raza"),
(4,"Mobeen"),
(5,"Kamran"),
(6,"Talha"),
(7,"tayab");
Alter Table Customer 
Add Primary Key(Customer_id);


Create Table Product(Prod_id int,Prod_name varchar(30),Prod_price int);
Insert INto Product(Prod_id,Prod_name,Prod_price)
Values
(1,"Laptop_Battery","12000"),
(2,"Panel","3500"),
(3,"MicroPhone","350"),
(4,"Keyboard","560"),
(5,"Mouse","600");
Alter Table Product 
Add Primary Key(Prod_id);

CREATE TABLE Orders (
  Ord_id INT PRIMARY KEY,
  Customer_id INT,
  Ord_date DATE,
  FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);
Insert into Orders(Ord_id,Customer_Id ,Ord_date)
Values
(1,1,"2025-04-1"),
(2,2,"2025-04-2"),
(3,3,"2025-04-23"),
(4,4,"2025-04-15"),
(5,5,"2025-04-06");

CREATE TABLE Orders_iteam (
  item_id INT PRIMARY KEY,
  Quantity INT,
  Prod_id INT,
  Ord_id INT,
  CONSTRAINT FOREIGN KEY (Prod_id) REFERENCES product(Prod_id),
  CONSTRAINT FOREIGN KEY (Ord_id) REFERENCES orders(Ord_id)
);
INSERT INTO Orders_iteam (item_id, Quantity, Prod_id, Ord_id)
VALUES
  (1, 5, 1, 1),
  (2, 3, 2, 2),
  (3, 2, 3, 3),
  (4, 7, 4, 4),
  (5, 1, 5, 5);




-- Check the Customers with no orders
SELECT c.*
FROM Customer c
LEFT JOIN Orders o ON c.Customer_id = o.Customer_id
WHERE o.Customer_id IS NULL;

-- find Top 5 products by revenue
Select p.Prod_id,p.Prod_name,p.Prod_price,SUM(oi.Quantity * p.Prod_price) as Top5_revenue
From orders_iteam oi
Join Product p 
ON p.Prod_id=oi.Prod_id
Group By Prod_id,Prod_name
Order By  Top5_revenue DESC
Limit 5;

-- Orders with total > average order value
SELECT oi.Ord_id,SUM(oi.Quantity * p.Prod_price) AS order_total
FROM orders_iteam oi
JOIN Product p 
ON oi.Prod_id = p.Prod_id
GROUP BY oi.Ord_id
HAVING order_total > (
    SELECT AVG(order_value)
    FROM (SELECT oi.Ord_id,SUM(oi.Quantity * p.Prod_price) AS order_value
      FROM Orders_iteam oi
      JOIN Product p 
      ON oi.Prod_id = p.Prod_id
      GROUP BY oi.Ord_id) AS avg_orders);

-- CASE statement to label customer spending tiers (Low/Medium/High
SELECT c.Customer_id,c.Customer_name,SUM(oi.Quantity * p.Prod_price) AS total_spent,
CASE
    WHEN SUM(oi.Quantity * p.Prod_price) < 5000 THEN 'Low'
    WHEN SUM(oi.Quantity * p.Prod_price) BETWEEN 5000 AND 15000 THEN 'Medium'
    WHEN SUM(oi.Quantity * p.Prod_price) > 15000 THEN 'High'
    END AS spending_tier
FROM Customer c
JOIN Orders o 
ON c.Customer_id = o.Customer_id
JOIN Orders_iteam oi 
ON o.Ord_id = oi.Ord_id
JOIN Product p 
ON oi.Prod_id = p.Prod_id
GROUP BY c.Customer_id, c.Customer_name;


