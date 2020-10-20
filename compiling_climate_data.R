library(tidyverse)
library(plyr)

setwd("/Users/chelseawilmer/Desktop/Github/Gradient-Site-Climate")

#### Make a list of sites ####

file.names <- list.files(".", pattern = ".csv") # getting a list of file names from a folder
site.names <- c("ALP", "USA")

all_sites <- data.frame(matrix(vector(),0,4, dimnames = list(c(), c("DateTime", "Precip_mm", "Temp_C", "Site"))), stringsAsFactors = F)
print(all_sites)

for (i in 1:length(site.names)){
  print(site.names[i])
  t_precip = read.csv(paste(site.names[i], "_precip.csv", sep = ""))
  t_temp = read.csv(paste(site.names[i], "_meantemp.csv", sep = ""))
  colnames(t_precip) <- c("DateTime", "Precip_mm")
  colnames(t_temp) <- c("DateTime", "Temp_C")
  print(head(t_precip))
  print(head(t_temp))
  site_climate <- join(t_precip, t_temp, by = "DateTime", type = "full", match = "all")
  site_climate$Site <- site.names[i]
  print(site_climate)
  all_sites <- rbind(all_sites, site_climate)
}

#### Import all data ####
