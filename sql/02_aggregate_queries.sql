-- Business Question:
-- Show category-wise nutrition summary.
-- Include only categories with at least 5 foods.
-- Sort by average protein in descending order.

SELECT
    category,
    COUNT(*) AS total_foods,
    AVG(protein) AS avg_protein,
    SUM(protein) AS total_protein,
    MAX(protein) AS highest_protein,
    MIN(protein) AS lowest_protein
FROM foods
GROUP BY category
HAVING COUNT(*) >= 5
ORDER BY AVG(protein) DESC;
