# Prepare data for example for tests, MeticValues
# BCG - PacNW
#
# Erik.Leppo@tetratech.com
# 2021-01-18
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Prep####
#library(readxl)
#library(BioMonTools)

# 1. Get data and process#####
# Calculate Metrics
df.samps.bugs <- readxl::read_excel(
                             system.file("extdata/Data_BCG_PugLowWilVal.xlsx"
                                        , package = "BCGcalc")
                            , guess_max = 10^6)
# Run Function
myDF <- df.samps.bugs
myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2", "INDEX_CLASS")
# Add columns
myDF[, c("INFRAORDER", "HABITAT", "ELEVATION_ATTR", "GRADIENT_ATTR"
         , "WSAREA_ATTR", "HABSTRUCT")] <- NA_character_
myDF[, ("UFC")] <- NA_integer_
df.metric.values.bugs <- BioMonTools::metric.values(myDF
                                                    , "bugs"
                                                    , fun.cols2keep = myCols) 
df <- df.metric.values.bugs

# 1.2. Process Data
View(df)
# QC check
dim(df)
# structure
str(df)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. Save as RDA for use in package####
#
metrics_values <- df
usethis::use_data(metrics_values, overwrite = TRUE)

