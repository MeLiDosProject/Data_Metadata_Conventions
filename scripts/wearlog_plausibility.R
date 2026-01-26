wearlog_plausibility <- function(data) {
  data |> 
    arrange(record_id, Datetime) |> 
    mutate(.after = event, 
           .by = record_id,
           is.plausible = 
             case_when(
               event == "off" & lead(event) == "on" & lead(Datetime) < (Datetime + dhours(16)) ~ TRUE,
               event == "off" & lead(event) == "sleep" & lead(Datetime) < (Datetime + dhours(4)) ~ TRUE,
               event == "sleep" & lead(event) == "on" & lead(Datetime) < (Datetime + ddays(1)) ~ TRUE,
               event == "sleep" & lead(event) == "off" & lead(Datetime) < (Datetime + dhours(12)) ~ TRUE,
               event == "on" & lag(event) %in% c("off", "sleep") & lag(Datetime) < (Datetime + ddays(1)) ~ TRUE,
               event == "site_leave" & lead(event) == "site_return" ~ TRUE,
               event == "site_return" & lag(event) == "site_leave" ~ TRUE,
               # .default = FALSE
             )
    )
}