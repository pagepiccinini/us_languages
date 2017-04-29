## LOAD PACKAGES ####
source("scripts/r/us_languages_packages.R")
library(shiny)


## LOAD FUNCTIONS ####
source("scripts/r/us_languages_functions.R")


## READ IN DATA AND ORGANIZE ####
# Read in initial data
source("scripts/r/us_languages_cleaning.R")

# Set initial figure data
data_figs = data_clean

# Total non-English
data_noneng_figs = data_clean %>%
  group_by(year, state) %>%
  summarise(perc_noneng = sum(percentage)) %>%
  ungroup() %>%
  arrange(desc(perc_noneng))

# Get map
states_map = usa_composite()

# Fortify map
states = fortify(states_map, region="name") %>%
  # Change column for state names to 'state'
  rename(state = id)

# Combine map and full data
data_states_figs = inner_join(data_figs, states)

# Combine map and data for percentage of language
data_noneng_states_figs = inner_join(data_noneng_figs, states)


## MAKE UI INPUTS ####
ui <- fluidPage(
  fluidRow(
    
    column(12,
      # Add menu input for census year
      selectInput(inputId = "year",
                  label = "Census Year",
                  choices = c(levels(factor(data_figs$year)))),
      
      # Add general map of non-English usage
      plotOutput("percnoneng_map")
    )
  ),
  
  fluidRow(
    
    column(6,
      # Add menu input for ranking
      selectInput(inputId = "ranking",
                  label = "Ranking",
                  choices = c(1, 2, 3, 4, 5)),
      
      # Add map for non-English language ranking
      plotOutput("top_map")
    ),
    
    column(6,
      # Add menu input for language
      selectInput(inputId = "language",
                  label = "Specific Language",
                  choices = c(levels(data_figs$language))),
      
      # Add map for specific language
      plotOutput("specificlg_map")
    )
  )
)


## MAKE SERVER OUTPUTS
server <- function(input, output) {
  # Add code for map of non-English usage for user chosen year
  output$percnoneng_map = renderPlot({
    percnoneng_map(data_noneng_states_figs, input$year)
  })
  
  # Add code for map of non-English language ranking for user chosen year and ranking
  output$top_map = renderPlot({
    top_map(data_states_figs, input$year, input$ranking)
  })
  
  # Add code for map of specific user chosen year and language
  output$specificlg_map = renderPlot({
    specificlg_map(data_states_figs, input$year, input$language)
  })
}


## RENDER APP ####
shinyApp(ui = ui, server = server)