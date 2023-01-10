####Split xrefs into separate columns####
##1. create columns to indicate whether ID present in xref column.
##2. if 1, then extract ID to column.


####LOAD LIBRARIES####
library("here")
library("stringr")
library("readr")
library("dplyr")

#### LOAD ORPHA DATA #####
ordo <- read_csv(here("data", "processed_data", "ordo_post_02.csv"))
human_do <- read_csv(here("data","processed_data", "human_do_post_02.csv"))

#### 1/0 columns for presence of ID in xref ####

#Below are all possible DBs ORPHA is linked to.
# > unique(db_list_orpha)
# [1] "icd10"     "mesh"      "meddra"    "umls"      "omim"
# [6] "icd11"     "ensembl"   "genatlas"  "hgnc"      "swissprot"
# [11] "reactome"  "iuphar"


db_list_ordo <- c("icd10", "mesh", "meddra", "umls", "omim","icd11" ,"ensembl",
                  "genatlas", "hgnc", "swissprot", "reactome" , "iuphar")


for(id in db_list_ordo){
eval(parse(text = paste0("ordo_", id, ' <-', 'ifelse(grepl(id, ordo$xref), ',
                         'yes = str_extract_all(ordo$xref, paste0(id, "([^;])+")),
                             no = NA)')))
eval(parse(text = paste0("ordo$", id, ' <-', 'unlist("ordo_",', id, ')' )))

    }


db_list_human_do <- c("icdo", "mesh" ,"nci" , "snomedct_us_2022_03_01" , "umls_cui", "icd10cm" ,
                      "icd9cm","snomedct_us_2021_09_01", "ordo", "gard", "omim"  ,
                      "efo"  , "kegg",  "meddra", "snomedct_us_2021_07_31",
                      "snomedct_us_2022_10_31", "icd11"  , "snomedct_us_2022_07_31",  "snomedct_us_2020_09_01" ,
                      "snomedct_us_2020_03_01")

for(id in db_list_human_do){
    eval(parse(text = paste0("human_do$", id, ' <-', 'ifelse(grepl(id, human_do$xref), ',
                             'yes = str_extract_all(human_do$xref, paste0(id, "([^;])+")),
                             no = NA)'))) }

# [a-zA-Z]*: to remove text before colon
ordo <- ordo |>  select(-c(MeSHpresent))

write_csv(ordo, here("data", "processed_data", "ordo_post_03.csv"))
write_csv(human_do, here("data", "processed_data","human_do_post_03.csv"))

# > colnames(ordo)
# [1] "id"                                        "name"                                      "parents"
# [4] "children"                                  "ancestors"                                 "obsolete"
# [7] "format-version"                            "data-version"                              "property_value"
# [10] "ontology"                                  "xref"                                      "is_a"
# [13] "http://www.orpha.net/ORDO/Orphanet_410295" "http://www.orpha.net/ORDO/Orphanet_317345" "http://www.orpha.net/ORDO/Orphanet_317343"
# [16] "http://www.orpha.net/ORDO/Orphanet_327767" "http://www.orpha.net/ORDO/Orphanet_317349" "http://www.orpha.net/ORDO/Orphanet_317348"
# [19] "http://www.orpha.net/ORDO/Orphanet_410296" "http://www.orpha.net/ORDO/Orphanet_317344" "http://www.orpha.net/ORDO/Orphanet_465410"
# [22] "http://www.orpha.net/ORDO/Orphanet_317346" "xref_new"                                  "icd10present"
# [25] "meshpresent"                               "meddrapresent"                             "umlspresent"
# [28] "omimpresent"                               "icd11present"                              "ensemblpresent"
# [31] "genatlaspresent"                           "hgncpresent"                               "swissprotpresent"
# [34] "reactomepresent"                           "iupharpresent"

# colnames(human_do)
# [1] "id"                            "name"                          "parents"                       "children"                      "ancestors"
# [6] "obsolete"                      "format-version"                "data-version"                  "date"                          "saved-by"
# [11] "subsetdef"                     "default-namespace"             "remark"                        "ontology"                      "property_value"
# [16] "alt_id"                        "def"                           "subset"                        "synonym"                       "xref"
# [21] "is_a"                          "created_by"                    "creation_date"                 "comment"                       "disjoint_from"
# [26] "replaced_by"                   "xref_new"                      "icdopresent"                   "meshpresent"                   "ncipresent"
# [31] "snomedct_us_2022_03_01present" "umls_cuipresent"               "icd10cmpresent"                "icd9cmpresent"                 "snomedct_us_2021_09_01present"
# [36] "ordopresent"                   "gardpresent"                   "omimpresent"                   "efopresent"                    "keggpresent"
# [41] "meddrapresent"                 "snomedct_us_2021_07_31present" "snomedct_us_2022_10_31present" "icd11present"                  "snomedct_us_2022_07_31present"
# [46] "snomedct_us_2020_09_01present" "snomedct_us_2020_03_01present"
