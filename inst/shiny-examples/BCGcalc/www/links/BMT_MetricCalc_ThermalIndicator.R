# Jen Stamp for BCGcalc Shiny app, thermal indicators metric calc 
# Jen.Stamp@tetratech.com, 10/10/2022

# STEP 1 - Install BioMonTools if needed (Optional) ----
if(!require(remotes)){install.packages("remotes")}  #install if needed
if(!require(BioMonTools)){install_github("leppott/BioMonTools", force=TRUE)}


# Packages ----
#library(readxl)
library(knitr)
library(dplyr)
library(lazyeval)
library(BioMonTools)

# Working Directory ----
# wd <-'C:/Users/Jen.Stamp/Documents/ThermPrefMetrics'
# setwd(wd)

# STEP 2 - Mark redundant taxa ----
# (this will add the 'Exclude - TRUE/FALSE' column to the input file)
# these taxa are potentially redundant (non-distinct) and will be excluded from the richness metric calculations

df_data <- read.csv("Input_ti_test_20221010.csv")

SampID     <- "SampleID"
TaxaID     <- "TaxaID"
TaxaCount  <- "N_Taxa"
Exclude    <- "Exclude"
TaxaLevels <- c("Phylum"
                , "Class"
                , "Subclass"      
                , "Order"
                , "Suborder"             
                , "Superfamily"  
                , "Family"
                , "SubFamily"
                , "Tribe"
                , "Genus")

Exceptions <- NA

df_example <- markExcluded(df_data, SampID="SampleID", TaxaID="TaxaID", TaxaCount= "N_Taxa"
                           , Exclude="Exclude", TaxaLevels=TaxaLevels, Exceptions=NA)

write.csv(df_example, "Input_ti_test_wExclude_20221010.csv")


# STEP 3 - Calculate Metrics of Interest ----
# take the output csv file coming from the previous step (mark redundant taxa)
# and calculate the thermal indicator metrics

# load data
df.data <- read.csv("Input_ti_test_wExclude_20221010.csv")


fun.MetricNames <- c(
  "ni_total"
  , "nt_total"
  , "nt_ti_stenocold"
  , "nt_ti_cold"
  , "nt_ti_cool"
  , "nt_ti_cowa"
  , "nt_ti_warm"
  , "nt_ti_stenowarm"
  , "nt_ti_eury"
  , "nt_ti_stenocold_cold"
  , "nt_ti_stenocold_cold_cool"
  , "nt_ti_cowa_warm_stenowarm"
  , "nt_ti_warm_stenowarm"
  , "nt_ti_na"
  , "pi_ti_stenocold"
  , "pi_ti_cold"
  , "pi_ti_cool"
  , "pi_ti_cowa"
  , "pi_ti_warm"
  , "pi_ti_stenowarm"
  , "pi_ti_eury"
  , "pi_ti_stenocold_cold"
  , "pi_ti_stenocold_cold_cool"
  , "pi_ti_cowa_warm_stenowarm"
  , "pi_ti_warm_stenowarm"
  , "pi_ti_na"
  , "pt_ti_stenocold"
  , "pt_ti_cold"
  , "pt_ti_cool"
  , "pt_ti_cowa"
  , "pt_ti_warm"
  , "pt_ti_stenowarm"
  , "pt_ti_eury"
  , "pt_ti_stenocold_cold"
  , "pt_ti_stenocold_cold_cool"
  , "pt_ti_cowa_warm_stenowarm"
  , "pt_ti_warm_stenowarm"
  , "pt_ti_na")


df_metric_values_bugs <- metric.values(data_benthos_PacNW, fun.Community = "bugs", fun.MetricNames = fun.MetricNames)


# Run Function - will get selection prompt, need to select YES or NO

df.metval <- metric.values(df.data, "bugs"
                           , fun.MetricNames = fun.MetricNames)

# Ouput
df.metval.select <- df.metval[, c(fun.MetricNames)]

# write results
write.csv(df.metval, "Output_ti_test_20221010.csv")


