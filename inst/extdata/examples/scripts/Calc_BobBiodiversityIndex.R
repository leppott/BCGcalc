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
library(lazyeval)
library(BioMonTools)

# Data ----
# wd <-'C:/Users/Jen.Stamp/Documents/R_BioMonTools'
# setwd(wd)

df_data <- read.csv("~/R_BioMonTools/BobBDVI_20230205.csv")


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

df_example <- markExcluded(df_data, SampID = "SampleID", TaxaID = "TaxaID", TaxaCount =  "N_Taxa"
                           , Exclude = "Exclude", TaxaLevels = TaxaLevels, Exceptions = NA)

write.csv(df_example, "BobBDVI_wExclude_20230206.csv")



# Calculate Metrics of Interest

# Load libraries
library(readxl)
library(knitr)
library(BioMonTools)

# set working directory
wd <-'C:/Users/Jen.Stamp/Documents/R_BioMonTools'
setwd(wd)

# load data
df.data <- read.csv("C:/Users/Jen.Stamp/Documents/R_BioMonTools/BobBDVI_wExclude_20230206.csv")


# Calculate Bob's BioDiversity Index

library(devtools) 
library(BioMonTools)
library(readxl)
library(reshape2)

help(package = "BioMonTools")

# Thresholds (came with package installation, in the MetricScoring Excel file in the extdata folder)
fn_thresh <- file.path(system.file(package = "BioMonTools"), "extdata", "MetricScoring.xlsx")
df_thresh_metric <- read_excel(fn_thresh, sheet = "metric.scoring")
df_thresh_index <- read_excel(fn_thresh, sheet = "index.scoring")


# Directory
# dn_rp <- "C:/Users/Jen.Stamp/Documents/R_code/BCGcalc"
dn_rp <- getwd()

# File
fn_rp <- "BobBDVI_wExclude_20230206.csv"
fp_rp <- file.path(dn_rp, fn_rp)
df_rp <- read.csv(fp_rp)


# calculate metrics for Bob's Biodiversity Index; limit output to index input metrics only
myIndex <- "BCG_PacNW_L1"
df_rp$INDEX_NAME   <- myIndex
df_rp$INDEX_REGION <- "ALL"
(myMetrics.Bugs <- unique(as.data.frame(df_thresh_metric)[df_thresh_metric[,"INDEX_NAME"] == myIndex,"METRIC_NAME"]))


# tell R to ignore these fields so you don't get a warning. Just added this. Not sure it will work yet.
df_rp[, c("FFG2", "TOLVAL2")] <- NA


# Run Function - YOU'LL NEED TO STOP TO ANSWER YES (1)
df_metric_values_bugs <- metric.values(df_rp, "bugs", fun.MetricNames = myMetrics.Bugs)


# index to BCG_PacNW_L1
df_metric_values_bugs$INDEX_NAME <- myIndex
df_metric_values_bugs$INDEX_REGION <- "ALL"


# SCORE Metrics
df_metric_scores_bugs <- metric.scores(df_metric_values_bugs
                                       , myMetrics.Bugs
                                       , "INDEX_NAME"
                                       , "INDEX_CLASS"
                                       , df_thresh_metric
                                       , df_thresh_index)


# Create csv file with Results
write.csv(df_metric_scores_bugs, "BobBDVI_Results.csv")

# QC, table
table(df_metric_scores_bugs$Index, df_metric_scores_bugs$Index_Nar)

