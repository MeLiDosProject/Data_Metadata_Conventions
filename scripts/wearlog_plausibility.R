# Here, we perform some basic plausibility checking for the wearlog:
#   
#   1. Sorting by `record_id` and `start`
# 
# 2. Set to plausible if:
#   
#   - site `leave` and `return` are consecutive events?
#   - wearlog `off` event is followed by `on` within 16 hours?
#   - wearlog `off` event is followed by `sleep` within 4 hours?
#   - wearlog `sleep` event is followed by `on` within 1 day?
#   - wearlog `sleep` event is followed by `off` within 1 day?
#   - wearlog `on` event is preceded by either `off` or `sleep` within 12 hours?

wearlog_plausibility <- function(data) {
  data |> 
    arrange(record_id, start) |> 
    mutate(.after = event, 
           .by = record_id,
           is.plausible = 
             case_when(
               event == "off" & lead(event) == "on" & lead(start) < (start + dhours(16)) ~ TRUE,
               event == "off" & lead(event) == "sleep" & lead(start) < (start + dhours(4)) ~ TRUE,
               event == "sleep" & lead(event) == "on" & lead(start) < (start + ddays(1)) ~ TRUE,
               event == "sleep" & lead(event) == "off" & lead(start) < (start + dhours(12)) ~ TRUE,
               event == "on" & lag(event) %in% c("off", "sleep") & lag(start) < (start + ddays(1)) ~ TRUE,
               event == "site_leave" & lead(event) == "site_return" ~ TRUE,
               event == "site_return" & lag(event) == "site_leave" ~ TRUE,
               # .default = FALSE
             )
    )
}