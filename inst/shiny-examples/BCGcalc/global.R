# Shiny Global File

# Version ----
pkg_version <- "1.3.5.9010"

# Packages----
library(BCGcalc)
library(BioMonTools)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus) # only using for footer
library(shinyjs)
#library(shinyWidgets)
library(shinyBS)
library(DT)
# masks shinydashboardPlus::progressBar
# masks shinyjs::alert
# library(dplyr)
# library(tidyr)
library(ggplot2)
library(plotly)
library(readxl)
library(httr)
library(reshape2)
library(knitr)

# Source ----
db_main_sb       <- source("external/db_main_sb.R", local = TRUE)$value
db_main_body     <- source("external/db_main_body.R", local = TRUE)$value
tab_code_about   <- source("external/tab_about.R", local = TRUE)$value
tab_code_import  <- source("external/tab_import.R", local = TRUE)$value
tab_code_calcbcg <- source("external/tab_calcbcg.R", local = TRUE)$value

# Console Message ----
message(paste0("Interactive: ", interactive()))

# File Size ----
# By default, the file size limit is 5MB.
mb_limit <- 200
options(shiny.maxRequestSize = mb_limit * 1024^2)

# Folders----
path_data <- file.path("data")
path_results <- file.path("results")

# ensure results folder exists
if (dir.exists(path_results) == FALSE) {
  dir.create(path_results)
} else {
  message(paste0("Directory already exists; ", path_data))
}## IF ~ dir.exists

# create results subfolders
# dir_results_sub <- c("data")
# for (i in dir_results_sub){
#   dir_new <- file.path("results", i)
#   if (dir.exists(dir_new) == FALSE) {
#     dir.create(dir_new)
#   } else {
#     message(paste0("Directory already exists; ", i))
#   }## IF ~ dir.exists
# }## FOR ~ i

# Selection Choices----
sel_community <- c("bugs", "fish", "algae")

##  BCG Models ----
url_bcg_models <- "https://github.com/leppott/BCGcalc/raw/main/inst/extdata/Rules.xlsx"
GET(url_bcg_models, write_disk(temp_bcg_models <- tempfile(fileext = ".xlsx")))
df_bcg_models <- as.data.frame(read_excel(temp_bcg_models
                                          , guess_max = 10^3
                                          , sheet = "Rules"))
sel_bcg_models <- sort(unique(df_bcg_models$Index_Name))

# Flags ----
url_bcg_checks <- "https://github.com/leppott/BCGcalc/raw/main/inst/extdata/MetricFlags.xlsx"
GET(url_bcg_checks, write_disk(temp_bcg_checks <- tempfile(fileext = ".xlsx")))
df_checks <- as.data.frame(readxl::read_excel(temp_bcg_checks, sheet="Flags"))
