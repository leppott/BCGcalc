#Calculate Bob's BioDiversity Index (MaritimeNW)
# Jen.Stamp@tetratech.com
# 2023-02-06
#~~~~~~~~~~~~~~~~~

# # STEP 1 (optional) Install BioMonTools if needed
# if (!require(remotes)) {install.packages("remotes")}  #install if needed
# install_github("leppott/BioMonTools", force = TRUE)

# STEP 2 - Mark redundant taxa (this will add the 'Exclude - TRUE/FALSE' column to the input file)
# these taxa are potentially redundant (non-distinct) and will be excluded from the richness metric calculations

# Package ----
library(readxl)
library(knitr)
library(dplyr)
library(BioMonTools)
library(reshape2)

# Data ----
fn_data <- "TestData_Calc_BobBDVI.csv"
dn_data <- file.path(tempdir(), "examples", "data")
dn_output <- file.path(tempdir(), "examples", "results")
path_data <- file.path(dn_data, fn_data)

df_data <- read.csv(path_data)


SampID     <- "SampleID"
TaxaID     <- "TaxaID"
TaxaCount  <- "N_Taxa"
Exclude    <- "Exclude"
TaxaLevels <- c("Phylum"
                , "Class"
                , "Order"
                , "Family"
                , "SubFamily"
                , "Tribe"
                , "Genus")
Exceptions <- NA

df_example <- BioMonTools::markExcluded(df_data
                           , SampID = "SampleID"
                           , TaxaID = "TaxaID"
                           , TaxaCount =  "N_Taxa"
                           , Exclude = "Exclude"
                           , TaxaLevels = TaxaLevels
                           , Exceptions = NA)
# Save Results
fn_met_memb <- "Test1_BCGcalc.Metric.Membership.tsv"
fn_input_base <- tools::file_path_sans_ext(fn_data)
fn_excl <- paste0(fn_input_base, "_wExclude.csv")
path_excl <- file.path(dn_output, fn_excl)
write.csv(df_example, path_excl)


# Calculate Metrics ----

# File


# Calculate Bob's BioDiversity Index

# Thresholds (came with package installation, in the MetricScoring Excel file in the extdata folder)
fn_thresh <- file.path(system.file(package = "BioMonTools"), "extdata", "MetricScoring.xlsx")
df_thresh_metric <- read_excel(fn_thresh, sheet = "metric.scoring")
df_thresh_index <- read_excel(fn_thresh, sheet = "index.scoring")

# load data
## use excluded taxa output
path_rp <- path_excl
df_rp <- read.csv(path_data, stringsAsFactors = FALSE)


# calculate metrics for Bob's Biodiversity Index; 
# limit output to index input metrics only
myIndex <- "BCG_PacNW_L1"
df_rp$INDEX_NAME   <- myIndex
df_rp$INDEX_REGION <- "ALL"
(myMetrics.Bugs <- unique(as.data.frame(df_thresh_metric)[df_thresh_metric[,"INDEX_NAME"] == myIndex,"METRIC_NAME"]))


# tell R to ignore these fields so you don't get a warning
col2NA_char <- c("SUBPHYLUM", "SUBCLASS", "INFRAORDER", "HABIT", "LIFE_CYCLE"
                 , "FFG2", "HABITAT", "ELEVATION_ATTR", "GRADIENT_ATTR"
                 , "WSAREA_ATTR", "HABSTRUCT", "BCG_ATTR2")
col2NA_num <- c("TOLVAL", "TOLVAL2", "UFC")
col2NA_boo <- ("AIRBREATHER")
df_rp[, col2NA_char] <- NA_character_
df_rp[, col2NA_num] <- NA_real_
df_rp[, col2NA_boo] <- NA


# Run Function - YOU'LL NEED TO STOP TO ANSWER YES (1)
df_metric_values_bugs <- metric.values(df_rp
                                       , "bugs"
                                       , fun.MetricNames = myMetrics.Bugs)

#~~~~~~~~~~~~
#WAIT to run this until you get through the Yes/No prompt. 
#~~~~~~~~~~~~~


# SCORE Metrics ----
df_metric_scores_bugs <- metric.scores(DF_Metrics = df_metric_values_bugs
                                       , col_MetricNames = myMetrics.Bugs
                                       , col_IndexName = "INDEX_NAME"
                                       , col_IndexRegion = "INDEX_CLASS"
                                       , DF_Thresh_Metric = df_thresh_metric
                                       , DF_Thresh_Index = df_thresh_index)


# Create csv file with Results
fn_results <- "BobBDVI_Results.csv"
path_results <- file.path(dn_output, fn_results)
write.csv(df_metric_scores_bugs, path_results, row.names = FALSE)

#~~~~~~~~~~~~
# QC, table
table(df_metric_scores_bugs$Index, df_metric_scores_bugs$Index_Nar)
#~~~~~~~~~~~~

