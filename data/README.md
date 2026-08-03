# Teaching data

The textbook keeps learner-facing files directly in this folder so students
can use short paths such as:

```r
gpfg <- read_csv("data/gpfg.csv")
```

Start with `gpfg.csv`. Use
`gpfg_equities_last_10_years.csv` when the book introduces comparisons over
time. `gpfg_data_dictionary.csv` explains the variables, units, and important
reporting cautions.

Other CSV files support the later case studies and practice labs. The textbook
chapter for each case provides the exact filename and explains what one row
represents.

The `processed/` folder contains advanced maintenance and audit files. Students
do not need that folder to follow the main lessons.
