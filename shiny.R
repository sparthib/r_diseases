###### LOAD PACKAGES ######
library(shiny)
library(readr)
library(here)


##### LOAD DATASETS #######

protac_db <- read_csv(here("data", "raw_data", "protac.csv"))
ordo <- read_csv(here("data", "processing_data", "ordo_post_03.csv"))


#### OUTLINE ####
ui <- fluidPage(

    selectInput(inputId = "varname",
                label = "Choose a variable",
                choices = colnames(cars_info)[c(2, 6, 7)])

    tableOutput())
)

#2 define server instructions
server <- function(input, output) {




}

#3 putting everything together
shinyApp(ui = ui, server = server)
