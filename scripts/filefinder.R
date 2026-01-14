filefinder <- function(aspect, individual = TRUE, continuous = FALSE, full.names = TRUE){

  #path to questionnaire
  if(continuous) {
    path_part2 <- paste0("/continuous/", aspect)
    } else path_part2 <- paste0("/", aspect)
  
  #base path
  if(individual){
    path_part1 <- "../data/raw/individual"
    #getting all subfolders
    folders <- dir(path_part1)
    #creating complete folder names
    paths <- glue("{path_part1}/{folders}{path_part2}")
    } else {
      path_part1 <- "../data/raw/group"
      #creating complete folder names
      paths <- glue("{path_part1}{path_part2}")
      }

  #collecting file names
  files <- list.files(paths, full.names = TRUE)
}