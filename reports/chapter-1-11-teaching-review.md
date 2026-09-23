# Teaching Review: Chapters 1–11

This review evaluates the revised sequence as a beginner-friendly but rigorous
undergraduate data journalism course. It focuses on what happens when an
instructor actually demonstrates the material and students follow in their own
R Markdown documents.

## Overall assessment

The sequence now has a coherent spine:

1. set up one RStudio Project;
2. create small vectors and turn those same vectors into a tibble;
3. import a deliberately imperfect external CSV;
4. clean that same table and save a new analysis-ready file;
5. use the clean 2025 snapshot for description, ranking, comparison, and
   relationship questions;
6. import and combine five annual files, inspect the resulting data, and ask
   trend questions;
7. turn checked tables into basic charts one layer at a time;
8. add visual complexity when a question requires more groups or variables;
9. reshape a wide table and join variables from a second source;
10. apply the same join logic to geographic boundaries and build a map; and
11. transfer the workflow to Billboard data with a genuinely new unit-of-
    analysis problem.

The strongest improvement is continuity. Objects and ideas now return for a
reason: the vectors become tibble columns, the imported raw table becomes the
clean table, the clean table supports analysis, the country summary becomes a
chart and then a map, and the multi-year table supports both trend calculations
and line charts. The longer 1998–2025 archive remains available without
overloading the first multi-year lesson.

The sequence now uses a question-driven, function-explicit balance. A
reporting need comes first, but a core function is not allowed to appear as a
black box: its purpose and simplest useful syntax are explained immediately
before first use, and the resulting row meaning is checked afterward. Later
chapters give shorter reminders instead of reteaching the same verb.

The main remaining risk is pace, not sequence. Chapters 1 and 8 contain more
material than most beginners can absorb in one uninterrupted live demo. The
class notes identify a shorter route; the fuller chapters should remain
available for reading, review, and optional extensions.

## Chapter 1: R and RStudio

### Strengths

- Clearly distinguishes R, RStudio, R Projects, packages, Markdown, and R
  Markdown before asking students to use them.
- Explains installation versus loading with a memorable shelf analogy.
- Establishes one `djr` project with `data` and `outputs` folders for the rest
  of the course.
- Treats R Markdown as the beginner workspace so code, output, and notes remain
  visible together.

### Revisions made

- Corrected the book numbering so this is Chapter 1 rather than Chapter 2.
- Standardized the first notebook name as `01-setup.Rmd`.
- Explicitly explains why `rmarkdown` is installed in addition to the
  tidyverse.

### Teaching caution

Package installation is slow and sometimes fails for reasons unrelated to the
lesson. Ask students to install R, RStudio, tidyverse, and rmarkdown before
class when possible. In class, the essential achievement is creating and
knitting one project-based R Markdown document; the pane tour and additional
links can be assigned as review.

## Chapter 2: R Basics

### Strengths

- Uses familiar, small values before introducing the main dataset.
- Creates `student_names`, `student_ages`, and `student_present`, then reuses
  those exact vectors in `tibble()`.
- Introduces data types only after students can see `<chr>`, `<dbl>`, and
  `<lgl>` in a printed tibble.
- Reuses `student_ages` for arithmetic, summary functions, and the pipe.

### Revisions made

- Replaced disconnected objects with one cumulative example.
- Moved the tibble before formal type terminology.
- Added tidy-data row/column/cell rules immediately after the tibble.
- Clarified `<-`, `->`, `=`, `==`, `|>`, and `%>%` without using all styles in
  later chapters.

### Teaching caution

Show `%>%` only for recognition; do not make students practice two pipe styles.
The live exercise should end by building a second tibble from three student-
created vectors. That checks whether they understand alignment by position and
equal vector length.

## Chapter 3: Data Import

### Strengths

- Moves naturally from a hand-built tibble to an external CSV.
- Defines tidyverse, readr, `read_csv()`, a file path, and a relative path
  before use.
- Uses one essential argument in `read_csv()` and explains why loading the
  tidyverse also makes readr available.
- Reads the `glimpse()` output line by line and turns observations into a
  cleaning checklist.

### Revisions made

- Replaced the already-clean file with `gpfg_messy.csv`.
- Removed Excel and other side routes from the core lesson.
- Removed `show_col_types = FALSE` and the abstract `problems()` detour.
- Keeps URL and package imports as brief context while explaining why a local
  source copy is better for reproducible reporting.

### Teaching caution

Do not read every value printed by `glimpse()`. Ask students to identify only
four things: size, names, types, and examples. End the class with a written
cleaning plan rather than beginning transformations immediately.

## Chapter 4: Data Cleaning

### Strengths

- Continues with the exact `gpfg_raw` object imported in Chapter 3.
- The simplified teaching file contains visible problems with four column
  names, one consistently formatted text date, one incomplete row, and one
  exact repeated row. Amounts, percentages, and categories already import
  correctly.
- Each transformation follows an observation and is followed by inspection.
- Preserves the imported file and writes a separate `gpfg_2025.csv` for later
  work.

### Revisions made

- Reduced the workflow to `rename()`, `mutate()` with `dmy()`, missing-value
  checks, duplicate checks, `distinct()`, and `write_csv()`.
- Removed formatted-number parsing, mixed-date parsing, and text-category
  standardization from the beginner lesson.
- Kept a short ambiguity warning so students confirm whether a source uses
  day-month-year, month-day-year, or year-month-day order.

### Teaching caution

The shortened `rename()` block changes only four columns. Ask students why the
remaining names do not need intervention; cleaning should respond to observed
problems rather than change everything automatically.

Do not treat a missing value or repeated identifier as an automatic error. The
incomplete row and exact duplicate are removable here only after inspecting
the complete rows and recalling what one row should represent.

## Chapter 5: Analysis I

### Strengths

- Continues directly from Chapter 4 with the clean `gpfg_2025.csv` object.
- Shows that one annual snapshot can already answer description, ranking,
  comparison, and relationship questions.
- Gives students the question types before introducing the functions used to
  answer them.
- Introduces `summarise()`, `arrange()`, and grouped summaries in a concrete
  reporting workflow.

### Revisions made

- Separated single-year analysis from the work of importing multiple files.
- Added a deliberate ending: a single snapshot cannot answer a trend question.
- Made that limitation the reason to continue to Analysis II.
- Added just-in-time syntax explanations for `distinct()`, `arrange()`,
  `summarise()`, `select()`, `group_by()`, `n()`, and `mutate()`.

### Teaching caution

Keep asking whether a result describes rows, companies, markets, or money. A
ranking of individual holdings and a ranking of grouped market totals are not
interchangeable.

## Chapter 6: Analysis II

### Strengths

- Begins with genuine import practice: five annual files are read separately,
  compared, and stacked with `bind_rows()`.
- Makes “know the dataset” a required stage before trend analysis: students
  check row meaning, year coverage, missingness, and category values.
- Answers the trend question that Chapter 5 explicitly could not answer.
- Retains the full 1998–2025 archive as an optional resource rather than making
  28 years the beginner default.

### Revisions made

- Moved the multi-year workflow out of the first analysis lesson.
- Uses `gpfg_2021.csv` through `gpfg_2025.csv` and saves
  `gpfg_5_years.csv` for later chapters.
- Separates the overall annual trend from a comparison of selected countries.

### Teaching caution

Importing five files is intentionally repetitive so students see the purpose
of `bind_rows()`. Do not expand the live demonstration to all available years.
Stress that repeated annual snapshots do not automatically prove why a value
changed.

## Chapter 7: Visualization I

### Strengths

- Organizes visualizations around reporting questions rather than the abstract
  exploratory/explanatory distinction.
- Uses one repeated sequence: question, needed columns, prepared table,
  aesthetic roles, basic plot, inspection, labels, and restrained styling.
- Begins with a trend already calculated in Chapter 6.
- Separates data mappings inside `aes()` from fixed appearance choices outside
  it.

### Revisions made

- Replaced finished plots shown all at once with visible intermediate stages.
- Develops a line chart, ordered bar chart, histogram, and scatterplot from a
  minimal first version.
- Uses the five-year file, while filtering 2025 for single-year questions.

### Teaching caution

The core lecture can stop after the line and bar charts. Have students say what
x and y mean before they type `ggplot()` and explain the purpose of every new
layer.

## Chapter 8: Visualization II

### Strengths

- Adds complexity only when a reporting question requires multiple groups,
  composition, distributions, or crowded relationships.
- Builds multi-line, grouped, stacked, percentage-stacked, box, and faceted
  charts from familiar basic forms.
- Explains why color, fill, position, log scales, and facets are being added
  instead of presenting them as decoration.

### Revisions made

- Reorganized the material by question type and visual need.
- Shows the default stacked bar before changing only `position` to create a
  grouped or percentage comparison.
- Keeps interactive graphics optional rather than adding another package to
  the core workflow.

### Teaching caution

Do not live-code every chart. A strong route is multi-country trends, grouped
versus stacked bars, and one choice between box plots and facets.

## Chapter 9: Join and Reshape

### Strengths

- Begins with an authentic need: annual values are stored in separate columns
  and region is stored in another file.
- Prioritizes the common wide-to-long direction needed for tidyverse analysis.
- Checks duplicate and unmatched keys before `left_join()`.
- Connects structural changes to row meaning and a regional trend question.

### Revisions made

- Keeps `bind_rows()` in Chapter 6, where students first need it.
- Uses `gpfg_country_wide.csv` for `pivot_longer()` and
  `gpfg_country_lookup.csv` for a necessary join.
- Keeps `pivot_wider()` as a short reporting-output example.

### Teaching caution

Ask students to draw the before-and-after table shapes. The key ideas are which
columns become rows, what the join key is, and whether the join changed the
number of observations.

## Chapter 10: Mapping

### Strengths

- Keeps mapping separate because geographic boundaries introduce a genuinely
  new data structure.
- Reuses the country summary and Chapter 9 join workflow, then adds name
  reconciliation and geographic coordinates.
- Uses a prepared tidyverse-friendly boundary CSV rather than introducing an
  additional spatial package.
- Explains what gray areas and the investment-market field do—and do not—mean.

### Revisions made

- Builds the map in stages: question and columns, summary, name check, join,
  basic polygons, corrected coordinates, color scale, and final labels.
- Uses a restrained sequential palette with gray for unmatched values.

### Teaching caution

Inspect unmatched names before drawing the map so students see that joining is
the central reporting task. Explain why values repeat across boundary rows and
must not be summed after the join.

## Chapter 11: Billboard Hot 100

### Strengths

- Opens with a new challenge: a weekly appearance is not a distinct song, and
  a title alone is not a reliable identifier.
- Makes students define “success” before ranking.
- Compares distinct songs, weekly number-one appearances, distinct number-one
  songs, and song-level weeks.
- Demonstrates how defensible metrics can produce different rankings and
  headlines.

### Revisions made

- Places artist and song together throughout entity counting.
- Adds explicit period and chart-threshold decisions.
- Treats the source's `-` marker as missing during import.
- Treats variations in artist credits as a reporting limitation rather than
  silently merging them.

### Teaching caution

Before running code, ask which metric rewards one long-running hit and which
rewards a larger catalogue. The conceptual decision should lead the code.

## Recommended lecture use

The textbook and class notes now have different jobs:

- **Textbook chapters:** definitions, explanations, optional variants,
  reporting cautions, and independent-study links.
- **Class-note R Markdown files:** the shortest coherent live-demo route,
  checkpoints, code to rerun, and exit activities.

For live teaching, pause after every pipeline and ask two questions: “What does
one row represent now?” and “Which part of the reporting question did this step
answer?” Those recurring prompts will make the sections feel like one method
rather than a catalogue of functions.
