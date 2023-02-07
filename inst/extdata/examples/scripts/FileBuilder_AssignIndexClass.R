# BCGcalc - File Builder - Merge Files
# Erik.Leppo@tetratech.com
# 2023-02-07
#
# Replicate Shiny app code, server.R, as a stand-alone script
#
# Assign Index_Class
#
# User Input
# data file
# column names
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Packages----
library(readxl)
library(httr)  # GET
library(BioMonTools)

# Data----
## Data, File Info
dn_input <- file.path(tempdir(), "examples", "data")
dn_output <- file.path(tempdir(), "examples", "results")
dn_data <- file.path(dn_input)
fn_data <- "Test2_AssignIndexClass.csv"
path_data <- file.path(dn_data, fn_data)

## Data, Define Parameters ----
# Fun Param, Define
sel_col_indexname  <- "INDEX_NAME"
sel_col_indexclass <- "INDEX_CLASS"
sel_col_sampid     <- "Site.Code"
sel_indexname      <- "BCG_MariNW_Bugs500ct"
sel_col_elev       <- "slope_nhd"
sel_col_slope      <- "elev_m"

## Data, Index Class ----
## URL BioMonTools
url_bmt_base <- "https://github.com/leppott/BioMonTools_SupportFiles/raw/main/data"
url_indexclass_crit <- file.path(url_bmt_base
                                 , "index_class"
                                 , "IndexClass.xlsx")
httr::GET(url_indexclass_crit
    , write_disk(temp_indexclass_crit <- tempfile(fileext = ".xlsx")))

df_indexclass_crit <- readxl::read_excel(temp_indexclass_crit
                                         , sheet = "Index_Class")

## Data, Read ----
# Read user imported file
# Add extra colClasses parameter for BCG_Attr
# the "i" values default to complex numbers
# many permutations of BCG_Attr so check for it first then import
df_header <- read.delim(path_data
                        , header = TRUE
                        , sep = ","
                        , stringsAsFactors = FALSE
                        , na.strings = c("", "NA")
                        , nrows = 0)
col_num_bcgattr <- grep("BCG_ATTR", toupper(names(df_header)))

if (identical(col_num_bcgattr, integer(0))) {
  # BCG_Attr present = FALSE
  # define classes = FALSE
  df_data <- read.delim(path_data
                         , header = TRUE
                         , sep = ","
                         , stringsAsFactors = FALSE
                         , na.strings = c("", "NA"))
} else {
  # BCG_Attr present = TRUE
  # define classes = TRUE
  classes_df <- sapply(df_header, class)
  classes_df[col_num_bcgattr] <- "character"
  df_data <- read.delim(path_data
                         , header = TRUE
                         , sep = ","
                         , stringsAsFactors = FALSE
                         , na.strings = c("", "NA")
                         , colClasses = classes_df)
}## IF ~ col_num_bcgattr == integer(0)

# QC checks ----
boo_col_sampid <- sel_col_sampid %in% names(df_data)
if (boo_col_sampid == FALSE) {
  df_data[, sel_col_sampid] <- NA_character_
}


# Check if required fields for criteria
indexclass_fields <- sort(
  unique(
    df_indexclass_crit[df_indexclass_crit[
      , "INDEX_NAME"] == sel_indexname
      , "FIELD", TRUE]))
# change from user_indexname to sel_indexname
indexclass_fields_user <- c(sel_col_elev, sel_col_slope)


# Update official index classification file with user fields
df_indexclass_crit[df_indexclass_crit[, "FIELD"] == "elev_m"
                   , "FIELD"] <- sel_col_elev
df_indexclass_crit[df_indexclass_crit[, "FIELD"] == "pslope_nhd"
                   , "FIELD"] <- sel_col_slope

# Add Index_Name
df_data[, sel_col_indexname] <- sel_indexname
# Add Index_Class
## can crash if case is different
### Rename to standard
position_IC <- grep(sel_col_indexclass
                    , names(df_data)
                    , ignore.case = TRUE)
if (!identical(position_IC, integer(0))) {
  names(df_data)[position_IC] <- sel_col_indexclass
}## IF ~ position_IC
### Add (if not present) or Change to NA
df_data[, sel_col_indexclass] <- NA_character_ 
### Remove
df_data[, sel_col_indexclass] <- NULL 


# Assign Index_Class ----
df_indexclass_results <- BioMonTools::assign_IndexClass(data = df_data
                                          , criteria = df_indexclass_crit
                                          , name_indexclass = sel_col_indexclass
                                          , name_indexname = sel_col_indexname
                                          , name_siteid = sel_col_sampid
                                          , data_shape = "WIDE")

# Save ----

## save, criteria
df_save <- df_indexclass_crit
fn_part <- paste0("_indexclass_", "0criteria", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)

## save, results
df_save <- df_indexclass_results
fn_part <- paste0("_indexclass_", "1results", ".csv")
write.csv(df_save
          , file.path(dn_output, paste0(fn_input_base, fn_part))
          , row.names = FALSE)
rm(df_save, fn_part)
