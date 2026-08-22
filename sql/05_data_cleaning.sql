-- 04_data_cleaning.sql
-- Purpose: Create a validated analytical copy of the Foods table.
--
-- Cleaning decision:
-- "t" in Sat.Fat is treated as a trace amount for numerical analysis
-- and converted to 0.
-- NULL values are preserved as missing data.

DROP TABLE IF EXISTS Foods_cleaned;

CREATE TABLE Foods_cleaned (
    Food TEXT,
    Measure TEXT,
    Grams REAL,
    Calories REAL,
    Protein REAL,
    Fat REAL,
    "Sat.Fat" REAL,
    Fiber REAL,
    Carbs REAL,
    Category TEXT,
    "Free Sugar (g)" REAL,
    "Sodium (mg)" REAL,
    "Calcium (mg)" REAL,
    "Iron (mg)" REAL,
    "Vitamin C (mg)" REAL,
    "Folate (µg)" REAL,
    protein_per_calorie REAL
);

INSERT INTO Foods_cleaned (
    Food,
    Measure,
    Grams,
    Calories,
    Protein,
    Fat,
    "Sat.Fat",
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
)
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
    END,
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
