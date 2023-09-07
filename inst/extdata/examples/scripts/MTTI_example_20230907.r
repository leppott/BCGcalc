# MTTI calculation script
#
# Original work
# Author: Shannon Hubler
# Initial Date: 11.10.21
# updates:
					# 1/25/23: SLH updated taxonomy to use the most recent "final" OTUs.
					# 1/25/23: SLH explored the use of "all taxa", not just those with n>30 
								# (sill using appropriate OTU levels accordingly phylogeny to eliminate ambiguous taxa)
								# RESULTS: no model improvements by leaving rare taxa in.  Do not include rare taxa moving forward.
					# 3/12/23: SLH updated taxonomy to pull from Git repo--now requires an internet connection, but just for this piece

# Project: Macroinvertebrate Inferred Temperature

# summary: Building on thermal traits work, as part of the Western OR/WA BCG workgroup.
#			  Develop Weighted Averaging models to infer seasonal 7-d maximum temperatures,
#			  derived from NorWeSTs MWMT metric.

#				HIGH taxonomic resolution models
#				Check model performance
#				Look for bias
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Used Shiny code adaptation from Shannon's original work as template for example
# https://github.com/leppott/BCGcalc/blob/main/inst/shiny-examples/BCGcalc/server.R#L2863
# Erik.Leppo@tetratech.com
# 2023-09-07
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Packages----
library(BCGcalc) # GitHub
library(tools)
library(httr)
library(dplyr)
library(rioja)
library(tibble)
library(tidyr)
library(BioMonTools) # GitHub
library(readxl)
library(reshape2)

# Initialize----
## Working Directory
wd <- tempdir()
path_results <- wd
## Copy Data to WD
fn_data <- "TestData_MTTI_20230414.csv"
path_from <- system.file(file.path("extdata", "examples", "data", fn_data)
                         , package = "BCGcalc")
file.copy(path_from, wd)
## OTU
MTTI_OTU <- TRUE

# Load Data----
## replace with user data
df_data <- read.csv(file.path(wd, fn_data))
## model
# Data, Model
## Copy Model to WD
fn_model <- "wa_MTTI.mar23.Rdata"
path_model <- system.file(file.path("shiny-examples", "BCGcalc"
                                   , "data", "MTTI_model", fn_model)
                         , package = "BCGcalc")
load(path_model)

# filename base
fn_input_base <- tools::file_path_sans_ext(fn_data)

# Fun Param, Define
sel_col_sampid <- "SampleID" # default = "SampleID"
sel_col_taxaid <- "TAXA_ID"  # default = "TaxaID"
sel_col_ntaxa  <- "COUNTS"   # default = "N_Taxa"

# Data, Taxa List Official
## get from BioMonTools_SupportFiles GitHub Repo
## URL BioMonTools
url_bmt_base <- "https://github.com/leppott/BioMonTools_SupportFiles/raw/main/data"
# BMT, Taxa Official Pick----
url_taxa_official_pick <- file.path(url_bmt_base
                                    , "taxa_official"
                                    , "_pick_files.csv")
httr::GET(url_taxa_official_pick
          , httr::write_disk(temp_taxa_official_pick <- tempfile(fileext = ".csv")))

df_pick_taxoff <- read.csv(temp_taxa_official_pick)
# df_pick_taxoff from GLOBAL code
fn_taxoff <- df_pick_taxoff[df_pick_taxoff$project == 
                              "MTTI (Oregon/Washington)"
                            , "filename"]

url_taxa_official <- file.path(url_bmt_base
                               , "taxa_official"
                               , fn_taxoff)

# download so ensure have it before read
httr::GET(url_taxa_official
          , httr::write_disk(temp_taxa_official <- tempfile(fileext = ".csv")))

df_tax <- read.csv(temp_taxa_official)

## Calc, 03, Run Function----

# Munge
prog_detail <- "Calculation, Munge"
message(paste0("\n", prog_detail))

## Munge, Data 
df_data <- df_data %>%
  dplyr::rename(sample.id = dplyr::all_of(sel_col_sampid)) %>%
  dplyr::rename(Taxon_orig = dplyr::all_of(sel_col_taxaid)) %>%
  dplyr::rename(Count = dplyr::all_of(sel_col_ntaxa))

# limit to necessary fields to void messy joins
df_tax_otu <- df_tax %>%
  dplyr::select(Taxon_orig, OTU_MTTI) 

### Data Prep----
# need relative abundances
prog_detail <- "Calculation, Data Prep"
message(paste0("\n", prog_detail))


df_abunds <- df_data %>% 			
  dplyr::group_by(sample.id) %>% 
  dplyr::summarize(tot.abund = sum(Count))

df_abunds <- as.data.frame(df_abunds)

df_data <- df_data %>%
  dplyr::left_join(df_abunds, by = 'sample.id')

df_data_RA <- df_data %>%
  dplyr::group_by(sample.id, Taxon_orig) %>%
  dplyr::summarize(RA = (Count / tot.abund), .groups = "drop_last")

#	join bugs and OTUs, filter out 'DNI' taxa, sum across OTUs within a sample
# join
df_bugs_otu <- df_data_RA %>%
  # join dataframes
  dplyr::left_join(df_tax_otu, by = 'Taxon_orig') %>% 
  # filter out DNI taxa
  dplyr::filter(OTU_MTTI != 'DNI')						

# sum RA's across all OTUs--should see a reduction in rows.  
# Also limits to the following: dataset (CAL/VAL/not), sample, OTU, (summed) RA

df_data_otu_sum_RA <- plyr::ddply(.data = df_bugs_otu
                                  , c('sample.id', 'OTU_MTTI')
                                  , plyr::summarize
                                  , RA = sum(RA))

#	Prepare data sets for modeling
#	need to crosstab the bug data (turn into a wide format) so that OTUs are columns
# then split into separate CAl and VAl datasets 

df_data_cross <- df_data_otu_sum_RA %>% 
  tidyr::pivot_wider(id_cols = c(sample.id)
                     , names_from = OTU_MTTI
                     , values_from = RA
                     , values_fn = sum) 


df_data_cross[is.na(df_data_cross)] <- 0 

df_data_cross <-	tibble::column_to_rownames(df_data_cross, 'sample.id') 

### Model----

prog_detail <- "Calculation, Model"
message(paste0("\n", prog_detail))

## Model, Calculation (from rioja package)
model_pred <- predict(wa_MTTI.mar23
                      , newdata = df_data_cross)
# , sse = TRUE
# , nboot = 100
# , match.data = TRUE
# , verbose = TRUE)

## Model, Munge
df_results_model <- as.data.frame(model_pred$fit)

df_results_model <- df_results_model %>%
  dplyr::select(WA.cla.tol) %>% 
  dplyr::rename("MTTI" = "WA.cla.tol")

# rownames to column 1
df_results_model <- tibble::rownames_to_column(df_results_model
                                               , sel_col_sampid)

### Flags----
prog_detail <- "Calculation, Flags"
message(paste0("\n", prog_detail))


# Import Checks
df_checks <- readxl::read_excel(system.file("./extdata/MetricFlags.xlsx"
                                            , package = "BioMonTools")
                                , sheet = "Flags")
# Data
## Data, Optima
df_optima <- tibble::rownames_to_column(data.frame(wa_MTTI.mar23$coefficients)
                                        , "TAXAID")

## Data, bug samples for metric calc
df_bugs_met <- df_data %>%
  # join dataframes
  dplyr::left_join(df_tax_otu, by = 'Taxon_orig') %>%
  dplyr::rename("SAMPLEID" = "sample.id"
                , "TAXAID" = "OTU_MTTI"
                , "N_TAXA" = "Count") %>%
  dplyr::mutate("EXCLUDE" = FALSE
                , "INDEX_NAME" = "MTTI"
                , "INDEX_CLASS" = "MTTI") %>%
  dplyr::left_join(df_optima, by = "TAXAID")

# if checked Convert to OTU  
if (MTTI_OTU == TRUE) {
  df_bugs_met <- dplyr::rename(df_bugs_met, "TOLVAL2" = "Optima")
  # NONTARGET
}## IF ~ input$MTTI_OTU

# Calc Metrics (MTTI)
df_met <- BioMonTools::metric.values(df_bugs_met
                                     , "bugs"
                                     , boo.Shiny = TRUE
                                     , metric_subset = "MTTI")
## only need some metrics for MTTI so warning message ok

# Add site score
df_met <-  merge(df_met
                 , df_results_model
                 , by.x = "SAMPLEID"
                 , by.y = sel_col_sampid
                 , all.x = TRUE)

# WAopt range check
df_met[, "MTTI_LO"] <- df_met[, "MTTI"] < df_met[, "x_tv2_min"]
df_met[, "MTTI_HI"] <- df_met[, "MTTI"] > df_met[, "x_tv2_max"]

# Munge
df_met <- df_met %>% 
  dplyr::relocate("MTTI", "MTTI_LO", "MTTI_HI", .after = "INDEX_CLASS")

# Generate Flags
df_met_flags <- BioMonTools::qc.checks(df_met, df_checks)
df_met_flags_summary <- table(df_met_flags[, "CHECKNAME"]
                              , df_met_flags[, "FLAG"]
                              , useNA = "ifany")

# Change terminology; PASS/FAIL to NA/flag
df_met_flags[, "FLAG"][df_met_flags[, "FLAG"] == "FAIL"] <- "flag"
df_met_flags[, "FLAG"][df_met_flags[, "FLAG"] == "PASS"] <- NA
# long to wide format
df_flags_wide <- reshape2::dcast(df_met_flags
                                 , SAMPLEID ~ CHECKNAME
                                 , value.var = "FLAG")


# Calc number of "flag"s by row.
df_flags_wide$NumFlags <- rowSums(df_flags_wide == "flag", na.rm = TRUE)
# Rearrange columns
NumCols <- ncol(df_flags_wide)
df_flags_wide <- df_flags_wide[, c(1, NumCols, 2:(NumCols - 1))]

# Merge model results and Flags
df_results <- merge(df_results_model
                    , df_flags_wide
                    , by.x = sel_col_sampid
                    , by.y = "SAMPLEID"
                    , all.x = TRUE)


## Calc, 09, Save Results ----
prog_detail <- "Save Results"
message(paste0("\n", prog_detail))


fn_save <- paste0(fn_input_base, "_MTTI_RESULTS.csv")
pn_save <- file.path(path_results, fn_save)
write.csv(df_results, pn_save, row.names = FALSE)

fn_save <- paste0(fn_input_base, "_MTTI_flags_1_metrics.csv")
pn_save <- file.path(path_results, fn_save)
write.csv(df_met, pn_save, row.names = FALSE)

fn_save <- paste0(fn_input_base, "_MTTI_flags_2_eval_long.csv")
pn_save <- file.path(path_results, fn_save)
write.csv(df_met_flags, pn_save, row.names = FALSE)

fn_save <- paste0(fn_input_base, "_MTTI_flags_3_eval_summary.csv")
pn_save <- file.path(path_results, fn_save)
write.csv(df_met_flags_summary, pn_save, row.names = TRUE)

# Open working directory (Windows only)
shell.exec(wd)
