# GPFG equity holdings data audit

## Recommendation

Use the 2016–2025 equity holdings as the main longitudinal teaching dataset, and use the single 2025 snapshot for introductory importing, filtering, sorting, grouping, and charting. Keep the complete 1998–2025 archive for optional historical investigations.

The dataset's unit of analysis is **one equity holding reported by NBIM at one year-end**. A row is not a transaction, cash flow, investment return, or money received by a company.

## Stable files created

- `gpfg_equities_latest.csv`: beginner-friendly latest-year snapshot.
- `gpfg_equities_last_10_years.csv`: rolling ten-year teaching dataset.
- `gpfg_equities_last_10_years.rds`: compact R version of the teaching dataset.
- `gpfg_equities_full_history.rds`: compact complete historical archive.
- `gpfg_annual_summary.csv`: annual coverage and quality summary.
- `gpfg_data_dictionary.csv`: definitions, units, and teaching cautions.
- `gpfg_source_manifest.csv`: source URL, file size, and checksum for each year.
- `gpfg_validation_checks.csv`: machine-readable checks for every rebuild.

## Coverage

- Years: 1998–2025 (28 year-end snapshots).
- Full archive: 185,892 holding records.
- Teaching period: 88,858 records from 2016–2025.
- Latest snapshot: 7,201 records in 2025.
- Validation checks passed: 9 of 9.

## Important historical cautions

### Coverage expands sharply in 2007

The number of records rises sharply between 2006 and 2007. Students should investigate whether reporting coverage changed before describing this as an investment decision.

### Industry categories change in 2021

Industry labels and categories change around 2020–2021. Trends crossing this break require a documented concordance or separate-period analysis.

### Negative historical positions are preserved

The full archive contains 102 negative NOK market-value records, 77 negative ownership values, and 1 negative voting value. They are preserved rather than silently removed.

### Company names are not stable identifiers

The rolling teaching dataset contains 16,869 distinct published names; 3,285 occur in every included year. Renaming, mergers, demergers, entry, and exit are mixed together.

### The latest record count declines in 2025

Holding records change from 8,659 in 2024 to 7,201 in 2025 (-16.8%). Treat this as a result to investigate, not automatically as an error or divestment.

## Teaching guardrails

1. Say “year-end market value of holdings,” not “money invested that year.”
2. Use NOK for multi-year comparisons and explain that values remain nominal.
3. Use USD mainly for single-year international readability.
4. State the unit of analysis before every aggregation.
5. Count rows and distinct company names separately.
6. Audit unmatched country names before mapping.
7. Treat industry comparisons across 2020–2021 as a classification problem.
8. Avoid treating a company-name match as a permanent identifier.

## Reproducibility

Run `Rscript scripts/update_gpfg.R` from the project root. Existing raw files are retained, only missing years are downloaded, and the preparation step stops if years are missing or the source schema changes.
