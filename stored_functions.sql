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


