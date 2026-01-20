table_sleepdiary <- function(data){
  data |> 
    tbl_summary(include = -c(comments, record_id),
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)",
                                 c(bedtime, sleep, sleepprep)  ~ "{time_median} ({nighttime_p25}, {nighttime_p75})",
                                 c(wake, out_ofbed)  ~ "{time_median} ({daytime_p25}, {daytime_p75})"
                ),
                type = awakenings ~ "continuous",
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Morning sleep diary**") |> 
    modify_footnote_header("Nighttime variables center on midnight, daytime variables on noon; median for time is based on circular time", columns = stat_0, replace = FALSE)
}

table_demographics <- function(data){
  data |> 
    tbl_summary(include = -c(comments, record_id),
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)"
                ), type = age ~ "continuous",
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Demographics**")
}

table_chronotype <- function(data){
  data |> 
    tbl_summary(include = -c(record_id),
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)",
                                 c(so_w, so_f, msw, msf, msf_sc)  ~ "{time_median} ({nighttime_p25}, {nighttime_p75})"
                ),
                type = c(sjl, outside, sd_w, sd_f, msw, msf) ~ "continuous",
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Chronotype**")  }