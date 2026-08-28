#	Chinook	Business	Analysis	—	Data	Analyst	Task	
##	Overview
End-to-end	business	analysis	of	the	Chinook	digital	media	store	database,	using
SQL	for	data	extraction,	Python/Pandas	for	analysis	and	visualization,	and	Power	BI
for	interactive	dashboard	reporting.
##	Objective
Answer	key	business	questions	about	revenue,	customers,	products,	and	time-based
trends	to	support	data-driven	decision-making.
##	Dataset
Chinook	SQLite	Database	(`Chinook_Sqlite.sqlite`), a	fictional	digital	media
store	containing	customers,	invoices,	tracks,	albums,	artists,	genres,	and	employees.
Source:	Chinook	SQLite	Database	-	GitHub.
##	Tools
Python,	Jupyter	Notebook,	SQLite,	Pandas,	Matplotlib,	Seaborn,	Power	BI	Desktop.
##	SQL	Analysis
25	SQL	queries	in	'analysis.sql'	covering	revenue,	customers,	orders,	products,
geography,	and	time-based	trends.	Concepts	used:	SELECT,	WHERE,	GROUP	BY,	ORDER	BY,
HAVING,	JOIN,	SUM,	AVG,	COUNT,	CASE,	CTE,	and	subqueries.
##	Python	Analysis
'analysis.ipynb'	loads	every	SQL	query	into	Pandas	DataFrames	and	produces
6	visualizations	(saved	in	`visualizations`):
1.	Revenue	by	Country
2.	Top	10	Customers
3.	Revenue	by	Genre
4.	Top	Artists
5.	Monthly	Sales	Trend
6.	Customer	Distribution	by	Country
##	Power	BI	Dashboard
'Chinook Power	BI Dashboard.pbix'	—	one	dashboard	with	4	KPI	cards
(Total	Revenue,	Total	Orders,	Total	Customers,	Average	Order	Value),	5	charts,
and	3	slicers	(Country,	Year,	Genre).
##	Business	Insights
See	'business_insights.md'	for	5-7	findings,	each	with	supporting
evidence	and	a	recommended	action.
