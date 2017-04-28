## LOAD PACKAGES ####
# Import pandas for data manipulation as data frames
import pandas as pd

# Import packages for census data
from census import Census
from us import states


## READ IN DATA ####
# Read in variable names
variables = pd.read_csv("data/census_variables.csv")
variable_list = variables["variable"].tolist()

# Set census key
from censuskey import censuskey

# Get state ids and names
states = pd.DataFrame()

for state in range(1, 57):
    state = pd.DataFrame.from_dict(censuskey.acs5.state('NAME', state))
    states = pd.concat([states, state])


## GET DATA FOR ALL STATES AT ONCE ####
# Initialize empty data frame
data = pd.DataFrame()

# Loop over every state to get data and append to single data frame
for year in [2010, 2011, 2012, 2013]:
    for state in range(1, 57):
        raw_state  = censuskey.acs5.state(variable_list, state, year = year)
        data_state = pd.DataFrame.from_dict(raw_state)
        data_state['year'] = year
        data = pd.concat([data, data_state])

# Transform data to long form
data_long = pd.melt(data, id_vars = ['year', 'state'])

# Join with variable names to get languages
data_full = pd.merge(variables, data_long, on = 'variable', how = 'inner')

# Convert values to numeric
data_full['value'] = pd.to_numeric(data_full['value'])


## ORGANIZE DATA ####
# Make separate data frame just for totals
data_totals = data_full[data_full.language == 'Total'] \
                 # Drop unneeded columns
                .drop(['variable', 'language'], axis = 1) \
                # Rename column 'value' to 'total'
                .rename(columns = {'value': 'total'})

# Make separate data frame just for languages
data_langs = data_full[data_full.language != 'Total'] \
                # Join with data on totals
                .merge(data_totals, on = ['year', 'state'], how = 'inner')

# Add column for percentage of each language
data_langs['percentage'] = (data_langs.value / data_langs.total) * 100

# Join with state ids to get names
data_clean = pd.merge(data_langs, states, on = 'state', how = 'inner')
data_clean = data_clean[data_clean.language != 'Speak only English']
data_clean['ranking'] = data_clean.sort_values(['value'], ascending=[False]) \
             .groupby(['year', 'NAME']) \
             .cumcount() + 1


## WRITE TO CSV ####
data_clean.to_csv("data/data_clean.csv")
