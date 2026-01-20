#this script takes time columns in a dataset, and determines whether sleep (ready) times are later than bedtimes. If so, it uses bedtime as sleep ready time
#it also creates an adjusted nr_workdays column

mctq_bedsleeptimes <- function(data) {
    data %>%
    pivot_longer(
      cols = contains(c("ready_sleep_", "bedtime")),
      names_to = c(".value", "context"),
      names_pattern = "^(mctq_bedtime|mctq_ready_sleep)_(.*)$"
    ) %>%
    mutate(
      across(contains(c("ready_sleep", "bedtime")),
             \(x) ifelse(x < (12*60*60), 
                         as.POSIXct("2000-01-02"), 
                         as.POSIXct("2000-01-01")) |> 
               as.POSIXct() + x ),
      mctq_ready_sleep = pmax(mctq_bedtime, mctq_ready_sleep),
      across(contains(c("ready_sleep", "bedtime")), \(x) x |> hms::as_hms()),
      mctq_nr_workdays_adj = ifelse(is.na(mctq_nr_workdays), 5, mctq_nr_workdays)
    ) |> 
    pivot_wider(names_from = context, values_from = c(mctq_bedtime, mctq_ready_sleep))
}