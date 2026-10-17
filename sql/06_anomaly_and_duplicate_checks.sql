-- 1. Check food-name duplicates (returns 4 repeated names: Spanish rice, Ice cream, Fresh, raw, Custard)
SELECT
    Food,
    COUNT(*) AS record_count
FROM Foods_cleaned
GROUP BY Food
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

-- 2. Verify zero exact full-row duplicates across all 17 columns
SELECT
    Food, Measure, Grams, Calories, Protein, Fat, "Sat.Fat",
    Fiber, Carbs, Category, "Free Sugar (g)", "Sodium (mg)",
    "Calcium (mg)", "Iron (mg)", "Vitamin C (mg)", "Folate (µg)",
    protein_per_calorie,
    COUNT(*) AS duplicate_count
FROM Foods_cleaned
GROUP BY
    Food, Measure, Grams, Calories, Protein, Fat, "Sat.Fat",
    Fiber, Carbs, Category, "Free Sugar (g)", "Sodium (mg)",
    "Calcium (mg)", "Iron (mg)", "Vitamin C (mg)", "Folate (µg)",
    protein_per_calorie
HAVING COUNT(*) > 1;

-- 3. Check for negative nutrient values (catches French-fried: Protein = -1.0)
SELECT *
FROM Foods_cleaned
WHERE Calories < 0
   OR Protein < 0
   OR Fat < 0
   OR "Sat.Fat" < 0
   OR Fiber < 0
   OR Carbs < 0
   OR "Free Sugar (g)" < 0
   OR "Sodium (mg)" < 0
   OR "Calcium (mg)" < 0
   OR "Iron (mg)" < 0
   OR "Vitamin C (mg)" < 0
   OR "Folate (µg)" < 0;

-- 4. Check for physically impossible protein_per_calorie (> 0.25 g/kcal)
SELECT
    Food,
    Category,
    Calories,
    Protein,
    Fat,
    Carbs,
    ROUND(4 * Protein + 4 * Carbs + 9 * Fat, 2) AS Atwater_Est_Calories,
    ROUND(protein_per_calorie, 4) AS protein_per_calorie
FROM Foods_cleaned
WHERE protein_per_calorie > 0.25
ORDER BY protein_per_calorie DESC;
