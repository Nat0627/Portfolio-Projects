-- Using groupbys to create a report style datasets.
-- Groupby is similar to Excel pivot table.
-- Groupby is helpful by showing the data at a higher level.  Data in database is way too granular, sometimes we need a birds eye view. 
-- Sum is the function on the amount column, we are taking the sum of amount column.   
-- Group by column, must be present in the select clause to group by it.  
-- Quick report to identify the total revenue for each geography.  

select GeoID, sum(amount), avg(amount), sum(boxes)
from sales
group by GeoID;

-- Joined the on the sales table to show the actual location where the revenue is being generated from. 
-- Ordered by desc to see which country bulk of sales generating from. 
-- Also ensure that whatever you are grouping by is the first column to ensure aggregations are correct.
-- Group by at a single level, but also on multiple levels, similar to pivot table in Excel.  
select g.geo, sum(amount), avg(amount), sum(boxes)
from sales s
JOIN geo g on g.geoid = s.GeoID
group by g.geo
order by avg(amount) desc;

-- Extract data from the people table and product table. 
-- Identify total amount coming in from a team.
-- 

select pr.category, p.team, sum(amount), sum(boxes)
from sales s
join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
group by pr.category, p.team;

-- more concise report, removes the nulls
-- having condition must be used to filter on aggregations/calculations.
select pr.category, p.team, sum(amount), sum(boxes)
from sales s
join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
where p.team <> ''
group by pr.category, p.team
order by pr.category, p.team;