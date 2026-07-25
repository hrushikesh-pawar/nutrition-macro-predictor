-- Total number of foods
SELECT COUNT(*) AS total_foods
FROM foods;

-- Number of foods in each category
SELECT category, COUNT(*) AS total_foods
FROM foods
GROUP BY category;

-- Categories with more than 50 foods
SELECT category, COUNT(*) AS total_foods
FROM foods
GROUP BY category
HAVING COUNT(*) > 50;
