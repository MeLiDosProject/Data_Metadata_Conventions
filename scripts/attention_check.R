attention_check <- 
  function(data, check.column, condition, label = "Attention check successful") {
    data <-
      data |> 
      mutate({{ check.column }} := 
               ({{ check.column }} %in% condition) |> 
               add_label(label)
      ) |> 
      relocate({{ check.column }}, .after = last_col())
  }
