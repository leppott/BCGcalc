# Pacific Maritime Northwest Region BCG model
# Jen.Stamp@tetratech.com
# 2023-02-06
#~~~~~~~~~~~~~~~~~
# Run this if you want to run the Shiny version locally on your computer. 
# BCGcalc::runShiny()
#~~~~~~~~~~~~~~~~~

# # STEP 1 (optional) Install BCGcalc if needed
# if (!require(remotes)) {install.packages("remotes")}  #install if needed
# install_github("leppott/BCGcalc", force = TRUE)
# 
# 
# # STEP 2 (optional) Install BioMonTools if needed
# if(!require(remotes)){install.packages("remotes")}  #install if needed
# install_github("leppott/BioMonTools", force = TRUE)

# Packages ----
library(BioMonTools)
library(BCGcalc)
library(readxl)
library(reshape2)
library(knitr)


# Data ----
fn_data <- "TestData_Calc_BCGcalc.csv"
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

df_example <- markExcluded(df_data
                           , SampID = "SampleID"
                           , TaxaID = "TaxaID"
                           , TaxaCount =  "N_Taxa"
                           , Exclude = "Exclude"
                           , TaxaLevels = TaxaLevels
                           , Exceptions = NA)

fn_input_base <- tools::file_path_sans_ext(fn_data)
fn_excl <- paste0(fn_input_base, "_wExclude.csv")
path_excl <- file.path(dn_output, fn_excl)
write.csv(df_example, path_excl)

# BCG model ----
# STEP 4 - Run data through BCG model.

# File
## use excluded taxa output
path_MariNW <- path_excl

# Data
df_MariNW <- read.csv(path_MariNW
                      , stringsAsFactors = FALSE
                      , colClasses = c("BCG_Attr" = "character"))
# if BCG_Attr is named differently change it.
# this part prevents the "1i" values from importing as complex numbers

#~~~~~~~~~
## QC, Visual ----
# Visually Check First 6 Rows of Input File (as a QC step, to make sure it looks correct)
nrow_MariNW <- nrow(df_MariNW)
ncol_MariNW <- ncol(df_MariNW)
MariNW_size <- paste0(nrow_MariNW, " rows, ", ncol_MariNW, " rows.")
message(MariNW_size)
View(head(df_MariNW))
#~~~~~~~~~


#~~~~~~~~~
## QC, Sample Size ----
# QC sample size. Target # organisms is 500
sampsize <- aggregate(df_MariNW$N_TAXA
                      , list(SampleID = df_MariNW$SampleID)
                      , sum
                      , na.rm = TRUE)
# N_Taxa to upper case
#View(sampsize)
summary(sampsize) # added for additional summary
#~~~~~~~~~


# tell R to ignore these fields so you don't get a warning
col2NA_char <- c("SUBPHYLUM", "INFRAORDER", "FFG2", "HABIT", "THERMAL_INDICATOR"
                 , "HABITAT", "ELEVATION_ATTR", "GRADIENT_ATTR", "WSAREA_ATTR"
                 , "HABSTRUCT", "BCG_ATTR2")
col2NA_num <- c("TOLVAL", "TOLVAL2", "UFC")
col2NA_boo <- c("LONGLIVED", "AIRBREATHER")
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
#these commands limit one of the metric calc outputs to the 12 metrics used in 
# the BCG model plus the 'flag' metrics.
#Important note: the Flag function below won't work properly unless you include 
# the flag metrics
col.met2keep <- c("ni_total", "nt_total", "nt_BCG_att1i2", "pt_BCG_att1i23"
                  , "pi_BCG_att1i23", "nt_EPT_BCG_att1i23"
                  , "pt_NonIns_BCG_att456", "nt_EPT", "pi_BCG_att1i2"
                  , "pi_NonInsTrombJuga_BCG_att456", "nt_ffg_pred_scrap_shred"
                  , "x_Shan_2", "nt_volt_semi", "pi_dom02", "pi_SimBtri"
                  , "pi_Tromb", "pi_JugaFlumi", "nt_Ephem", "nt_Pleco"
                  , "nt_Trich", "nt_Coleo", "pt_volt_multi", "pi_ffg_col_filt"
                  , "pi_Chiro", "pi_Oligo", "pi_CraCaeGam", "nt_habitat_brac"
                  , "nt_BCG_attNA", "pi_BCG_att56")
# Erik, change name of ffg col_filt

# Met Val ----
# calculate selected metrics - Run Function
df_met_val <- metric.values(df_MariNW
                            , "bugs"
                           # , fun.cols2keep = col2keep
                            , fun.MetricNames = col.met2keep)

#~~~~~~~~~~~~
#WAIT to run this until you get through the Yes/No prompt. 
#~~~~~~~~~~~~~

fn_met_val <- "Test1_BCGcalc.BCGPlusFlagMetrics.Values.tsv"
path_met_val <- file.path(dn_output, fn_met_val)
write.table(df_met_val
            , path_met_val
            , row.names = FALSE
            , col.names = TRUE
            , sep = "\t")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#OPTIONAL - ALL metrics
#run this command to get an output with all the metrics (vs. limiting to the 15 listed above); you need to run this, otherwise the R code will fail because it will be missing some of the flag metrics
## Calc (all)
df_met_val_all <- metric.values(df_MariNW, "bugs")
## Save
fn_met_val_all <- "Test1_BCGcalc.AllMetric.Values.tsv"
path_met_val_all <- file.path(dn_output, fn_met_val_all)
write.table(df_met_val_all
            , path_met_val_all
            , row.names = FALSE
            , col.names = TRUE
            , sep = "\t")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Flags ----
# Flags (metrics) - this directs R to the extdata folder and tells it to look at the MetricFlags Excel file
path_checks <- system.file("./extdata/MetricFlags.xlsx", package = "BCGcalc")
df_checks <- read_excel(path_checks, sheet = "Flags")
file.copy(path_checks, dn_output)

# 2021-12-20, Index_Region to upper
df_checks$INDEX_CLASS <- toupper(df_checks$INDEX_CLASS)

#~~~~~~~~~~~~~~~~
## QC, Flags ----
# Ensure have all "flag" metrics in met_val
check_metrics <- unique(df_checks[df_checks$Index_Name == "BCG_MariNW_Bugs500ct"
                                  , "Metric_Name"
                                  , TRUE])
check_metrics[!check_metrics %in% names(df_met_val)]
# check original data
check_metrics[!check_metrics %in% names(df_met_val)] %in% names(df_MariNW)
# no matches so add to df_met_val
#~~~~~~~~~~~~~~~~

col2add <- check_metrics[!check_metrics %in% names(df_met_val)]
df_met_val[, col2add] <- NA
## 2021-12-20, all present but code does no harm if nothing to add

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
df_flag_summary <- table(df_flags[, "CHECKNAME"]
                         , df_flags[, "FLAG"]
                         , useNA = "ifany")
kable(df_flag_summary, caption = "Flag summary.")
View(df_flag_summary)

## Save
fn_flags_met <- "Test1_BCGcalc.metval.flags.tsv"
path_flags_met <- file.path(dn_output, fn_flags_met)
write.table(df_flag_summary
            , path_flags_met
            , row.names = TRUE
            , col.names = TRUE
            , sep = "\t")


# BCG ----
## BCG, Metric Memb ----
# Calculate Metric Scores (BCG)
# this directs R to the extdata folder and tells it to look at the Rules Excel file
df_rules <- read_excel(system.file("./extdata/Rules.xlsx"
                                   , package = "BCGcalc"), sheet = "Rules") 


# Tell R to look for the Site_Type column instead of an Index_Region column (rules vary slightly btw hi vs. lo)

df_met_val$SITE_TYPE <- df_met_val$INDEX_REGION

# Run function
df_met_memb <- BCG.Metric.Membership(df_met_val, df_rules)

# Save Results
fn_met_memb <- "Test1_BCGcalc.Metric.Membership.tsv"
path_met_memb <- file.path(dn_output, fn_met_memb)
write.table(df_met_memb
            , path_met_memb
            , row.names = FALSE
            , col.names = TRUE
            , sep = "\t")

## BCG, Level Memb----
# Calculate Level Memberships
df_lev_memb <- BCG.Level.Membership(df_met_memb, df_rules)

## BCG, Level Assignment----
# Assign Levels
df_levels <- BCG.Level.Assignment(df_lev_memb)

# Merge Levels and Flags
df_levels_flags <- merge(df_levels, df_flags_wide
                         , by.x = "SampleID"
                         , by.y = "SAMPLEID"
                         , all.x = TRUE)

# Save Results
fn_levels_flags <- "Test1_BCGcalc.Levels.Flags.csv"
path_levels_flags <- file.path(dn_output, fn_levels_flags)
write.csv(df_levels_flags
          , path_levels_flags)

## BCG, Summary ---- 
# Display number of each level
df_summary_levels <- table(df_levels_flags$Primary_BCG_Level
                           , df_levels_flags$Secondary_BCG_Level
                           , useNA = "ifany")
knitr::kable(df_summary_levels
             , caption = "Level assignments (1st on Left, 2nd on Top) (NA are no 2nd).")

