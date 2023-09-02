SELECT SaleDate, Amount, Customers from sales;
SELECT Amount, Customers, GeoId from sales; 

-- Pulling Saledate, Amount, and boxes column, the calculating the ratio of amount to boxes from sales table
Select Saledate, Amount, Boxes, Amount / boxes from sales;

-- Pulling same columns, but aliasing the amount / boxes ratio column name to Amount per boxes.  
Select Saledate, Amount, Boxes, Amount / boxes 'Amount per boxes' from sales;

-- Pulling all columns from the sales table where amount is greater than 10,000; where clause is like filtering in Excel
Select * from sales
Where Amount > 10000

-- Pulls all columns from sales table, where amount is greater than 10,000; ordered largest to smallest; order by is like sort in Excel.
Select * from sales
Where Amount > 10000
Order by amount desc; 

-- Query pulls all columns from sales table, where geoid is equal to G1, and ordered by the product id and amount largest to smallest.
-- Multiple filter / ordering in one query
Select * from sales 
WHERE GeoID = 'G1' 
Order by PID, Amount desc; 

-- Pull all columns from the sales table with amount greater than 10000 and sales date greater or equal to 01-01-2022.
Select * from sales
Where Amount > 10000 AND SaleDate >= '2022-01-01'

-- Pull SaleDate and Amount column from sales table, amount greater than 10,000; used year function to extract year from date.
-- Ordered amount by largest to smallest.
Select SaleDate, Amount from sales
WHERE amount > 10000 AND year(SaleDate) = 2022
Order by amount desc; 

-- Pulled all columns from sales table, boxes column is greater than 0, greater than or equal to 50, sorted boxes column largest to smallest. 
Select * from sales
where boxes > 0 AND boxes <= 50
order by boxes desc

-- Pulled all columns from sales table, where boxes column is between 0 and 50; 0 is included unlike previous query that filtered above 0.
select * from sales
where boxes between 0 and 50

-- Pulled SaleDate, amount, and boxes column, used weekday function to extract day of week from sales table; filtered for weekday as Friday, or 4.
-- Identified shipments that take place on Fridays.
select SaleDate, Amount, Boxes, weekday(SaleDate) as 'Day of Week' from sales
where weekday(SaleDate) = 4

-- Select all salespeople on Delish or Juices team
-- when using or here, must recall the column name again; hence, team = 2xs.
-- We did not use AND condition because person cannot be in both teams, we want one or the other, OR condition allows for this.  
select * from people
where team = 'Jucies' or team = 'Delish'

-- in clause; example to filter people with team = Jucies or Delish
-- in is more flexible way in returning multiple conditions without consistently typing column name over and over. 
select * from people
where team in ('Jucies', 'Delish');

-- Pattern Matching; LIKE operator
-- Query all salespeople who's names begin with B; 'B%'
-- % means anything
select * from people
where salesperson like 'B%'

-- Query salespeople with a B anywhere in their name.
select * from people
where salesperson like '%B%'

-- Case When, then Operator
-- Add an amount column, amount up to 1000 having level under 1000, amount between 1000 - 5000 having level under 5000, amount 5K - 10K under 10K
-- With bigger queries, select on first line, drop down and tab to make query neater and broken up. 
-- start with case; end with end.  
-- Created another column where amounts are classified based on amount levels; spaces help organize the query.  
-- Helpful building categorizations, numerically or with text strings

Select	SaleDate, Amount,
		case 	when amount < 1000 then 'Under 1K'
				when amount < 5000 then 'Under 5K'
                when amount < 10000 then 'Under 10K'
			else '10k or more'
		end as 'Amount Category'
from sales; 

