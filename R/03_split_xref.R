####Split xrefs into separate columns####
##1. create columns to indicate whether ID present in xref column.
##2. if 1, then extract ID to column.


####LOAD LIBRARIES####
library("here")
library("stringr")
library("readr")
library("dplyr")

#### LOAD ORPHA DATA #####
orpha <- read_csv(here("data", "orpha.csv"))
human_do <- read_csv(here("data", "human_do.csv"))

