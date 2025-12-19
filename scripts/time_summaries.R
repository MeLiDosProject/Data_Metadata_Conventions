time_median <- function(datetime){
  datetime |> 
    LightLogR:::datetime_to_circular() |> 
    median() |> 
    LightLogR:::circular_to_hms() |> 
    hms::round_hms(1)
}

nighttime_p25 <- function(datetime){
  morning <- hms::as_hms(datetime) < 12*60*60
  date(datetime) <- ifelse(morning, as.Date("2000-01-02"), as.Date("2000-01-01")) |> as.Date()
  datetime |> 
    quantile(0.25) |> 
    hms::as_hms()
}

nighttime_p75 <- function(datetime){
  morning <- hms::as_hms(datetime) < 12*60*60
  date(datetime) <- ifelse(morning, as.Date("2000-01-02"), as.Date("2000-01-01")) |> as.Date()
  datetime |> 
    quantile(0.75) |> 
    hms::as_hms()
}

daytime_p25 <- function(datetime){
  hms::as_hms(datetime) |> quantile(0.25) |> hms::as_hms()
}

daytime_p75 <- function(datetime){
  hms::as_hms(datetime) |> quantile(0.75) |> hms::as_hms()
}
