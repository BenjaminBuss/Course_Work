
# Load in packages
library(pdftools)
library(tidyverse)
library(pdfsearch)

# Load PDF of Trader Joe's Locations
jl_loc <- pdf_text("C:/Users/benja/Pictures/Trader-Joes-Stores.pdf") %>% readr::read_lines()

# Load list of zipcodes(from work DB)
zipcodes <- read.csv("zipcodes.csv")

# Extract zip code into an array
zips <- zipcodes %>% pull(zip_code)

# Search for matching strings
tj_zips <- keyword_search(jl_loc, zips)

# Turn into an array
zip_tj <- as.numeric(tj_zips$keyword)

rm(test, xx, zipcodes, jl_loc, zips)


write.csv(zip_tj, "zip_tj.csv")




