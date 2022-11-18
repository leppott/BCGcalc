#' @title BCG Level Assignment
#' 
#' @description Biological Condition Gradient level assignment (1st and 2nd) 
#' given Level memberships.
#' 
#' @details Input is L1 to L6 with membership values of 0 to 1.  
#' Result is 1st Level (Primary_BCG_Level) and 2nd Level (Secondary_BCG_Level). 
#' Also give close (Membership_Close) and a proportional Level 
#' assignment ("Lev.Prop").
#' 
#' 
#' @param df.level.membership Wide data frame with level memberships (0-1).
#' @param col_SampleID Column name for sample id.  Default = "SAMPLEID"
#' @param col_L1 Column name for memberships, Level 1.  Default = "L1"
#' @param col_L2 Column name for memberships, Level 2.  Default = "L2"
#' @param col_L3 Column name for memberships, Level 3.  Default = "L3"
#' @param col_L4 Column name for memberships, Level 4.  Default = "L4"
#' @param col_L5 Column name for memberships, Level 5.  Default = "L5"
#' @param col_L6 Column name for memberships, Level 6.  Default = "L6"
#' 
#' @return Returns a data frame of results in the wide format.
#' 
#' @examples
#' # Example 1
#' 
#' # construct a dummy dataset
#' L1 <- c(rep(0, 12))
#' L2 <- c(0.4, 0, 0.4, rep(0,7), 0, 0)
#' L3 <- c(0.6, 0, 0.6, 0, 0.42, 0, 1, 1, 0.22, 0.33, 0.5, 0)
#' L4 <- c(0, 0.9, 0, 0, 0.58, 0.05, 0, 0, 0.78, 0.67, 0.5, 0)
#' L5 <- c(0, 0.1, 0, 1, 0, 0.95, rep(0,4), 0, 1)
#' L6 <- c(rep(0, length(L1)))
#' SAMPLEID <- LETTERS[1:length(L1)]
#' df_lev_memb <- data.frame(SAMPLEID = SAMPLEID
#'                           , L1 = L1
#'                           , L2 = L2
#'                           , L3 = L3
#'                           , L4 = L4
#'                           , L5 = L5
#'                           , L6 = L6)
#' 
#' # Run Function
#' df_Levels <- BCG.Level.Assignment(df_lev_memb)
#' 
#' # Show Results
#' #View(df_Levels)
#' 
#' # Save Results
#' write.table(df_Levels
#'             , file.path(tempdir(), "Levels.tsv")
#'             , row.names = FALSE
#'             , col.names = TRUE
#'             , sep = "\t")
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~
#' 
#' # Example 2
#' 
#' # library(readxl)
#' # library(reshape2) 
#' # library(BioMonTools)
#' 
#' # Calculate Metrics
#' df_samps_bugs <- readxl::read_excel(system.file(
#'                                        "extdata/Data_BCG_PugLowWilVal.xlsx"
#'                                         , package="BCGcalc")
#'                            , guess_max = 10^6)
#'                                         
#' # Run Function
#' myDF <- df_samps_bugs
#' myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2"
#'             , "INDEX_CLASS")
#' #' # populate missing columns prior to metric calculation
#' col_missing <- c("INFRAORDER", "HABITAT", "ELEVATION_ATTR", "GRADIENT_ATTR"
#'                  , "WSAREA_ATTR", "HABSTRUCT", "UFC")
#' myDF[, col_missing] <- NA
#' df_met_val_bugs <- BioMonTools::metric.values(myDF
#'                                               , "bugs"
#'                                               , fun.cols2keep = myCols) 
#' 
#' # Import Rules
#' df_rules <- readxl::read_excel(system.file("extdata/Rules.xlsx"
#'                                            , package="BCGcalc")
#'                               , sheet="Rules") 
#' 
#' # Calculate Metric Memberships
#' df_met_memb <- BCG.Metric.Membership(df_met_val_bugs, df_rules)
#' 
#' # Calculate Level Memberships
#' df_lev_memb <- BCG.Level.Membership(df_met_memb, df_rules)
#' 
#' # Run Function
#' df_Levels <- BCG.Level.Assignment(df_lev_memb)
#' 
#' # QC Checks (flags)
#' #
#' # Import Checks
#' df_checks <- readxl::read_excel(system.file("extdata/MetricFlags.xlsx"
#'                                             , package="BCGcalc")
#'                                , sheet="Flags") 
#'
#' # Run Function
#' df_flags <- BioMonTools::qc.checks(df_met_val_bugs, df_checks)
#' # Change terminology; PASS/FAIL to NA/flag
#' df_flags[, "FLAG"][df_flags[, "FLAG"] == "FAIL"] <- "flag"
#' df_flags[, "FLAG"][df_flags[, "FLAG"] == "PASS"] <- NA
#' 
#' # long to wide format
#' df_flags_wide <- reshape2::dcast(df_flags
#'                                  , SAMPLEID ~ CHECKNAME
#'                                  , value.var="FLAG")
#' # Calc number of "flag"s by row.
#' df_flags_wide$NumFlags <- rowSums(df_flags_wide == "flag", na.rm = TRUE)
#' # Rearrange columns
#' NumCols <- ncol(df_flags_wide)
#' df_flags_wide <- df_flags_wide[, c(1, NumCols, 2:(NumCols - 1))]
#' 
#' # Merge Levels and Flags
#' df_lev_flags <- merge(df_Levels
#'                       , df_flags_wide
#'                       , by.x = "SampleID"
#'                       , by.y = "SAMPLEID"
#'                       , all.x = TRUE)
#'              
#' # Summarize Results
#' table(df_flags[, "CHECKNAME"], df_flags[, "FLAG"], useNA = "ifany")
#' 
#' # Show Results
#' # View(df_lev_flags)
#' 
#' # Save Results
#' write.csv(df_lev_flags, file.path(tempdir(), "Level_Flags.csv"))
#' 
#' # Summary Report
#'  strFile.RMD <- system.file(paste0("rmd/Results_Summary.Rmd")
#'                             , package = "BCGcalc")
#' strFile.RMD.format <- "html_document"
#' strFile.out <- "_bcgcalc_RESULTS.html"
#' dir.export <- tempdir()
#' rmarkdown::render(strFile.RMD
#'                   , output_format = strFile.RMD.format
#'                   , output_file = strFile.out
#'                   , output_dir = dir.export
#'                   , quiet = TRUE)
#' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# SampleID <- LETTERS[1:10]
# df.Level.Membership <- as.data.frame(SampleID, stringsAsFactors=FALSE)
# df.Level.Membership[,"L1"] <- L1
# df.Level.Membership[,"L2"] <- L2
# df.Level.Membership[,"L3"] <- L3
# df.Level.Membership[,"L4"] <- L4
# df.Level.Membership[,"L5"] <- L5
# df.Level.Membership[,"L6"] <- L6
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Level.Assignment <- function(df.level.membership
                                 , col_SampleID = "SAMPLEID"
                                 , col_L1 = "L1"
                                 , col_L2 = "L2"
                                 , col_L3 = "L3"
                                 , col_L4 = "L4"
                                 , col_L5 = "L5"
                                 , col_L6 = "L6") {
  # global variable binding
  df_Lev_Memb <- NULL
  
  # QC
  boo_QC <- FALSE
  if(isTRUE(boo_QC)) {
    # construct a dummy dataset
    L1 <- c(rep(0, 12))
    L2 <- c(0.4, 0, 0.4, rep(0,7), 0, 0)
    L3 <- c(0.6, 0, 0.6, 0, 0.42, 0, 1, 1, 0.22, 0.33, 0.5, 0)
    L4 <- c(0, 0.9, 0, 0, 0.58, 0.05, 0, 0, 0.78, 0.67, 0.5, 0)
    L5 <- c(0, 0.1, 0, 1, 0, 0.95, rep(0,4), 0, 1)
    L6 <- c(rep(0, length(L1)))
    SAMPLEID <- LETTERS[1:length(L1)]
    df_lev_memb <- data.frame(SAMPLEID = SAMPLEID
                              , L1 = L1
                              , L2 = L2
                              , L3 = L3
                              , L4 = L4
                              , L5 = L5
                              , L6 = L6)
    # function inputs
    df.level.membership <- df_lev_memb
    col_SampleID <- "SAMPLEID"
    col_L1 <- "L1"
    col_L2 <- "L2"
    col_L3 <- "L3"
    col_L4 <- "L4"
    col_L5 <- "L5"
    col_L6 <- "L6"
  }## IF ~ boo_QC ~ END
  
  # to data frame
  df.result <- as.data.frame(df.level.membership)
  #
  # QC, columns
  col_keep <- c(col_SampleID, col_L1, col_L2, col_L3, col_L4, col_L5, col_L6)
  df.result <- df.result[, col_keep]
  names(df.result) <- c("SampleID", paste0("L", 1:6))
  
  # QC check membership (should be 1)
  df.result[, "Membership_Total"] <- round(rowSums(df.result[, paste0("L", 1:6)]
                                             , na.rm = TRUE), 8)
  df.result[, "Membership_Total_QC"] <- "FAIL"
  df.result[df.result[, "Membership_Total"] == 1
            , "Membership_Total_QC"] <- "PASS"
  #
  # add result columns
  myCol.1 <- paste0("Primary_", c("BCG_Level", "Membership"))
  myCol.2 <- sub("Primary_", "Secondary_", myCol.1)
  # default to NA so don't need extra conditions later
  df.result[, c(myCol.1, myCol.2)] <- NA
  
  # Assign Levels ####
  # # quick and dirty
  # for (i in 1:nrow(df.result)){##FOR.i.START
  #   # Max Value Name
  #   df.result[i, "Primary_BCG_Level"] <- match(df.result[i, "Primary_Membership"], df.result[i, paste0("L",1:6)])
  #   # Remove max and get max of remainder
  #   df.result[i, "Secondary_Membership"]  <- max(df.result[i, paste0("L",1:6)][-df.result[i, "Primary_BCG_Level"]], na.rm=TRUE)
  #   # match 2nd
  #   if(df.result[i, "Primary_Membership"]==1){##IF.START
  #     df.result[i, "Secondary_BCG_Level"] <- NA
  #   } else {
  #     df.result[i, "Secondary_BCG_Level"] <- match(df.result[i, "Secondary_Membership"], df.result[i, paste0("L",1:6)]) 
  #   }##IF.END
  #   #
  #   df.result[i, "Membership_Diff"] <- df.result[i, "Primary_Membership"] - df.result[i, "Secondary_Membership"]
  #   #df.levels[i, "Membership_Close"] <- NA
  #   
  #   if(df.result[i,"Membership_Diff"]<0.2){
  #     df.result[i, "Membership_Close"] <- "yes"
  #   }
  #   if(df.result[i,"Membership_Diff"]<0.1){
  #     df.result[i, "Membership_Close"] <- "tie"
  #   }
  # }##FOR.i.END
  #
  # should be able to redo with apply similar to Level Assignment
  #
  # Primary Level Value: Max Value
  df.result[, "Primary_Membership"] <- apply(df.result[, c(paste0("L", 1:6))]
                                     , 1
                                     , max
                                     , na.rm = TRUE)
  # df.result[, "Primary_BCG_Level"] <- apply(df.result, 1, function(x) match(df.result[,"Primary_Membership"]
  #                                                                    , df.result[,paste0("L",1:6)]))
  # Primary Level Name; Max Value Name
  df.result[, "Primary_BCG_Level"] <- apply(df.result[,c(paste0("L", 1:6)
                                                    , "Primary_Membership")], 1
                                     , function(x) match(x[7], x[1:6]))
  # Secondary Level Value; 2nd Max
  df.result[, "Secondary_Membership"] <- apply(df.result[, c(paste0("L", 1:6)
                                                      , "Primary_BCG_Level")], 1
                                  , function(x) max(x[1:6][-x[7]], na.rm=TRUE))
  # Force 2nd Value to be 0 if 1st is "1"
  df.result[df.result[, "Primary_Membership"] == 1, "Secondary_Membership"] <- 0
  # Secondary Level Name; 2nd Max (but NA if Secondary Value is 0)
  df.result[df.result[, "Secondary_Membership"] != 0, "Secondary_BCG_Level"] <- apply(
    df.result[df.result[, "Secondary_Membership"] != 0, c(paste0("L", 1:6), "Secondary_Membership")]
    , 1
    , function(x) match(x[7], x[1:6]))
  ## need condition for 50/50 split (no other duplicate should occur)
  df.result[df.result[, "Secondary_Membership"] == 0.5, "Secondary_BCG_Level"] <- apply(
    df.result[df.result[, "Secondary_Membership"] == 0.5, c(paste0("L", 1:6))]
      , 1
      , function(x) which(x[1:6] == 0.5)[2])

  # Diff
  df.result[, "Membership_Diff"] <- df.result[, "Primary_Membership"] -
                                                   df.result[, "Secondary_Membership"]
  # Close
  df.result[df.result[,"Membership_Diff"] < 0.2, "Membership_Close"] <- "yes"
  # Tie
  df.result[df.result[,"Membership_Diff"] < 0.1, "Membership_Close"] <- "tie"
  
  
  # Close
  # df.result[, "Membership_Diff"] <- df.result[, "Primary_Membership"] - df.result[
  # , "Secondary_Membership"]
  # df.result[,"Membership_Close"] <- NA
  # df.result[df.result[,"Membership_Diff"]<0.2, "Membership_Close"] <- "yes"
  # df.result[df.result[,"Membership_Diff"]<0.1, "Membership_Close"] <- "tie"
  
  # Proportional (Continuous) Assignment, Numeric----
  Lev.Col <- c(paste0("L",1:6))
  #df.result[,"Lev.Prop"] <- NA
  df.result[,"Continuous_BCG_Level"] <- apply(t((1:6) * t(df.result[,Lev.Col]))
                                      , 1
                                      , FUN = sum)
  
  # Proportional (Continuous) Assignment, Narrative----
  df.result.prop <- df.result
  df.result.prop[, "Continuous_BCG_Level.Int"] <- round(df.result.prop[, "Continuous_BCG_Level"]
                                                , 0)
  df.result.prop[, "Continuous_BCG_Level.Rem"]      <- df.result.prop[
                                                        , "Continuous_BCG_Level.Int"] - 
                                                df.result.prop[, "Continuous_BCG_Level"]
  df.result.prop[, "Continuous_BCG_Level.Sign"] <- sign(df.result.prop[
                                                          , "Continuous_BCG_Level.Rem"])
  df.result.prop[, "Continuous_BCG_Level.Sign.Nar"] <- ifelse(df.result.prop[
                                                    , "Continuous_BCG_Level.Sign"] == -1
                                                  , "-"
                                                  , ifelse(df.result.prop[
                                                     , "Continuous_BCG_Level.Sign"] == 1
                                                    , "+"
                                                    , ""))
  df.result.prop[, "BCG_Status"] <- paste0(df.result.prop[
    , "Continuous_BCG_Level.Int"], df.result.prop[, "Continuous_BCG_Level.Sign.Nar"])
  df.result.prop[, "BCG_Status.Tie"]      <- ifelse(df.result.prop[
    , "Membership_Close"]=="tie", paste0(df.result.prop[, "Primary_BCG_Level"], "/"
                                       , df.result.prop[, "Secondary_BCG_Level"]," tie")
    , NA)
  df.result.prop[!is.na(df.result.prop[, "BCG_Status.Tie"])
                 , "BCG_Status"] <- df.result.prop[ !is.na(df.result.prop[
                   , "BCG_Status.Tie"]), "BCG_Status.Tie"]
  #
  df.result[, "BCG_Status"] <- df.result.prop[, "BCG_Status"]
  
  # new field 2022-11-18
  # BCG_Status no plus minus
  df.result[, "BCG_Status2"] <- NA
  
  # create output
  return(df.result)
  #
}##FUNCTION.END
