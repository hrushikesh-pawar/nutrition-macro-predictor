-- Business Question:
-- How many foods are there?

SELECT COUNT(*) AS total_foods
FROM foods;

----------------------------------------------------

-- Business Question:
-- Show all unique categories.

SELECT DISTINCT category
FROM foods;

----------------------------------------------------

-- Business Question:
-- Show average protein by category.

SELECT
    category,
    AVG(protein) AS average_protein
FROM foods
GROUP BY category;
