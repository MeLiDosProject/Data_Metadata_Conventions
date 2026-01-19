coltype_checker <- function(codebook, data) {
  require(dplyr)
  require(stringr)
  require(tibble)
  
  # --- expected columns by rule ---
  should_POSIXct <-
    codebook |>
    filter(`Text Validation Type OR Show Slider Number` == "datetime_dmy") |>
    pull(`Variable / Field Name`) |>
    unique()
  
  should_logical <-
    codebook |>
    filter(
        `Field Type` %in% c("yesno")
    ) |>
    pull(`Variable / Field Name`) |>
    unique()
  
  should_numeric <- 
    codebook |>
    filter(
      `Text Validation Type OR Show Slider Number` %in% c("number", "integer") |
        `Field Type` %in% c("radio", "dropdown")
    ) |>
    pull(`Variable / Field Name`) |>
    unique()
  
  should_date <-
    codebook |>
    filter(str_detect(`Field Label`, "Date")) |>
    pull(`Variable / Field Name`) |>
    unique() |>
    setdiff(c("startdate", "enddate"))
  
  should_time <-
    codebook |>
    filter(
    `Text Validation Type OR Show Slider Number` %in% c("time")) |> 
    pull(`Variable / Field Name`) |>
    unique()
  
  should_character <-
    setdiff(
      unique(codebook |> pull(`Variable / Field Name`)),
      c(should_numeric, should_POSIXct, should_logical, 
        should_date, should_time, "startdate", "enddate")
    )
  
  expected_map <- tibble::tribble(
    ~col, ~expected,
    !!!c(rbind(should_POSIXct,  rep("POSIXct",    length(should_POSIXct))),
         rbind(should_numeric,  rep("numeric",    length(should_numeric))),
         rbind(should_logical,  rep("logical",    length(should_logical))),
         rbind(should_date,     rep("Date",       length(should_date))),
         rbind(should_time,     rep("time",       length(should_time))),
         rbind(should_character,rep("character",  length(should_character))))
  ) |>
    # The rbind trick can create a matrix; coerce cleanly:
    as.data.frame(stringsAsFactors = FALSE) |>
    tibble::as_tibble() |>
    transmute(col = .data$col, expected = .data$expected) |>
    distinct()
  
  # If nothing expected, return a trivial summary
  if (nrow(expected_map) == 0) {
    return(list(
      ok = TRUE,
      summary = list(
        missing = character(0),
        wrong_type = tibble::tibble(),
        ok = character(0)
      ),
      details = tibble::tibble()
    ))
  }
  
  # --- helpers ---
  actual_class <- function(x) {
    # Return the first class; keep simple and stable for reporting
    class(x)[1]
  }
  
  is_expected_type <- function(x, expected) {
    switch(
      expected,
      "POSIXct"   = inherits(x, "POSIXct"),
      "numeric"   = is.numeric(x),
      "logical"   = is.logical(x),
      "Date"      = inherits(x, "Date"),
      "time"      = inherits(x, "hms"),
      "character" = is.character(x),
      FALSE
    )
  }
  
  data_names <- names(data)
  
  # --- build per-column diagnostics ---
  details <- expected_map |>
    mutate(
      present = .data$col %in% data_names,
      actual = dplyr::if_else(
        present,
        vapply(.data$col, \(nm) actual_class(data[[nm]]), character(1)),
        NA_character_
      ),
      type_ok = dplyr::if_else(
        present,
        mapply(\(nm, exp) is_expected_type(data[[nm]], exp),
               .data$col, .data$expected),
        FALSE
      ),
      issue = dplyr::case_when(
        !present ~ "missing",
        present & !type_ok ~ "wrong_type",
        TRUE ~ "ok"
      ),
      expected_example = dplyr::case_when(
        expected == "POSIXct"   ~ "as.POSIXct(..., tz = 'UTC')",
        expected == "numeric"   ~ "as.numeric(...)",
        expected == "logical"   ~ "as.logical(...)",
        expected == "Date"      ~ "as.Date(...)",
        expected == "time"      ~ "as.hms(...)",
        expected == "character" ~ "as.character(...)",
        TRUE ~ NA_character_
      )
    )
  
  missing <- details |> filter(issue == "missing") |> pull(col)
  ok_cols <- details |> filter(issue == "ok") |> pull(col)
  
  wrong_type <- details |>
    filter(issue == "wrong_type") |>
    transmute(
      col,
      expected_type = expected,
      actual_type = actual,
      suggested_coercion = expected_example
    )
  
  # --- grouped missing for convenience ---
  missing_by_expected <- details |>
    filter(issue == "missing") |>
    group_by(expected) |>
    summarise(cols = list(col), .groups = "drop")
  
  out <- list(
    ok = length(missing) == 0 && nrow(wrong_type) == 0,
    summary = list(
      missing = missing,
      missing_by_expected = missing_by_expected,
      wrong_type = wrong_type,
      ok = ok_cols
    ),
    details = details
  )
  
  class(out) <- c("coltype_check", class(out))
  out
}