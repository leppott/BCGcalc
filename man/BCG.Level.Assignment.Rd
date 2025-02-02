% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BCG.Level.Assignment.R
\name{BCG.Level.Assignment}
\alias{BCG.Level.Assignment}
\title{BCG Level Assignment}
\usage{
BCG.Level.Assignment(
  df.level.membership,
  col_SampleID = "SAMPLEID",
  col_Index_Name = "INDEX_NAME",
  col_Index_Class = "INDEX_CLASS",
  col_L1 = "L1",
  col_L2 = "L2",
  col_L3 = "L3",
  col_L4 = "L4",
  col_L5 = "L5",
  col_L6 = "L6"
)
}
\arguments{
\item{df.level.membership}{Wide data frame with level memberships (0-1).}

\item{col_SampleID}{Column name for sample id.  Default = "SAMPLEID"}

\item{col_Index_Name}{Column name for index name.  Default = "INDEX_NAME"}

\item{col_Index_Class}{Column name for index class.  Default = "INDEX_CLASS"}

\item{col_L1}{Column name for memberships, Level 1.  Default = "L1"}

\item{col_L2}{Column name for memberships, Level 2.  Default = "L2"}

\item{col_L3}{Column name for memberships, Level 3.  Default = "L3"}

\item{col_L4}{Column name for memberships, Level 4.  Default = "L4"}

\item{col_L5}{Column name for memberships, Level 5.  Default = "L5"}

\item{col_L6}{Column name for memberships, Level 6.  Default = "L6"}
}
\value{
Returns a data frame of results in the wide format.
}
\description{
Biological Condition Gradient level assignment (1st and 2nd) 
given Level memberships.
}
\details{
Input is L1 to L6 with membership values of 0 to 1.  
Result is 1st Level (Primary_BCG_Level) and 2nd Level (Secondary_BCG_Level). 
Also give close (Membership_Close) and a continuous proportional Level 
assignment ("Continuous_BCG_Level").
}
\examples{
# Example 1

# construct a dummy dataset
L1 <- c(rep(0, 12))
L2 <- c(0.4, 0, 0.4, rep(0,7), 0, 0)
L3 <- c(0.6, 0, 0.6, 0, 0.42, 0, 1, 1, 0.22, 0.33, 0.5, 0)
L4 <- c(0, 0.9, 0, 0, 0.58, 0.05, 0, 0, 0.78, 0.67, 0.5, 0)
L5 <- c(0, 0.1, 0, 1, 0, 0.95, rep(0,4), 0, 1)
L6 <- c(rep(0, length(L1)))
SAMPLEID <- LETTERS[1:length(L1)]
df_lev_memb <- data.frame(SAMPLEID = SAMPLEID
                          , INDEX_NAME = "TEST_NAME"
                          , INDEX_CLASS = "TEST_CLASS"
                          , L1 = L1
                          , L2 = L2
                          , L3 = L3
                          , L4 = L4
                          , L5 = L5
                          , L6 = L6)

# Run Function
df_Levels <- BCG.Level.Assignment(df_lev_memb)

# Show Results
#View(df_Levels)

# Save Results
write.table(df_Levels
            , file.path(tempdir(), "Levels.tsv")
            , row.names = FALSE
            , col.names = TRUE
            , sep = "\t")

#~~~~~~~~~~~~~~~~~~~~~~~

# Example 2

# library(readxl)
# library(reshape2) 
# library(BioMonTools)

# Calculate Metrics
df_samps_bugs <- readxl::read_excel(system.file(
                                       "extdata/Data_BCG_PugLowWilVal.xlsx"
                                        , package="BCGcalc")
                           , guess_max = 10^6)
                                        
# Run Function
myDF <- df_samps_bugs
myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2")
#' # populate missing columns prior to metric calculation
col_missing <- c("INFRAORDER", "HABITAT", "ELEVATION_ATTR", "GRADIENT_ATTR"
                 , "WSAREA_ATTR", "HABSTRUCT", "UFC")
myDF[, col_missing] <- NA
df_met_val_bugs <- BioMonTools::metric.values(myDF
                                              , "bugs"
                                              , fun.cols2keep = myCols) 

# Import Rules
df_rules <- readxl::read_excel(system.file("extdata/Rules.xlsx"
                                           , package="BCGcalc")
                              , sheet="Rules") 

# Calculate Metric Memberships
df_met_memb <- BCG.Metric.Membership(df_met_val_bugs, df_rules)

# Calculate Level Memberships
df_lev_memb <- BCG.Level.Membership(df_met_memb, df_rules)

# Run Function
df_Levels <- BCG.Level.Assignment(df_lev_memb)

# QC Checks (flags)
#
# Import Checks
df_checks <- readxl::read_excel(system.file("extdata/MetricFlags.xlsx"
                                            , package="BCGcalc")
                               , sheet="Flags") 

# Run Function
df_flags <- BioMonTools::qc.checks(df_met_val_bugs, df_checks)
# Change terminology; PASS/FAIL to NA/flag
df_flags[, "FLAG"][df_flags[, "FLAG"] == "FAIL"] <- "flag"
df_flags[, "FLAG"][df_flags[, "FLAG"] == "PASS"] <- NA

# long to wide format
df_flags_wide <- reshape2::dcast(df_flags
                                 , SAMPLEID ~ CHECKNAME
                                 , value.var="FLAG")
# Calc number of "flag"s by row.
df_flags_wide$NumFlags <- rowSums(df_flags_wide == "flag", na.rm = TRUE)
# Rearrange columns
NumCols <- ncol(df_flags_wide)
df_flags_wide <- df_flags_wide[, c(1, NumCols, 2:(NumCols - 1))]

# Merge Levels and Flags
df_lev_flags <- merge(df_Levels
                      , df_flags_wide
                      , by.x = "SampleID"
                      , by.y = "SAMPLEID"
                      , all.x = TRUE)
             
# Summarize Results
table(df_flags[, "CHECKNAME"], df_flags[, "FLAG"], useNA = "ifany")
table(df_lev_flags$BCG_Status)

# Show Results
# View(df_lev_flags)

# Save Results
write.csv(df_lev_flags, file.path(tempdir(), "Level_Flags.csv"))

# # Summary Report
# strFile.RMD <- system.file(paste0("rmd/Results_Summary.Rmd")
#                              , package = "BCGcalc")
# strFile.RMD.format <- "html_document"
# strFile.out <- "_bcgcalc_RESULTS.html"
# dir.export <- tempdir()
# rmarkdown::render(strFile.RMD
#                    , output_format = strFile.RMD.format
#                    , output_file = strFile.out
#                    , output_dir = dir.export
#                    , quiet = TRUE)

}
