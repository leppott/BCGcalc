## ----rmd_setup, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----Pkg_Install, eval=FALSE--------------------------------------------------
#  # Installing the BCGcalc library (with the vignette) from GitHub
#  library(devtools)
#  install_github("leppott/BCGcalc", force=TRUE, build_vignettes=TRUE)

## ----Pkg_Help, eval=FALSE-----------------------------------------------------
#  help(package="BCGcalc")

## ----View_TaxaMaster, eval=FALSE----------------------------------------------
#  library(BCGcalc)
#  
#  View(TaxaMaster_Ben_BCG_PugLowWilVal)
#  
#  # Save to working directory
#  #write.csv(TaxaMaster_Ben_BCG_PugLowWilVal
#  #          , "TaxaMaster_Ben_BCG_PugLowWilVal_20180927.csv")

## ----Head_TaxaMaster, echo=FALSE, eval=TRUE-----------------------------------
library(BCGcalc)
library(knitr)
kable(head(TaxaMaster_Ben_BCG_PugLowWilVal)
      , caption="PugLowWilVal BCG Master Taxa")

## ----CoreFun_TestData, eval=FALSE---------------------------------------------
#  # Packages
#  library(BCGcalc)
#  library(readxl)
#  library(reshape2)
#  library(BioMonTools)
#  
#  # Import
#  df.samps.bugs <- read_excel(system.file("./extdata/Data_BCG_PugLowWilVal.xlsx"
#                                          , package="BCGcalc")
#                              , guess_max = 10^6)
#  
#  # QC for TRUE/FALSE (both ok)
#  # Exclude to TRUE/FALSE
#  table(df.samps.bugs$Exclude)
#  # NonTarget to TRUE/FALSE
#  table(df.samps.bugs$NonTarget)
#  
#  # Add missing columns
#  col_add_char <- c("INFRAORDER", "HABITAT", "ELEVATION_ATTR", "GRADIENT_ATTR"
#                    , "WSAREA_ATTR", "HABSTRUCT")
#  col_add_num <- "UFC"
#  df.samps.bugs[, col_add_char] <- NA_character_
#  df.samps.bugs[, col_add_num] <- NA_integer_
#  
#  # 1.A. Calculate Metrics
#  # Extra columns to keep in results
#  keep.cols <- c("Area_mi2"
#                 , "SurfaceArea"
#                 , "Density_m2"
#                 , "Density_ft2"
#                 , "Site_Type")
#  # Run Function
#  df.metrics <- metric.values(df.samps.bugs, "bugs", fun.cols2keep = keep.cols)
#  # QC
#  dim(df.metrics)
#  View(df.metrics)
#  # Save
#  write.table(df.metrics
#              , "Metric.Values.Test.tsv"
#              , col.names=TRUE
#              , row.names=FALSE
#              , sep="\t")
#  
#  # 1.B. Metric Membership
#  # Import Rules
#  df.rules <- read_excel(system.file("./extdata/Rules.xlsx"
#                               , package="BCGcalc")
#                         , sheet="BCG_PugLowWilVal_500ct")
#  # Run function
#  df.Metric.Membership <- BCG.Metric.Membership(df.metrics, df.rules)
#  # Show Results
#  View(df.Metric.Membership)
#  # Save Results
#  write.table(df.Metric.Membership, "Metric.Membership.Test.tsv"
#                , row.names=FALSE, col.names=TRUE, sep="\t")
#  
#  # 1.C. Level Assignment
#  # Run Function
#  df.Level.Membership <- BCG.Level.Membership(df.Metric.Membership, df.rules)
#  # Show results
#  View(df.Level.Membership)
#  # Save Results
#  write.table(df.Level.Membership, "Level.Membership.Test.tsv"
#               , row.names=FALSE, col.names=TRUE, sep="\t")
#  
#  # 1.D. Level Membership
#  # Run Function
#  df.Levels <- BCG.Level.Assignment(df.Level.Membership)
#  
#  # 1.E. Flags
#  # Import QC Checks
#  df.checks <- read_excel(system.file("./extdata/MetricFlags.xlsx"
#                                            , package="BCGcalc")
#                          , sheet="Flags")
#  # Run Function
#  df.flags <- qc.checks(df.metrics, df.checks)
#  # Change terminology; PASS/FAIL to NA/flag
#  df.flags[,"FLAG"][df.flags[,"FLAG"]=="FAIL"] <- "flag"
#  df.flags[, "FLAG"][df.flags[,"FLAG"]=="PASS"] <- NA
#  # long to wide format
#  df.flags.wide <- dcast(df.flags, SAMPLEID ~ CHECKNAME, value.var="FLAG")
#  # Calc number of "flag"s by row.
#  df.flags.wide$NumFlags <- rowSums(df.flags.wide=="flag", na.rm=TRUE)
#  # Rearrange columns
#  NumCols <- ncol(df.flags.wide)
#  df.flags.wide <- df.flags.wide[, c(1, NumCols, 2:(NumCols-1))]
#  # Merge Levels and Flags
#  df.Levels.Flags <- merge(df.Levels, df.flags.wide, by="SAMPLEID", all.x=TRUE)
#  # Show Results
#  View(df.Levels.Flags)
#  # Summarize Results
#  table(df.flags[,"CHECKNAME"], df.flags[,"FLAG"], useNA="ifany")
#  # Save Results
#  write.csv(df.Levels.Flags, "Levels.Flags.Test.csv")

## ----CoreFun_NewData, eval=FALSE----------------------------------------------
#  # Setup
#  library(readxl)
#  library(dplyr)
#  library(BCGcalc)
#  library(BioMonTools)
#  
#  # Read File
#  ## FileName
#  fn.data <- system.file("./extdata/ExampleMunge_UnformatedData.xlsx"
#                         , package="BCGcalc")
#  # wd <- "F:\\myDocs"
#  # fn.data <- file.path(wd, "ExampleMunge_UnformatedData.xlsx")
#  
#  ## Worksheet
#  sh.data <- "SamplesWithBioticAttributesAndR"
#  ## Import
#  ### set "guess" to a large number to avoid type being wrong
#  df.data <- read_excel(fn.data, sheet = sh.data, guess_max=12000)
#  dim(df.data)
#  
#  # Munge
#  ## Col Names
#  ### convert to upper case
#  names(df.data) <- toupper(names(df.data))
#  ### Rename Columns (base R) [dplyr::rename not working]
#  names(df.data)[names(df.data)=="SAMPLE ID"] <- "SAMPLEID"
#  names(df.data)[names(df.data)=="TAXON"] <- "TAXAID"
#  names(df.data)[names(df.data)=="SAMPLE ID"] <- "SAMPLEID"
#  names(df.data)[names(df.data)=="QUANTITY SUBSAMPLING"] <- "N_TAXA"
#  #names(df.data)[names(df.data)=="HILSENHOFF BIOTIC TOLERANCE INDEX"] <- "TOLVAL"
#  # df.data <- df.data %>% rename("SAMPLEID"="SAMPLE ID"
#  #                              , "TAXAID"="TAXON"
#  #                              , "N_TAXA"="QUANTITY SUBSAMPLING"
#  #                              , "TOLVAL"="HILSENHOFF BIOTIC TOLERANCE INDEX"
#  #                              )
#  ### Create columns
#  df.data$EXCLUDE    <- !df.data$UNIQUE
#  df.data$NONTARGET  <- df.data$`OUTSIDE PROTOCOL`
#  # df.data$FFG        <- NA
#  # df.data$FFG[df.data$PREDATOR==TRUE]  <- "PR"
#  # df.data$HABIT      <- NA
#  # df.data$HABIT[df.data$CLINGER==TRUE] <- "CN"
#  # df.data$LIFE_CYCLE <- NA
#  df.data$SITE_TYPE  <- NA
#  # df.data$BCG_ATTR   <- NA
#  # df.data$THERMAL_INDICATOR <- NA
#  df.data$INDEX_NAME <- "BCG_PugLowWilVal_500ct"
#  df.data$SURFACEAREA <- df.data$`SURFACE AREA`
#  df.data$AREA_MI2 <- NA
#  df.data$DENSITY_M2 <- NA
#  df.data$DENSITY_FT2 <- NA
#  
#  # Add slope (and then gradient for SiteType) from NHD+ v2
#  fn.slope <- system.file("./extdata/ExampleMunge_Slope.xlsx", package="BCGcalc")
#  # fn.slope <- file.path(wd, "ExampleMunge_Slope.xlsx")
#  df.slope <- read_excel(fn.slope)
#  names(df.slope) <- toupper(names(df.slope))
#  # merge files
#  df.comb.slope <- merge(df.data
#                         , df.slope
#                         , by.x="SITE CODE"
#                         , by.y="SITE_CODE"
#                         , all.x=TRUE)
#  # QC (rows)
#  dim(df.data)
#  dim(df.comb.slope)
#  nrow(df.data) == nrow(df.comb.slope)
#  df.comb.slope$SITE_TYPE <- df.comb.slope$`SLOPE CATEGORY`
#  
#  # Update Taxa Attributes from Master Taxa List in Package
#  df.taxamaster <- TaxaMaster_Ben_BCG_PugLowWilVal
#  names(df.taxamaster) <- toupper(names(df.taxamaster))
#  ## Assume phylogenetic information is correct.
#  col.auteco <- c("TAXAID", "BCG_ATTR", "THERMAL_INDICATOR", "LONG_LIVED", "FFG"
#                  , "HABIT", "LIFE_CYCLE", "TOLVAL")
#  df.comb.slope.auteco <- merge(df.comb.slope, df.taxamaster[, col.auteco]
#                                , by.x="TAXAID", by.y="TAXAID", all.x=TRUE)
#  nrow(df.comb.slope) == nrow(df.comb.slope.auteco)
#  
#  # Create Anlaysis File
#  col2keep <- c("SAMPLEID", "INDEX_NAME", "SITE_TYPE"
#                , "AREA_MI2", "SURFACEAREA", "DENSITY_M2", "DENSITY_FT2"
#                , "TAXAID", "N_TAXA", "EXCLUDE", "NONTARGET"
#                , "PHYLUM", "SUBPHYLUM", "CLASS", "ORDER", "FAMILY", "SUBFAMILY"
#                , "TRIBE", "GENUS"
#                , "FFG", "HABIT", "LIFE_CYCLE", "TOLVAL", "BCG_ATTR"
#                , "THERMAL_INDICATOR")
#  df.samps.bugs <- as.data.frame(df.comb.slope.auteco[, col2keep ])
#  
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # Repeat code from previous example
#  # (with minor edits)
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  
#  # QC for TRUE/FALSE (both ok)
#  # Exclude to TRUE/FALSE
#  table(df.samps.bugs$EXCLUDE)
#  # NonTarget to TRUE/FALSE
#  table(df.samps.bugs$NONTARGET)
#  
#  # 1.A. Calculate Metrics
#  # Extra columns to keep in results
#  keep.cols <- toupper(c("Area_mi2"
#                         , "SurfaceArea"
#                         , "Density_m2"
#                         , "Density_ft2"
#                         , "Site_Type"))
#  # Run Function
#  df.metrics <- metric.values(df.samps.bugs, "bugs", fun.cols2keep = keep.cols)
#  # QC
#  dim(df.metrics)
#  View(df.metrics)
#  # Save
#  write.table(df.metrics
#              , "Metric.Values.New.tsv"
#              , col.names=TRUE
#              , row.names=FALSE
#              , sep="\t")
#  
#  # 1.B. Metric Membership
#  # Import Rules
#  df.rules <- read_excel(system.file("./extdata/Rules.xlsx"
#                               , package="BCGcalc")
#                         , sheet="BCG_PugLowWilVal_500ct")
#  # Run function
#  df.Metric.Membership <- BCG.Metric.Membership(df.metrics, df.rules)
#  # Show Results
#  View(df.Metric.Membership)
#  # Save Results
#  write.table(df.Metric.Membership, "Metric.Membership.New.tsv"
#                , row.names=FALSE, col.names=TRUE, sep="\t")
#  
#  # 1.C. Level Assignment
#  # Run Function
#  df.Level.Membership <- BCG.Level.Membership(df.Metric.Membership, df.rules)
#  # Show results
#  View(df.Level.Membership)
#  # Save Results
#  write.table(df.Level.Membership, "Level.Membership.New.tsv"
#               , row.names=FALSE, col.names=TRUE, sep="\t")
#  
#  # 1.D. Level Membership
#  # Run Function
#  df.Levels <- BCG.Level.Assignment(df.Level.Membership)
#  
#  # 1.E. Flags
#  # Import QC Checks
#  df.checks <- read_excel(system.file("./extdata/MetricFlags.xlsx"
#                                            , package="BCGcalc")
#                          , sheet="Flags")
#  # Run Function
#  df.flags <- qc.checks(df.metrics, df.checks)
#  # Change terminology; PASS/FAIL to NA/flag
#  df.flags[,"FLAG"][df.flags[,"FLAG"]=="FAIL"] <- "flag"
#  df.flags[, "FLAG"][df.flags[,"FLAG"]=="PASS"] <- NA
#  # long to wide format
#  df.flags.wide <- dcast(df.flags, SAMPLEID ~ CHECKNAME, value.var="FLAG")
#  # Calc number of "flag"s by row.
#  df.flags.wide$NumFlags <- rowSums(df.flags.wide=="flag", na.rm=TRUE)
#  # Rearrange columns
#  NumCols <- ncol(df.flags.wide)
#  df.flags.wide <- df.flags.wide[, c(1, NumCols, 2:(NumCols-1))]
#  # Merge Levels and Flags
#  df.Levels.Flags <- merge(df.Levels, df.flags.wide, by="SAMPLEID", all.x=TRUE)
#  # Show Results
#  View(df.Levels.Flags)
#  # Summarize Results
#  table(df.flags[,"CHECKNAME"], df.flags[,"FLAG"], useNA="ifany")
#  # Save Results
#  write.csv(df.Levels.Flags, "Levels.Flags.New.csv")

## ----Other_Rarify, eval=TRUE, echo=TRUE---------------------------------------
library(BCGcalc)
library(knitr)
library(BioMonTools)

# Subsample to 600 organisms (from over 600 organisms) for 12 samples.

## FileName
### Package example
df_data <- BioMonTools::data_bio2rarify
### Excel
# wd <- "F:\\myDocs"
# fn_data <- file.path(wd, "ExampleMunge_UnformatedData.xlsx")
# readxl::read_excel(fn.data)
### CSV
# fn_data <- 
# df_data <- read.csv(fn_data)
#
df_biodata <- df_data
#dim(df_biodata)
#View(df_biodata)

# subsample
mySize <- 600
Seed_OR <- 18590214
Seed_WA <- 18891111
Seed_US <- 17760704
bugs_mysize <- BioMonTools::rarify(inbug=df_biodata, sample.ID="SampleID"
                     ,abund="N_Taxa",subsiz=mySize, mySeed=Seed_US)
#dim(bugs.mysize)
#View(bugs.mysize)

# Compare pre- and post- subsample counts
df_compare <- merge(df_biodata, bugs_mysize, by=c("SampleID", "TaxaID")
                    , suffixes = c("_Orig","_600"))
df_compare <- df_compare[,c("SampleID", "TaxaID", "N_Taxa_Orig", "N_Taxa_600")]
#View(df.compare)

# compare totals
tbl_compare <- head(df_compare)
tbl_compare_caption <- "First few rows of original and rarified data."
kable(tbl_compare, caption=tbl_compare_caption)

tbl_totals <- aggregate(cbind(N_Taxa_Orig, N_Taxa_600) ~ SampleID
                        , df_compare, sum)
tbl_totals_caption <- "Comparison of total individuals per sample."
kable(tbl_totals, caption=tbl_totals_caption)

# save the data
#write.table(bugs.mysize,paste("bugs",mySize,"txt",sep="."),sep="\t")


## ----MetricValues_Keep1, eval = FALSE-----------------------------------------
#  # Packages
#  library(BCGcalc)
#  library(readxl)
#  library(knitr)
#  library(BioMonTools)
#  
#  # Load Data
#  df.data <- read_excel(system.file("./extdata/Data_BCG_PugLowWilVal.xlsx"
#                                         , package="BCGcalc")
#                        , guess_max = 10^6)
#  # Columns to keep
#  myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2", "Site_Type")
#  # Metrics of Interest (BCG)
#  col.met2keep <- c("ni_total", "nt_total", "nt_BCG_att1i2", "pt_BCG_att1i23"
#                    , "pi_BCG_att1i23", "pt_BCG_att56", "pi_BCG_att56"
#                    , "nt_EPT_BCG_att1i23", "pi_NonInsJugaRiss_BCG_att456"
#                    , "pt_NonIns_BCG_att456", "nt_EPT", "pi_NonIns_BCG_att456")
#  # Run Function
#  df.metval <- metric.values(df.data, "bugs"
#                             , fun.cols2keep=myCols
#                             , fun.MetricNames = col.met2keep)
#  1 # YES
#  
#  # Select columns
#  col.ID <- c("SAMPLEID", toupper(myCols), "INDEX_NAME", "SITE_TYPE")
#  # Ouput
#  df.metval.bcg12 <- df.metval[, c(col.ID, col.met2keep)]
#  # RMD table
#  kable(head(df.metval.bcg12), caption = "Select Metrics, Example 1")

