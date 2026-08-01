#!/usr/bin/env Rscript

# One-command annual update for the NBIM equity-holdings teaching data.
#
# Normal use, after NBIM has published the previous year's report:
#   Rscript scripts/update_gpfg.R
#
# Rebuild through a specific year:
#   Rscript scripts/update_gpfg.R --through=2026
#
# Re-download files that already exist:
#   Rscript scripts/update_gpfg.R --through=2026 --overwrite

args <- commandArgs(trailingOnly = TRUE)

get_option <- function(name, default = NULL) {
  equals_prefix <- paste0(name, "=")
  equals_match <- args[startsWith(args, equals_prefix)]

  if (length(equals_match) > 1) {
    stop("Option supplied more than once: ", name)
  }

  if (length(equals_match) == 1) {
    return(substring(equals_match, nchar(equals_prefix) + 1))
  }

  position <- match(name, args, nomatch = 0)
  if (position > 0) {
    if (position == length(args)) {
      stop("Missing value after ", name)
    }
    return(args[[position + 1]])
  }

  default
}

script_argument <- commandArgs(trailingOnly = FALSE)
script_file <- sub("^--file=", "", script_argument[startsWith(script_argument, "--file=")][1])

if (is.na(script_file) || !nzchar(script_file)) {
  stop("Could not determine the updater's location.")
}

project_root <- normalizePath(
  file.path(dirname(normalizePath(script_file)), ".."),
  mustWork = TRUE
)
setwd(project_root)

completed_year <- as.integer(format(Sys.Date(), "%Y")) - 1L
through_year <- as.integer(get_option("--through", as.character(completed_year)))

if (is.na(through_year) || through_year < 1998L) {
  stop("--through must be a four-digit year of 1998 or later.")
}

rscript <- file.path(R.home("bin"), "Rscript")

run_r_script <- function(path, script_args = character()) {
  message("\nRunning ", path, " …")
  status <- system2(rscript, c(path, script_args))

  if (!identical(status, 0L)) {
    stop(path, " failed with exit status ", status, ".")
  }
}

download_args <- paste0("--through=", through_year)
if ("--overwrite" %in% args) {
  download_args <- c(download_args, "--overwrite")
}

run_r_script("scripts/download_gpfg.R", download_args)
run_r_script("scripts/prepare_gpfg.R")

checks <- read.csv(
  "data/processed/gpfg_validation_checks.csv",
  stringsAsFactors = FALSE
)

if (!all(checks$passed)) {
  failed <- checks$check[!checks$passed]
  stop(
    "The data were rebuilt, but validation failed: ",
    paste(failed, collapse = "; "),
    ". Review the source files before rendering or publishing the textbook."
  )
}

manifest <- read.csv(
  "data/processed/gpfg_source_manifest.csv",
  stringsAsFactors = FALSE
)

latest_year <- max(manifest$year)

message(
  "\nGPFG update complete through ", latest_year, ". All ",
  nrow(checks), " validation checks passed.\n",
  "Next: review reports/gpfg-data-audit.md, then run `quarto render`."
)
