# WIMS Transform Script
library(tidyverse)
library(magrittr)


 WIMS <- read.csv("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/CEP/Wessex_WIMS_monthly_scheduled.csv")

# Transform to spatial object so can crop by catchment of interest
 
     WIMS %<>% st_as_sf(coords= c("sample.samplingPoint.easting", "sample.samplingPoint.northing"), crs=27700) %>% 
      filter(!is.na("sample.samplingPoint.easting") &!is.na("sample.samplingPoint.northing")) 
    
    CAT <- catch[catch$OPCAT_NAME == Catchments,]
    
# Transform CAT so can join in planar geoms.  
    CAT_W <-st_transform(CAT, st_crs(27700))
    
# Spatial join to catchment of choice
    joined <- st_join(WIMS, CAT_W)
 
    joined_w <- st_transform(joined, st_crs(4326))

# Crop Wessex wide to be in catchment.
    WIMS_CAT <- joined[CAT_W,]
    
    
# Transform dates & filter out the random MISCELLANEOUS catchments
      WIMS_CAT  %<>% mutate(date_time = lubridate::ymd_hms(sample.sampleDateTime),
                   Date= as.Date(date_time),
                   Year = lubridate::year(date_time)) %>% 
                   filter(!grepl("MISCELLANEOUS", sample.samplingPoint.label))    

      
# Transform into WGS84
    WIMS_CAT %<>% st_transform(st_crs(4326))