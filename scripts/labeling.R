library(dplyr)
library(tibble)
library(rlang)

add_col_labels <- function(data, lookup, var_col = var, label_col = label, warn = TRUE) {
  var_col   <- enquo(var_col)
  label_col <- enquo(label_col)
  
  # Named vector: names = variable names, values = labels
  labs <- lookup %>%
    transmute(.var = as.character(!!var_col),
              .lab = as.character(!!label_col)) %>%
    filter(!is.na(.var), .var != "") %>%
    distinct(.var, .keep_all = TRUE) %>%
    deframe()
  
  vars_in_data <- intersect(names(labs), names(data))
  missing      <- setdiff(names(labs), names(data))
  
  if (warn && length(missing) > 0) {
    warning("Labels provided for variables not in `data`: ",
            paste(missing, collapse = ", "))
  }
  
  data %>%
    mutate(across(all_of(vars_in_data), ~{
      attr(.x, "label") <- labs[[cur_column()]]
      .x
    }))
}