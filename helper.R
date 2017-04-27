# Create intervals
numericCutter <- function(vect, step = 0.2, tilda = FALSE, cont = TRUE) {
  # Wrapper for cut function
  # Takes numeric vector as input
  # Returns factor based on intervals
  if (cont == TRUE) {
    vect <- round(vect, 2)
    vect <- cut(vect,
                breaks = unique(quantile(vect, 
                                         probs = seq(0, 1, step),
                                         names = FALSE,
                                         na.rm = TRUE)),
                dig.lab = 10,
                ordered_result = TRUE,
                include.lowest = TRUE,
                right = FALSE)
    if (tilda == TRUE) {
      levels(vect) <- gsub("\\[|\\]|\\(|\\)", "", levels(vect))
      levels(vect) <- gsub("\\,", "-", levels(vect))
    }
  } else {
    vect <- factor(vect)
  }
  return(vect)
}


# Merge basic data with user's file
user_data <- function(supplied_data, merge_by_var, merge_by_reg = TRUE) {
  if(is.null(supplied_data)) {
    data <- ggrmap
  } else {
    if (merge_by_reg == TRUE) {
      data <- left_join(ggrmap, supplied_data, by = c("id" = merge_by_var))
    } else {
      data <- left_join(ggrmap, supplied_data, by = c("okato" = merge_by_var))
    }
  }
  return(data)
}

