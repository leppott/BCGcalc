# BCGcalc - File Builder - Merge Files
# Erik.Leppo@tetratech.com
# 2023-02-07 
#
# Replicate Shiny app code, server.R, as a stand-alone script
#
# Merge 2 files
#
# User Input
# files, column names, project
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Packages----
library(httr)
library(BioMonTools)

# Data----
## Data, File Info
dn_input <- file.path(tempdir(), "examples", "data")
dn_output <- file.path(tempdir(), "examples", "results")
dn_data <- file.path(dn_input)
fn_data <- "Test1_TaxaTrans.csv"
path_data <- file.path(dn_data, fn_data)
## Data, Column Info
# Fun Param, Define
projects <- c("MaritimeNW BCG model (Pacific Northwest)"
              , "Thermal preference metrics (Pacific Northwest)"
              , "MTTI (Pacific Northwest)"
              , "Biodiversity index (Pacific Northwest)")
sel_proj <- projects[1]
sel_user_sampid <- "SampleID"
sel_user_taxaid <- "TaxaID"
sel_user_ntaxa <- "N_TAXA"
sel_user_groupby <- c("SourceEntity", "StationID", "CollDate") # columns to keep
sel_summ <- TRUE


## URL BioMonTools
url_bmt_base <- "https://github.com/leppott/BioMonTools_SupportFiles/raw/main/data"

# BMT, Taxa Official Pick----
url_taxa_official_pick <- file.path(url_bmt_base
                                    , "taxa_official"
                                    , "_pick_files.csv")
httr::GET(url_taxa_official_pick
          , write_disk(temp_taxa_official_pick <- tempfile(fileext = ".csv")))

df_pick_taxoff <- read.csv(temp_taxa_official_pick)


# Import data
# data
inFile <- path_data
fn_input_base <- tools::file_path_sans_ext(fn_data)
message(paste0("Import, file name, base: ", fn_input_base))
df_input <- read.delim(path_data
                       , header = TRUE
                       , sep = ","
                       , stringsAsFactors = FALSE)
# QC, FAIL if TRUE
if (is.null(df_input)) {
  msg <- "No data imported."
  message(msg)
}

# Gather and Test Inputs  ----
# Fun Param, Define



fn_taxoff <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                            , "filename"]
fn_taxoff_meta <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                 , "metadata_filename"] 
col_taxaid_official_match <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                            , "taxaid"]
col_taxaid_official_project <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                              , "calc_taxaid"]
col_drop_project <- unlist(strsplit(df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                                   , "col_drop"], ","))
fn_taxoff_attr <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                 , "attributes_filename"] 
col_taxaid_attr <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                  , "attributes_taxaid"] 
sel_taxaid_drop <-  df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                   , "taxaid_drop"] 

# include = yes; unique(sel_user_groupby)
# include sampid, taxaid, and n_taxa so not dropped
user_col_keep <- names(df_input)[names(df_input) %in% c(sel_user_groupby
                                                        , sel_user_sampid
                                                        , sel_user_taxaid
                                                        , sel_user_ntaxa)]
# flip to col_drop
user_col_drop <- names(df_input)[!names(df_input) %in% user_col_keep]

# Fun Param, Test

if (sel_proj == "") {
  # end process with pop up
}## IF ~ sel_proj

if (is.na(fn_taxoff_meta) | fn_taxoff_meta == "") {
  # set value to NULL 
  df_official_metadata <- NULL
}## IF ~ fn_taxaoff_meta

if (is.na(sel_user_ntaxa) | sel_user_ntaxa == "") {
  sel_user_ntaxa <- NULL
}## IF ~ fn_taxaoff_meta

if (is.null(sel_summ)) {
  sel_summ <- FALSE
}## IF ~ sel_summ

if (sel_taxaid_drop == "NULL") {
  sel_taxaid_drop <- NULL
}## IF ~ sel_taxaid_drop


message(paste0("User response to summarize duplicate sample taxa = "
               , sel_summ)) 

# Import Official Data (and Metadata)  ----

## Data,  Official Taxa----
url_taxoff <- file.path(url_bmt_base
                        , "taxa_official"
                        , fn_taxoff)
httr::GET(url_taxoff
          , write_disk(temp_taxoff <- tempfile(fileext = ".csv")))

df_taxoff <- read.csv(temp_taxoff)

## Data, Official Taxa, Meta Data----
if (!is.null(fn_taxoff_meta)) {
  url_taxoff_meta <- file.path(url_bmt_base
                               , "taxa_official"
                               , fn_taxoff_meta)
  httr::GET(url_taxoff_meta
            , write_disk(temp_taxoff_meta <- tempfile(fileext = ".csv")))
  
  df_taxoff_meta <- read.csv(temp_taxoff_meta)
}## IF ~ fn_taxaoff_meta

## Data, Official Attributes----
if (!is.null(fn_taxoff_attr)) {
  url_taxoff_attr <- file.path(url_bmt_base
                               , "taxa_official"
                               , fn_taxoff_attr)
  httr::GET(url_taxoff_attr
            , write_disk(temp_taxoff_attr <- tempfile(fileext = ".csv")))
  
  df_taxoff_attr <- read.csv(temp_taxoff_attr)
}## IF ~ fn_taxoff_attr


# Run Function ----

# function parameters
df_user                 <- df_input
df_official             <- df_taxoff
df_official_metadata    <- df_taxoff_meta
taxaid_user             <- sel_user_taxaid
taxaid_official_match   <- col_taxaid_official_match
taxaid_official_project <- col_taxaid_official_project
taxaid_drop             <- sel_taxaid_drop
col_drop                <- user_col_drop #NULL #sel_col_drop
sum_n_taxa_boo          <- TRUE
sum_n_taxa_col          <- sel_user_ntaxa
sum_n_taxa_group_by     <- c(sel_user_sampid
                             , sel_user_taxaid
                             , sel_user_groupby)

## run the function ----
taxatrans_results <- BioMonTools::taxa_translate(df_user
                                                 , df_official
                                                 , df_official_metadata
                                                 , taxaid_user
                                                 , taxaid_official_match
                                                 , taxaid_official_project
                                                 , taxaid_drop
                                                 , col_drop
                                                 , sum_n_taxa_boo
                                                 , sum_n_taxa_col
                                                 , sum_n_taxa_group_by)

## Munge ----

# Remove non-project taxaID cols
# Specific to shiny project, not a part of the taxa_translate function
col_keep <- !names(taxatrans_results$merge) %in% col_drop_project
taxatrans_results$merge <- taxatrans_results$merge[, col_keep]

# Attributes if have 2nd file
if (!is.na(fn_taxoff_attr)) {
  df_ttrm <- taxatrans_results$merge
  # drop translation file columns
  col_keep_ttrm <- names(df_ttrm)[names(df_ttrm) %in% c(sel_user_sampid
                                                        , sel_user_taxaid
                                                        , sel_user_ntaxa
                                                        , "Match_Official"
                                                        , sel_user_groupby)]
  df_ttrm <- df_ttrm[, col_keep_ttrm]
  # merge with attributes
  df_merge_attr <- merge(df_ttrm
                         , df_taxoff_attr
                         , by.x = taxaid_user
                         , by.y = col_taxaid_attr
                         , all.x = TRUE
                         , sort = FALSE
                         , suffixes = c("_xDROP", "_yKEEP"))
  # Drop duplicate names from Trans file (x)
  col_keep <- names(df_merge_attr)[!grepl("_xDROP$"
                                          , names(df_merge_attr))]
  df_merge_attr <- df_merge_attr[, col_keep]
  # KEEP and rename duplicate names from Attribute file (y)
  names(df_merge_attr) <- gsub("_yKEEP$", "", names(df_merge_attr))
  # Save back to results list
  taxatrans_results$merge <- df_merge_attr
  
  # QC check
  # testthat::expect_equal(nrow(df_merge_attr), nrow(df_ttrm))
  # testthat::expect_equal(sum(df_merge_attr[, sel_user_ntaxa], na.rm = TRUE)
  #                        , sum(df_ttrm[, sel_user_ntaxa], na.rm = TRUE))
}## IF ~ !is.na(fn_taxoff_attr)

# Reorder by SampID and TaxaID
taxatrans_results$merge <- taxatrans_results$merge[
  order(taxatrans_results$merge[, sel_user_sampid]
        , taxatrans_results$merge[, sel_user_taxaid]), ]

# Add input filenames
taxatrans_results$merge[, "file_taxatrans"] <- fn_taxoff
taxatrans_results$merge[, "file_attributes"] <- fn_taxoff_attr


# Resort columns
col_start <- c(sel_user_sampid
               , sel_user_taxaid
               , sel_user_ntaxa
               , "file_taxatrans"
               , "file_attributes")
col_other <- names(taxatrans_results$merge)[!names(taxatrans_results$merge) 
                                            %in% col_start]
taxatrans_results$merge <- taxatrans_results$merge[, c(col_start
                                                       , col_other)]

# Convert required file names to standard
## do at end so don't have to modify any other variables
boo_req_names <- TRUE
if (boo_req_names == TRUE) {
  names(taxatrans_results$merge)[names(taxatrans_results$merge) 
                                 %in% sel_user_sampid] <- "SampleID"
  names(taxatrans_results$merge)[names(taxatrans_results$merge) 
                                 %in% sel_user_taxaid] <- "TaxaID"
  names(taxatrans_results$merge)[names(taxatrans_results$merge) 
                                 %in% sel_user_ntaxa] <- "N_Taxa"
}## IF ~ boo_req_names


# Save Results ----

# Save files

## File version names
df_save <- data.frame(project = sel_proj
                      , file_translations = fn_taxoff
                      , taxaid_translations = col_taxaid_official_project
                      , file_metadata = fn_taxoff_attr
                      , file_attributes = fn_taxoff_attr
                      , taxaid_attributes = col_taxaid_attr)
fn_part <- paste0("_taxatrans_", "0fileversions", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)

## Taxa User 
# saved when imported

## Taxa Official
df_save <- df_official
fn_part <- paste0("_taxatrans_", "1official", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)

## Taxa Official, Attributes
df_save <- df_taxoff_attr
fn_part <- paste0("_taxatrans_", "1attributes", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)

## meta data
df_save <- taxatrans_results$official_metadata # df_taxoff_meta
fn_part <- paste0("_taxatrans_", "1metadata", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)

## translate - crosswalk
df_save <- taxatrans_results$taxatrans_unique # df_taxoff_meta
fn_part <- paste0("_taxatrans_", "2taxamatch", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)

## Non Match
df_save <- data.frame(taxatrans_results$nonmatch)
fn_part <- paste0("_taxatrans_", "3nonmatch", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)

## Taxa Trans
df_save <- taxatrans_results$merge
fn_part <- paste0("_taxatrans_", "MERGED", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)


