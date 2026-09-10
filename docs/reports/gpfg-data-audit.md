# GPFG equity holdings data audit

## Recommendation

Use the deliberately messy 2025 snapshot for importing and cleaning, then combine the five annual learner files for introductory analysis and charting. The compressed 1998–2025 history supports longitudinal lessons; use shorter, comparable periods when coverage or classifications change.

The dataset's unit of analysis is **one equity holding reported by NBIM at one year-end**. A row is not a transaction, cash flow, investment return, or money received by a company.

## Stable files created

- `data/gpfg_messy.csv`: deliberately messy latest-year file for import and cleaning lessons.
- `data/gpfg_2021.csv` through `data/gpfg_2025.csv`: clean annual files for import and `bind_rows()` practice.
- `data/gpfg_5_years.csv`: the combined five-year result used in later chapters.
- `data/gpfg_country_wide.csv`: country totals with one column per year for reshaping practice.
- `data/gpfg_country_lookup.csv`: country-to-region lookup for joining practice.
- `data/gpfg_history.csv.gz`: compressed CSV containing every annual snapshot.
- `data/gpfg_data_dictionary.csv`: definitions, units, and teaching cautions.
- `data/processed/gpfg_equities_last_10_years.rds`: compact R version of the teaching dataset.
- `data/processed/gpfg_equities_full_history.rds`: compact complete historical archive.
- `data/processed/gpfg_annual_summary.csv`: annual coverage and quality summary.
- `data/processed/gpfg_source_manifest.csv`: source URL, file size, and checksum for each year.
- `data/processed/gpfg_validation_checks.csv`: machine-readable checks for every rebuild.

## Coverage

- Years: 1998–2025 (28 year-end snapshots).
- Full archive: 185,892 holding records.
- Teaching period: 88,858 records from 2016–2025.
- Latest snapshot: 7,201 records in 2025.
- Validation checks passed: 13 of 13.

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
