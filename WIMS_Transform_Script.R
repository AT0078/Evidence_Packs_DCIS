# WIMS Transform Script
library(tidyverse)
library(magrittr)

    # Load in 
library(httr)
library(jsonlite)
library(tidyverse)
library(magrittr)

# Ammoniacal N "0111"
# Orthophosphate "0180"
# Dissolved Oxygen "0116"
# Biological Dissolved Oxygen "0085"
# Oxygen, Dissolved, % Saturation "9901"


#https://environment.data.gov.uk/water-quality/def/determinands

Deters = c("9901", "0111", "0180", "0116", "0085") 
Years = as.numeric(c(paste0(2022:format(Sys.Date(), "%Y"))))

# Set initial skeleton   
build <- data.frame()

# Loop through the Deters and Years vectors
for(x in Deters){
  for(z in Years){  

    # Use trycatch to skip any years with different formatting. Use area= to identify EA area
    tryCatch({
      base_url <- "http://environment.data.gov.uk/water-quality/"
      ending <- paste0("data/measurement?_limit=999999&&area=6-28&determinand=", x, "&year=", z) # filters all samples of orthophosphate.
      
      url <- paste0(base_url, ending)
      
      A_stations <- GET(url) 
      
      # Check if the status code is 200
      if(A_stations$status_code == 200){
        api_char <- rawToChar(A_stations$content)
        api <- fromJSON(api_char, flatten = TRUE)
        
        # Extract items
        api_it <- api$items
        
        # Append to empty data frame
        build <- rbind(build, api_it)
        
        print(paste0("Year: ", Years[z], "/", Deters[x], " - Rows: ", dim(build)[1], " Cols: ", dim(build)[2]))
      } else {
        warning("Status code not 200 for URL: ", url)
      }
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    Sys.sleep(45)
  }
}


#---------------------------------------------------------------------------------------------------------------------------------
#write_csv(build, "/dbfs/FileStore/WSX_HGray/Wessex_WIMS_monthly_scheduled.csv")



    
    WIMS %<>% st_as_sf(coords= c("sample.samplingPoint.easting", "sample.samplingPoint.northing"), crs=27700) %>% 
      filter(!is.na("sample.samplingPoint.easting") &!is.na("sample.samplingPoint.northing")) 
    
    CAT <- catch[catch$OPCAT_NAME == Catchments,]
    
    # Transform CAT so can join in planar geoms.  
    CAT_W <-st_transform(CAT, st_crs(27700))
    
    # Spatial join
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
  