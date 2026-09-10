# Teaching Review: Chapters 1–10

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
5. import and combine five annual files, inspect the resulting data, and ask
   description, ranking, comparison, and trend questions;
6. turn checked tables into basic charts one layer at a time;
7. add visual complexity when a question requires more groups or variables;
8. reshape a wide table and join variables from a second source;
9. apply the same join logic to geographic boundaries and build a map; and
10. transfer the workflow to Billboard data with a genuinely new unit-of-
    analysis problem.

The strongest improvement is continuity. Objects and ideas now return for a
reason: the vectors become tibble columns, the imported raw table becomes the
clean table, the clean table supports analysis, the country summary becomes a
chart and then a map, and the multi-year table supports both trend calculations
and line charts. The longer 1998–2025 archive remains available without
overloading the first multi-year lesson.

The main remaining risk is pace, not sequence. Chapters 1 and 7 contain more
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

## Chapter 5: Data Analysis

### Strengths

- Begins with genuine import practice: five annual files are read separately,
  checked, and stacked with `bind_rows()`.
- Makes “know the dataset” a required stage before analysis: students check
  row meaning, year coverage, category values, frequencies, and missingness.
- Gives a big-picture overview of description, ranking, comparison,
  relationship, and trend questions.
- Starts with a five-year trend so time is part of the reporting workflow from
  the beginning rather than an isolated later topic.
- Introduces `group_by()` and `summarise()` only after students understand the
  combined table and carefully distinguishes a result, finding, and possible
  explanation.

### Revisions made

- Replaced a single-year opening with `gpfg_2021.csv` through
  `gpfg_2025.csv` and saves the result as `gpfg_5_years.csv`.
- Moved `bind_rows()` here because students experience the need while
  importing repeated annual data.
- Added checks before questions and made trend, description, ranking, and
  comparison build on the same combined object.
- Retained the full `gpfg_history.csv.gz` archive as an optional source rather
  than making 28 years the beginner default.

### Teaching caution

Importing five files is intentionally repetitive so students see what
`bind_rows()` solves. Do not expand the live demonstration to all 28 years.
Large currency totals are also hard to interpret in the console: calculate in
original units first, then translate the checked result into billions or
trillions. Keep asking what one row represents after every summary.

## Chapter 6: Basic Visualization

### Strengths

- Organizes visualizations around reporting questions rather than the abstract
  exploratory/explanatory distinction.
- Uses one repeated sequence: question, needed columns, prepared table,
  aesthetic roles, basic plot, inspection, labels, and restrained styling.
- Begins with a time trend already calculated in Chapter 5, so the first chart
  has an immediate journalistic purpose.
- Separates data mappings inside `aes()` from fixed appearance choices outside
  it.

### Revisions made

- Replaced finished plots shown all at once with visible intermediate stages.
- Develops a line chart, ordered bar chart, histogram, and scatterplot from a
  minimal first version.
- Uses `gpfg_5_years.csv` throughout, with a filtered 2025 object for
  single-year questions.
- Added explicit checks of the plotting table before every chart.

### Teaching caution

The core lecture can stop after the line and bar charts. The histogram and
scatterplot reinforce the workflow but need not be rushed into the same class.
Have students say what x and y mean before they type `ggplot()`.

## Chapter 7: Advanced Visualization

### Strengths

- Adds complexity only when a reporting question requires multiple groups,
  composition, distributions, or crowded relationships.
- Builds multi-line, grouped, stacked, percentage-stacked, box, and faceted
  charts from familiar basic forms.
- Continues to prepare and inspect a table before plotting it.
- Explains why color, fill, position, log scales, and facets are being added
  instead of presenting them as decoration.

### Revisions made

- Reorganized the material by question type and visual need rather than by the
  number of variables alone.
- Starts each section with a plain-language question and column plan.
- Shows the default stacked bar before changing only `position` to create a
  grouped or percentage comparison.
- Keeps interactive graphics as an optional direction rather than adding a new
  package to the core workflow.

### Teaching caution

This is the densest visualization chapter. Do not live-code every chart. A
strong lecture route is multi-country trends, grouped versus stacked bars, and
one choice between box plots and facets. Assign the remaining variants for
guided practice.

## Chapter 8: Join and Reshape

### Strengths

- Begins with an authentic need: annual values are stored in separate columns
  and region is stored in another file.
- Prioritizes the common wide-to-long direction needed for tidyverse analysis.
- Checks duplicate and unmatched keys before `left_join()`.
- Connects structural changes to row meaning and to a specific regional trend
  question.

### Revisions made

- Moved combining annual rows to Chapter 5, where students encounter the need.
- Removed the artificial split-and-recombine exercise and the duplicate trend
  analysis.
- Uses `gpfg_country_wide.csv` for `pivot_longer()` and
  `gpfg_country_lookup.csv` for a necessary join.
- Keeps `pivot_wider()` as a short reporting-output example rather than giving
  both pivot directions equal emphasis.

### Teaching caution

Ask students to draw the before-and-after table shapes on paper. The important
ideas are which columns become rows, what the key is, and whether the join
changed the number of observations—not memorizing every join type.

## Chapter 9: Mapping

### Strengths

- Keeps mapping separate because geographic boundaries introduce a genuinely
  new data structure.
- Reuses the familiar country summary and the Chapter 8 join workflow, then
  adds name reconciliation and geographic coordinates.
- Uses a prepared tidyverse-friendly boundary CSV rather than introducing an
  additional spatial package in a beginner chapter.
- Explains what gray areas and the investment-market field do—and do not—mean.

### Revisions made

- Rebuilt the map in stages: question and columns, summary, name check, join,
  basic polygons, corrected coordinates, color scale, and final labels.
- Updated the practice task to use another year from the same five-year file.
- Uses a restrained blue-green sequential palette with an explicitly defined
  gray for unmatched values.

### Teaching caution

Begin by asking whether geography matters to the question; a ranked bar chart
is better for precise comparisons. Inspect the unmatched table before drawing
anything so students see that joining—not `geom_polygon()`—is the central
reporting task. Also explain why values repeat across boundary-coordinate rows
and must not be summed after the join.

## Chapter 10: Billboard Hot 100

### Strengths

- Opens with a clearly different challenge: a weekly appearance is not a
  distinct song, and a title alone is not a reliable identifier.
- Makes students define “success” before ranking.
- Compares distinct Hot 100 songs, weekly number-one appearances, distinct
  number-one songs, and song-level weeks.
- Demonstrates how different defensible metrics produce different rankings and
therefore different headlines.

### Revisions made

- Places artist and song together throughout entity counting.
- Adds explicit period and chart-threshold decisions.
- Treats the source's `-` marker as a missing value during import so the weeks
  column arrives as numeric without a hidden parsing warning.
- Treats variations in artist credits as a reporting limitation rather than
  silently merging them.

### Teaching caution

Before running code, ask students to predict which metric rewards one
long-running hit and which rewards a larger catalogue. The conceptual decision
should lead the code. This case is successful precisely because it adds a new
problem rather than repeating the GPFG workflow with different labels.

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
