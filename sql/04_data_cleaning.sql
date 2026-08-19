-- 04_data_cleaning.sql
-- Purpose: Clean the Sat.Fat column for numerical analysis.
--
-- Cleaning decision:
-- "t" represents a trace amount.
-- Trace values are converted to 0 for numerical analysis.
-- NULL values are preserved because they represent missing data.

DROP TABLE IF EXISTS Foods_cleaned;

CREATE TABLE Foods_cleaned AS
SELECT
    Food,
    Measure,
    Grams,
    Calories,
    Protein,
    Fat,
    CASE
        WHEN "Sat.Fat" = 't' THEN 0
        ELSE CAST("Sat.Fat" AS REAL)
    END AS "Sat.Fat",
    Fiber,
    Carbs,
    Category,
    "Free Sugar (g)",
    "Sodium (mg)",
    "Calcium (mg)",
    "Iron (mg)",
    "Vitamin C (mg)",
    "Folate (µg)",
    protein_per_calorie
FROM Foods;
