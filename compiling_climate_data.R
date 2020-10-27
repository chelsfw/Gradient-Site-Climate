rm(list=ls())
## Date: October 2020
## Author: C. Wilmer with the help of Dana K. Chadwick and Amanda Henderson
## Project: Phenology Durations MS Thesis
## Script: This script is an exercise in wrangling several files and creating one file. The data are temperature and precipition data at 4km scale for East River and Washington Gulch separated for five sites along an elevation gradient. The resolution is questionable and such needs to be summarised to see if there are differences between sites.
## Packages:

library(tidyverse)
library(plyr)
library(lubridate)

setwd("/Users/chelseawilmer/Desktop/Github/Gradient-Site-Climate")

#### Bring in Data ####
#file.names <- list.files(".", pattern = ".csv") # getting a list of file names from a folder
site.names <- c("ALP", "USA", "LSA", "UM", "LM")

# make a blank data frame that will be populated with data in the specified format
all_sites <- data.frame(matrix(vector(),0,4, dimnames = list(c(), c("Date", "Precip_mm", "Temp_C", "Site"))), stringsAsFactors = T)
print(all_sites) #view

# iteration - this for loop works on one site at a time, reading in the separate precip and temperature files for each site, changing the column names, joining the precip and temp data into one dataframe, adding a site column with correct site identifier and binding the rows to the all_sites dataframe site by site
for (i in 1:length(site.names)){
  t_precip = read.csv(paste(site.names[i], "_precip.csv", sep = ""))
  t_temp = read.csv(paste(site.names[i], "_meantemp.csv", sep = ""))
  colnames(t_precip) <- c("DateTime", "Precip_mm")
  colnames(t_temp) <- c("DateTime", "Temp_C")
  site_climate <- join(t_precip, t_temp, by = "DateTime", type = "full", match = "all")
  site_climate$Site <- site.names[i]
  all_sites <- rbind(all_sites, site_climate)
}

str(all_sites)

all_sites$DateTime <- mdy(all_sites$DateTime)
str(all_sites)
all_sites$Year <- year(all_sites$DateTime)
all_sites$Month <- month(all_sites$DateTime)
all_sites$DOY <- yday(all_sites$DateTime)
col_order <- c("Date", "Site", "Precip_mm", "Temp_C")

means <- all_sites %>%
  group_by(Year, Site, Precip_mm, Temp_C) %>%
  summarise(mean_Precip = mean(Precip_mm), 
            mean_Temp = mean(Temp_C))

#### Visualize ####
# need to get year out of the date to do this but want to see

ggplot(all_sites, aes(x=Site, y=Precip_mm)) +
  geom_boxplot()

ggplot(all_sites, aes(x=DOY, y=Temp_C, color = Site)) +
  geom_line()+
  facet_grid(Year~.)+
  labs(title = "Site Level Temperature", x = "Julian Day of Year", y = "Temperature (C)")


        
