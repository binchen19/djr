#!/usr/bin/env Rscript

# Download official NBIM year-end equity holdings.
#
# By default, the script downloads every year from 1998 through the most
# recently completed calendar year. Existing files are preserved, so the
# normal annual run downloads only the newly available year.
#
# Examples:
#   Rscript scripts/download_gpfg.R
#   Rscript scripts/download_gpfg.R --through=2026
#   Rscript scripts/download_gpfg.R --through=2026 --overwrite

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

completed_year <- as.integer(format(Sys.Date(), "%Y")) - 1L
start_year <- as.integer(get_option("--start", "1998"))
through_year <- as.integer(get_option("--through", as.character(completed_year)))
overwrite <- "--overwrite" %in% args

if (is.na(start_year) || is.na(through_year)) {
  stop("--start and --through must be four-digit years.")
}

if (start_year < 1998L || through_year < start_year) {
  stop("Choose a year range beginning in 1998 or later.")
}

years <- seq.int(start_year, through_year)
formats <- c("xlsx", "csv")
raw_dir <- "data/raw/gpfg"

dir.create(raw_dir, recursive = TRUE, showWarnings = FALSE)

download_one <- function(year, format, overwrite = FALSE) {
  report_date <- paste0(year, "-12-31")
  destination <- file.path(
    raw_dir,
    paste0("gpfg-equities-", report_date, ".", format)
  )

  if (file.exists(destination) && !overwrite) {
    message("Keeping existing file: ", destination)
    return(invisible(destination))
  }

  url <- paste0(
    "https://www.nbim.no/api/investments/v2/report/",
    "?assetType=eq&date=", report_date,
    "&fileType=", format
  )

  message("Downloading ", report_date, " (", format, ") …")

  result <- tryCatch(
    suppressWarnings(download.file(
      url,
      destination,
      mode = "wb",
      quiet = TRUE
    )),
    error = identity
  )

  failed <- inherits(result, "error") ||
    !file.exists(destination) ||
    file.info(destination)$size < 1000

  if (failed) {
    if (file.exists(destination)) {
      unlink(destination)
    }

    detail <- if (inherits(result, "error")) {
      conditionMessage(result)
    } else {
      "the downloaded file was missing or unexpectedly small"
    }

    stop(
      "Could not download NBIM holdings for ", report_date, " (", format,
      "): ", detail, ". The year-end file may not have been published yet."
    )
  }

  invisible(destination)
}

for (year in years) {
  for (format in formats) {
    download_one(year, format, overwrite = overwrite)
  }
}

message(
  "Archive ready through ", through_year, ": ",
  length(years), " years × ", length(formats), " formats."
)
