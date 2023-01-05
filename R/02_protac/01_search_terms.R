#How to automate a PUBMED search?

#Suppose your search term is ( (term1) AND (term2) AND (term3))
#Then the, results URL for that search is
#. https://pubmed.ncbi.nlm.nih.gov/?term=%28%28term1%29+AND+%28term2%29%29+AND+%28term3%29


#open paranthesis = %28
#close paranthesis = %29

# Given a list of terms say from a CSV file,
#first we need to construct the pubmed URL for the search term

#Use rvest to read html, if it has the term "zero results",
#that means we didn't find any articles related to that search term.


####LOAD PACKAGES ####
library(here)
library(rvest)
library(dplyr)
library(readr)
library(tidyr) #crossing() function
library(stringr)
library(purrr)

library(parallel)
detectCores() 8


#### load data ####

warhead_db <- read_csv(here("data", "raw_data", "warhead.csv"))


# `Compound ID` Uniprot Target Name      Smiles   `IC50 (nM)` `Assay (IC50)` `EC50 (nM)`
# <dbl> <chr>   <chr>  <chr>     <chr>    <chr>       <chr>                <dbl>
#     1             1 Q9NPI1  BRD7   BI-7273   COC1=CC… 117         BRD7 H3 Alpha…          NA
# 2             1 Q9H8M2  BRD9   BI-7273   COC1=CC… 19          BRD9-H3 Alpha…          NA
# 3             2 Q9NPI1  BRD7   BI-9564   COC1=CC… 3410        BRD7 H3 Alpha…          NA
# 4             2 Q9H8M2  BRD9   BI-9564   COC1=CC… 75          BRD9-H3 Alpha…          NA
# 5             3 Q07820  MCL1   A-1210477 CC1=NN(… NA          NA                      NA
#                                                  6             4 Q00987  MDM2   MI-1242   CNC(=O)…


ordo <- read_csv(here("data", "processed_data", "ordo_post_02.csv"))

# > head(ordo$name)
# [1] "48,XXYY syndrome"                                       "Ataxia-telangiectasia"
# [3] "Ocular albinism with late-onset sensorineural deafness" "Reticular perineurioma"
# [5] "Sclerosing perineurioma"                                "Extraneural perineurioma"


warhead_Name_crossing <- crossing(warhead_db$Name, ordo$name)
colnames(warhead_Name_crossing) <- c("term_1", "term_2")

#remove extra spaces from terms

warhead_Name_crossing$term_1 <- gsub("\\s+"," ",warhead_Name_crossing$term_1)
warhead_Name_crossing$term_2 <- gsub("\\s+"," ",warhead_Name_crossing$term_2)

# URLencode terms
t1 <- Sys.time()
warhead_Name_crossing <- warhead_Name_crossing |>
    mutate(term_1_url_encode = URLencode(term_1))
t2 <- Sys.time()
warhead_Name_crossing <- warhead_Name_crossing |>
    mutate(term_2_url_encode = URLencode(term_2))
t3 <- Sys.time()

t2 - t1 #Time difference of 1.74198 mins
t3 - t2 #Time difference of 3.138833 mins


warhead_Name_crossing <- warhead_Name_crossing |>
    mutate(url = paste0("https://pubmed.ncbi.nlm.nih.gov/?term=%28%28",
           term_1_url_encode, "+AND+", term_2_url_encode))



#### FUNCTIONS FOR GETTING RELEVANT INFO OUT OF HTML PAGE ####
get_num_results <- function(url){
    html_data <- read_html(url)
    res <- (html_data |> html_nodes("div.results-amount") |> html_text())[1]
    res <- gsub("\n", "", res)
    res <- gsub(" ", "", res)
    res
}


is_spell_check_warning_na <- function(url){
    html_data <- read_html(url)
    res <- (html_data |> html_nodes("corrected-query-warning") |> html_text())[1]
    is.na(res)
}


###### CLEAN AND TABULATE EXTERNAL INFO FOR ALL OBS ####
t4 <- Sys.time()
foo <- map(warhead_Name_crossing$url[1:10], get_num_results)
t5 <- Sys.time()


t6 <- Sys.time()
warhead_Name_crossing$is_spell_checked <- map(warhead_Name_crossing$url, is_spell_check_warning_na)
t7 <- Sys.time()

t5-t4
# Time difference of 6.900798 secs

t7 - t6


###### PARALLEL COMPUTATION #####
s <- system.time({  warhead_Name_crossing$num_results<- mclapply(warhead_Name_crossing$url,
                                    get_num_results, mc.cores = 4) })
# user  system elapsed
# 0.220   0.115   1.858

### Reduced from 6 to 2 seconds.
warhead_Name_crossing_fraxf <- warhead_Name_crossing |> filter(term_2 == "FRAXF syndrome")


warhead_Name_crossing_fraxf$num_results<- mclapply(warhead_Name_crossing_fraxf$url,
                                                                 get_num_results, mc.cores = 4)
# user  system elapsed
# 6.807   1.422  44.574

warhead_Name_crossing_fraxf$is_not_spell_checked <- mclapply(warhead_Name_crossing_fraxf$url,
                                                         is_spell_check_warning_na, mc.cores = 4)


warhead_Name_crossing_fraxf
