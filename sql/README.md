SQL scripts used for preparing and analyzing European aviation data.
# SQL — European Aviation Analytics

This directory contains PostgreSQL scripts used for data preparation, validation, and airport delay analysis for the European Aviation Analytics project (2024–2025).

## SQL Files

### 01_create_airport_operations_view.sql

Creates the `vw_airport_operations` analytical view by combining two source tables:

- `airport_traffic` — airport traffic and flight movement data.
- `airport_delays` — IFR departure and delay statistics.

The view uses a `LEFT JOIN` on flight date and airport ICAO code to retain traffic records even when matching delay data is unavailable.

### 02_delay_analysis.sql

Contains exploratory SQL queries covering:

- Yearly record counts and date coverage.
- Missing-value analysis and delay data completeness.
- Validation of joins between traffic and delay records.
- Average delay per IFR departure.
- Airport-level delay comparisons.
- Ranking airports by average delay with a minimum traffic threshold.

## SQL Techniques

`SELECT` · `LEFT JOIN` · `GROUP BY` · `HAVING` · `ORDER BY` · `COUNT` · `SUM` · `MIN` · `MAX` · `ROUND` · `NULLIF` · `LIMIT`

## Data Quality Considerations

- Missing delay values are preserved rather than replaced with zero.
- Average delay is calculated using reported delay minutes and the corresponding IFR departure counts.
- Minimum traffic thresholds can be applied to avoid misleading comparisons involving very small airports.

## Database

**Database engine:** PostgreSQL

**Analytical view:** `public.vw_airport_operations`

The scripts assume the source tables have already been imported into the database.
