#' @title BCG Level Membership
#' 
#' @description Biological Condition Gradient Level assignment given metric memberships.
#' 
#' @details Input is metric memberships and a rules tables.  Output are 
#' 
#' @param df.metric.membership Data frame of metric memberships (long format, the same as the output of BCG.Membership).
#' @param df.rules Data frame of BCG model rules.
#'
#' @return Returns a data frame of results in the wide format.
#' 
#' @examples
#' library(readxl)
#' 
#' # Calculate Metrics
#' df.samps.bugs <- read_excel(system.file("./extdata/Data_BCG_PacNW.xlsx"
#'                                         , package="BCGcalc"))
#' myDF <- df.samps.bugs
#' df.metric.values.bugs <- metric.values(myDF, "bugs")
#' 
#' # Import Rules
#' df.rules <- read_excel(system.file("./extdata/Rules.xlsx"
#'                              , package="BCGcalc"), sheet="BCG_PacNW_2018") 
#' 
#' # Calculate Metric Memberships
#' df.Metric.Membership <- BCG.Metric.Membership(df.metric.values.bugs, df.rules)
#' 
#' # Calculate Level Memberships
#' df.Level.Membership <- BCG.Level.Membership(df.Metric.Membership, df.rules)
#' 
#' # Show results
#' View(df.Level.Membership)
#' 
#' # Save Results
#' write.table(df.Level.Membership, "Level.Membership.tsv"
#'             , row.names=FALSE, col.names=TRUE, sep="\t")
#' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# library(BCGcalc)
# library(readxl)
# # Calculate Metrics
# df.samps.bugs <- read_excel(system.file("./extdata/Data_BCG_PacNW.xlsx"
#                                         , package="BCGcalc"))
# myDF <- df.samps.bugs
# df.metric.values.bugs <- metric.values(myDF, "bugs")
# 
# # Import Rules
# df.rules <- read_excel(system.file("./extdata/Rules.xlsx"
#                              , package="BCGcalc"), sheet="BCG_PacNW_2018")
# # Calculate Membership
# df.metric.membership <- BCG.Metric.Membership(df.metric.values.bugs, df.rules)
# #
# input.shape <- "long"
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Level.Membership <- function(df.metric.membership, df.rules){##FUNCTION.START
  #
  # # convert membership to long format if provided
  # # Metrics to long
  # if (input.shape=="wide") {##IF.input.shape.START
  #   df.long <- reshape2::melt(df.metric.membership, id.vars=c("SAMPLEID", "INDEX_NAME", "SITETYPE")
  #                             , variable.name="metric.name", value.name="metric.value")
  # } else {
  #   df.long <- df.metric.membership
  # }##IF.input.shape.END
  
  # Convert names to upper case
  names(df.metric.membership) <- toupper(names(df.metric.membership))
  names(df.rules) <- toupper(names(df.rules))
  
  # Drop extra columns from df.metric.membership
  # (otherwise duplicates in merge)
  col.drop <- c("NUMERIC RULES", "SYMBOL", "LOWER", "UPPER", "INCREASE", "DESCRIPTION", "RULETYPE")
  col.keep <- names(df.metric.membership)[!(names(df.metric.membership) %in% col.drop)]
  
  # merge metrics and rules
  df.merge <- merge(df.metric.membership[,col.keep], df.rules
                    , by.x=c("INDEX_NAME", "SITETYPE", "LEVEL", "METRIC.NAME")
                    , by.y=c("INDEX_NAME", "SITETYPE", "LEVEL", "METRIC.NAME"))
  
  # Min of Alt2
  # Max of Alt1 (with Min of Alt2)
  # Min of Rule0 (with alt above)
  
  # Will get lots of warnings for the SampID that don't have alt 1 or alt 2 rules
  suppressWarnings(
    df.lev <- dplyr::summarise(dplyr::group_by(df.merge, SAMPLEID, INDEX_NAME
                                                 , SITETYPE, LEVEL)
                              #
                              # Min of Alt2
                              , MembCalc1_Alt2=min(MEMBERSHIP[RULETYPE == "Alt2"], na.rm=TRUE)
                              # Max of Alt1
                              , MembCalc2_Alt1=max(MEMBERSHIP[RULETYPE == "Alt1"], na.rm=TRUE)
                              # Min of Rule0 (with alt above)
                              , MembCalc3_Rule0=min(MEMBERSHIP[RULETYPE == "Rule0"], na.rm=TRUE)

  ))

  # convert from tible to df
  df.lev <- as.data.frame(df.lev)
  # replace Inf and -Inf with NA
  df.lev[!is.finite(df.lev[,"MembCalc1_Alt2"]), "MembCalc1_Alt2"] <- NA
  df.lev[!is.finite(df.lev[,"MembCalc2_Alt1"]), "MembCalc2_Alt1"] <- NA
  # this one shouldn't happen.  Use zero just in case.
  df.lev[!is.finite(df.lev[,"MembCalc3_Rule0"]), "MembCalc3_Rule0"] <- 0
  
  
  # Have to do outside of dplyr to get rid of Inf and -Inf
  
  # Need to suppress warnings again
  suppressWarnings(
    df.lev[,"MembCalc4_Max12"] <- apply(df.lev[,c("MembCalc1_Alt2", "MembCalc2_Alt1")]
                                          , 1, max, na.rm=TRUE)
  )
  # replace Inf with NA
  df.lev[!is.finite(df.lev[,"MembCalc4_Max12"]), "MembCalc4_Max12"] <- NA
  
  # Final Calc
  # df.lev[,"Level.Membership"] <- min(df.lev[,"MembCalc4_Max12"]
  #                                      , df.lev[,"MembCalc3_Rule0"], na.rm=TRUE)
  
  
  df.lev[,"Level.Membership"] <- apply(df.lev[,c("MembCalc4_Max12", "MembCalc3_Rule0")]
                                         , 1, min, na.rm=TRUE)
  # add extra to "Level"
  df.lev[,"LEVEL"] <- paste0("L", df.lev[,"LEVEL"])
  
  df.lev.wide <- reshape2::dcast(df.lev, SAMPLEID + INDEX_NAME + SITETYPE 
                                 ~ LEVEL, value.var="Level.Membership"
                                 )
  # Add missing Levels and sort L1:L6
  col.Levels <- c(paste0("L",1:6))
  col.Other <- names(df.lev.wide)[!(names(df.lev.wide) %in% col.Levels)]
  col.Levels.Present <- names(df.lev.wide)[(names(df.lev.wide) %in% col.Levels)]
  col.Levels.Absent  <- col.Levels[!col.Levels %in% names(df.lev.wide)]
  # Add missing Level columns
  df.lev.wide[, col.Levels.Absent] <- 0
  # Sort columns
  df.results <- df.lev.wide[,c(col.Other, col.Levels)]
  
  # Results are for each SAMPLEID, INDEX_NAME, SITETYPE, and LEVEL Assignment/Membership
  #df.results <- df.lev.wide

  # create output
  return(df.results)
  #
}##FUNCTION.END
