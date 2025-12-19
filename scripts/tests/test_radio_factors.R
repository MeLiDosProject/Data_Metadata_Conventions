library(tibble)

source("scripts/radio_factors.R")

data <- tibble(
  q1 = c("1", "2", NA_character_),
  q2 = c(1, 2, 3),
  q3 = c("1", "2", "3")
)

lookup <- tibble(
  var = c("q1", "q2", "missing"),
  type = c("radio", "radio", "radio"),
  levels = c(
    "1, Yes | 2, No",
    "1, Low | 2, Medium | 3, High",
    "1, A | 2, B"
  )
)

result <- add_radio_factors(
  data,
  lookup,
  var_col = var,
  type_col = type,
  levels_col = levels,
  warn = FALSE
)

stopifnot(is.factor(result$q1))
stopifnot(is.factor(result$q2))
stopifnot(!is.factor(result$q3))
stopifnot(identical(levels(result$q1), c("Yes", "No")))
stopifnot(identical(levels(result$q2), c("Low", "Medium", "High")))
stopifnot(identical(as.character(result$q1), c("Yes", "No", NA)))
