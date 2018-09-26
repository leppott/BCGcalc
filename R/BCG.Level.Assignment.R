#' @title BCG Level Assignment
#' 
#' @description Biological Condition Gradient level assignment (1st and 2nd) given Level memberships.
#' 
#' @details Input is L1 to L6 with membership values of 0 to 1.  
#' Result is 1st (primary) and 2nd (secondary) Level.  
#' Also give close.
#' 
#' Add QC Checks.
#' 
#' @param df.level.membership Wide data frame with level memberships (0-1).  L1 to L6.
#' 
#' @return Returns a data frame of results in the wide format.
#' 
#' @examples
#' 
#' # construct a dummy dataset
#' L1 <- c(rep(0, 10), 0, 0)
#' L2 <- c(0.4, 0, 0.4, rep(0,7), 0, 0)
#' L3 <- c(0.6, 0, 0.6, 0, 0.42, 0, 1, 1, 0.22, 0.33, 0.5, 0)
#' L4 <- c(0, 0.9, 0, 0, 0.58, 0.05, 0, 0, 0.78, 0.67, 0.5, 0)
#' L5 <- c(0, 0.1, 0, 1, 0, 0.95, rep(0,4), 0, 1)
#' L6 <- c(rep(0, 10), 0, 0)
#' SampleID <- LETTERS[1:length(L1)]
#' df.Level.Membership <- as.data.frame(SampleID, stringsAsFactors=FALSE)
#' df.Level.Membership[,"L1"] <- L1
#' df.Level.Membership[,"L2"] <- L2
#' df.Level.Membership[,"L3"] <- L3
#' df.Level.Membership[,"L4"] <- L4
#' df.Level.Membership[,"L5"] <- L5
#' df.Level.Membership[,"L6"] <- L6
#' 
#' # Run Function
#' df.Levels <- BCG.Level.Assignment(df.Level.Membership)
#' 
#' # Show Results
#' View(df.Levels)
#' 
#' # Save Results
#' write.table(df.Levels, "Levels.tsv"
#'             , row.names=FALSE, col.names=TRUE, sep="\t")
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~
#' # Example Data
#' 
#' library(readxl)
#' library(reshape2)
#' 
#' # Calculate Metrics
#' df.samps.bugs <- read_excel(system.file("./extdata/Data_BCG_PacNW.xlsx"
#'                                         , package="BCGcalc"))
#'                                         
#' # Run Function
#' myDF <- df.samps.bugs
#' df.metric.values.bugs <- metric.values(myDF, "bugs") 
#' 
#' # Import Rules
#' df.rules <- read_excel(system.file("./extdata/Rules.xlsx"
#'                              , package="BCGcalc"), sheet="BCG_PacNW_v1_500ct") 
#' 
#' # Calculate Metric Memberships
#' df.Metric.Membership <- BCG.Metric.Membership(df.metric.values.bugs, df.rules)
#' 
#' # Calculate Level Memberships
#' df.Level.Membership <- BCG.Level.Membership(df.Metric.Membership, df.rules)
#' 
#' # Run Function
#' df.Levels <- BCG.Level.Assignment(df.Level.Membership)
#' 
#' # QC Checks (flags)
#' #
#' # Import Checks
#' df.checks <- read_excel(system.file("./extdata/MetricFlags.xlsx"
#'                                           , package="BCGcalc"), sheet="Flags") 
#' # Rerun metrics including extra columns
#' myDF <- df.samps.bugs
#' myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2")
#' df.metric.values.bugs <- metric.values(myDF, "bugs", fun.cols2keep=myCols)                                         
#'
#' # Run Function
#' df.flags <- qc.checks(df.metric.values.bugs, df.checks)
#' # Change terminology; PASS/FAIL to NA/flag
#' df.flags[,"FLAG"][df.flags[,"FLAG"]=="FAIL"] <- "flag"
#' df.flags[, "FLAG"][df.flags[,"FLAG"]=="PASS"] <- NA
#' 
#' # long to wide format
#' df.flags.wide <- dcast(df.flags, SAMPLEID ~ CHECKNAME, value.var="FLAG")
#' # Calc number of "flag"s by row.
#' df.flags.wide$NumFlags <- rowSums(df.flags.wide=="flag", na.rm=TRUE)
#' # Rearrange columns
#' NumCols <- ncol(df.flags.wide)
#' df.flags.wide <- df.flags.wide[, c(1, NumCols, 2:(NumCols-1))]
#' 
#' # Merge Levels and Flags
#' df.Levels.Flags <- merge(df.Levels, df.flags.wide, by="SAMPLEID", all.x=TRUE)
#' 
#' # Show Results
#' View(df.Levels.Flags)
#'              
#' # Summarize Results
#' table(df.flags[,"CHECKNAME"], df.flags[,"FLAG"], useNA="ifany")
#' 
#' \dontrun{
#' # Save Results
#' write.csv(df.Levels.Flags, "Levels.Flags.csv")
#' }
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
BCG.Level.Assignment <- function(df.level.membership){##FUNCTION.START
  #
  # to data frame
  df.result <- as.data.frame(df.level.membership)
  #
  # QC check membership (should be 1)
  df.result[,"Memb.Total"] <- round(rowSums(df.result[,paste0("L",1:6)], na.rm=TRUE),8)
  df.result[,"Memb.QC"] <- "FAIL"
  df.result[df.result[,"Memb.Total"]==1, "Memb.QC"] <- "PASS"
  #
  # add result columns
  myCol.1 <- paste0("Lev.1.", c("Memb", "Name"))
  myCol.2 <- sub("1", "2", myCol.1)
  # default to NA so don't need extra conditions later
  df.result[, c(myCol.1, myCol.2)] <- NA
  
  # Assign Levels ####
  # # quick and dirty
  # for (i in 1:nrow(df.result)){##FOR.i.START
  #   # Max Value Name
  #   df.result[i, "Lev.1.Name"] <- match(df.result[i, "Lev.1.Memb"], df.result[i, paste0("L",1:6)])
  #   # Remove max and get max of remainder
  #   df.result[i, "Lev.2.Memb"]  <- max(df.result[i, paste0("L",1:6)][-df.result[i, "Lev.1.Name"]], na.rm=TRUE)
  #   # match 2nd
  #   if(df.result[i, "Lev.1.Memb"]==1){##IF.START
  #     df.result[i, "Lev.2.Name"] <- NA
  #   } else {
  #     df.result[i, "Lev.2.Name"] <- match(df.result[i, "Lev.2.Memb"], df.result[i, paste0("L",1:6)]) 
  #   }##IF.END
  #   #
  #   df.result[i, "Lev.Memb.Diff"] <- df.result[i, "Lev.1.Memb"] - df.result[i, "Lev.2.Memb"]
  #   #df.levels[i, "Lev.Memb.close"] <- NA
  #   
  #   if(df.result[i,"Lev.Memb.Diff"]<0.2){
  #     df.result[i, "Lev.Memb.close"] <- "yes"
  #   }
  #   if(df.result[i,"Lev.Memb.Diff"]<0.1){
  #     df.result[i, "Lev.Memb.close"] <- "tie"
  #   }
  # }##FOR.i.END
  #
  # should be able to redo with apply similar to Level Assignment
  #
  # Primary Level Value: Max Value
  df.result[, "Lev.1.Memb"] <- apply(df.result[, c(paste0("L",1:6))], 1, max, na.rm=TRUE)
  # df.result[, "Lev.1.Name"] <- apply(df.result, 1, function(x) match(df.result[,"Lev.1.Memb"]
  #                                                                    , df.result[,paste0("L",1:6)]))
  # Primary Level Name; Max Value Name
  df.result[, "Lev.1.Name"] <- apply(df.result[,c(paste0("L",1:6), "Lev.1.Memb")], 1
                                     , function(x) match(x[7], x[1:6]))
  # Secondary Level Value; 2nd Max
  df.result[, "Lev.2.Memb"] <- apply(df.result[,c(paste0("L",1:6), "Lev.1.Name")], 1
                                     , function(x) max(x[1:6][-x[7]], na.rm=TRUE))
  # Force 2nd Value to be 0 if 1st is "1"
  df.result[df.result[,"Lev.1.Memb"]==1, "Lev.2.Memb"] <- 0
  # Secondary Level Name; 2nd Max (but NA if Secondary Value is 0)
  df.result[df.result[, "Lev.2.Memb"]!=0, "Lev.2.Name"] <- apply(
    df.result[df.result[, "Lev.2.Memb"]!=0, c(paste0("L",1:6), "Lev.2.Memb")]
    , 1
    , function(x) match(x[7], x[1:6]))
  ## need condition for 50/50 split (no other duplicate should occur)
  df.result[df.result[, "Lev.2.Memb"]==0.5, "Lev.2.Name"] <- apply(
    df.result[df.result[, "Lev.2.Memb"]==0.5, c(paste0("L",1:6))]
      , 1
      , function(x) which(x[1:6]==0.5)[2])

  # Diff
  df.result[, "Lev.Memb.Diff"] <- df.result[,"Lev.1.Memb"] - df.result[,"Lev.2.Memb"]
  # Close
  df.result[df.result[,"Lev.Memb.Diff"]<0.2, "Lev.Memb.close"] <- "yes"
  # Tie
  df.result[df.result[,"Lev.Memb.Diff"]<0.1, "Lev.Memb.close"] <- "tie"
  
  
  # Close
  # df.result[, "Lev.Memb.Diff"] <- df.result[, "Lev.1.Memb"] - df.result[, "Lev.2.Memb"]
  # df.result[,"Lev.Memb.close"] <- NA
  # df.result[df.result[,"Lev.Memb.Diff"]<0.2, "Lev.Memb.close"] <- "yes"
  # df.result[df.result[,"Lev.Memb.Diff"]<0.1, "Lev.Memb.close"] <- "tie"

  # create output
  return(df.result)
  #
}##FUNCTION.END
