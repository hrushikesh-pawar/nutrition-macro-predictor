## Duplicate Record Investigation (Step 1 Completed)

Duplicate profiling was performed in SQLite across `Foods` / `Foods_cleaned` at two levels:

### 1. Food-Name Level (`GROUP BY Food HAVING COUNT(*) > 1`)
Total rows: `1,274` | Unique `Food` names: `1,270`

Four food names appear twice (`record_count = 2`):
- **Custard** — 1 record in `Dairy products` (`1 cup`, `248g`, `285 kcal`) and 1 record in `Desserts, sweets` (`1 slice`, `130g`, `265 kcal`)
- **Fresh, raw** — 1 record in `Fruits A-F` (`1 cup`, `114g`, `65 kcal`) and 1 record in `Fruits G-P` (`1 med.`, `114g`, `35 kcal`)
- **Ice cream** — 1 record in `Dairy products` (`1 cup`, `188g`, `300 kcal`) and 1 record in `Desserts, sweets` (`2 cups`, `300g`, `250 kcal`)
- **Spanish rice** — 1 record in `Breads, cereals, fastfood,grains` (`1 cup`, `250g`, `217 kcal`) and 1 record in `Indian Dishes` (`164.24 kcal`)

### 2. Full-Row Level (`GROUP BY` all 17 columns `HAVING COUNT(*) > 1`)
- Returned **0 records**.

**Conclusion on Duplicates:**
There are **no exact duplicate rows** in the dataset. The 4 repeated food names represent distinct food entries across different categories, serving measures, or source datasets and should be retained.

---

## Impossible & Suspicious Numeric Values Investigation (Step 2 Completed)

### 1. Negative Nutrient Values
All numeric columns were queried for values `< 0`. One corrupted record was identified:
- **Food:** `French-fried` (`Category`: `Vegetables R-Z`, `Measure`: `10 pieces`, `Grams`: `60.0`)
- **Observed Anomaly:** `Protein = -1.0`, resulting in `protein_per_calorie = -0.006452`
- **Diagnosis:** Typographical sign error in the raw Western dataset (`-1` instead of `1`).

### 2. Biochemical Upper-Bound Violations (`protein_per_calorie > 0.25`)
Because pure protein provides `4 kcal/g`, the theoretical maximum for `protein_per_calorie` is:
`1g Protein / 4 kcal = 0.25 g/kcal`

Querying `WHERE protein_per_calorie > 0.25` identified **11 records** (all in `Indian Dishes`, primarily soups):
- `Chicken sweet corn soup` (`Calories = 28.32`, `Protein = 14.48g`, `Fat = 12.59g` → `protein_per_calorie = 0.5113`)
- `Consomme au vermicelli` (`Calories = 29.94`, `Protein = 15.23g`, `Fat = 12.98g` → `protein_per_calorie = 0.5087`)
- `Meat consomme (with mutton)` (`Calories = 29.76`, `Protein = 14.86g`, `Fat = 13.68g` → `protein_per_calorie = 0.4993`)
- `Egg drop soup` (`Calories = 26.64`, `Protein = 12.93g`, `Fat = 13.52g` → `protein_per_calorie = 0.4854`)
- `Consomme au julienne` (`0.4499`), `Spinach soup (Palak ka soup)` (`0.3234`), `Lentil soup` (`0.3096`), `Cheese soup` (`0.3012`), `Talaumein soup` (`0.2840`), `Classic seasoned black beans` (`0.2783`), and `Green pea soup` (`0.2778`).

**Diagnosis:**
Using the Atwater energy formula (`4 * Protein + 4 * Carbs + 9 * Fat`), these soup records contain `137–211 kcal` of macronutrients, but their `Calories` column was recorded for a smaller/diluted serving (`26–41 kcal`). This explains why Indian soups appeared to outperform `Shrimp` (`0.2091 g/kcal`) in raw rankings before macro-calorie validation.

---

## Defined Cleaning Policy (Steps 3 & 4)

1. **Systematic Missingness (`Measure`, `Grams`, `Sat.Fat`, Micronutrients):** Retain as `NULL`. Do not impute across incompatible schemas.
2. **Undefined Derived Ratios (`Club soda`, `Carbonated drinks`):** Retain `protein_per_calorie` as `NULL` where `Calories = 0` (`0 / 0` is undefined).
3. **Trace Values (`'t'` in `Sat.Fat`):** Preserve raw `'t'` in the `Foods` source table; map `'t' -> 0.0` (with `REAL` affinity) in `Foods_cleaned` as a documented analytical assumption.
4. **Negative Value (`French-fried`):** Quarantine or correct `Protein = -1.0` in `Foods_cleaned` and recalculate `protein_per_calorie`.
5. **Macro-Calorie Mismatches (`protein_per_calorie > 0.25`):** Flag records where `protein_per_calorie > 0.25` (or `4*Protein + 4*Carbs + 9*Fat > 1.3 * Calories`) so they can be excluded from protein-efficiency rankings without deleting raw source data.
