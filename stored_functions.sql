-- Stored Functions!

SELECT COUNT(*)
FROM actor
WHERE last_name LIKE 'S%';

SELECT COUNT(*)
FROM actor 
WHERE last_name LIKE 'T%';

-- Create a stored function thta will give the count of actors with a 
-- last name that starts with *letter*

CREATE OR REPLACE FUNCTION get_actor_count(letter VARCHAR(1))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO actor_count
	FROM actor
	WHERE last_name ILIKE CONCAT(letter, '%');
	RETURN actor_count;
END;
$$;


-- Execute the function - use SELECT
SELECT get_actor_count('S');
SELECT get_actor_count('R');
SELECT get_actor_count('A');
SELECT get_actor_count('d');

SELECT get_actor_count('n', 'w');


DROP FUNCTION get_actor_count(VARCHAR, VARCHAR);



-- Create a function that will return the employee with the most transactions (based on payment table)
SELECT *
FROM payment;

SELECT CONCAT(first_name, ' ', last_name) AS employee
FROM staff
WHERE staff_id = (
	SELECT staff_id
	FROM payment
	GROUP BY staff_id
	ORDER BY COUNT(*) DESC
	LIMIT 1
);

-- Store above as a function
CREATE OR REPLACE FUNCTION employee_with_most_transactions()
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
	DECLARE employee VARCHAR;
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) INTO employee
	FROM staff
	WHERE staff_id = (
		SELECT staff_id
		FROM payment
		GROUP BY staff_id
		ORDER BY COUNT(*) DESC
		LIMIT 1
	);
	RETURN employee;
END;
$$;

SELECT employee_with_most_transactions();


-- Create a function that will return a table with customer info (first and last name)
-- and full address (address, city, district, country) by country name


SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci
ON ci.city_id = a.city_id
JOIN country co 
ON co.country_id = ci.country_id
WHERE country = 'India';


CREATE OR REPLACE FUNCTION customers_in_country(country_name VARCHAR)
RETURNS TABLE (
	first_name VARCHAR(45),
	last_name VARCHAR(45),
	address VARCHAR(50),
	city VARCHAR(50),
	district VARCHAR(20),
	country VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	FROM customer c
	JOIN address a
	ON c.address_id = a.address_id
	JOIN city ci
	ON ci.city_id = a.city_id
	JOIN country co 
	ON co.country_id = ci.country_id
	WHERE co.country = country_name;
END;
$$;

-- Execute a function that returns a table - use SELECT ... FROM
SELECT *
FROM customers_in_country('India');

SELECT *
FROM customers_in_country('Mexico');

SELECT *
FROM customers_in_country('United States')
WHERE district = 'Illinois';


SELECT district, COUNT(*)
FROM customers_in_country('India')
GROUP BY district
ORDER BY COUNT(*) DESC;


-- To delete a function, use DROP
DROP FUNCTION IF EXISTS employee_with_most_transactions;
