-- Stored Procedures!


SELECT *
FROM customer;


-- If you don't have loyalty member column, execute the following:
--ALTER TABLE customer
--ADD COLUMN loyalty_member BOOLEAN;

-- Reset all customers to be loyalty_member = False
UPDATE customer 
SET loyalty_member = FALSE;

SELECT *
FROM customer 
WHERE loyalty_member = FALSE;

-- Create a procedure that will set anyone who has spent >= $100 to be a loyalty_member


-- Query to get the customers who have spent >= $100

SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) >= 100;


-- Update the customer table to set those customer to loyalty members
UPDATE customer
SET loyalty_member = TRUE
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) >= 100
);

SELECT *
FROM customer
WHERE loyalty_member = TRUE;


-- Set up a stored procedure to set loyalty_member
CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET loyalty_member = TRUE
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) >= 100
	);
END;
$$;


-- Execute the Procedure with CALL 
CALL update_loyalty_status();

SELECT *
FROM customer
WHERE loyalty_member = TRUE;


-- Mimic a customer making a new purchase that will put them over the threshold

-- Find a customer who is close to our threshold
SELECT customer_id, SUM(amount)
FROM payment 
GROUP BY customer_id
HAVING SUM(amount) BETWEEN 95 AND 100;


SELECT *
FROM customer
WHERE customer_id = 554;


-- Add a new payment of 4.99 with that customer to push them over the threshold
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES (554, 1, 1, 4.99, '2023-05-25 13:44:46');

-- Call the procedure again
CALL update_loyalty_status();


-- Check out the customer's loyalty status
SELECT *
FROM customer
WHERE customer_id = 554;




-- Create a procedure to add new rows to the actor table
SELECT *
FROM actor;


SELECT NOW();

INSERT INTO actor(first_name, last_name, last_update)
VALUES ('Brian', 'Stanton', NOW());


INSERT INTO actor(first_name, last_name, last_update)
VALUES ('Kevin', 'Beier', '2023-05-25 13:53:10.234');


CREATE OR REPLACE PROCEDURE add_actor(first_name VARCHAR, last_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO actor(first_name, last_name)
	VALUES (first_name, last_name);
END;
$$;


--INSERT INTO actor(first_name, last_name)
--VALUES ('Jeremy', 'Strong');
--
SELECT *
FROM actor 
ORDER BY actor_id DESC;

CALL add_actor('Kieran', 'Culkan');
CALL add_actor('Ana', 'de Armas');


-- To delete a procedre, we use DROP
DROP PROCEDURE IF EXISTS update_loyalty_status;





-- Default Arguments
CREATE OR REPLACE PROCEDURE update_loyalty_status(loyalty_min NUMERIC(5,2) DEFAULT 100.00)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET loyalty_member = TRUE
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) >= loyalty_min
	);
END;
$$;


-- RESET all customers loyalty
UPDATE customer 
SET loyalty_member = FALSE;

SELECT COUNT(*)
FROM customer
WHERE loyalty_member = TRUE;

-- Execute the procedure with an argument passed in (more than 100)

CALL update_loyalty_status(150.00); 


CALL update_loyalty_status(); -- DEFAULTS TO 100.00 WITHOUT PASSING IN an argument 



