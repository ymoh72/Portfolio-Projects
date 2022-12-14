SELECT * FROM Chinook.customers;

--Displaying all customers not located in the US

SELECT FirstName,
LastName,
CustomerID,
Country
FROM Chinook.customers
WHERE Country != 'USA';

--Displaying list of distinct countries 

SELECT DISTINCT(BillingCountry)
FROM Chinook.invoices;

--Displaying all Brazilian customers and their transaction details

SELECT FirstName,
LastName,
CustomerID,
Country,
InvoiceDate,
Total
FROM Chinook.customers
LEFT JOIN Chinook.invoices
    ON customers.CustomerId = invoices.CustomerId
WHERE Country = 'Brazil';


--Combining three tables to display purchase details with each invoice

SELECT i.InvoiceLineID,
t.Name as TrackName,
a.Title AS AlbumName,
s.Name AS ArtistName
FROM Chinook.invoice_items i
LEFT JOIN chinook.tracks t
    ON i.TrackId = t.TrackId
LEFT JOIN chinook.albums a
    ON t.AlbumId = a.AlbumId
LEFT JOIN chinook.artists s
    ON a.ArtistId = s.ArtistId
GROUP BY InvoiceLineId;


--Displaying all employees who work in sales

SELECT *
FROM Chinook.employees
WHERE Title LIKE '%Sales%';

--Displaying quantity of sales associated with each employee

SELECT FirstName,
LastName,
EmployeeId,
COUNT(CustomerId) AS 'Number of Clients'
FROM Chinook.employees
LEFT JOIN Chinook.customers
    ON employees.EmployeeId = customers.SupportRepId
GROUP BY EmployeeId;


--Displaying the number and total sales for the year 2009

SELECT UnitPrice,
Quantity,
(UnitPrice*Quantity) AS RevGenerated,
InvoiceDate,
Total
FROM Chinook.invoice_items
LEFT JOIN Chinook.invoices
ON invoice_items.InvoiceId = invoices.InvoiceId
WHERE InvoiceDate LIKE '%2009%'
GROUP BY InvoiceDate;


--Displaying sales earnings for each employee in 2009

SELECT SupportRepId,
FirstName,
LastName,
SUM(Total) AS SalesTotals
FROM chinook.employees
LEFT JOIN chinook.customers
    ON employees.EmployeeId = customers.SupportRepId
LEFT JOIN chinook.invoices
    ON customers.CustomerId = invoices.CustomerId
WHERE Title LIKE '%Agent%' AND InvoiceDate LIKE '%2009%'
    GROUP BY SupportRepID;
