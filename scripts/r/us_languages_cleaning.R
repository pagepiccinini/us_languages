## READ IN DATA AND ORGANIZE ####
# Read in data
data = read.csv("data/data_clean.csv")

# Organize data
data_clean = data %>%
  # Drop random extra column at beginning and numeric state column
  select(-c(X, state)) %>%
  # Rename full state name to just 'state'
  rename(state = NAME)
