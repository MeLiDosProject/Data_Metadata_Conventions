diarydate <- function(data, date.column) {
  require(lubridate)
  require(dplyr)
    data |> 
    mutate(Date = date({{ date.column }}),
           .Time = hms::as_hms({{ date.column }}),
           Date = case_when(.Time < (14*60*60) ~ Date - ddays(1),
                            .default = Date),
           .before = {{ date.column }}
           ) |> 
    select(-.Time)
}