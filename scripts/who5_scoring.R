who5_scoring <- function(data){
  data2 <- 
    data |> 
    mutate(
      across(
        c(who5_1998_1, who5_1998_2, who5_1998_3, who5_1998_5),
        \(x) 6 - as.numeric(x)
      ),
      who5_1998_4 = who5_1998_4 |> as.numeric()
    ) |> 
    rowwise() |> 
    mutate(who5_raw = sum(c_across(contains("who5_"))),
           who5_percentage = who5_raw*4) |> 
    ungroup() |> 
    select(who5_raw, who5_percentage)
  data |> 
    bind_cols(data2) |> 
    add_labels(c(who5_raw = "WHO-5 raw score (calculated, 0-25)",
                 who5_percentage = "WHO-5 percentage score (calculated, 0-100)"))
}
