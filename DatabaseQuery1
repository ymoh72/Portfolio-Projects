SELECT * FROM BIT_DB.customers LIMIT 20;
SELECT * FROM BIT_DB.JanSales LIMIT 20;

--Displaying amount of orders in January

SELECT COUNT(*) FROM BIT_DB.JanSales;

--Displaying the number of iPhones sold in January

SELECT COUNT(*) FROM BIT_DB.JanSales WHERE Product LIKE '%iPhone%';

--Selecting account numbers for custmers who bought in February

SELECT acctnum
FROM BIT_DB.customers cust
INNER JOIN BIT_DB.FebSales Feb
ON cust.order_id=FEB.orderid;

--Selecting and displaying price for the cheapest product sold in January

SELECT distinct Product, price
FROM BIT_DB.JanSales
WHERE  price in (SELECT min(price) FROM BIT_DB.JanSales);

--Dsiplaying total revenue for each product in January

SELECT sum(quantity)*price as revenue
,product
FROM BIT_DB.JanSales
GROUP BY product;

/*Displaying the products, quanityt, and revenue for items
 sold in February at the 548 Lincoln St location*/

SELECT 
SUM(Quantity), 
product, 
SUM(quantity)*price AS revenue
FROM BIT_DB.FebSales 
WHERE location = '548 Lincoln St, Seattle, WA 98101'
GROUP BY product;

/*Displaying the number of customers who bought more than 2 products at a time
and the average amount spent for those customers*/

SELECT 
COUNT(cust.acctnum), 
AVG(quantity*price)
FROM BIT_DB.FebSales Feb
LEFT JOIN BIT_DB.customers cust
ON FEB.orderid=cust.order_id
WHERE Feb.Quantity>2;


--Filtering sales by date and time

SELECT orderdate
FROM BIT_DB.FebSales
WHERE orderdate between '02/13/19 00:00' AND '02/18/19 00:00';

SELECT location
FROM BIT_DB.FebSales 
WHERE orderdate = '02/18/19 01:35';

SELECT SUM(quantity)
FROM BIT_DB.FebSales 
WHERE orderdate like '02/18/19%';

--Filtering sales by price and product name

SELECT distinct Product
FROM BIT_DB.FebSales
WHERE Product like '%Batteries%';

SELECT distinct Product, Price
FROM BIT_DB.FebSales 
WHERE Price like '%.99';

--Selecting all products sold in LA in the month of February

SELECT product, SUM(quantity)
FROM BIT_DB.FebSales
WHERE location LIKE '%Los Angeles%'
GROUP BY product;

--Displaying locations in New York with at least 3 orders in January

SELECT DISTINCT location,COUNT(orderID)
FROM BIT_DB.JanSales
WHERE location LIKE '%NY%'
GROUP BY location
HAVING COUNT(orderID) > 2;

--Displaying the quantity of each type of headphone sold in February

SELECT product,SUM(quantity) AS Quantity
FROM BIT_DB.FebSales
WHERE product LIKE '%headphone%'
GROUP BY product;

--Displaying the average amount spent per account in February

SELECT SUM(quantity*price)/COUNT(cust.acctnum)
FROM BIT_DB.FebSales Feb

LEFT JOIN BIT_DB.customers cust
    ON Feb.orderid=cust.order_id;
    
--Displaying the average quantity of products purchased per account in February

SELECT SUM(quantity)/COUNT(cust.acctnum)
FROM BIT_DB.FebSales Feb

LEFT JOIN BIT_DB.customers cust
    ON Feb.orderid=cust.order_id;
    
/*Displaying which products brought in the most revenue how much it generated
in the month of January*/

SELECT product,SUM(quantity*price) AS revenue
FROM BIT_DB.JanSales
GROUP BY product
ORDER BY revenue DESC;
