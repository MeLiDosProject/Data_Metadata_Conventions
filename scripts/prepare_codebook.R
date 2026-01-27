#base path is https://raw.githubusercontent.com/MeLiDosProject/Data_Metadata_Conventions/main/codebook/
prepare_codebook <- function(codebook, form.filter = NULL) {
  require(glue)
  path <- glue(
    "https://raw.githubusercontent.com/MeLiDosProject/Data_Metadata_Conventions/main/codebook/",
    codebook
  )
  strings_to_ignore <- 
    "<div class=\"rich-text-field-label\">|<span style=\"font-weight: normal;\">Note: please answer with regard to your personal smartwatch (if you own one), not the one actimeter given to you for the study|<span style=\"font-weight: normal;\">Note: please answer with regard to your personal smartwatch (if you own one), not the one actimeter given to you for the study|<span style=\"font-weight: normal;\">Note: this does not include the time spent filling in the questionnaires.|<span style=\"font-weight: normal;\">Note: please answer with regard to your personal smartwatch (if you own one), not the one actimeter given to you for the study|<span style=\"text-decoration: underline;\">|</span>|<p>|<br />|<em>|</em>|</p>|</div>|<span style=\"font-weight: normal;\">We need this so that we can contact you with further details about participation in the study. Please provide an e-mail address that you regularly check.</span>"
  codebook <- 
    read_csv(
      path, show_col_types = FALSE
    )
  
  if(!is.null(form.filter)){
    #filter relevant columns
    codebook <- 
      codebook |> filter(`Form Name` %in% form.filter)
  }
  
  #clean up labels
  codebook <-
    codebook |> 
    mutate(
      `Field Label` = 
        `Field Label` |> 
        str_remove_all(strings_to_ignore)
    )
  codebook
}