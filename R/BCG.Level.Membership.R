#' @title BCG Level Membership
#' 
#' @description Biological Condition Gradient Level assignment given metric memberships.
#' 
#' @details Input is metric memberships and a rules tables.  
#' Output is a data frame with the membership for each row to each Level (1:6).
#' Minimum of:
#' * 1- sum of previous levels
#' * Rule0 memberships
#' * max of Alt1 rules (and min of Alt2 rules)
#' That is, perform calculations in this order:
#' 1. Min of Alt2 metric memberships
#' 2. Max of Alt2 rules and the above result.
#' 3. Min of Rule0, the above result, and the sum of previous levels.
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
# #  Calculate Metrics
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
# df.Level.Membership <- BCG.Level.Membership(df.metric.membership, df.rules)
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# df.metric.membership <- as.data.frame(df.metric.membership)
# df.rules <- as.data.frame(df.rules)
# 
# # Convert names to upper case
# names(df.metric.membership) <- toupper(names(df.metric.membership))
# names(df.rules) <- toupper(names(df.rules))
# 
# # SITE_TYPE to lowercase
# df.metric.membership[,"SITE_TYPE"] <- tolower(df.metric.membership[,"SITE_TYPE"])
# df.rules[,"SITE_TYPE"] <- tolower(df.rules[,"SITE_TYPE"])
# 
# # Drop extra columns from df.metric.membership
# # (otherwise duplicates in merge)
# col.drop <- c("NUMERIC_RULES", "SYMBOL", "LOWER", "UPPER", "INCREASE", "DESCRIPTION")
# col.keep <- names(df.metric.membership)[!(names(df.metric.membership) %in% col.drop)]
# 
# # merge metrics and rules
# df.merge <- merge(df.metric.membership[,col.keep], df.rules
#                   , by.x=c("INDEX_NAME", "SITE_TYPE", "LEVEL", "METRIC_NAME", "RULE_TYPE")
#                   , by.y=c("INDEX_NAME", "SITE_TYPE", "LEVEL", "METRIC_NAME", "RULE_TYPE"))
# 
# 
# df.merge <- df.merge[df.merge$SAMPLEID=="06029CSR_Bug_2006-09-27_0", ]
# 
# 
# df.lev <- dplyr::summarise(dplyr::group_by(df.merge, SAMPLEID, INDEX_NAME
#                                            , SITE_TYPE, LEVEL)
#                            #
#                            # Min of Alt2
#                            , MembCalc_Alt2_min=min(MEMBERSHIP[RULE_TYPE == "Alt2"], na.rm=TRUE)
#                            # Max of Alt1
#                            , MembCalc_Alt1_max=max(MEMBERSHIP[RULE_TYPE == "Alt1"], na.rm=TRUE)
#                            # Min of Rule0 (with alt above)
#                            , MembCalc_Rule0_min=min(MEMBERSHIP[RULE_TYPE == "Rule0"], na.rm=TRUE)
# )
# View(df.merge)
# View(df.lev)
# 
# # convert from tibble to df
# df.lev <- as.data.frame(df.lev)
# # replace Inf and -Inf with NA
# df.lev[!is.finite(df.lev[,"MembCalc_Alt2_min"]), "MembCalc_Alt2_min"] <- NA
# df.lev[!is.finite(df.lev[,"MembCalc_Alt1_max"]), "MembCalc_Alt1_max"] <- NA
# # this one shouldn't happen.  Use zero just in case.
# df.lev[!is.finite(df.lev[,"MembCalc_Rule0_min"]), "MembCalc_Rule0_min"] <- 0
# 
# View(df.lev)
# 
# df.lev[,"MembCalc_Alt12_max"] <- apply(df.lev[,c("MembCalc_Alt2_min", "MembCalc_Alt1_max")]
#                                        , 1, max, na.rm=TRUE)
# View(df.lev)
# 
# df.lev[!is.finite(df.lev[,"MembCalc_Alt12_max"]), "MembCalc_Alt12_max"] <- NA
# View(df.lev)
# 
# df.lev[,"Level.Membership"] <- apply(df.lev[,c("MembCalc_Alt12_max", "MembCalc_Rule0_min")]
#                                      , 1, min, na.rm=TRUE)
# View(df.lev)

#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Level.Membership <- function(df.metric.membership, df.rules){##FUNCTION.START
  #
  # # convert membership to long format if provided
  # # Metrics to long
  # if (input.shape=="wide") {##IF.input.shape.START
  #   df.long <- reshape2::melt(df.metric.membership, id.vars=c("SAMPLEID", "INDEX_NAME", "SITE_TYPE")
  #                             , variable.name="METRIC_NAME", value.name="METRIC_VALUE")
  # } else {
  #   df.long <- df.metric.membership
  # }##IF.input.shape.END
  
  # Convert to data.frame (from Tibble)
  df.metric.membership <- as.data.frame(df.metric.membership)
  df.rules <- as.data.frame(df.rules)
  
  # Convert names to upper case
  names(df.metric.membership) <- toupper(names(df.metric.membership))
  names(df.rules) <- toupper(names(df.rules))
  
  # SITE_TYPE to lowercase
  df.metric.membership[,"SITE_TYPE"] <- tolower(df.metric.membership[,"SITE_TYPE"])
  df.rules[,"SITE_TYPE"] <- tolower(df.rules[,"SITE_TYPE"])
  
  # Drop extra columns from df.metric.membership
  # (otherwise duplicates in merge)
  col.drop <- c("NUMERIC_RULES", "SYMBOL", "LOWER", "UPPER", "INCREASE", "DESCRIPTION")
  col.keep <- names(df.metric.membership)[!(names(df.metric.membership) %in% col.drop)]
  
  # merge metrics and rules
  df.merge <- merge(df.metric.membership[,col.keep], df.rules
                    , by.x=c("INDEX_NAME", "SITE_TYPE", "LEVEL", "METRIC_NAME", "RULE_TYPE")
                    , by.y=c("INDEX_NAME", "SITE_TYPE", "LEVEL", "METRIC_NAME", "RULE_TYPE"))
  
  # Min of Alt2
  # Max of Alt1 (with Min of Alt2)
  # Min of Rule0 (with alt above)
  
  # Will get lots of warnings for the SampID that don't have alt 1 or alt 2 rules
  suppressWarnings(
    df.lev <- dplyr::summarise(dplyr::group_by(df.merge, SAMPLEID, INDEX_NAME
                                                 , SITE_TYPE, LEVEL)
                              #
                              # Min of Alt2
                              , MembCalc_Alt2_min=min(MEMBERSHIP[RULE_TYPE == "Alt2"], na.rm=TRUE)
                              # Max of Alt1
                              , MembCalc_Alt1_max=max(MEMBERSHIP[RULE_TYPE == "Alt1"], na.rm=TRUE)
                              # Min of Rule0 (with alt above)
                              , MembCalc_Rule0_min=min(MEMBERSHIP[RULE_TYPE == "Rule0"], na.rm=TRUE)

  ))

  # convert from tibble to df
  df.lev <- as.data.frame(df.lev)
  # replace Inf and -Inf with NA
  df.lev[!is.finite(df.lev[,"MembCalc_Alt2_min"]), "MembCalc_Alt2_min"] <- NA
  df.lev[!is.finite(df.lev[,"MembCalc_Alt1_max"]), "MembCalc_Alt1_max"] <- NA
  # this one shouldn't happen.  Use zero just in case.
  df.lev[!is.finite(df.lev[,"MembCalc_Rule0_min"]), "MembCalc_Rule0_min"] <- 0
  
  
  # Have to do outside of dplyr to get rid of Inf and -Inf
  
  # Need to suppress warnings again
  suppressWarnings(
    df.lev[,"MembCalc_Alt12_max"] <- apply(df.lev[,c("MembCalc_Alt2_min", "MembCalc_Alt1_max")]
                                          , 1, max, na.rm=TRUE)
  )
  # replace Inf with NA
  df.lev[!is.finite(df.lev[,"MembCalc_Alt12_max"]), "MembCalc_Alt12_max"] <- NA
  
  # Final Calc
  # df.lev[,"Level.Membership"] <- min(df.lev[,"MembCalc_Alt12_max"]
  #                                      , df.lev[,"MembCalc_Rule0_min"], na.rm=TRUE)
  
  
  df.lev[,"Level.Membership"] <- apply(df.lev[,c("MembCalc_Alt12_max", "MembCalc_Rule0_min")]
                                         , 1, min, na.rm=TRUE)
  # add extra to "Level"
  df.lev[,"LEVEL"] <- paste0("L", df.lev[,"LEVEL"])
  
  df.lev.wide <- reshape2::dcast(df.lev, SAMPLEID + INDEX_NAME + SITE_TYPE
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
  df.subtotal <- df.lev.wide[,c(col.Other, col.Levels)]
  # rename L1:6 with .sub
  col.rename <- names(df.subtotal) %in% col.Levels
  col.sub <- paste0(names(df.subtotal)[col.rename], ".Sub")
  names(df.subtotal)[col.rename] <- col.sub
  # Calculate Final scoring
  ## Need to consider other final scores (use apply)
  df.subtotal[,"L1"] <- df.subtotal[,"L1.Sub"]
  
  df.subtotal[,"L2"] <- apply(df.subtotal[,c("L1", "L2.Sub")], 1
                              , function(x) min(1-x[1], x[2], na.rm=TRUE))
  df.subtotal[,"L3"] <- apply(df.subtotal[,c("L1", "L2", "L3.Sub")], 1
                              , function(x) min(1-sum(x[1], x[2], na.rm=TRUE)
                                                , x[3], na.rm=TRUE))
  df.subtotal[,"L4"] <- apply(df.subtotal[,c("L1", "L2", "L3", "L4.Sub")], 1
                              , function(x) min(1-sum(x[1], x[2], x[3], na.rm=TRUE)
                                                , x[4], na.rm=TRUE))
  df.subtotal[,"L5"] <- apply(df.subtotal[,c("L1", "L2", "L3", "L4", "L5.Sub")], 1
                              , function(x) min(1-sum(x[1], x[2], x[3], x[4], na.rm=TRUE)
                                                , x[5], na.rm=TRUE))
  df.subtotal[,"L6"] <- apply(df.subtotal[,c("L1", "L2", "L3", "L4", "L5")], 1
                              , function(x) 1-sum(x[1], x[2], x[3], x[4], x[5], na.rm=TRUE))
  # Return RESULTS ####
  # Remove sub fields
  df.results <- df.subtotal[,!(names(df.subtotal) %in% col.sub)]
  # Results are for each SAMPLEID, INDEX_NAME, SITE_TYPE, and LEVEL Assignment/Membership
  # create output
  return(df.results)
  #
}##FUNCTION.END
