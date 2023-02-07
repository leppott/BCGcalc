# BCGcalc - File Builder - Merge Files
# Erik.Leppo@tetratech.com
# 2023-02-06  
#
# Replicate Shiny app code, server.R, as a stand-alone script
#
# Merge 2 files
#
# User Input
# mf1 = Sample file (taxa, counts, and attributes)
# mf2 = Site file (location information)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Packages----
# none

# Data----
## Data, File Info
dn_input <- file.path(tempdir(), "examples", "data")
dn_output <- file.path(tempdir(), "examples", "results")
dn_mf1 <- file.path(dn_input)
dn_mf2 <- file.path(dn_input)
fn_mf1 <- "Test3_Merge_Samples.csv"
fn_mf2 <- "Test3_Merge_Sites.csv"
path_mf1 <- file.path(dn_mf1, fn_mf1)
path_mf2 <- file.path(dn_mf2, fn_mf2)
## Data, Column Info
col_siteid_mf1 <- "SampleID"
col_siteid_mf2 <- "SampleID"

## Data, Read MF1 ----
## extra steps to ensure BCG_Attr does not import as complex
# Read user imported file
# Add extra colClasses parameter for BCG_Attr
# the "i" values default to complex numbers
# many permutations of BCG_Attr so check for it first then import
df_header <- read.delim(path_mf1
                        , header = TRUE
                        , sep = ","
                        , stringsAsFactors = FALSE
                        , na.strings = c("", "NA")
                        , nrows = 0)
col_num_bcgattr <- grep("BCG_ATTR", toupper(names(df_header)))

if (identical(col_num_bcgattr, integer(0))) {
  # BCG_Attr present = FALSE
  # define classes = FALSE
  df_mf1 <- read.delim(path_mf1
                         , header = TRUE
                         , sep = ","
                         , stringsAsFactors = FALSE
                         , na.strings = c("", "NA"))
} else {
  # BCG_Attr present = TRUE
  # define classes = TRUE
  classes_df <- sapply(df_header, class)
  classes_df[col_num_bcgattr] <- "character"
  df_mf1 <- read.delim(path_mf1
                         , header = TRUE
                         , sep = ","
                         , stringsAsFactors = FALSE
                         , na.strings = c("", "NA")
                         , colClasses = classes_df)
  
}## IF ~ col_num_bcgattr == integer(0)

## Data, Read MF2----
df_mf2 <- read.delim(path_mf2
                     , header = TRUE
                     , sep = ","
                     , stringsAsFactors = FALSE
                     , na.strings = c("", "NA"))

# Merge----
suff_1x <- ".x"
suff_2y <- ".y"
df_merge <- merge(df_mf1
                  , df_mf2
                  , by.x = col_siteid_mf1
                  , by.y = col_siteid_mf2
                  , suffixes = c(suff_1x, suff_2y)
                  , all.x = TRUE
                  , sort = FALSE
)

# Munge ----
# move MF2 columns to the start (at end after merge)
## use index numbers
ncol_1x <- ncol(df_mf1)
ncol_merge <- ncol(df_merge)
df_merge <- df_merge[, c(1, seq(ncol_1x + 1, ncol_merge), 2:ncol_1x)]

# Save ----
fn_input_base <- tools::file_path_sans_ext(fn_mf1)
fn_merge <- paste0(fn_input_base, "_MergeFiles_RESULTS.csv")
path_merge <- file.path(dn_output, fn_merge)
write.csv(df_merge, path_merge, row.names = FALSE)

