# NBIM year-end equity holdings: raw archive

This directory contains the official year-end equity-holdings files from 1998
through the latest downloaded year from Norges Bank Investment Management (NBIM). Both CSV
and Excel exports are preserved. The preparation script uses the Excel files
because they retain typed numeric columns and incorporation-country values
that are blank in the CSV export.

- Source page: <https://www.nbim.no/en/investments/all-investments/>
- API pattern: `https://www.nbim.no/api/investments/v2/report/?assetType=eq&date=YYYY-12-31&fileType=csv`
- Asset type: listed equities (`eq`)
- Archived formats: Excel (`.xlsx`) and UTF-16LE, semicolon-delimited CSV
- Download date: 2026-08-01

These source files should remain unchanged. Run `Rscript scripts/prepare_gpfg.R` from
the project root to rebuild the cleaned datasets, source manifest, data
dictionary, and validation checks.

The downloaded `.csv` and `.xlsx` files are intentionally excluded from Git to
keep the textbook repository small. This README and the download scripts remain
in the repository so the archive can be reproduced locally.

To update the archive and rebuild the teaching data in one step, run
`Rscript scripts/update_gpfg.R`. Existing files are preserved by default, so a
normal annual run downloads only the missing year. Pass `--overwrite` only when
you intentionally want to replace existing official downloads.

The holdings are year-end snapshots, not records of purchases, sales, cash
flows, investment performance, or money “received” by companies. Company
names and industry classifications are not stable identifiers across 28 years.
