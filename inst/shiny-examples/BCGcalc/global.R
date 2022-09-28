# Shiny Global File

# Version ----
pkg_version <- "1.3.5.9004"

# Packages----
library(BCGcalc)
library(BioMonTools)
library(shiny)
#library(shinydashboard)
#library(shinydashboardPlus)
library(shinyjs)
#library(shinyWidgets)
#library(shinyBS)
library(DT)
# masks shinydashboardPlus::progressBar
# masks shinyjs::alert
# library(dplyr)
# library(tidyr)
# library(ggplot2)
# library(plotly)
library(readxl)
library(httr)
library(reshape2)

# Source ----
sb_main            <- source("external/sb_main.R", local = TRUE)$value
db_main            <- source("external/db_main.R", local = TRUE)$value
tab_code_about     <- source("external/tab_about.R", local = TRUE)$value
tab_code_import    <- source("external/tab_import.R", local = TRUE)$value
tab_code_calcbcg   <- source("external/tab_calcbcg.R", local = TRUE)$value

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
  message(paste0("Directory already exists; ", i))
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
