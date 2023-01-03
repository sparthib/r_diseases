####Split xrefs into separate columns####
##1. create columns to indicate whether ID present in xref column.
##2. if 1, then extract ID to column.


####LOAD LIBRARIES####
library("here")
library("stringr")
library("readr")
library("dplyr")

#### LOAD ORPHA DATA #####
ordo <- read_csv(here("data", "ordo_post_02.csv"))
human_do <- read_csv(here("data", "human_do_post_02.csv"))

#### 1/0 columns for presence of ID in xref ####

#Below are all possible DBs ORPHA is linked to.
# > unique(db_list_orpha)
# [1] "icd10"     "mesh"      "meddra"    "umls"      "omim"
# [6] "icd11"     "ensembl"   "genatlas"  "hgnc"      "swissprot"
# [11] "reactome"  "iuphar"


db_list_ordo <- c("icd10", "mesh", "meddra", "umls", "omim","icd11" ,"ensembl",
                  "genatlas", "hgnc", "swissprot", "reactome" , "iuphar")


for(id in db_list_ordo){
eval(parse(text = paste0("ordo$", id, 'present', ' <-', 'ifelse(grepl(id, ordo$xref), ',
                         'yes = str_extract_all(ordo$xref[2], paste0(id, "([^;])+")),
                             no = NA)'))) }


db_list_human_do <- c("icdo", "mesh" ,"nci" , "snomedct_us_2022_03_01" , "umls_cui", "icd10cm" ,
                      "icd9cm","snomedct_us_2021_09_01", "ordo", "gard", "omim"  ,
                      "efo"  , "kegg",  "meddra", "snomedct_us_2021_07_31",
                      "snomedct_us_2022_10_31", "icd11"  , "snomedct_us_2022_07_31",  "snomedct_us_2020_09_01" ,
                      "snomedct_us_2020_03_01")

for(id in db_list_human_do){
    eval(parse(text = paste0("human_do$", id, 'present',' <-', 'ifelse(grepl(id, human_do$xref), ',
                             'yes = str_extract_all(human_do$xref[2], paste0(id, "([^;])+")),
                             no = NA)'))) }



