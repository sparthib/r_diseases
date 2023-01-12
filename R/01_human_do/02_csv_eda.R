## Cleaning up some columns and EDA


####LOAD LIBRARIES####
library("here")
library("stringr")
library("readr")
library("dplyr")

#### LOAD ORPHA DATA #####

orpha <- read_csv(here("data", "orpha.csv"))
human_do <- read_csv(here("data", "human_do.csv"))


#### INSPECT COLUMNS ####
colnames(orpha)
# [1] "id"                                        "name"
# [3] "parents"                                   "children"
# [5] "ancestors"                                 "obsolete"
# [7] "format-version"                            "data-version"
# [9] "property_value"                            "ontology"
# [11] "xref"                                      "is_a"
# [13] "http://www.orpha.net/ORDO/Orphanet_410295" "http://www.orpha.net/ORDO/Orphanet_317345"
# [15] "http://www.orpha.net/ORDO/Orphanet_317343" "http://www.orpha.net/ORDO/Orphanet_327767"
# [17] "http://www.orpha.net/ORDO/Orphanet_317349" "http://www.orpha.net/ORDO/Orphanet_317348"
# [19] "http://www.orpha.net/ORDO/Orphanet_410296" "http://www.orpha.net/ORDO/Orphanet_317344"
# [21] "http://www.orpha.net/ORDO/Orphanet_465410" "http://www.orpha.net/ORDO/Orphanet_317346"

nrow(orpha)
# [1] 15312


colnames(human_do)
# [1] "id"                "name"              "parents"           "children"          "ancestors"         "obsolete"
# [7] "format-version"    "data-version"      "date"              "saved-by"          "subsetdef"         "default-namespace"
# [13] "remark"            "ontology"          "property_value"    "alt_id"            "def"               "subset"
# [19] "synonym"           "xref"              "is_a"              "created_by"        "creation_date"     "comment"
# [25] "disjoint_from"     "replaced_by"

nrow(human_do)
# [1] 13650


#### keep only ID vals in columns ####
orpha <- orpha |> mutate(across(everything(), gsub, pattern = "http://www.orpha.net/ORDO/Orphanet_", replacement = ""))
human_do <- human_do |> mutate(across(everything(), gsub, pattern = "DOID:", replacement = ""))



#### XREF ####

head(orpha$xref)
# [1] "ICD-10:Q98.8; MeSH:D007713; MedDRA:10048230; UMLS:C2936741"
# [2] "ICD-10:G11.3; MeSH:D001260; MedDRA:10003594; OMIM:208900; OMIM:208910; UMLS:C0004135"
# [3] "ICD-10:E70.3; MeSH:C537043; OMIM:300650; UMLS:C1845069"
# [4] "ICD-10:D36.1"
# [5] "ICD-10:D36.1"
# [6] "ICD-10:D36.1"

#Each xref observation contains disease ID list in character form.
# class(orpha$xref[1])
# "ICD-10:Q98.8; MeSH:D007713; MedDRA:10048230; UMLS:C2936741"
# "character"

## Missing values
sum(is.na(orpha$xref)) #2763 missing vals

# 2763/nrow(orpha)
# [1] 0.1804467

sum(is.na(human_do$xref))
#3116
# 3116/nrow(human_do)
# [1] 0.2282784

## ~20% external ref IDs missing in both datasets.


#### Number of rows that don't have children ####

sum(is.na(orpha$children)) #14263
sum(is.na(human_do$children)) #11353


#### XREF string mutation ####
orpha$xref <- gsub("ICD-", "ICD", orpha$xref)
orpha$xref <- str_to_lower(orpha$xref)

orpha <- orpha |> mutate(xref_new = paste0(" ", xref)) #add space to first position
orpha <- orpha |> mutate(xref_new = str_extract_all(xref_new, pattern = "[^;]*:")) #extract all db keys

db_list_orpha <- as.list(orpha$xref_new)
db_list_orpha <- unlist(db_list_orpha ,recursive=F)
db_list_orpha <- gsub(":", "", db_list_orpha)
db_list_orpha <- gsub(" ", "", db_list_orpha)

#Below are all possible DBs ORPHA is linked to.
# > unique(db_list_orpha)
# [1] "icd10"     "mesh"      "meddra"    "umls"      "omim"
# [6] "icd11"     "ensembl"   "genatlas"  "hgnc"      "swissprot"
# [11] "reactome"  "iuphar"

human_do$xref <- str_to_lower(human_do$xref)

human_do <- human_do |> mutate(xref_new = paste0(" ", xref)) #add space to first position
human_do <- human_do |> mutate(xref_new = str_extract_all(xref_new, pattern = "[^;]*:")) #extract all db keys

db_list_human_do <- as.list(human_do$xref_new)
db_list_human_do <- unlist(db_list_human_do ,recursive=F)
db_list_human_do <- gsub(":", "", db_list_human_do)
db_list_human_do <- gsub(" ", "", db_list_human_do)

#All possible DBs human_do is linked to.
# > unique(db_list_human_do)
# [1] "icdo"                   "mesh"                   "nci"                    "snomedct_us_2022_03_01" "umls_cui"
# [6] "icd10cm"                "icd9cm"                 "snomedct_us_2021_09_01" "ordo"                   "gard"
# [11] "omim"                   "efo"                    "kegg"                   "meddra"                 "snomedct_us_2021_07_31"
# [16] "snomedct_us_2022_10_31" "icd11"                  "snomedct_us_2022_07_31" "snomedct_us_2020_09_01" "snomedct_us_2020_03_01"


#### SAVE NEW DFS ####
if(!file.exists(here("data", "processed_data" "ordo_post_02.csv"))){
    write_csv(orpha, here("data", "processed_data",  "ordo_post_02.csv"))
}

if(!file.exists(here("data", "human_do_post_02.csv"))){
    write_csv(human_do, here("data", "processed_data", "human_do_post_02.csv"))
}
