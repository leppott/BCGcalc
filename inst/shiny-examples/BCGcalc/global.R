# Shiny Global File

# Version ----
pkg_version <- "2.1.0.9006"

# Packages----
# nolint start
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
library(dplyr)
# library(tidyr)
library(ggplot2)
library(plotly)
library(readxl)
library(httr)
library(reshape2)
library(knitr)
library(leaflet)
library(rioja)   # MTTI model predict
library(zip)
library(StreamCatTools)
library(nhdplusTools)
library(ComplexUpset)
library(MazamaSpatialUtils) # ecoregion assignment
library(openxlsx)
# MTTI
# library(plyr)
# library(dplyr)
# library(tidyr)
# library(tibble)
# nolint end

# Source ----

# Helper Functions ----
source(file.path("scripts", "helper_functions.R"))

## tabs ----
# sourced in global.R
# ref in db_main_body.R
# menu in db_main_sb.R
db_main_sb                     <- source("external/db_main_sb.R"
                                         , local = TRUE)$value
db_main_body                   <- source("external/db_main_body.R"
                                        , local = TRUE)$value
tab_code_about                 <- source("external/tab_about.R" 
                                         , local = TRUE)$value
tab_code_import                <- source("external/tab_import.R"
                                         , local = TRUE)$value
tab_code_filebuilder           <- source("external/tab_filebuilder.R"
                                         , local = TRUE)$value
tab_code_filebuilder_taxatrans <- source("external/tab_filebuilder_taxatrans.R"
                                         , local = TRUE)$value
tab_code_filebuilder_indexclass <- source(
                                         "external/tab_filebuilder_indexclass.R"
                                         , local = TRUE)$value
tab_code_filebuilder_indexclassparam <- source(
                                    "external/tab_filebuilder_indexclassparam.R"
                                         , local = TRUE)$value
tab_code_filebuilder_mergefiles <- source(
                                         "external/tab_filebuilder_mergefiles.R"
                                         , local = TRUE)$value
tab_code_calc_bcg              <- source("external/tab_calc_bcg.R"
                                         , local = TRUE)$value
tab_code_calc_thermalmetrics   <- source("external/tab_calc_thermalmetrics.R"
                                         , local = TRUE)$value
tab_code_calc_thermalfuzzy     <- source("external/tab_calc_thermalfuzzy.R"
                                         , local = TRUE)$value
tab_code_calc_mtti             <- source("external/tab_calc_mtti.R"
                                         , local = TRUE)$value
tab_code_calc_bdi              <- source("external/tab_calc_bdi.R"
                                         , local = TRUE)$value
tab_code_calc_fishthermalclass <- source("external/tab_calc_fishthermalclass.R"
                                         , local = TRUE)$value
tab_code_map                   <- source("external/tab_map.R"
                                         , local = TRUE)$value
tab_code_rep_single            <- source("external/tab_report_single.R"
                                         , local = TRUE)$value
tab_code_rep_multi             <- source("external/tab_report_multi.R"
                                         , local = TRUE)$value
tab_code_resources             <- source("external/tab_resources.R"
                                         , local = TRUE)$value
tab_code_troubleshoot          <- source("external/tab_troubleshoot.R"
                                         , local = TRUE)$value


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

# File and Folder Names ----
abr_filebuilder <- "FB"
abr_taxatrans   <- "TaxaTranslator"
abr_classparam  <- "ClassParam"
abr_classassign <- "ClassAssign"
abr_mergefiles  <- "MergeFiles"
abr_bcg         <- "BCG"
abr_tmet        <- "ThermMet"
abr_fuzzy       <- "FuzzyTemp"
abr_mtti        <- "MTTI"
abr_bdi         <- "BDI"
abr_bsti        <- "BSTI"
abr_map         <- "map"
abr_report      <- "report"
abr_results     <- "results"

dn_files_input  <- "_user_input"
dn_files_ref    <- "reference"
dn_files_fb     <- paste(abr_results, abr_filebuilder, sep = "_")
dn_files_bcg    <- paste(abr_results, abr_bcg, sep = "_")
dn_files_tmet   <- paste(abr_results, abr_tmet, sep = "_")
dn_files_fuzzy  <- paste(abr_results, abr_fuzzy, sep = "_")
dn_files_mtti   <- paste(abr_results, abr_mtti, sep = "_")
dn_files_bdi    <- paste(abr_results, abr_bdi, sep = "_")
dn_files_bsti   <- paste(abr_results, abr_bsti, sep = "_")
dn_files_report <- paste(abr_results, abr_report, sep = "_")

# Selection Choices----
sel_community <- c("bugs", "fish", "algae")

##  BCG Models ----
url_bcg_base <- "https://github.com/leppott/BCGcalc/raw/main/inst/extdata"

url_bcg_models <- file.path(url_bcg_base, "Rules.xlsx")
httr::GET(url_bcg_models, httr::write_disk(temp_bcg_models <- tempfile(fileext = ".xlsx")))

df_bcg_models <- as.data.frame(readxl::read_excel(temp_bcg_models
                                                  , guess_max = 10^3
                                                  , sheet = "Rules"))
sel_bcg_models <- sort(unique(df_bcg_models$Index_Name))

## Metric Suites
sel_metric_suites <- ("ThermalHydro")

## URL BioMonTools
url_bmt_base <- "https://github.com/leppott/BioMonTools_SupportFiles/raw/main/data"

# BMT, Flags ----
url_bcg_checks <- file.path(url_bcg_base, "MetricFlags.xlsx")
httr::GET(url_bcg_checks
    , httr::write_disk(temp_bcg_checks <- tempfile(fileext = ".xlsx")))

df_checks <- as.data.frame(readxl::read_excel(temp_bcg_checks, sheet = "Flags"))

# BMT, Taxa Official Pick----
url_taxa_official_pick <- file.path(url_bmt_base
                                    , "taxa_official"
                                    , "_pick_files.csv")
httr::GET(url_taxa_official_pick
    , httr::write_disk(temp_taxa_official_pick <- tempfile(fileext = ".csv")))

df_pick_taxoff <- read.csv(temp_taxa_official_pick)

# BMT, Index Class ----
url_indexclass_crit <- file.path(url_bmt_base
                                 , "index_class"
                                 , "IndexClass.xlsx")
httr::GET(url_indexclass_crit
    , httr::write_disk(temp_indexclass_crit <- tempfile(fileext = ".xlsx")))

df_indexclass_crit <- readxl::read_excel(temp_indexclass_crit
                                         , sheet = "Index_Class")

## Index Class, Index Names----
sel_indexclass_indexnames <- sort(unique(df_indexclass_crit[, "INDEX_NAME"
                                                            , TRUE]))

## Index Class, Index Names----
sel_indexclass_params <- sort(unique(df_indexclass_crit[, "FIELD"
                                                            , TRUE]))

# BMT, Metric Names ----
url_bmt_pkg <- "https://github.com/leppott/BioMonTools/raw/main/inst/extdata"
url_metricnames <- file.path(url_bmt_pkg, "MetricNames.xlsx")
httr::GET(url_metricnames
    , httr::write_disk(temp_metricnames <- tempfile(fileext = ".xlsx")))

df_metricnames <- readxl::read_excel(temp_metricnames
                                     , sheet = "MetricMetadata"
                                     , skip = 4)

# BMT, Fuzzy Therm Narrative ----
url_fuzzytherm_crit <- file.path(url_bmt_base
                                 , "fuzzythermal"
                                 , "FuzzyTherm_ScoringScale.xlsx")
httr::GET(url_fuzzytherm_crit
    , httr::write_disk(temp_fuzzytherm_crit <- tempfile(fileext = ".xlsx")))

df_fuzzytherm_crit <- readxl::read_excel(temp_fuzzytherm_crit
                                         , sheet = "Current")

# EPSG ----
epsg_wgs84 <- 4326
epsg_nad83_na <- 4269
epsg_default <- epsg_nad83_na

# Map ----
map_datatypes <- c("BCG"
                   , "Fuzzy Temp Model"
                   , "MTTI"
                   , "BDI"
                   , "Thermal Metrics, nt_ti_stenocold"
                   , "Thermal Metrics, nt_ti_stenocold_cold"
                   , "Thermal Metrics, nt_ti_stenocold_cold_cool"
                   , "Thermal Metrics, pt_ti_stenocold_cold_cool"
                   , "Thermal Metrics, pi_ti_stenocold_cold_cool"
                   , "Thermal Metrics, pt_ti_warm_stenowarm"
                   , "Thermal Metrics, nt_ti_warm_stenowarm"
                   )

fn_map_meta <- "BCGcalc_Shiny_map_inputs_20230828.xlsx"
map_meta <- as.data.frame(readxl::read_excel(file.path(path_data, fn_map_meta)
                                             , sheet = "field_names"
                                             , skip = 7))

# Report ----

