# Pacific Maritime Northwest Region BCG model
# Jen.Stamp@tetratech.com
# 2023-02-06
#~~~~~~~~~~~~~~~~~
# Calculate Fuzzy Thermal Model
#~~~~~~~~~~~~~~~~

# # STEP 1 (optional) Install BCGcalc if needed
# if (!require(remotes)) {install.packages("remotes")}  #install if needed
# install_github("leppott/BCGcalc", force = TRUE)
# 
# # STEP 2 (optional) Install BioMonTools if needed
# if (!require(remotes)) {install.packages("remotes")}  #install if needed
# install_github("leppott/BioMonTools", force = TRUE)


# STEP 3 - Mark redundant taxa (this will add the 'Exclude - TRUE/FALSE' column to the input file)
# these taxa are potentially redundant (non-distinct) and will be excluded from the richness metric calculations

# Packages ----
library(readxl)
library(knitr)
library(dplyr)
library(lazyeval)
library(BioMonTools)

# Data ----
wd <-'C:/Users/Jen.Stamp/Documents/R_BCGcalc'
setwd(wd)

df_data <- read.csv("~/R_BCGcalc/Test1_ThermPrefMetric_input.csv")


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

write.csv(df_example, "Test1_ThermPrefMetric_wExclude_20230206.csv")


# STEP 4 - Run data through BCG model.

#Packages
#library(devtools)
library(BioMonTools)
library(BCGcalc)
library(readxl)
library(reshape2)
library(knitr)

#run this if you want to run the Shiny version locally on your computer. 
BCGcalc::runShiny()

# Directory
# dn_rp <- "C:/Users/Jen.Stamp/Documents/R_code/BCGcalc"
#dn_MariNW <- getwd()
dn_MariNW <- "C:/Users/Jen.Stamp/Documents/R_BCGcalc"
dn_MariNW <- getwd()

# File
#fn_MariNW <- "_Input_HiGradLoElev_20211129.csv" # added CSV extension
fn_MariNW <- "Test1_ThermPrefMetric_wExclude_20230206.csv"
fp_MariNW <- file.path(dn_MariNW, fn_MariNW)

#df_MariNW <- read.csv(fp_MariNW)

#from BioMonTools
df_MariNW <- read.csv(fp_MariNW
                      , stringsAsFactors = FALSE
                      , colClasses = c("BCG_Attr" = "character"))

# Visually Check First 6 Rows of Input File (as a QC step, to make sure it looks correct)
nrow_MariNW <- nrow(df_MariNW)
ncol_MariNW <- ncol(df_MariNW)
MariNW_size <- paste0(nrow_MariNW, " rows, ", ncol_MariNW, " rows.")
View(head(df_MariNW))

# Index Name and Region flipped
#df_MariNW$INDEX_NAME <- "BCG_MariNW_Bugs500ct"
#df_MariNW$INDEX_REGION <- "HiGrad-LoElev"


# QC sample size. Target # organisms is 500
sampsize <- aggregate(df_MariNW$N_TAXA
                      , list(SampleID = df_MariNW$SampleID)
                      , sum
                      , na.rm = TRUE)
# N_Taxa to upper case
#View(sampsize)
summary(sampsize) # added for additional summary

# with the recent updates, R is now programmed to look for INDEX_REGION; 
# but this command tells it to look for SITE_TYPE instead
# Erik - I commented this out because I entered INDEX_REGION. 
# Hopefully this doesn't screw things up.
#df_MariNW$INDEX_REGION <- df_MariNW$SITE_TYPE

# tell R to ignore these fields so you don't get a warning
df_MariNW[, c("FFG2", "TOLVAL2")] <- NA
# Add more columns so don't get warning
col2NA <- c("SUBPHYLUM", "INFRAORDER", "TOLVAL", "LONGLIVED", "UFC")
df_MariNW[, col2NA] <- NA

# Columns to keep. 
# if available, include these others as well (they are used in flagging)
#col2keep <- c("Site_Type", "Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2")
#JS - the entries below are tied to flags if included in the input file 
# but I want to leave them as optional for now
#col2keep <- c("pcSLOPE", "DrArea_mi2", "CollMonth", "SfcArea_ft2", "LTR"
#             , "Subsample_percent", "Density_m2")


#Calculate an output with selected metrics
#Important note: the Flag function below won't work properly unless you include 
# the flag metrics

col.met2keep <- c("ni_total", "nt_total", "pi_dom01", "pi_dom02", "nt_ti_stenocold"
  , "nt_ti_cold", "nt_ti_cool", "nt_ti_cowa", "nt_ti_warm", "nt_ti_stenowarm", "nt_ti_eury", "nt_ti_stenocold_cold"
  , "nt_ti_stenocold_cold_cool", "nt_ti_cowa_warm_stenowarm", "nt_ti_warm_stenowarm"
  , "nt_ti_na", "pi_ti_stenocold", "pi_ti_cold", "pi_ti_cool"
  , "pi_ti_cowa", "pi_ti_warm", "pi_ti_stenowarm", "pi_ti_eury"
  , "pi_ti_stenocold_cold", "pi_ti_stenocold_cold_cool", "pi_ti_cowa_warm_stenowarm"
  , "pi_ti_warm_stenowarm", "pi_ti_na", "pt_ti_stenocold"
  , "pt_ti_cold", "pt_ti_cool", "pt_ti_cowa", "pt_ti_warm"
  , "pt_ti_stenowarm", "pt_ti_eury", "pt_ti_stenocold_cold"
  , "pt_ti_stenocold_cold_cool", "pt_ti_cowa_warm_stenowarm", "pt_ti_warm_stenowarm"
  , "pt_ti_na")


# Erik, change name of ffg col_filt

# Met Val ----
# calculate selected metrics - Run Function
df_met_val <- metric.values(df_MariNW
                            , "bugs"
                           # , fun.cols2keep = col2keep
                            , fun.MetricNames = col.met2keep)

#WAIT to run this until you get through the Yes/No prompt. calculate selected metrics - Save
write.table(df_met_val, "Test1_ThermPrefMetrics.Values.tsv"
            , row.names = FALSE, col.names = TRUE, sep = "\t")

#OPTIONAL - run this command to get an output with all the metrics (vs. limiting to the 15 listed above); you need to run this, otherwise the R code will fail because it will be missing some of the flag metrics
#col2keep <- "Site_Type"
#df_MariNW$Site_Type <- df_MariNW$INDEX_REGION
#df_met_val <- metric.values(df_MariNW, "bugs") #, fun.cols2keep = col2keep)

#OPTIONAL - Save
#write.table(df_met_val, file.path(dn_MariNW, "Test1_BCGcalc.AllMetric.Values.tsv")
#            , row.names = FALSE, col.names = TRUE, sep = "\t")

# Erik, move to data dir

# Flags (metrics) - this directs R to the extdata folder and tells it to look at the MetricFlags Excel file
df_checks <- read_excel(system.file("./extdata/MetricFlags.xlsx"
                                  , package = "BCGcalc"), sheet = "Flags")

# 2021-12-20, Index_Region to upper
#df_checks$Index_Region <- toupper(df_checks$Index_Region)
df_checks$INDEX_CLASS <- toupper(df_checks$INDEX_CLASS)

# Erik
# Ensure have all "flag" metrics in met_val
check_metrics <- unique(df_checks[df_checks$Index_Name == "Therm_ORWA_Bugs500ct", "Metric_Name", TRUE])
check_metrics[!check_metrics %in% names(df_met_val)]
# check original data
check_metrics[!check_metrics %in% names(df_met_val)] %in% names(df_MariNW)
# no matches so add to df_met_val
col2add <- check_metrics[!check_metrics %in% names(df_met_val)]
df_met_val[, col2add] <- NA
## 2021-12-20, all present but code does no harm if nothing to add

## fix caps issue. View df_check vs df_met_value. one is all caps, the other first letter cap
#df_checks$INDEX_NAME<-df_checks$Index_Name
#df_checks$INDEX_REGION<-df_checks$Index_Region
#df_checks <- df_checks[!names(df_checks) %in% c("Index_Name", "Index_Region")]

# Calculate Flags
df_flags <- qc.checks(df_met_val, df_checks)

# Change terminology; PASS/FAIL to NA/flag
df_flags[, "FLAG"][df_flags[, "FLAG"] == "FAIL"] <- "flag"
df_flags[, "FLAG"][df_flags[, "FLAG"] == "PASS"] <- NA

# long to wide format
df_flags_wide <- dcast(df_flags, SAMPLEID ~ CHECKNAME, value.var = "FLAG")

# Calc number of "flag"s by row.
df_flags_wide$NumFlags <- rowSums(df_flags_wide == "flag", na.rm = TRUE)

# Rearrange columns
NumCols <- ncol(df_flags_wide)
df_flags_wide <- df_flags_wide[, c(1, NumCols, 2:(NumCols - 1))]

# Summarize Results
df_flag_summary <- table(df_flags[,"CHECKNAME"]
                         , df_flags[, "FLAG"]
                         , useNA = "ifany")
kable(df_flag_summary, caption = "Flag summary.")
View(df_flag_summary)

# BCG, Metric Memb ----
# Calculate Metric Scores (BCG)
# this directs R to the extdata folder and tells it to look at the Rules Excel file
df_rules <- read_excel(system.file("./extdata/Rules.xlsx"
                                   , package = "BCGcalc"), sheet = "Rules") 
# Erik, change sheet name

# Tell R to look for the Site_Type column instead of an Index_Region column (rules vary slightly btw hi vs. lo)
#Erik - I commented this out because I entered INDEX_REGION. Hopefully this doesn't screw things up.
#df_rules$Index_Region <- df_rules$Site_Type

# Erik, BCGcalc still using Site_Type
df_met_val$SITE_TYPE <- df_met_val$INDEX_REGION

# Run function
df_met_memb <- BCG.Metric.Membership(df_met_val, df_rules)

# Save Results
write.table(df_met_memb
            , file.path(dn_MariNW, "Test1_FuzzyTemp.Metric.Membership.tsv")
            , row.names = FALSE, col.names = TRUE, sep = "\t")
# Erik, added file.path

# BCG, Level Memb----
# Calculate Level Memberships
df_lev_memb <- BCG.Level.Membership(df_met_memb, df_rules)

# BCG, Level Assignment----
# Assign Levels
df_levels <- BCG.Level.Assignment(df_lev_memb)

# Merge Levels and Flags
df_levels_flags <- merge(df_levels, df_flags_wide
                         , by.x = "SampleID"
                         , by.y = "SAMPLEID"
                         , all.x = TRUE)

# Save Results
write.csv(df_levels_flags
          , file.path(dn_MariNW, "Test1_FuzzyTemp.Levels.Flags.csv"))


# Summary ---- 
# Display number of each level
df_summary_levels <- table(df_levels_flags$Primary_BCG_Level
                           , df_levels_flags$Secondary_BCG_Level
                           , useNA = "ifany")
knitr::kable(df_summary_levels
             , caption = "Level assignments (1st on Left, 2nd on Top) (NA are no 2nd).")

