# Script which pulls anglers riverfly monitoring initative data from castco data hub 
# Find api at: https://data.castco.org/datasets/theriverstrust::riverfly-monitoring-initiative-static-download/api


library(sf)
library(magrittr)

ARMI <- read_sf("https://services3.arcgis.com/Bb8lfThdhugyc4G3/arcgis/rest/services/Riverfly_static_download/FeatureServer/0/query?where=1%3D1&outFields=*&geometry=-7.437%2C49.874%2C1.968%2C52.289&geometryType=esriGeometryEnvelope&inSR=4326&spatialRel=esriSpatialRelIntersects&outSR=4326&f=json")

# Change date & time formating and apply a mean to all dates and those after 2022
ARMI %<>% 
  mutate(
    Recorded__Date = ymd(Recorded__Date),
    Recorded__Time = hms(Recorded__Time)
  ) %>% 
  group_by(Site) %>%
  mutate(
    Survey_Count = n(),
    Mean_Tot = round(mean(ARMI_Total, na.rm = TRUE),2)
  ) %>% 
  filter(
   year(Recorded__Date) > 2022
  ) %>% 
  mutate(
    Mean_Tot_22 = round(mean(ARMI_Total, na.rm = TRUE),2)
  ) %>% 
  ungroup()
