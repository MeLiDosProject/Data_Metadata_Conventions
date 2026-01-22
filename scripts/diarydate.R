diarydate <- function(data, date.column, cutoff = 14*60*60) {
  require(lubridate)
  require(dplyr)
    data |> 
    mutate(Date = date({{ date.column }}),
           .Time = hms::as_hms({{ date.column }}),
           Date = case_when(.Time < cutoff ~ Date - ddays(1),
                            .default = Date),
           .after = record_id
           ) |> 
    select(-.Time)
}