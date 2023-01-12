####Split xrefs into separate columns####
##1. create columns to indicate whether ID present in xref column.
##2. if 1, then extract ID to column.


####LOAD LIBRARIES####
library("here")
library("stringr")
library("readr")
library("dplyr")
library("tibble")

#### LOAD ORPHA DATA #####
ordo <- read_csv(here("data", "processed_data", "ordo_post_02.csv"))
human_do <- read_csv(here("data","processed_data", "human_do_post_02.csv"))

ordo <- as_tibble(ordo)
human_do <- as_tibble(human_do)

#### 1/0 columns for presence of ID in xref ####

#Below are all possible DBs ORPHA is linked to.
# > unique(db_list_orpha)
# [1] "icd10"     "mesh"      "meddra"    "umls"      "omim"
# [6] "icd11"     "ensembl"   "genatlas"  "hgnc"      "swissprot"
# [11] "reactome"  "iuphar"


db_list_ordo <- c("icd10", "mesh", "meddra", "umls", "omim","icd11" ,"ensembl",
                  "genatlas", "hgnc", "swissprot", "reactome" , "iuphar")


for(id in db_list_ordo){
eval(parse(text = paste0("ordo_", id, ' <-',  'ifelse(grepl(id, ordo$xref), ',
                         'yes = str_extract_all(ordo$xref, paste0(id, "([^;])+")),
                             no = NA)')))

}




db_list_human_do <- c("icdo", "mesh" ,"nci" , "snomedct_us_2022_03_01" , "umls_cui", "icd10cm" ,
                      "icd9cm","snomedct_us_2021_09_01", "ordo", "gard", "omim"  ,
                      "efo"  , "kegg",  "meddra", "snomedct_us_2021_07_31",
                      "snomedct_us_2022_10_31", "icd11"  , "snomedct_us_2022_07_31",  "snomedct_us_2020_09_01" ,
                      "snomedct_us_2020_03_01")

for(id in db_list_human_do){
    eval(parse(text = paste0("human_do_", id, ' <-', 'ifelse(grepl(id, human_do$xref), ',
                             'yes = str_extract_all(human_do$xref, paste0(id, "([^;])+")),
                             no = NA)'))) }

# [a-zA-Z]*: to remove text before colon




## Currently can view each external reference id column in R, but some
## diseases have multiple ids for each xref, so these are currently stored as
## list of lists and there's no straightforward way to export these to CSVs.
## e.g. ordo_icd10, or human_do_omim are lists of lists
