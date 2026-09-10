# Teaching data

The textbook keeps learner-facing files directly in this folder so students
can use short paths such as:

```r
gpfg <- read_csv("data/gpfg_5_years.csv")
```

The main teaching sequence uses these versions of the same data:

1. `gpfg_messy.csv` is a deliberately altered 2025 snapshot for learning how
   to rename columns, convert a date, inspect missing values, and check a
   duplicate row.
2. `gpfg_2025.csv` is the clean result created in the cleaning chapter.
3. `gpfg_2021.csv` through `gpfg_2025.csv` are imported and combined in the
   analysis chapter.
4. `gpfg_5_years.csv` is the combined 2021--2025 result reused for analysis,
   visualization, and mapping.
5. `gpfg_country_wide.csv` and `gpfg_country_lookup.csv` support the join and
   reshape chapter.
6. `gpfg_history.csv.gz` is an optional compressed CSV containing all 28 year-end
   snapshots from 1998 through 2025. `read_csv()` opens the compressed file
   directly.

`gpfg_data_dictionary.csv` explains the variables, units, and important
reporting cautions.

Other CSV files support the later case studies and practice labs. The textbook
chapter for each case provides the exact filename and explains what one row
represents.

The `processed/` folder contains advanced maintenance and audit files. Students
do not need that folder to follow the main lessons.
