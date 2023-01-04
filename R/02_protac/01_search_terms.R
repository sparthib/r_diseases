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


#Try it with one term

####load html ####
url <- "https://pubmed.ncbi.nlm.nih.gov/?term=%28%28hashimoto%29+"

html_data <- read_html(url)

##we want to grab the title text ####

res <- (html_data |> html_nodes("div.results-amount") |> html_text())[1]



####LOAD PACKAGES ####
library(here)
library(rvest)
library(dplyr)
library(readr)
library(tidyr) #crossing() function
library(stringr)
library(purrr)



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


warhead_Name_crossing$url <- warhead_Name_crossing |>
    mutate("https://pubmed.ncbi.nlm.nih.gov/?term=%28%28",
           term_1_url_encode, "+AND+", term_2_url_encode)

##task: make sure spell-check is off




