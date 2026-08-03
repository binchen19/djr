library(tidyverse)

transcript_lines <- read_lines("data/debate.txt") |>
  discard(~ str_trim(.x) == "")

parse_transcript <- function(lines) {
  speaker_pattern <- "^[A-Z][A-Z ]+:"
  turns <- list()
  current_speaker <- NA_character_
  current_text <- character()

  save_turn <- function(speaker, text_parts) {
    tibble(
      speaker = speaker,
      text = str_squish(str_c(text_parts, collapse = " "))
    )
  }

  for (line in lines) {
    if (str_detect(line, speaker_pattern)) {
      if (!is.na(current_speaker)) {
        turns[[length(turns) + 1]] <- save_turn(current_speaker, current_text)
      }

      pieces <- str_split_fixed(line, ":", 2)
      current_speaker <- str_trim(pieces[, 1])
      current_text <- str_trim(pieces[, 2])
    } else {
      current_text <- c(current_text, str_trim(line))
    }
  }

  if (!is.na(current_speaker)) {
    turns[[length(turns) + 1]] <- save_turn(current_speaker, current_text)
  }

  bind_rows(turns)
}

turns <- parse_transcript(transcript_lines)

write_csv(turns, "data/debate_turns.csv")
