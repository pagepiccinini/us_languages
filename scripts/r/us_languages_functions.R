# Make map with percentage non-English over time
percnoneng_map = function(data, plot_year) {
  data %>%
    filter(year == plot_year) %>%
    ggplot(aes(x = long, y = lat, group = group, fill = perc_noneng)) +
    # Add title
    ggtitle(paste0("Year ", plot_year)) +
    # Draw states as polygons with white borders between states
    geom_polygon(color = "white") +
    # Change legend title and colors
    scale_fill_distiller("percentage non-English\nlanguage", palette = "PuBu",
                         direction = 1, limits = c(0, 50)) +
    # Update map projection to match most maps
    coord_map(projection = "polyconic") +
    # Remove axes and background
    theme_void() +
    # Move legend position and increase text size
    theme(legend.position = "top",
          text = element_text(size = 16))  
}

# Make map for top X language
top_map = function(data, plot_year, number) {
  data %>%
    filter(ranking == number) %>%
    filter(year == plot_year) %>%
    ggplot(aes(x = long, y = lat, group = group, fill = language, alpha = percentage)) +
    # Add title
    ggtitle(paste0("Top ", number, " Non-English Language for ", plot_year),
            subtitle = "Darkness function of percentage of speakers") +
    # Draw states as polygons with white borders between states
    geom_polygon(color = "white") +
    # Update legend
    guides(fill = guide_legend(nrow = round(length(unique(levels(data$language))) / 10, 0))) +
    # Set limits for alpha and supress legend
    scale_alpha(guide = 'none', limits = c(0, 30)) +
    # Update map projection to match most maps
    coord_map(projection = "polyconic") +
    # Remove axes and background
    theme_void() +
    # Move legend position and increase text size
    theme(legend.position = "top",
          text = element_text(size = 16))  
}

# Make barplot for top X language
top_barplot = function(data, number) {
  data %>%
    filter(ranking == number) %>%
    ggplot(aes(x = language, fill = language)) +
    facet_wrap(~year) +
    geom_bar() +
    ggtitle(paste0("Number of States Where Langauge ", number, " Most Common\n(after English)")) +
    xlab("Language") +
    ylab("Number of states") +
    guides(fill = guide_legend(nrow = round(length(unique(levels(data$language))) / 10, 0))) +
    theme_classic() +
    theme(text = element_text(size = 16),
          legend.position = "top",
          axis.text.x = element_blank(), axis.ticks.x = element_blank())
}

# Map map for specific language
specificlg_map = function(data, plot_year, specific_language) {
  data %>%
    filter(year == plot_year) %>%
    filter(language == specific_language) %>%
    ggplot(aes(x = long, y = lat, group = group, fill = percentage)) +
    # Add title
    ggtitle(paste0("Percentage of ", specific_language, " in ", plot_year)) +
    # Draw states as polygons with white borders between states
    geom_polygon(color = "white") +
    # Change legend title and colors
    scale_fill_distiller(palette = "RdPu", direction = 1) +
    # Update map projection to match most maps
    coord_map(projection = "polyconic") +
    # Remove axes and background
    theme_void() +
    # Move legend position and increase text size
    theme(legend.position = "top",
          text = element_text(size = 16))  
}