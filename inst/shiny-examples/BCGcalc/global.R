# Shiny Global File

# Version ----
pkg_version <- "2.0.0.9018"

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
db_main_sb           <- source("external/db_main_sb.R", local = TRUE)$value
db_main_body         <- source("external/db_main_body.R", local = TRUE)$value
tab_code_about       <- source("external/tab_about.R", local = TRUE)$value
tab_code_import      <- source("external/tab_import.R", local = TRUE)$value
tab_code_filebuilder <- source("external/tab_filebuilder.R", local = TRUE)$value
tab_code_taxatrans <- source("external/tab_taxatrans.R", local = TRUE)$value
tab_code_assignindexclass <- source("external/tab_assignindexclass.R"
                                    , local = TRUE)$value
tab_code_calc_bcg    <- source("external/tab_calc_bcg.R", local = TRUE)$value
tab_code_calc_thermalmetrics <- source("external/tab_calc_thermalmetrics.R"
                                    , local = TRUE)$value
tab_code_calc_thermalfuzzy <- source("external/tab_calc_thermalfuzzy.R"
                                , local = TRUE)$value
tab_code_calc_mtti <- source("external/tab_calc_mtti.R", local = TRUE)$value
tab_code_calc_biodivind <- source("external/tab_calc_biodivind.R"
                                  , local = TRUE)$value
tab_code_rep_ss_ss   <- source("external/tab_report_singlesite_singlesamp.R"
                               , local = TRUE)$value
tab_code_rep_ss_ms   <- source("external/tab_report_singlesite_multisamp.R"
                               , local = TRUE)$value
tab_code_rep_ms      <- source("external/tab_report_multiplesite.R"
                            , local = TRUE)$value
tab_code_resources   <- source("external/tab_resources.R", local = TRUE)$value

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
url_bcg_base <- "https://github.com/leppott/BCGcalc/raw/main/inst/extdata"

url_bcg_models <- file.path(url_bcg_base, "Rules.xlsx")
GET(url_bcg_models, write_disk(temp_bcg_models <- tempfile(fileext = ".xlsx")))
df_bcg_models <- as.data.frame(read_excel(temp_bcg_models
                                          , guess_max = 10^3
                                          , sheet = "Rules"))
sel_bcg_models <- sort(unique(df_bcg_models$Index_Name))

## Metric Suites
sel_metric_suites <- c("ThermalHydro")

# Flags ----
url_bcg_checks <- file.path(url_bcg_base, "MetricFlags.xlsx")
GET(url_bcg_checks, write_disk(temp_bcg_checks <- tempfile(fileext = ".xlsx")))
df_checks <- as.data.frame(readxl::read_excel(temp_bcg_checks, sheet="Flags"))

# Taxa Official Pick----
url_bmt_sf_taxoff <- "https://github.com/leppott/BioMonTools_SupportFiles/raw/main/data/taxa_official"
url_taxa_official_pick <- file.path(url_bmt_sf_taxoff, "_pick_files.csv")
GET(url_taxa_official_pick, write_disk(temp_taxa_official_pick <- tempfile(fileext = ".csv")))
df_pick_taxoff <- read.csv(temp_taxa_official_pick)

