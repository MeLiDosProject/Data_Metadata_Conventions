table_sleepdiary <- function(data){
  data |> 
    tbl_summary(include = -c(comments, record_id),
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)",
                                 c(bedtime, sleep, sleepprep)  ~ "{time_median} ({nighttime_p25}, {nighttime_p75})",
                                 c(wake, out_ofbed)  ~ "{time_median} ({daytime_p25}, {daytime_p75})"
                ),
                type = c(awakenings, awake_duration) ~ "continuous",
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
                type = c(sjl, outdoor, sd_w, sd_f, msw, msf, so_w, so_f, meq, sd_week) ~ "continuous",
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Chronotype**")  }

table_exercisediary <- function(data){
  data |> 
    tbl_summary(include = -c(record_id, type, type_english, startdate_3, enddate_3, Date, instructions),
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)"
                ),
                type = list(
                  c(commute, sedentary) ~ "continuous",
                  c(light_glasses) ~ "dichotomous"
                ),
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Evening exercise diary**")  }

table_wearlog <- function(data){
  data |> 
    tbl_summary(include = -c(start, end, record_id, wearlog_event, wearlog_place, wearlog_place_english, radius), 
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)"
                ),
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Wearlog**")
}

table_leba <- function(data){
  data |> 
    mutate(across(c(any_of(relevant_columns), -record_id), as.numeric)) |> 
    add_col_labels(codebook, var_col = `Variable / Field Name`, label_col = `Field Label`) |> 
    tbl_summary(include = -record_id, 
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)"
                ),
                type = everything() ~ "continuous",
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Light exposure behaviour (LEBA)**") |> 
    as_gt() |> 
    gt::tab_footnote("Items are coded as follows. 1: Never | 2: Rarely | 3: Sometimes | 4: Often | 5: Always. Factors ('F') are numerical summations")
}


table_health <- function(data){
  data |> 
    tbl_summary(include = -c(record_id, medication_type),
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)"
                ),
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Lifestyle and health**")
}

table_currentconditions <- function(data){
  data |> 
    tbl_summary(include = -c(record_id, Datetime, enddate_4),
                statistic = list(all_continuous() ~ "{median} ({p25}, {p75})", 
                                 all_categorical() ~ "{n} ({p}%)"
                ),
                missing_text = "missing") |> 
    add_n() |> 
    bold_labels() |> 
    modify_header(label = "**Lifestyle and health**")
}
