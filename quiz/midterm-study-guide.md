# Midterm Study Guide: Data Journalism with R

This guide covers the concepts and functions assessed in the midterm question bank. It does not reproduce the quiz questions or answers.

## How to use this guide

For every concept or function, make sure you can:

1. Explain what it is for in plain language.
2. Recognize its basic syntax.
3. Identify the data or object it works on.
4. Predict what kind of result it returns.
5. Recognize a common mistake involving it.

Study with an R Project and an R Markdown document open. Run a small example of each function, change one part of the code, and observe what changes in the result. Focus on understanding the workflow rather than memorizing code character by character.

## 1. R, RStudio, projects, and packages

### R

R is a programming language and environment for working with data. It performs the calculations and runs the code.

### RStudio

RStudio is an interface for working with R. It provides an editor, Console, Environment pane, Files pane, and tools for projects and R Markdown.

### R Project

An R Project keeps the files for one piece of work together. It gives the project a consistent starting folder, which makes relative paths easier to use.

Know why an R Project makes an analysis easier to organize, move, and share.

### Packages

A package adds functions and other tools to R.

```r
install.packages("tidyverse")
```

- Installs a package on the computer.
- Normally needs to be done only once.

```r
library(tidyverse)
```

- Loads an installed package for the current R session.
- Must be run again after starting a new session.
- Should appear near the beginning of an R Markdown document if the document uses tidyverse functions.

### Tidyverse

The tidyverse is a collection of related R packages for importing, cleaning, transforming, analyzing, and visualizing data. This part of the course focuses on tidyverse-style functions and workflows.

### R Markdown and reproducibility

An R Markdown document combines text and executable R code. When the document is knitted, its code is run to create the output.

Important ideas:

- An object created only in the Console is not automatically available when the document is knitted.
- The document should contain the code needed to load packages, import data, and create the objects it uses.
- Code should run in order from the beginning of the document.

## 2. Objects, syntax, and data types

### Assignment: `<-`

Assignment saves a value or result under an object name.

```r
city <- "Hong Kong"
```

If a transformed result is not assigned to an object, R displays the result but does not permanently change the original object.

```r
open_cases <- complaints |>
  filter(status == "Open")
```

Here, `open_cases` contains the filtered result and `complaints` remains unchanged.

### Pipe: `|>`

The pipe passes the result on its left to the function on the next line.

```r
complaints |>
  filter(status == "Open")
```

Read this as: “Take `complaints`, then filter it.”

Know that the order of steps in a pipeline matters.

### Accessing a column: `$`

The dollar sign selects one column from a data frame or tibble.

```r
complaints$district
```

### Comparison and logical conditions

```r
status == "Open"
```

- `==` asks whether two values are equal.
- It is different from assignment with `<-`.

```r
condition_1 & condition_2
```

- `&` means both conditions must be true.

```r
condition_1 | condition_2
```

- `|` means at least one condition must be true.

Inside `filter()`, conditions separated by commas also mean “and.”

### `c()`

`c()` combines values into a vector.

```r
scores <- c(72, 81, 94)
```

A vector contains values of a common type.

### `tibble()`

`tibble()` creates a tidy table from columns or vectors.

```r
case_data <- tibble(
  district = city,
  number_of_cases = cases
)
```

The vectors used as columns should have compatible lengths.

### Common data types

| Display | Meaning | Typical values |
|---|---|---|
| `<chr>` | Character or text | names, categories, labels |
| `<dbl>` | Numeric values | amounts, percentages, measurements |
| `<lgl>` | Logical values | `TRUE` or `FALSE` |
| `<date>` | Calendar dates | year-month-day values |

Correct column types matter because functions behave differently with text, numbers, logical values, and dates.

## 3. CSV files, data import, and paths

### CSV files

CSV stands for comma-separated values. A CSV file stores a table as plain text.

Important characteristics:

- It normally represents one table.
- It does not preserve spreadsheet formatting, formulas, or multiple worksheets.
- It can be read by many programs.
- Importing it successfully does not prove that its data are clean or correct.

### `read_csv()`

`read_csv()` imports a CSV file and returns a tibble.

```r
data <- read_csv("data/file.csv")
```

It comes from the `readr` package, which is loaded by `library(tidyverse)`.

### `read.csv()`

`read.csv()` is a base R function that can also import CSV files. In this course, use `read_csv()` so the import workflow remains consistent with the tidyverse.

### Relative paths

A relative path describes a file’s location starting from the R Project folder.

```r
read_csv("data/complaints.csv")
```

Relative paths are portable because they do not include one person’s username or computer folders.

### Absolute paths

An absolute path describes the complete location on one computer.

```text
/Users/name/Desktop/project/data/complaints.csv
```

Absolute paths often fail when the project is moved or shared.

### Local files and URLs

R can import data from a local file or, in some cases, directly from a URL. A stable local copy is often preferable for a reproducible analysis because an online file may change, move, or become unavailable.

### Common import checks

When R cannot find a file, check:

- The correct R Project is open.
- The file is inside the expected folder.
- The folder and file names are spelled correctly.
- The relative path matches the project structure.
- The capitalization and file extension are correct.

## 4. Data inspection and cleaning

### Data cleaning

Data cleaning means identifying and addressing problems that could produce incorrect or misleading analysis.

The goal is not to make the data look neat. The goal is to make sure columns, values, types, dates, missing values, and records are suitable for the intended analysis.

### `glimpse()`

`glimpse()` gives a compact overview of a data frame.

```r
glimpse(complaints)
```

Use it to inspect:

- Column names
- Column types
- Number of rows and columns
- Example values

`glimpse()` can reveal a possible problem, such as numeric-looking values stored as text, but it cannot decide whether a real-world value is accurate.

### `slice_head()`

`slice_head()` displays rows from the beginning of the dataset’s current order.

```r
complaints |>
  slice_head(n = 5)
```

It does not automatically return the largest, smallest, oldest, or newest rows unless the data have already been arranged that way.

### `rename()`

`rename()` changes column names.

```r
complaints |>
  rename(category = complaint_category)
```

The pattern is:

```r
rename(new_name = old_name)
```

### `is.na()`

`is.na()` checks whether values are missing.

```r
is.na(complaints$agency)
```

It returns `TRUE` for missing values and `FALSE` for non-missing values.

### `colSums(is.na())`

This combination counts missing values in every column.

```r
colSums(is.na(complaints))
```

Use it for a compact missing-value report. Then inspect important missing records more closely.

### Inspecting rows with missing values

```r
complaints |>
  filter(is.na(agency))
```

Do not test missing values with `agency == NA`.

### `as.Date()`

`as.Date()` converts suitable values to R’s Date type.

```r
as.Date("2025-04-03")
```

The unambiguous year-month-day format is the safest simple input.

### `mdy()`

`mdy()` converts dates written in month-day-year order.

```r
mdy("04/03/2025")
```

This is interpreted as April 3, 2025.

Before converting dates, confirm their order and inspect whether the column contains mixed formats. Do not guess the intended date format.

### Duplicate rows and repeated identifiers

An exact duplicate row repeats the same values across all relevant columns. A repeated identifier is not necessarily an exact duplicate: the records may describe different events, versions, or observations.

Always identify the unit of analysis and investigate why records repeat before deleting anything.

## 5. Data analysis

### Reporting question and required columns

Before writing code:

1. State the question precisely.
2. Identify the rows that belong in the analysis.
3. Identify the columns needed to answer the question.
4. Confirm what one row represents.
5. Decide whether the answer requires individual records or grouped summaries.

### `distinct()`

`distinct()` returns unique values or unique combinations of values.

```r
donations |>
  distinct(city)
```

When only selected columns are given, the result describes uniqueness based on those columns. A repeated identifier does not automatically prove that entire rows are duplicates.

### `filter()`

`filter()` keeps rows that satisfy one or more conditions.

```r
inspections |>
  filter(result == "Fail")
```

Multiple conditions separated by commas mean all conditions must be true:

```r
complaints |>
  filter(district == "Kowloon", status == "Open")
```

Use `|` when either condition may be true:

```r
complaints |>
  filter(district == "Central" | district == "Western")
```

### `arrange()`

`arrange()` sorts rows by one or more columns.

```r
contracts |>
  arrange(value)
```

The default order is ascending: smallest to largest or alphabetical A to Z.

### `desc()`

Use `desc()` inside `arrange()` for descending order.

```r
contracts |>
  arrange(desc(value))
```

### `group_by()`

`group_by()` defines the groups that later calculations will use.

```r
complaints |>
  group_by(category)
```

`group_by()` does not calculate a result by itself. It is commonly followed by `summarise()`.

### `summarise()`

`summarise()` reduces many rows to one or more summary values.

Without grouping, it normally produces an overall summary:

```r
donations |>
  summarise(total = sum(amount, na.rm = TRUE))
```

After `group_by()`, it produces a summary for each group:

```r
patients |>
  group_by(hospital) |>
  summarise(average_wait = mean(wait_days, na.rm = TRUE))
```

After summarising, one row no longer represents an original record. It represents the group or overall summary defined by the code.

### `n()`

`n()` counts rows inside `summarise()`.

```r
complaints |>
  group_by(category) |>
  summarise(number_of_complaints = n())
```

The count describes rows, not necessarily unique people, companies, songs, or events. Its meaning depends on what one row represents.

### `sum()`

`sum()` adds numeric values.

```r
summarise(total = sum(amount, na.rm = TRUE))
```

### `mean()`

`mean()` calculates an arithmetic average.

```r
summarise(average = mean(value, na.rm = TRUE))
```

### `na.rm = TRUE`

The argument `na.rm = TRUE` tells functions such as `sum()` and `mean()` to remove missing values from the calculation.

Without it, a calculation containing a missing value may return `NA`.

Removing missing values from a calculation does not solve the underlying data-quality issue. You should still understand why values are missing and how excluding them affects the result.

### Ranking individual records

To find the largest individual records:

```r
contracts |>
  arrange(desc(value)) |>
  slice_head(n = 5)
```

### Ranking grouped totals

To rank categories by a combined value:

```r
spending |>
  group_by(department) |>
  summarise(total = sum(amount, na.rm = TRUE)) |>
  arrange(desc(total))
```

The grouping and summary must happen before ranking the grouped totals.

## 6. Analysis workflow and interpretation

### Order of operations

A common analysis order is:

```text
data
  → filter relevant rows
  → group rows when comparison is needed
  → summarise each group
  → arrange the results
  → inspect the leading rows
```

Changing this order can change the meaning of the analysis or remove columns before they are needed.

### Unit of analysis

The unit of analysis is what one row represents. Examples could include one payment, one complaint, one visit, or one inspection.

Before interpreting a count, total, or average, know:

- What one original row represents
- Whether the same person or entity can appear more than once
- What one row represents after grouping and summarising
- Whether the calculation measures records, unique entities, or something else

### Individual records versus grouped results

- Arranging raw data ranks individual rows.
- Grouping and summarising create category-level results.
- Arranging after summarising ranks those grouped results.

Be able to explain the meaning of one row at every stage of a pipeline.

## Core function checklist

| Function or operator | Main purpose |
|---|---|
| `install.packages()` | Install a package on the computer |
| `library()` | Load a package for the current session |
| `<-` | Assign and save a value or result |
| `|>` | Pass a result to the next function |
| `$` | Access one column |
| `==` | Test equality |
| `&` | Require both conditions |
| `|` | Allow either condition |
| `c()` | Create a vector |
| `tibble()` | Create a tibble |
| `read_csv()` | Import a CSV file as a tibble |
| `glimpse()` | Inspect structure, columns, types, and sample values |
| `slice_head()` | Return rows from the beginning of the current order |
| `rename()` | Rename columns |
| `as.Date()` | Convert suitable values to Date type |
| `mdy()` | Parse dates in month-day-year order |
| `is.na()` | Identify missing values |
| `colSums()` | Add values down each column; with `is.na()`, count missing values |
| `distinct()` | Return unique values or combinations |
| `filter()` | Keep rows that satisfy conditions |
| `arrange()` | Sort rows |
| `desc()` | Request descending order inside `arrange()` |
| `group_by()` | Define groups for later calculations |
| `summarise()` | Calculate overall or grouped summaries |
| `n()` | Count rows inside `summarise()` |
| `sum()` | Calculate a total |
| `mean()` | Calculate an average |

## Final preparation checklist

Before the midterm, confirm that you can:

- Explain the difference between R and RStudio.
- Explain why projects and relative paths improve reproducibility.
- Distinguish installing a package from loading it.
- Explain why code that works in the Console may fail when knitting.
- Read a short pipeline from top to bottom.
- Recognize common column types.
- Import a local CSV file with `read_csv()`.
- Diagnose a basic file-path error.
- Inspect columns, types, rows, dates, and missing values.
- Distinguish repeated identifiers from exact duplicate records.
- Filter with one condition, both conditions, or either condition.
- Calculate an overall summary and a grouped summary.
- Rank individual rows and grouped totals correctly.
- Explain what one row represents before and after `summarise()`.
- Interpret counts carefully when an entity can appear more than once.
