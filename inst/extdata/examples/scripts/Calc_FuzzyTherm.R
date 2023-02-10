# Pacific Maritime Northwest Region BCG model
# Jen.Stamp@tetratech.com
# 2023-02-06
#~~~~~~~~~~~~~~~~~
# Calculate Fuzzy Thermal Model
#~~~~~~~~~~~~~~~~
# Run this if you want to run the Shiny version locally on your computer. 
# BCGcalc::runShiny()
#~~~~~~~~~~~~~~~~~

# # STEP 1 (optional) Install BCGcalc if needed
# if (!require(remotes)) {install.packages("remotes")}  #install if needed
# install_github("leppott/BCGcalc", force = TRUE)
# 
# # STEP 2 (optional) Install BioMonTools if needed
# if (!require(remotes)) {install.packages("remotes")}  #install if needed
# install_github("leppott/BioMonTools", force = TRUE)


# Packages ----
library(readxl)
library(knitr)
#library(dplyr)
#library(lazyeval)
library(BioMonTools)
library(BCGcalc)
library(reshape2)
library(knitr)

# Data ----
fn_data <- "TestData_Calc_ThermPrefMetrics.csv"
dn_data <- file.path(tempdir(), "examples", "data")
dn_output <- file.path(tempdir(), "examples", "results")
path_data <- file.path(dn_data, fn_data)

df_data <- read.csv(path_data)


# Excl Taxa ----
# STEP 3 - Mark redundant taxa (this will add the 'Exclude - TRUE/FALSE' column to the input file)
# these taxa are potentially redundant (non-distinct) and will be excluded from the richness metric calculations

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
# Save
fn_input_base <- tools::file_path_sans_ext(fn_data)
fn_excl <- paste0(fn_input_base, "_wExclude.csv")
path_excl <- file.path(dn_output, fn_excl)
write.csv(df_example, path_excl, row.names = FALSE)


# BCG, Calc ----
# STEP 4 - Run data through BCG model.

# File
## use excluded taxa output
path_MariNW <- path_excl

#from BioMonTools
df_MariNW <- read.csv(path_MariNW
                      , stringsAsFactors = FALSE)

#~~~~~~~~~
## QC, Visual ----
# Visually Check First 6 Rows of Input File (as a QC step, to make sure it looks correct)
nrow_MariNW <- nrow(df_MariNW)
ncol_MariNW <- ncol(df_MariNW)
MariNW_size <- paste0(nrow_MariNW, " rows, ", ncol_MariNW, " rows.")
View(head(df_MariNW))
#~~~~~~~~~

#~~~~~~~~~~~~~~~~
## QC sample size----
# Target # organisms is 500
sampsize <- aggregate(df_MariNW$N_TAXA
                      , list(SampleID = df_MariNW$SAMPLEID)
                      , sum
                      , na.rm = TRUE)
# N_Taxa to upper case
#View(sampsize)
summary(sampsize) # added for additional summary
#~~~~~~~~~~~~~~~~

# tell R to ignore these fields so you don't get a warning
col2NA_char <- c("SUBPHYLUM", "INFRAORDER", "FFG", "LIFE_CYCLE", "BCG_ATTR"
                 , "FFG2", "HABITAT", "ELEVATION_ATTR", "GRADIENT_ATTR"
                 , "WSAREA_ATTR", "HABSTRUCT", "BCG_ATTR2", "HABIT")
col2NA_num <- c("TOLVAL", "TOLVAL2", "UFC")
col2NA_boo <- c("LONGLIVED", "NOTEWORTHY", "AIRBREATHER")
df_MariNW[, col2NA_char] <- NA_character_
df_MariNW[, col2NA_num] <- NA_real_
df_MariNW[, col2NA_boo] <- NA


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

col.met2keep <- c("ni_total", "nt_total", "pi_dom01", "pi_dom02"
                  , "nt_ti_stenocold"
  , "nt_ti_cold", "nt_ti_cool", "nt_ti_cowa", "nt_ti_warm", "nt_ti_stenowarm"
  , "nt_ti_eury", "nt_ti_stenocold_cold"
  , "nt_ti_stenocold_cold_cool", "nt_ti_cowa_warm_stenowarm"
  , "nt_ti_warm_stenowarm"
  , "nt_ti_na", "pi_ti_stenocold", "pi_ti_cold", "pi_ti_cool"
  , "pi_ti_cowa", "pi_ti_warm", "pi_ti_stenowarm", "pi_ti_eury"
  , "pi_ti_stenocold_cold", "pi_ti_stenocold_cold_cool"
  , "pi_ti_cowa_warm_stenowarm"
  , "pi_ti_warm_stenowarm", "pi_ti_na", "pt_ti_stenocold"
  , "pt_ti_cold", "pt_ti_cool", "pt_ti_cowa", "pt_ti_warm"
  , "pt_ti_stenowarm", "pt_ti_eury", "pt_ti_stenocold_cold"
  , "pt_ti_stenocold_cold_cool", "pt_ti_cowa_warm_stenowarm"
  , "pt_ti_warm_stenowarm"
  , "pt_ti_na")


# Met Val ----
# calculate selected metrics - Run Function
df_met_val <- metric.values(df_MariNW
                            , "bugs"
                           # , fun.cols2keep = col2keep
                            , fun.MetricNames = col.met2keep)


#~~~~~~~~~~~~
#WAIT to run this until you get through the Yes/No prompt. 
#~~~~~~~~~~~~~

fn_met_val <- "Test1_ThermPrefMetrics.Values.tsv"
path_met_val <- file.path(dn_output, fn_met_val)
write.table(df_met_val
            , path_met_val
            , row.names = FALSE
            , col.names = TRUE
            , sep = "\t")


#~~~~~~~~~~~~~~~~
# OPTIONAL - run this command to get an output with all the metrics (vs. limiting to the 15 listed above); you need to run this, otherwise the R code will fail because it will be missing some of the flag metrics
# # Calc Metrics (all)
# df_met_val <- metric.values(df_MariNW, "bugs") 
# # Save
# fn_met_val_all <- "Test1_BCGcalc.AllMetric.Values.tsv"
# path_met_val_all <- file.path(dn_output, fn_met_val_all)
# write.table(df_met_val_all
#             , path_met_val_all
#             , row.names = FALSE
#             , col.names = TRUE
#             , sep = "\t")
#~~~~~~~~~~~~~~~~

# Flags ----
# (metrics) - this directs R to the extdata folder and tells it to look at the MetricFlags Excel file
df_checks <- read_excel(system.file("./extdata/MetricFlags.xlsx"
                                  , package = "BCGcalc"), sheet = "Flags")

# 2021-12-20, Index_Region to upper
df_checks$INDEX_CLASS <- toupper(df_checks$INDEX_CLASS)


#~~~~~~~~~~~~~~~~
## QC, Flags ----
# Ensure have all "flag" metrics in met_val
check_metrics <- unique(df_checks[df_checks$Index_Name == "Therm_ORWA_Bugs500ct", "Metric_Name", TRUE])
check_metrics[!check_metrics %in% names(df_met_val)]
# check original data
check_metrics[!check_metrics %in% names(df_met_val)] %in% names(df_MariNW)
# no matches so add to df_met_val
col2add <- check_metrics[!check_metrics %in% names(df_met_val)]
df_met_val[, col2add] <- NA
## 2021-12-20, all present but code does no harm if nothing to add
#~~~~~~~~~~~~~~~~

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
df_rules <- read_excel(system.file("./extdata/Rules.xlsx", package = "BCGcalc")
                       , sheet = "Rules") 


# Erik, BCGcalc still using Site_Type
df_met_val$SITE_TYPE <- df_met_val$INDEX_REGION # old

# Run function
df_met_memb <- BCG.Metric.Membership(df_met_val, df_rules)

# Save Results
fn_met_memb <- "Test1_FuzzyTemp.Metric.Membership.tsv"
path_met_memb <- file.path(dn_output, fn_met_memb)
write.table(df_met_memb
            , path_met_memb
            , row.names = FALSE
            , col.names = TRUE
            , sep = "\t")

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
fn_levels_flags <- "Test1_FuzzyTemp.Levels.Flags.csv"
path_levels_flags <- file.path(dn_output, fn_levels_flags)
write.csv(df_levels_flags
          , path_levels_flags)


# Summary ---- 
# Display number of each level
df_summary_levels <- table(df_levels_flags$Primary_BCG_Level
                           , df_levels_flags$Secondary_BCG_Level
                           , useNA = "ifany")
knitr::kable(df_summary_levels
             , caption = "Level assignments (1st on Left, 2nd on Top) (NA are no 2nd).")

