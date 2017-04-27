# Function to create a map of Russia with filling of choice

mapPlotter <- function(data, fill_var, title = "", leg_name = "", pal = "GnBu") {
  # Function plots map of Russia with chosen filling
  #
  # Args:
  #  data: dataframe with long, lat, group by variable and filling
  #  fill_var: variable to fill the plot
  #  title: title of the plot
  #  leg_name: title of the legend
  #
  # Returns:
  #  ggplot2 object: map of Russia
  mplot <- ggplot(data = data, aes_(x = ~long,
                                   y = ~lat, 
                                   group = ~group, 
                                   fill = as.name(fill_var))) +
    geom_polygon(colour = "gray", size = 0.3) + 
    coord_quickmap() + 
    labs(x = "", 
         y = "",
         title = str_wrap(title, 60)) + 
    scale_x_continuous(breaks = NULL) +
    scale_y_continuous(breaks = NULL) + 
    scale_fill_brewer(name = leg_name,
                      palette = pal,
                      na.value = "darkgray") +
    theme_bw() +
    theme(
      plot.title = element_text(hjust = 0.5),
      legend.title.align = 0,
      legend.key.width = unit(1.3, "line"),
      legend.key.height = unit(1.3, "line"),
      legend.key = element_blank())
  
  return(mplot)
}