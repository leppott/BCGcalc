# Prepare data for example for Master Taxa table
# BCG - PacNW
#
# Erik.Leppo@tetratech.com
# 20180314
#
# 20221101, rename index
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Prep####
# assume is package directory
wd <- file.path(system.file(package = "BCGcalc"), "extdata") 
#library(readxl)

# df.1, date, time, and datetime
# df.2 only datetime (different format)
# df.3 subset (one month) of df.2

# 1. Get data and process#####
# 1.1. Import Data
myFile <- "TaxaMaster_Bug_BCG_PugLowWilVal.xlsx"
ws <- "TaxaMaster_Ben_BCG_PugLowWilVal"
df <- as.data.frame(readxl::read_excel(file.path(wd, myFile), sheet = ws))

# 1.2. Process Data
View(df)
# QC check
dim(df)
# structure
str(df)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. Save as RDA for use in package####
#
TaxaMaster_Ben_BCG_PugLowWilVal <- df
usethis::use_data(TaxaMaster_Ben_BCG_PugLowWilVal, overwrite = TRUE)

