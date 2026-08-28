-- QUERY 1 - Total Revenue

SELECT	SUM(Total)	AS	TotalRevenue 
FROM Invoice;

-- QUERY 2 - Total Customers

SELECT COUNT(*) AS TotalCustomers 
FROM Customer;

-- QUERY 3 - Total Orders

SELECT COUNT(*) AS TotalOrders 
FROM Invoice;

-- QUERY 4 - Average Order Value

SELECT AVG(Total) AS AOV 
FROM Invoice;

-- QUERY 5 - Average Spending Per Customer

SELECT	AVG(CustomerTotal)	AS	AvgSpendPerCustomer 
FROM	
(
SELECT	CustomerId,	SUM(Total)	AS	CustomerTotal 
FROM	Invoice
GROUP	BY	CustomerId
);

-- QUERY 6 - Top 10 Customers by Spending

SELECT
    c.CustomerId,
    c.FirstName||' '||c.LastName AS CustomerName,
    c.Country,
    SUM(i.Total) AS TotalSpent
FROM Customer c
JOIN Invoice i ON c.CustomerId=i.CustomerId
GROUP BY c.CustomerId, CustomerName, c.Country
ORDER BY TotalSpent DESC
LIMIT 10;
-- QUERY 7 - Revenue by	Country

SELECT	BillingCountry	AS	Country,	SUM(Total)	AS	Revenue
FROM	Invoice
GROUP	BY	BillingCountry
ORDER	BY	Revenue	DESC;

-- QUERY 8 - Customer	Count	by	Country

SELECT	Country,	COUNT(*)	AS	CustomerCount
FROM	Customer
GROUP	BY	Country
ORDER	BY	CustomerCount	DESC;

-- QUERY 9 - Top-Selling	Genres

SELECT
g.Name	AS	Genre,
SUM(il.UnitPrice	*	il.Quantity)	AS	Revenue,
COUNT(il.InvoiceLineId)	AS	UnitsSold
FROM	InvoiceLine	il
JOIN	Track	t	ON	il.TrackId = t.TrackId
JOIN	Genre	g	ON	t.GenreId = g.GenreId
GROUP	BY	g.Name
ORDER	BY	Revenue	DESC;

-- QUERY 10 - Top-Selling	Artists

SELECT
ar.Name	AS	Artist,
SUM(il.UnitPrice	*	il.Quantity)	AS	Revenue,
COUNT(il.InvoiceLineId)	AS	UnitsSold
FROM	InvoiceLine	il
JOIN	Track	t ON il.TrackId = t.TrackId
JOIN	Album	al ON t.AlbumId =	al.AlbumId
JOIN	Artist	ar	ON al.ArtistId	= ar.ArtistId
GROUP	BY	ar.Name
ORDER	BY	Revenue	DESC
LIMIT	10;

-- QUERY 11 - Top-Selling Tracks

SELECT
t.Name	AS	Track,
SUM(il.UnitPrice	*	il.Quantity)	AS	Revenue,
COUNT(il.InvoiceLineId)	AS	UnitsSold
FROM	InvoiceLine	il
JOIN	Track	t	ON	il.TrackId	=	t.TrackId
GROUP	BY	t.Name
ORDER	BY	Revenue	DESC
LIMIT	10;

-- QUERY 12 - Revenue by Year

SELECT	strftime('%Y', InvoiceDate)	AS Year, SUM(Total)	AS Revenue
FROM	Invoice
GROUP	BY	Year
ORDER	BY	Year;

-- QUERY 13 - Revenue by Month

SELECT strftime('%Y-%m', InvoiceDate) AS YearMonth,	SUM(Total) AS Revenue
FROM	Invoice
GROUP	BY	YearMonth
ORDER	BY	YearMonth;

-- QUERY 14 - Monthly / Yearly Sales Growth

WITH	MonthlyRevenue	AS	(
SELECT	strftime('%Y-%m', InvoiceDate) AS YearMonth, SUM(Total)	AS Revenue
FROM	Invoice
GROUP	BY	YearMonth
)
SELECT
YearMonth,
Revenue,
LAG(Revenue) OVER (ORDER	BY	YearMonth) AS PrevMonthRevenue,
ROUND(
(Revenue - LAG(Revenue)	OVER (ORDER	BY YearMonth)) * 100.0
/ LAG(Revenue) OVER (ORDER	BY	YearMonth),	2 )	AS	GrowthPercent
FROM	MonthlyRevenue
ORDER	BY	YearMonth;


-- QUERY 15 - Highest-Performing Country

SELECT BillingCountry AS Country, SUM(Total) AS Revenue
FROM	Invoice
GROUP	BY	BillingCountry
ORDER	BY	Revenue	DESC
LIMIT	1;

-- QUERY 16 - Highest-Performing Month

SELECT	strftime('%Y-%m',	InvoiceDate) AS	YearMonth, SUM(Total) AS Revenue
FROM	Invoice
GROUP	BY	YearMonth
ORDER	BY	Revenue	DESC
LIMIT	1;

-- QUERY 17 - 	Highest-Performing Artist

SELECT ar.Name AS Artist, SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM	InvoiceLine	il
JOIN	Track	t ON	il.TrackId = t.TrackId
JOIN	Album	al ON	t.AlbumId = al.AlbumId
JOIN	Artist	ar ON	al.ArtistId	= ar.ArtistId
GROUP	BY	ar.Name
ORDER	BY	Revenue	DESC
LIMIT	1;

-- QUERY 18 - Customers	with Highest Purchase Frequency

SELECT
c.CustomerId,
c.FirstName	||	'	'	||	c.LastName AS CustomerName,
COUNT(i.InvoiceId) AS OrderCount
FROM	Customer	c
JOIN	Invoice	i	ON	c.CustomerId = i.CustomerId
GROUP	BY	c.CustomerId,	CustomerName
HAVING	COUNT(i.InvoiceId)	>	1
ORDER	BY	OrderCount	DESC
LIMIT	10;

-- QUERY 19 - Revenue Contribution of Top Customers

WITH	CustomerRevenue	AS	(
SELECT	CustomerId,	SUM(Total) AS TotalSpent
FROM	Invoice
GROUP BY CustomerId
),
Top10 AS (
SELECT * FROM CustomerRevenue ORDER	BY TotalSpent DESC 
LIMIT	10
)
SELECT
(SELECT ROUND(SUM(TotalSpent), 2) FROM Top10) AS Top10Revenue,													
(SELECT	ROUND(SUM(TotalSpent),2) FROM CustomerRevenue) AS TotalRevenue,			

ROUND((SELECT SUM(TotalSpent) FROM Top10) * 100.0	/
(SELECT	SUM(TotalSpent)	FROM CustomerRevenue),	2
) AS Top10PercentOfRevenue;

-- QUERY 20 - High/Medium/Low-Value	Customer Segments

WITH CustomerSpend AS (
SELECT	c.CustomerId,
c.FirstName	||	'	'	||	c.LastName AS CustomerName,
SUM(i.Total) AS TotalSpent
FROM	Customer	c
JOIN	Invoice	i	ON	c.CustomerId = i.CustomerId
GROUP	BY	c.CustomerId,	CustomerName
)
SELECT
CASE
WHEN	TotalSpent	>=	100	THEN 'High	Value'
WHEN	TotalSpent	>=	50	THEN 'Medium	Value'
ELSE	'Low	Value'
END	AS	Segment,
COUNT(*)	AS	NumberOfCustomers,
ROUND(SUM(TotalSpent),	2)	AS	SegmentRevenue
FROM	CustomerSpend
GROUP	BY	Segment
ORDER	BY	SegmentRevenue	DESC;
