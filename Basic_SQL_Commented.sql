-- Create a list of all distinct districts customers are from.
-- Customers are representative of 378 unique districts. 
-- The keywords SELECT DISTINCT queried ONLY unique districts contained in the district column ONLY. 
-- The keyword FROM identifies the table from where the data is being queried.

SELECT DISTINCT district
FROM address;

-- What is the latest rental date? 
-- The last rental date was 2/14/2020 at 9:16.
-- Keywords SELECT DISTINCT queried unique rental dates ONLY.
-- FROM queried data ONLY contained in the rental table.
-- ORDER BY DESC sorted the rental dates in order from last rental date to first rental date. 

SELECT DISTINCT rental_date
FROM rental
ORDER BY rental_date DESC; 

-- How many films does the company have? 
-- The company has 1,000 unique films. 
-- SELECT COUNT aggregated a count of the film ids, film ids are unique in this case, so there was no need to use DISTINCT.
-- FROM queried data ONLY contained in the film table.

SELECT COUNT(film_id)
FROM film

-- How many distinct last names of the customers are there? 
-- There are 599 customers with unique last names.  
-- SELECT COUNT DISTINCT aggregated a unique count on last_names ONLY.
-- FROM queried data from the customer table.  
	
SELECT COUNT(DISTINCT last_name)
FROM customer
