#!/usr/bin/env Rscript

# Build analysis-ready teaching datasets from NBIM's year-end equity holdings.
#
# Raw files are downloaded from the official NBIM holdings API and are kept
# unchanged in data/raw/gpfg/. This script only reads those files and writes
# reproducible outputs to data/processed/ and reports/.

suppressPackageStartupMessages({
  library(dplyr)
  library(purrr)
  library(readr)
  library(readxl)
  library(stringr)
  library(tidyr)
})

raw_dir <- "data/raw/gpfg"
processed_dir <- "data/processed"
report_dir <- "reports"

dir.create(processed_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(report_dir, recursive = TRUE, showWarnings = FALSE)

first_year <- 1998L

raw_files <- list.files(
  raw_dir,
  pattern = "^gpfg-equities-[0-9]{4}-12-31\\.xlsx$",
  full.names = TRUE
) |>
  sort()

if (length(raw_files) == 0) {
  stop("No annual NBIM Excel files were found in ", raw_dir, ".")
}

extract_report_date <- function(path) {
  as.Date(str_extract(basename(path), "[0-9]{4}-12-31"))
}

found_report_dates <- as.Date(
  map_chr(raw_files, ~ format(extract_report_date(.x), "%Y-%m-%d"))
)
found_years <- as.integer(format(found_report_dates, "%Y"))
latest_year <- max(found_years)
expected_years <- seq.int(first_year, latest_year)
teaching_years <- seq.int(max(first_year, latest_year - 9L), latest_year)

if (!identical(found_years, expected_years)) {
  missing_years <- setdiff(expected_years, found_years)
  stop(
    "The raw archive must contain one continuous annual series from ",
    first_year, " through ", latest_year, ". Missing: ",
    paste(missing_years, collapse = ", "), "."
  )
}

expected_columns <- c(
  "Region",
  "Country",
  "Name",
  "Industry",
  "Market Value(NOK)",
  "Market Value(USD)",
  "Voting",
  "Ownership",
  "Incorporation Country"
)

clean_text <- function(x) {
  x |>
    str_squish() |>
    na_if("")
}

read_holding_file <- function(path) {
  report_date <- extract_report_date(path)
  year <- as.integer(format(report_date, "%Y"))

  raw <- read_excel(
    path,
    sheet = "Holdings Report",
    col_types = c("text", "text", "text", "text", "numeric", "numeric", "numeric", "numeric", "text"),
    trim_ws = TRUE,
    progress = FALSE
  )

  if (!identical(names(raw), expected_columns)) {
    stop("Unexpected columns in ", basename(path), ".")
  }

  raw |>
    transmute(
      year = year,
      report_date = report_date,
      region = clean_text(Region),
      country = clean_text(Country),
      company = clean_text(Name),
      industry = clean_text(Industry),
      market_value_nok = `Market Value(NOK)`,
      market_value_usd = `Market Value(USD)`,
      voting_pct = Voting,
      ownership_pct = Ownership,
      incorporation_country = clean_text(`Incorporation Country`),
      source_file = basename(path),
      source_url = paste0(
        "https://www.nbim.no/api/investments/v2/report/?assetType=eq&date=",
        report_date,
        "&fileType=xlsx"
      )
    ) |>
    filter(!if_all(everything(), is.na))
}

message("Reading ", length(raw_files), " annual NBIM files …")

gpfg_full <- map_dfr(raw_files, read_holding_file) |>
  arrange(year, country, company)

gpfg_teaching <- gpfg_full |>
  filter(year %in% teaching_years)

gpfg_latest <- gpfg_full |>
  filter(year == latest_year)

duplicate_name_audit <- gpfg_full |>
  count(year, company, name = "records_for_company_name") |>
  summarise(
    duplicate_company_names = sum(records_for_company_name > 1),
    .by = year
  )

gpfg_annual_summary <- gpfg_full |>
  summarise(
    report_date = first(report_date),
    holding_records = n(),
    distinct_company_names = n_distinct(company),
    countries = n_distinct(country),
    regions = n_distinct(region),
    industries = n_distinct(industry),
    total_market_value_nok = sum(market_value_nok, na.rm = TRUE),
    total_market_value_usd = sum(market_value_usd, na.rm = TRUE),
    missing_company = sum(is.na(company)),
    missing_country = sum(is.na(country)),
    missing_industry = sum(is.na(industry)),
    missing_market_value_nok = sum(is.na(market_value_nok)),
    missing_market_value_usd = sum(is.na(market_value_usd)),
    missing_voting_pct = sum(is.na(voting_pct)),
    missing_ownership_pct = sum(is.na(ownership_pct)),
    missing_incorporation_country = sum(is.na(incorporation_country)),
    negative_market_value_records = sum(market_value_nok < 0, na.rm = TRUE),
    negative_ownership_records = sum(ownership_pct < 0, na.rm = TRUE),
    negative_voting_records = sum(voting_pct < 0, na.rm = TRUE),
    .by = year
  ) |>
  left_join(duplicate_name_audit, by = "year") |>
  arrange(year)

gpfg_schema_audit <- tibble(
  source_file = basename(raw_files),
  report_date = found_report_dates,
  year = found_years,
  file_size_bytes = file.info(raw_files)$size,
  md5 = unname(tools::md5sum(raw_files)),
  source_format = "xlsx",
  worksheet = "Holdings Report",
  source_columns = length(expected_columns),
  expected_schema = TRUE,
  source_url = paste0(
    "https://www.nbim.no/api/investments/v2/report/?assetType=eq&date=",
    map_chr(raw_files, ~ format(extract_report_date(.x), "%Y-%m-%d")),
    "&fileType=xlsx"
  )
)

data_dictionary <- tribble(
  ~variable, ~type, ~description, ~unit_or_example, ~teaching_note,
  "year", "integer", "Calendar year of the year-end holdings snapshot.", "2025", "A snapshot date, not a transaction year.",
  "report_date", "date", "Official reporting date for the holdings snapshot.", "2025-12-31", "Use this when exact timing matters.",
  "region", "character", "NBIM geographic region assigned to the investment market.", "North America", "Categories may change over a long historical period.",
  "country", "character", "NBIM country or market assigned to the holding.", "United States", "This is not necessarily the incorporation country.",
  "company", "character", "Company or issuer name as published by NBIM.", "Apple Inc", "Names are not stable identifiers; mergers and renaming complicate longitudinal matching.",
  "industry", "character", "NBIM industry classification for the holding.", "Technology", "Classifications can change between years.",
  "market_value_nok", "double", "Year-end market value of the holding in Norwegian kroner.", "NOK", "Best monetary field for comparisons across years, but values are nominal and reflect prices, currencies, purchases, and sales.",
  "market_value_usd", "double", "Year-end market value of the holding converted to US dollars.", "USD", "Useful for a single snapshot; exchange-rate changes affect comparisons across years.",
  "voting_pct", "double", "Voting rights held, stored in percentage points.", "0.65 means 0.65%", "Do not divide by 100 unless a calculation needs a 0–1 proportion.",
  "ownership_pct", "double", "Equity ownership held, stored in percentage points.", "1.20 means 1.20%", "This is a stake, not a financial return.",
  "incorporation_country", "character", "Legal country of incorporation supplied by NBIM.", "Ireland", "Compare with country to distinguish incorporation from the investment market.",
  "source_file", "character", "Name of the archived official annual Excel file.", "gpfg-equities-2025-12-31.xlsx", "Use for provenance and debugging.",
  "source_url", "character", "Official NBIM API URL for the annual source file.", "https://www.nbim.no/api/investments/v2/report/…", "The URL includes the asset type and report date."
)

validation_checks <- tibble(
  check = c(
    "All expected years are present",
    "All source files use the expected schema",
    "Company is present in every record",
    "Country is present in every record",
    "NOK market value is present in every record",
    "NOK market values are finite when present",
    "Teaching-period NOK market values are non-negative",
    "Teaching-period ownership percentages are between 0 and 100",
    "Teaching-period voting percentages are between 0 and 100"
  ),
  passed = c(
    identical(sort(unique(gpfg_full$year)), expected_years),
    all(gpfg_schema_audit$expected_schema),
    !anyNA(gpfg_full$company),
    !anyNA(gpfg_full$country),
    !anyNA(gpfg_full$market_value_nok),
    all(is.finite(gpfg_full$market_value_nok) | is.na(gpfg_full$market_value_nok)),
    all(gpfg_teaching$market_value_nok >= 0, na.rm = TRUE),
    all(between(gpfg_teaching$ownership_pct, 0, 100), na.rm = TRUE),
    all(between(gpfg_teaching$voting_pct, 0, 100), na.rm = TRUE)
  )
)

if (!all(validation_checks$passed)) {
  failed <- validation_checks |>
    filter(!passed) |>
    pull(check)
  warning("Validation checks requiring attention: ", paste(failed, collapse = "; "))
}

saveRDS(
  gpfg_full,
  file.path(processed_dir, "gpfg_equities_full_history.rds"),
  compress = "xz"
)
saveRDS(
  gpfg_teaching,
  file.path(processed_dir, "gpfg_equities_last_10_years.rds"),
  compress = "xz"
)

write_csv(
  gpfg_teaching,
  file.path(processed_dir, "gpfg_equities_last_10_years.csv"),
  na = ""
)
write_csv(
  gpfg_latest,
  file.path(processed_dir, "gpfg_equities_latest.csv"),
  na = ""
)
write_csv(
  gpfg_annual_summary,
  file.path(processed_dir, "gpfg_annual_summary.csv"),
  na = ""
)
write_csv(
  data_dictionary,
  file.path(processed_dir, "gpfg_data_dictionary.csv"),
  na = ""
)
write_csv(
  gpfg_schema_audit,
  file.path(processed_dir, "gpfg_source_manifest.csv"),
  na = ""
)
write_csv(
  validation_checks,
  file.path(processed_dir, "gpfg_validation_checks.csv"),
  na = ""
)

teaching_start <- min(teaching_years)
teaching_end <- max(teaching_years)

company_persistence <- gpfg_teaching |>
  distinct(year, company) |>
  count(company, name = "years_present") |>
  summarise(
    distinct_names = n(),
    names_in_every_year = sum(years_present == length(teaching_years))
  )

historical_negatives <- gpfg_full |>
  summarise(
    market_value = sum(market_value_nok < 0, na.rm = TRUE),
    ownership = sum(ownership_pct < 0, na.rm = TRUE),
    voting = sum(voting_pct < 0, na.rm = TRUE)
  )

latest_records <- gpfg_annual_summary |>
  filter(year == latest_year) |>
  pull(holding_records)

previous_records <- gpfg_annual_summary |>
  filter(year == latest_year - 1L) |>
  pull(holding_records)

record_change_pct <- if (length(previous_records) == 1 && previous_records != 0) {
  100 * (latest_records / previous_records - 1)
} else {
  NA_real_
}

change_word <- if (is.na(record_change_pct)) {
  "changes"
} else if (record_change_pct < 0) {
  "declines"
} else {
  "increases"
}

format_count <- function(x) format(x, big.mark = ",", scientific = FALSE)
pluralize <- function(x, singular, plural = paste0(singular, "s")) {
  if (x == 1) singular else plural
}

audit_lines <- c(
  "# GPFG equity holdings data audit",
  "",
  "## Recommendation",
  "",
  paste0(
    "Use the ", teaching_start, "–", teaching_end,
    " equity holdings as the main longitudinal teaching dataset, and use the ",
    "single ", latest_year, " snapshot for introductory importing, filtering, ",
    "sorting, grouping, and charting. Keep the complete ", first_year, "–",
    latest_year, " archive for optional historical investigations."
  ),
  "",
  "The dataset's unit of analysis is **one equity holding reported by NBIM at one year-end**. A row is not a transaction, cash flow, investment return, or money received by a company.",
  "",
  "## Stable files created",
  "",
  "- `gpfg_equities_latest.csv`: beginner-friendly latest-year snapshot.",
  "- `gpfg_equities_last_10_years.csv`: rolling ten-year teaching dataset.",
  "- `gpfg_equities_last_10_years.rds`: compact R version of the teaching dataset.",
  "- `gpfg_equities_full_history.rds`: compact complete historical archive.",
  "- `gpfg_annual_summary.csv`: annual coverage and quality summary.",
  "- `gpfg_data_dictionary.csv`: definitions, units, and teaching cautions.",
  "- `gpfg_source_manifest.csv`: source URL, file size, and checksum for each year.",
  "- `gpfg_validation_checks.csv`: machine-readable checks for every rebuild.",
  "",
  "## Coverage",
  "",
  paste0("- Years: ", first_year, "–", latest_year, " (", length(expected_years), " year-end snapshots)."),
  paste0("- Full archive: ", format_count(nrow(gpfg_full)), " holding records."),
  paste0("- Teaching period: ", format_count(nrow(gpfg_teaching)), " records from ", teaching_start, "–", teaching_end, "."),
  paste0("- Latest snapshot: ", format_count(nrow(gpfg_latest)), " records in ", latest_year, "."),
  paste0("- Validation checks passed: ", sum(validation_checks$passed), " of ", nrow(validation_checks), "."),
  "",
  "## Important historical cautions",
  "",
  "### Coverage expands sharply in 2007",
  "",
  "The number of records rises sharply between 2006 and 2007. Students should investigate whether reporting coverage changed before describing this as an investment decision.",
  "",
  "### Industry categories change in 2021",
  "",
  "Industry labels and categories change around 2020–2021. Trends crossing this break require a documented concordance or separate-period analysis.",
  "",
  "### Negative historical positions are preserved",
  "",
  paste0(
    "The full archive contains ", historical_negatives$market_value,
    " negative NOK market-value records, ", historical_negatives$ownership,
    " negative ownership values, and ", historical_negatives$voting,
    " negative voting ", pluralize(historical_negatives$voting, "value"),
    ". They are preserved rather than silently removed."
  ),
  "",
  "### Company names are not stable identifiers",
  "",
  paste0(
    "The rolling teaching dataset contains ",
    format_count(company_persistence$distinct_names),
    " distinct published names; ",
    format_count(company_persistence$names_in_every_year),
    " occur in every included year. Renaming, mergers, demergers, entry, and exit are mixed together."
  ),
  "",
  paste0("### The latest record count ", change_word, " in ", latest_year),
  "",
  if (is.na(record_change_pct)) {
    "A prior-year comparison is not available."
  } else {
    paste0(
      "Holding records change from ", format_count(previous_records), " in ",
      latest_year - 1L, " to ", format_count(latest_records), " in ",
      latest_year, " (", sprintf("%+.1f%%", record_change_pct),
      "). Treat this as a result to investigate, not automatically as an error or divestment."
    )
  },
  "",
  "## Teaching guardrails",
  "",
  "1. Say “year-end market value of holdings,” not “money invested that year.”",
  "2. Use NOK for multi-year comparisons and explain that values remain nominal.",
  "3. Use USD mainly for single-year international readability.",
  "4. State the unit of analysis before every aggregation.",
  "5. Count rows and distinct company names separately.",
  "6. Audit unmatched country names before mapping.",
  "7. Treat industry comparisons across 2020–2021 as a classification problem.",
  "8. Avoid treating a company-name match as a permanent identifier.",
  "",
  "## Reproducibility",
  "",
  "Run `Rscript scripts/update_gpfg.R` from the project root. Existing raw files are retained, only missing years are downloaded, and the preparation step stops if years are missing or the source schema changes."
)

writeLines(
  audit_lines,
  file.path(report_dir, "gpfg-data-audit.md"),
  useBytes = TRUE
)

message(
  "Created ", format_count(nrow(gpfg_full)), " full-period records through ",
  latest_year, " and ", format_count(nrow(gpfg_teaching)),
  " teaching-period records for ", teaching_start, "–", teaching_end, "."
)
