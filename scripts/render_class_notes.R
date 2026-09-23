# Render the eleven instructor R Markdown class notes to a local-only folder.

notes <- list.files(
  "class-notes",
  pattern = "^[0-9]{2}-.*[.]Rmd$",
  full.names = TRUE
)

rendered_dir <- file.path(getwd(), "class-notes", "rendered")
dir.create(rendered_dir, recursive = TRUE, showWarnings = FALSE)

if (length(notes) != 11) {
  stop("Expected 11 class-note R Markdown files, but found ", length(notes), ".")
}

for (note in notes) {
  rmarkdown::render(
    input = note,
    output_dir = rendered_dir,
    knit_root_dir = getwd(),
    envir = new.env(parent = globalenv())
  )
}
