# Data Quality Investigation

## Dataset Overview

The Nutrition Macro Predictor dataset contains:

- 1,274 food records
- 17 columns
- Data sources combined into Indian and other food records

## Database Validation

The dataset was loaded into SQLite as the `Foods` table.

Validation performed:

- Verified database integrity using `PRAGMA integrity_check`
- Confirmed total record count using `COUNT(*)`
- Inspected table schema using `PRAGMA table_info()`
- Compared the SQLite data with the original Pandas DataFrame

Database integrity check returned:

`ok`

Total records:

`1,274`

## Category Profiling

The dataset contains 17 unique categories.

The largest category is:

`Indian Dishes` → 1,014 records

The remaining categories contain:

`260 records`

## Missing Value Investigation

Missing values were profiled using Pandas and SQL.

### 1,014 Missing Values

The following fields contain 1,014 missing values:

- Measure
- Grams
- Sat.Fat

Further analysis showed that all 1,014 missing values occur in the `Indian Dishes` category.

This indicates systematic missingness rather than random missingness.

### 260 Missing Values

The following fields contain 260 missing values:

- Free Sugar (g)
- Sodium (mg)
- Calcium (mg)
- Iron (mg)

These missing values occur in the other 260 records.

### 342 Missing Values

The following fields contain 342 missing values:

- Vitamin C (mg)
- Folate (µg)

The missing values consist of:

- 260 records from the other 260-food portion
- 82 records from Indian Dishes

Therefore:

342 = 260 + 82

## Sat.Fat Investigation

`Sat.Fat` has an `object` dtype in Pandas and is stored as `TEXT` in SQLite.

Observed values include:

- Numeric values
- NULL values
- 13 records containing `t`

The 13 `t` records occur in:

- Vegetables A-E → 5
- Dairy products → 4
- Fruits G-P → 3
- Desserts, sweets → 1

The `t` value appears to represent a trace amount, but this interpretation should be retained as a documented assumption until verified against the original source definition.

The value should not be blindly converted to zero.

## protein_per_calorie Investigation

Two records contain NULL `protein_per_calorie` values:

- Carbonated drinks Artificially sweetened
- Club soda

Both records contain:

- Calories = 0
- Protein = 0
- protein_per_calorie = NULL

The derived metric is:

protein_per_calorie = Protein / Calories

For these records:

0 / 0

is mathematically undefined.

External source validation also supported the zero-calorie and zero-protein values for these records.

Therefore, the NULL values in `protein_per_calorie` are currently considered valid undefined derived values and should not automatically be replaced with zero.

## Current Conclusion

The missing values in this dataset are not all the same type.

They include:

1. Systematic source-level missingness
2. Trace-value representation
3. Missing nutritional measurements
4. Valid NULL derived values caused by an undefined calculation

No values should be replaced until the appropriate treatment has been justified.

## Next Steps

1. Investigate duplicate records.
2. Check for impossible or suspicious numeric values.
3. Complete the data-quality assessment.
4. Define a cleaning policy.
5. Apply only justified transformations.
6. Recalculate derived metrics where appropriate.
7. Validate the cleaned dataset.
8. Rebuild or update the analytical database.
