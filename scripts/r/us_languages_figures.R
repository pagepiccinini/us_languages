## ORGANIZE DATA ####
# Set initial figure data
data_figs = data_clean

# Total non-English
data_noneng_figs = data_clean %>%
  group_by(year, state) %>%
  summarise(perc_noneng = sum(percentage)) %>%
  ungroup() %>%
  arrange(desc(perc_noneng))


## GET MAP DATA ####
# Get map
states_map = usa_composite()

# Fortify map
states = fortify(states_map, region="name") %>%
  # Change column for state names to 'state'
  rename(state = id)


## CREATE JOINED DATA FOR MAPS ####
# Combine map and full data
data_states_figs = inner_join(data_figs, states)

# Combine map and data for percentage of language
data_noneng_states_figs = inner_join(data_noneng_figs, states)


## MAPS PERCENTAGE OF ENGLISH OVER TIME ####
# Year 2010
percnoneng_2010.map = percnoneng_map(data_noneng_states_figs, 2010)
percnoneng_2010.map

# Year 2011
percnoneng_2011.map = percnoneng_map(data_noneng_states_figs, 2011)
percnoneng_2011.map

# Year 2012
percnoneng_2012.map = percnoneng_map(data_noneng_states_figs, 2012)
percnoneng_2012.map

# Year 2013
percnoneng_2013.map = percnoneng_map(data_noneng_states_figs, 2013)
percnoneng_2013.map


## MAPS TOP LANGUAGES ####
# Top 1, Year 2010
top1_2010.map = top_map(data_states_figs, 1, 2010)
top1_2010.map

# Top 1, Year 2011
top1_2011.map = top_map(data_states_figs, 1, 2011)
top1_2011.map

# Top 1, Year 2012
top1_2012.map = top_map(data_states_figs, 1, 2012)
top1_2012.map

# Top 1, Year 2013
top1_2013.map = top_map(data_states_figs, 1, 2013)
top1_2013.map

# Top 2, Year 2010
top2_2010.map = top_map(data_states_figs, 2, 2010)
top2_2010.map

# Top 2, Year 2011
top2_2011.map = top_map(data_states_figs, 2, 2011)
top2_2011.map

# Top 2, Year 2012
top2_2012.map = top_map(data_states_figs, 2, 2012)
top2_2012.map

# Top 2, Year 2013
top2_2013.map = top_map(data_states_figs, 2, 2013)
top2_2013.map

# Top 3, Year 2010
top3_2010.map = top_map(data_states_figs, 3, 2010)
top3_2010.map

# Top 3, Year 2011
top3_2011.map = top_map(data_states_figs, 3, 2011)
top3_2011.map

# Top 3, Year 2012
top3_2012.map = top_map(data_states_figs, 3, 2012)
top3_2012.map

# Top 3, Year 2013
top3_2013.map = top_map(data_states_figs, 3, 2013)
top3_2013.map


## BARPLOTS TOP LANGUAGES ####
# Top 1
top1.barplot = top_barplot(data_figs, 1)
top1.barplot

# Top 2
top2.plot = top_barplot(data_figs, 2)
top2.plot

# Top 3
top3.plot = top_barplot(data_figs, 3)
top3.plot


## MAPS SPECIFIC LANGUAGES ####
# Chinese in 2010
chinese_2010.map = specificlg_map(data_states_figs, 2010, "Chinese")
chinese_2010.map

# Spanish in 2010
spanish_2010.map = specificlg_map(data_states_figs, 2010, "Spanish or Spanish Creole")
spanish_2010.map

# French in 2010
french_2010.map = specificlg_map(data_states_figs, 2010, "French (incl. Patois, Cajun)")
french_2010.map
