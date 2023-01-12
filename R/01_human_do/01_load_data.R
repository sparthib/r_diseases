##Script converts OBO to flat files and saves them
## Used pronto library in python to convert OWL to OBO

####LOAD LIBRARIES####
library("ontologyIndex")
library("here")
library("stringr")
library("readr")

#### LOAD ORPHA DATA #####


orpha_onto <- get_ontology(
    file = here("data", "raw_data", "orpha.obo"),
    propagate_relationships = "is_a",
    extract_tags = "everything",
    merge_equivalent_terms = TRUE
)

orpha_df <- as.data.frame(orpha_onto)

# nrow(orpha_df)
# #15312
#
# length(unique(orpha_df$name))
# #15312
# Number of terms: 15302


##### Create data folder and save data ######
if(!file.exists(here("data"))){
    dir.create(here("data"))
    }

if(!file.exists(here("data", "processed_data", "ordo_post_01.csv"))){
    write_csv(orpha_df, here("data", "processed_data", "ordo_post_01.csv"))
}


##### LOAD HUMAN_DO DATA #####

human_do_url <- "https://raw.githubusercontent.com/DiseaseOntology/HumanDiseaseOntology/main/src/ontology/HumanDO.obo"

human_do_onto <- get_ontology(
    file = human_do_url,
    propagate_relationships = "is_a",
    extract_tags = "everything",
    merge_equivalent_terms = TRUE
)

human_df <- as.data.frame(human_do_onto)

if(!file.exists(here("data", "processed_data", "human_do_post_01.csv"))){
    write_csv(human_df, here("data","processed_data","human_do_post_01.csv"))
}

