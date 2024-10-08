#' @title BCG Level Membership
#' 
#' @description Biological Condition Gradient Level assignment given metric 
#' memberships.
#' 
#' @details Input is metric memberships and a rules tables.  
#' 
#' Output is a data frame with the membership for each row to each Level (1:6).
#' 
#' Minimum of:
#' 
#' * 1- sum of previous levels
#' 
#' * Rule0 memberships
#' 
#' * max of Rule1 (Alternate1) rules (and min of Rule2 (Alternate2) rules)
#' 
#' That is, perform calculations in this order:
#' 
#' 1. Min of Rule2 (Alternate2) metric memberships
#' 
#' 2. Max of Rule1 (Alternate1) rules and the above result.
#' 
#' 3. Min of: Rule0, the above results, and 1 - the sum of previous levels.
#' 
#' Some exceptions exist for particular models.
#' 
#' |Index_Name       |INDEX_CLASS|
#' |:----------------|:----------|
#' |CT_BCG_2015      |fish02     |
#' |CT_BCG_2015      |fish03     |
#' |BCG_NMSandyRivers|bugs       |
#'  
#' These exceptions are mostly hard coded into the function but gather some 
#' information with the parameter col_EXC_RULE from the rules table.  A future
#' update may fully automate this process.
#' 
#' 2021 saw the introduction of Median Exception rule.  
#' For the Pacific Northwest some metrics were grouped and the 2nd of 3 values
#' is used and the other 2 values tossed when determining level membership.  
#' This equates to using the median of the 3 values.  This is handled by 
#' including "MEDIAN" in the Exc_Rule column in Rules.xlsx.  Superceded by
#' "SMALL2".
#' 
#' 2024 added SMALL2 and SMALL3 Exception rules.
#' For New Mexico BCG some metrics are grouped so use the 2nd or 3rd smallest
#' value instead of the minimum.  As above, this is handled by including 
#' "SMALL2" or "SMALL3" in the Exc_Rule column in Rules.xlsx.
#' 
#' Some Great Plains rules use multiple groupings of SMALL2.  These are coded as
#' "SMALL2A" and "SMALL2B".  If additional groupings are needed the code needs
#' to be tweaked.
#' 
#' Deprecated col_SITE_TYPE for col_INDEX_CLASS in v2.0.0.9001.
#' @md
#' 
#' @param df.metric.membership Data frame of metric memberships 
#' (long format, the same as the output of BCG.Metric.Membership).
#' @param df.rules Data frame of BCG model rules.
#' @param col_SAMPLEID column name for sample id. Default = SAMPLEID
#' @param col_INDEX_NAME column name for index name. Default = INDEX_NAME
#' @param col_INDEX_CLASS column name for site type.Default = INDEX_CLASS
#' @param col_LEVEL column name for level.  Default = LEVEL
#' @param col_METRIC_NAME column name for metric name. Default = METRIC_NAME
#' @param col_RULE_TYPE column name for rule type (e.g., Rule0, Rule1, or 
#' Rule2). Default = RULE_TYPE 
#' @param col_MEMBERSHIP column name for metric membership. Default = MEMBERSHIP
#' @param col_EXC_RULE column name for exception rules. Default = EXC_RULE 
#' @param ... Arguments passed to `BCG.MetricMembership` used internally
#'
#' @return Returns a data frame of results in the wide format.
#' 
#' @examples
#' # library(readxl)
#' # library(BioMonTools)
#' 
#' # Calculate Metrics
#' df_samps_bugs <- readxl::read_excel(
#'                            system.file("extdata/Data_BCG_PugLowWilVal.xlsx"
#'                                              , package="BCGcalc")
#'                            , guess_max = 10^6)
#' myDF <- df_samps_bugs
#' myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2")
#' # populate missing columns prior to metric calculation
#' col_missing <- c("INFRAORDER", "HABITAT", "ELEVATION_ATTR", "GRADIENT_ATTR"
#'                  , "WSAREA_ATTR", "HABSTRUCT", "UFC")
#' myDF[, col_missing] <- NA
#' df_met_val_bugs <- BioMonTools::metric.values(myDF
#'                                               , "bugs"
#'                                               , fun.cols2keep = myCols)
#' 
#' 
#' # Import Rules
#' df_rules <- readxl::read_excel(system.file("extdata/Rules.xlsx"
#'                                            , package = "BCGcalc")
#'                       , sheet="Rules") 
#' 
#' # Calculate Metric Memberships
#' df_met_memb <- BCG.Metric.Membership(df_met_val_bugs, df_rules)
#' 
#' # Calculate Level Memberships
#' df_lev_memb <- BCG.Level.Membership(df_met_memb, df_rules)
#' 
#' # Show results
#' #View(df_lev_memb)
#' 
#' # Save Results
#' write.table(df_lev_memb
#'              , file.path(tempdir(), "Level_Membership.tsv")
#'              , row.names = FALSE
#'              , col.names = TRUE
#'              , sep = "\t")
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# library(BCGcalc)
# library(readxl)
# #  Calculate Metrics
# df.samps.bugs <- read_excel(system.file("extdata/Data_BCG_PacNW.xlsx"
#                                         , package="BCGcalc")
#                             , guess_max = 10^6)
# myDF <- df.samps.bugs
# df.metric.values.bugs <- BioMonTools::metric.values(myDF, "bugs")
# 
# # Import Rules
# df.rules <- read_excel(system.file("extdata/Rules.xlsx"
#                              , package="BCGcalc"), sheet="BCG_PacNW_v1_500ct")
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
# # INDEX_CLASS to lowercase
# df.metric.membership[,"INDEX_CLASS"] <- tolower(df.metric.membership[
#,"INDEX_CLASS"])
# df.rules[,"INDEX_CLASS"] <- tolower(df.rules[,"INDEX_CLASS"])
# 
# # Drop extra columns from df.metric.membership
# # (otherwise duplicates in merge)
# col.drop <- c("NUMERIC_RULES", "SYMBOL", "LOWER", "UPPER", "INCREASE"
#, "DESCRIPTION")
# col.keep <- names(df.metric.membership)[!(names(df.metric.membership) %in% 
#col.drop)]
# 
# # merge metrics and rules
# df.merge <- merge(df.metric.membership[,col.keep], df.rules
#       , by.x=c("INDEX_NAME", "INDEX_CLASS", "LEVEL", "METRIC_NAME", "RULE_TYPE")
#     , by.y=c("INDEX_NAME", "INDEX_CLASS", "LEVEL", "METRIC_NAME", "RULE_TYPE"))
# 
# 
# df.merge <- df.merge[df.merge$SAMPLEID=="06029CSR_Bug_2006-09-27_0", ]
# 
# 
# df.lev <- dplyr::summarise(dplyr::group_by(df.merge, SAMPLEID, INDEX_NAME
#                                            , INDEX_CLASS, LEVEL)
#                            #
#                            # Min of Alt2
#         , MembCalc_Alt2_min=min(MEMBERSHIP[RULE_TYPE == "Alt2"], na.rm=TRUE)
#                          # Max of Alt1
#          , MembCalc_Alt1_max=max(MEMBERSHIP[RULE_TYPE == "Alt1"], na.rm=TRUE)
#                          # Min of Rule0 (with alt above)
#        , MembCalc_Rule0_min=min(MEMBERSHIP[RULE_TYPE == "Rule0"], na.rm=TRUE)
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
# df.lev[,"MembCalc_Alt12_max"] <- apply(df.lev[,c("MembCalc_Alt2_min"
# , "MembCalc_Alt1_max")]
#                                        , 1, max, na.rm=TRUE)
# View(df.lev)
# 
# df.lev[!is.finite(df.lev[,"MembCalc_Alt12_max"]), "MembCalc_Alt12_max"] <- NA
# View(df.lev)
# 
# df.lev[,"Level.Membership"] <- apply(df.lev[,c("MembCalc_Alt12_max"
# , "MembCalc_Rule0_min")]
#                                      , 1, min, na.rm=TRUE)
# View(df.lev)
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Level.Membership <- function(df.metric.membership
                                 , df.rules
                                 , col_SAMPLEID = "SAMPLEID"
                                 , col_INDEX_NAME = "INDEX_NAME"
                                 , col_INDEX_CLASS = "INDEX_CLASS"
                                 , col_LEVEL = "LEVEL"
                                 , col_METRIC_NAME = "METRIC_NAME"
                                 , col_RULE_TYPE = "RULE_TYPE"
                                 , col_EXC_RULE = "EXC_RULE"
                                 , col_MEMBERSHIP = "MEMBERSHIP"
                                 , ...) {
  #
  browser()
  boo_QC <- FALSE
  if (isTRUE(boo_QC)) {
    df.metric.membership <- df_met_memb
    df.rules <- df_rules
    col_SAMPLEID <- "SAMPLEID"
    col_INDEX_NAME <- "INDEX_NAME"
    col_INDEX_CLASS <- "INDEX_CLASS"
    col_LEVEL <- "LEVEL"
    col_METRIC_NAME <- "METRIC_NAME"
    col_RULE_TYPE <- "RULE_TYPE"
    col_EXC_RULE <- "EXC_RULE"
    col_MEMBERSHIP <- "MEMBERSHIP"
    a <- c(col_INDEX_NAME
           , col_INDEX_CLASS
           , col_LEVEL
           , col_METRIC_NAME
           , col_RULE_TYPE
           , col_EXC_RULE)
  }## IF ~ boo_QC ~ END
  
  # define pipe
  `%>%` <- dplyr::`%>%`
  
  # QC----
  # DEPRECATE SITE_TYPE.
  if (exists("col_SITE_TYPE")) {
    col_INDEX_CLASS <- col_SITE_TYPE
    msg <- "The parameter 'col_SITE_TYPE' was deprecated in v2.0.0.9001. \n
    Use 'col_INDEX_CLASS' instead."
    message(msg)
  } ## IF ~ col_SITE_TYPE
  
  # # convert membership to long format if provided
  # # Metrics to long
  # if (input.shape=="wide") {##IF.input.shape.START
  #   df.long <- reshape2::melt(df.metric.membership, id.vars=c("SAMPLEID"
  # , "INDEX_NAME", "INDEX_CLASS")
  #                             , variable.name="METRIC_NAME"
  # , value.name="METRIC_VALUE")
  # } else {
  #   df.long <- df.metric.membership
  # }##IF.input.shape.END
  
  # Convert to data.frame (from Tibble)
  df.metric.membership <- as.data.frame(df.metric.membership)
  df.rules <- as.data.frame(df.rules)
  
  ## Convert names to upper case
  names(df.metric.membership) <- toupper(names(df.metric.membership))
  names(df.rules) <- toupper(names(df.rules))
  
  # QC, Columns
  # col_SAMPLEID
  # col_INDEX_NAME
  # col_INDEX_CLASS
  # col_LEVEL
  # col_METRIC_NAME
  # col_RULE_TYPE
  
  ## INDEX_CLASS to lowercase
  # preserve original
  col_INDEX_CLASS_ORIG <- paste0(col_INDEX_CLASS, "_ORIG")
  df.metric.membership[, col_INDEX_CLASS_ORIG] <- df.metric.membership[
                                                              , col_INDEX_CLASS] 
  df.metric.membership[, col_INDEX_CLASS] <- tolower(df.metric.membership[
                                                             , col_INDEX_CLASS])
  df.rules[, col_INDEX_CLASS] <- tolower(df.rules[, col_INDEX_CLASS])
  
  ## EXC_RULE to uppercase
  df.metric.membership[, col_EXC_RULE] <- toupper(df.metric.membership[
                                                                , col_EXC_RULE])
  df.rules[, col_EXC_RULE] <- toupper(df.rules[, col_EXC_RULE])
  
  ## RULE_TYPE to uppercase
  df.metric.membership[, col_RULE_TYPE] <- toupper(df.metric.membership[
    , col_RULE_TYPE])
  df.rules[, col_RULE_TYPE] <- toupper(df.rules[, col_RULE_TYPE])
  
  ## Drop extra columns from df.metric.membership
  # (otherwise duplicates in merge)
  # 20240806, add extra cols after DESCRIPTION
  col.drop <- c("NUMERIC_RULES"
                , "SYMBOL"
                , "LOWER"
                , "UPPER"
                , "INCREASE"
                , "DESCRIPTION"
                , "NOTE_RULE"
                , "INCLUDE_PARAMETER"
                , "INCLUDE_SYMBOL"
                , "INCLUDE_THRESHOLD"
                , "SITE_TYPE"
                , "INDEX_REGION")
  col.keep <- names(df.metric.membership)[!(names(df.metric.membership) %in% 
                                                                      col.drop)]
  # MERGE----
  # merge metrics and rules
  df.merge <- merge(df.metric.membership[, col.keep]
                    , df.rules
                    , by.x = c(col_INDEX_NAME
                               , col_INDEX_CLASS
                               , col_LEVEL
                               , col_METRIC_NAME
                               , col_RULE_TYPE
                               , col_EXC_RULE)
                    , by.y = c(col_INDEX_NAME
                               , col_INDEX_CLASS
                               , col_LEVEL
                               , col_METRIC_NAME
                               , col_RULE_TYPE
                               , col_EXC_RULE))
  # Match on all to ensure using the same rules
 
  # INDEX_CLASS, fix
  # move from end to here, 20240806
  # replace tolower(INDEX_CLASS) with INDEX_CLASS_ORIG
  df.merge[, col_INDEX_CLASS] <- df.merge[, col_INDEX_CLASS_ORIG]
  # remove INDEX_CLASS_ORIG
  col_drop_ICORIG <- !names(df.merge) %in% col_INDEX_CLASS_ORIG 
  df.merge <- df.merge[, col_drop_ICORIG]
  
  nrow_metmemb <- nrow(df.metric.membership)
  nrow_merge <- nrow(df.merge)
  if (nrow_metmemb != nrow_merge) {
    msg <- paste("Rules and Metric Membership not matching."
                 , paste0(nrow_metmemb, " = rows Metric Membership")
                 , paste0(nrow_merge, " = rows after merge with Rules")
                 , sep = "\n")
    message(msg)
  }## IF ~ nrow QC
  
  # Min of Rule2 (Alt2)
  # Max of Rule1 (Alt1) (with Min of Rule2 (Alt2))
  # Min of Rule0 (with alt above)
  
  # QC
  if (nrow(df.merge) == 0) {
    msg <- "Merging of Metric Membership and Rules data frames failed.
    Check columns col_INDEX_NAME, col_INDEX_CLASS, col_LEVEL, col_METRIC_NAME, col_RULE_TYPE, and col_EXC_RULE."
    stop(msg)
  }## IF ~ nrow(df.merge) ~ END
  
  # dplyr fix 1 ----
  # Ensure have correct names for summarise(group_by))
  names(df.merge)[names(df.merge) == col_SAMPLEID]    <- "SAMPLEID"
  names(df.merge)[names(df.merge) == col_INDEX_NAME]  <- "INDEX_NAME"
  names(df.merge)[names(df.merge) == col_INDEX_CLASS] <- "INDEX_CLASS"
  names(df.merge)[names(df.merge) == col_LEVEL]       <- "LEVEL"
  names(df.merge)[names(df.merge) == col_RULE_TYPE]   <- "RULE_TYPE"
  names(df.merge)[names(df.merge) == col_MEMBERSHIP]  <- "MEMBERSHIP"
  ## Exceptions
  names(df.merge)[names(df.merge) == col_EXC_RULE]    <- "EXC_RULE"
  
  # EXCEPTIONS ----
  # no harm done in allowing to run if not present
  
  ## EXC_RULE, MEDIAN ----
  df_er_median <- dplyr::filter(df.merge, EXC_RULE == "MEDIAN")
  df_er_median_calc <- dplyr::summarise(dplyr::group_by(df_er_median
                                                     , SAMPLEID
                                                     , INDEX_NAME
                                                     , INDEX_CLASS
                                                     , LEVEL
                                                     , RULE_TYPE
                                                     # , INDEX_CLASS_ORIG
                                                      )
                                      , .groups = "drop_last"
                #
                # Calc MEDIAN
                , MEMBERSHIP = median(MEMBERSHIP, na.rm = TRUE)
                # , MEMBERSHIP_MEDIAN = median(MEMBERSHIP, na.rm = TRUE)
                # , MEMBERSHIP_COUNT = dplyr::n()
  )##summarise ~ MEDIAN
  # This assumes have 3 values
  # Rename MEMBERSHIP_MEDIAN and drop Count
  #
  # Update df.merge
  # Remove EXC_RULE == "MEDIAN"
  df.merge <- dplyr::filter(df.merge, EXC_RULE != "MEDIAN" | is.na(EXC_RULE))
  # Add new memberships back to df.merge
  df.merge <- dplyr::bind_rows(df.merge, df_er_median_calc)
  # 2024-01-03
  # Median same as Small2 when have 3 values
  # Median came first and used in BCG_MariNW_Bugs500ct, leave 'as is' 
  
  ## EXC_RULE, SMALL2----
  df_er_small2 <- dplyr::filter(df.merge, EXC_RULE == "SMALL2")
  # default sort in arrange is ascending (NA are at end) 
  # group
  # filter for 2nd row 
  df_er_small2_calc <- dplyr::group_by(df_er_small2
                                       , SAMPLEID
                                       , INDEX_NAME
                                       , INDEX_CLASS
                                       , LEVEL
                                       # , INDEX_CLASS_ORIG
                                       ) %>%
    dplyr::arrange(MEMBERSHIP) %>% # sort asc
    dplyr::filter(dplyr::row_number() == 2)
  #
  # Update df.merge
  # Remove EXC_RULE == "SMALL2"
  df.merge <- dplyr::filter(df.merge, EXC_RULE != "SMALL2" | is.na(EXC_RULE))
  # Add new memberships back to df.merge
  df.merge <- dplyr::bind_rows(df.merge, df_er_small2_calc)
  
  ## EXC_RULE, SMALL2A----
  df_er_small2a <- dplyr::filter(df.merge, EXC_RULE == "SMALL2A")
  # default sort in arrange is ascending (NA are at end) 
  # group
  # filter for 2nd row 
  df_er_small2a_calc <- dplyr::group_by(df_er_small2a
                                       , SAMPLEID
                                       , INDEX_NAME
                                       , INDEX_CLASS
                                       , LEVEL
                                       # , INDEX_CLASS_ORIG
                                       ) %>%
    dplyr::arrange(MEMBERSHIP) %>% # sort asc
    dplyr::filter(dplyr::row_number() == 2)
  #
  # Update df.merge
  # Remove EXC_RULE == "SMALL2"
  df.merge <- dplyr::filter(df.merge, EXC_RULE != "SMALL2A" | is.na(EXC_RULE))
  # Add new memberships back to df.merge
  df.merge <- dplyr::bind_rows(df.merge, df_er_small2a_calc)
  
  ## EXC_RULE, SMALL2B----
  df_er_small2b <- dplyr::filter(df.merge, EXC_RULE == "SMALL2B")
  # default sort in arrange is ascending (NA are at end) 
  # group
  # filter for 2nd row 
  df_er_small2b_calc <- dplyr::group_by(df_er_small2b
                                        , SAMPLEID
                                        , INDEX_NAME
                                        , INDEX_CLASS
                                        , LEVEL
                                        # , INDEX_CLASS_ORIG
                                        ) %>%
    dplyr::arrange(MEMBERSHIP) %>% # sort asc
    dplyr::filter(dplyr::row_number() == 2)
  #
  # Update df.merge
  # Remove EXC_RULE == "SMALL2"
  df.merge <- dplyr::filter(df.merge, EXC_RULE != "SMALL2B" | is.na(EXC_RULE))
  # Add new memberships back to df.merge
  df.merge <- dplyr::bind_rows(df.merge, df_er_small2b_calc)
  
  ## EXC_RULE, SMALL3----
  # Need to handle Rule01 (max) [part of Small3 not a separate rule]
  df_er_small3_rule0 <- dplyr::filter(df.merge
                                      , EXC_RULE == "SMALL3" 
                                      & RULE_TYPE == "RULE0")
  df_er_small3_rule1 <- dplyr::filter(df.merge
                                      , EXC_RULE == "SMALL3" 
                                      & RULE_TYPE == "RULE1")
  # Rule1 before Rule0
  # Rule1, max then add to rule0
  ## not using summarize and max to maintain column order
  ## mutate to Rule0 to ensure not issues later if no other Rule0
  df_er_small3_rule1_calc <- dplyr::group_by(df_er_small3_rule1
                                             , SAMPLEID
                                             , INDEX_NAME
                                             , INDEX_CLASS
                                             , LEVEL
                                             # , INDEX_CLASS_ORIG
                                             ) %>%
    dplyr::arrange(MEMBERSHIP) %>% # sort asc
    dplyr::filter(dplyr::row_number() == 3) %>% 
    dplyr::mutate(RULE_TYPE = "RULE0")
  # Add Rule1 max to Rule0
  df_er_small3_rule0_calc <- dplyr::bind_rows(df_er_small3_rule0
                                              , df_er_small3_rule1_calc)
  # Small3 calc
  # default sort in arrange is ascending (NA are at end)
  # group
  # filter for 3rd row 
  df_er_small3_calc <- dplyr::group_by(df_er_small3_rule0_calc
                                       , SAMPLEID
                                       , INDEX_NAME
                                       , INDEX_CLASS
                                       , LEVEL
                                       # , INDEX_CLASS_ORIG
                                       ) %>%
    dplyr::arrange(MEMBERSHIP) %>% # sort asc
    dplyr::filter(dplyr::row_number() == 3)
  #
  # Update df.merge
  # Remove EXC_RULE == "SMALL3"
  df.merge <- dplyr::filter(df.merge, EXC_RULE != "SMALL3" | is.na(EXC_RULE))
  # Add new memberships back to df.merge
  df.merge <- dplyr::bind_rows(df.merge, df_er_small3_calc)
  
  ## EXC_RULE, FLIPMINMAX ----
  df.merge <- df.merge %>%
    dplyr::mutate(MEMBERSHIP = dplyr::case_when(EXC_RULE == "FLIPMINMAX" ~ - MEMBERSHIP,
                                                .default = MEMBERSHIP))
  # CHANGE BACK LATER IN CODE with abs() in next step
  
  # Summarize ----
  # Add abs() for MN FLIPMINMAX fix, 20241008
  # Will get lots of warnings, SampIDs without alt 1 or alt 2 rules
  suppressWarnings(
    df.lev <- dplyr::summarise(dplyr::group_by(df.merge
                                               , SAMPLEID
                                               , INDEX_NAME
                                               , INDEX_CLASS
                                               # , INDEX_CLASS_ORIG # 20240607
                                               , LEVEL
                                               )
                 , .groups = "drop_last"
                #
                # Min of Rule2 (Alt2)
                , MembCalc_Rule2_min = abs(min(MEMBERSHIP[RULE_TYPE == "RULE2"]
                                               , na.rm = TRUE))
                # Max of Rule1 (Alt1)
                , MembCalc_Rule1_max = abs(max(MEMBERSHIP[RULE_TYPE == "RULE1"]
                                               , na.rm = TRUE))
                # Min of Rule0 (with alt above)
                , MembCalc_Rule0_min = abs(min(MEMBERSHIP[RULE_TYPE == "RULE0"]
                                               , na.rm = TRUE))
                # Exceptions for CT
                ## don't need MN flip fix
                , MembCalc_Exc0_min = min(MEMBERSHIP[EXC_RULE == "EXCMEM0"]
                                          , na.rm = TRUE)
                , MembCalc_Exc1_max = max(MEMBERSHIP[EXC_RULE == "EXCMEM1"]
                                          , na.rm = TRUE)
                , MembCalc_Exc2_min = min(MEMBERSHIP[EXC_RULE == "EXCMEM2"]
                                          , na.rm = TRUE)
                

    )## summarise ~ END
  )## suppressWarnings ~ END

  # dplyr fix 2 ----
  # Change names back to variable inputs
  names(df.lev)[names(df.lev) == "SAMPLEID"] <- toupper(col_SAMPLEID)
  names(df.lev)[names(df.lev) == "INDEX_NAME"] <- toupper(col_INDEX_NAME)
  names(df.lev)[names(df.lev) == "INDEX_CLASS"] <- toupper(col_INDEX_CLASS)
  names(df.lev)[names(df.lev) == "LEVEL"] <- toupper(col_LEVEL)
  names(df.lev)[names(df.lev) == "RULE_TYPE"] <- toupper(col_RULE_TYPE)
  ## Exceptions
  names(df.lev)[names(df.lev) == "EXC_RULE"] <- toupper(col_EXC_RULE)
  
  # convert from tibble to df
  df.lev <- as.data.frame(df.lev)
  # replace Inf and -Inf with NA
  df.lev[!is.finite(df.lev[, "MembCalc_Rule2_min"]), "MembCalc_Rule2_min"] <- NA
  df.lev[!is.finite(df.lev[, "MembCalc_Rule1_max"]), "MembCalc_Rule1_max"] <- NA
  # this one shouldn't happen.  Use zero just in case.
  df.lev[!is.finite(df.lev[, "MembCalc_Rule0_min"]), "MembCalc_Rule0_min"] <- 0
  ## Exceptions
  df.lev[!is.finite(df.lev[, "MembCalc_Exc0_min"]), "MembCalc_Exc0_min"] <- NA
  df.lev[!is.finite(df.lev[, "MembCalc_Exc1_max"]), "MembCalc_Exc1_max"] <- NA
  df.lev[!is.finite(df.lev[, "MembCalc_Exc2_min"]), "MembCalc_Exc2_min"] <- NA
  
  # dplyr fix
  # Have to do outside of dplyr to get rid of Inf and -Inf
  
  # Need to suppress warnings again
  suppressWarnings(
    df.lev[,"MembCalc_Rule12_max"] <- apply(df.lev[, c("MembCalc_Rule2_min"
                                                      , "MembCalc_Rule1_max")]
                                          , 1
                                          , max
                                          , na.rm = TRUE)
  )
  # replace Inf with NA
  df.lev[!is.finite(df.lev[,"MembCalc_Rule12_max"])
         , "MembCalc_Rule12_max"] <- NA
  
  # Final Calc
  # df.lev[,"Level.Membership"] <- min(df.lev[,"MembCalc_Rule12_max"]
  #                                      , df.lev[,"MembCalc_Rule0_min"]
  #                                      , na.rm=TRUE)
  
  # Assign Level ----
  df.lev[,"Level.Membership"] <- apply(df.lev[,c("MembCalc_Rule12_max"
                                                 , "MembCalc_Rule0_min")]
                                       , 1, min, na.rm = TRUE)
  
  
  # ## Exceptions, Level Mem ----
  boo_exceptions <- FALSE
  #
  if (isTRUE(boo_exceptions)) {
    ## CT_F1_L4
    boo_CT_F1_L4 <- df.lev[, col_INDEX_NAME] == "BCG_CT_2015" &
      df.lev[, col_INDEX_CLASS] == "fish01" &
      df.lev[, col_LEVEL] == 4
    ### Exc1, Recalc
    df.lev[boo_CT_F1_L4, "MembCalc_Exc1_max"] <- max(c(
      df.lev[boo_CT_F1_L4, "MembCalc_Exc1_max"]
      , df.lev[boo_CT_F1_L4, "MembCalc_Exc0_min"])
      , na.rm = TRUE)
    ### replace Inf with NA
    df.lev[!is.finite(df.lev[, "MembCalc_Exc1_max"]), "MembCalc_Exc1_max"] <- NA
    ### Final Lev, Recalc
    df.lev[boo_CT_F1_L4, "Level.Membership"] <- min(c(
      df.lev[boo_CT_F1_L4, "MembCalc_Exc1_max"]
      , df.lev[boo_CT_F1_L4, "MembCalc_Exc2_min"])
      , na.rm = TRUE)
    #
    ## CT_F23_L2 (Combine fish02 and fish03)
    boo_CT_F23_L4 <- df.lev[, col_INDEX_NAME] == "BCG_CT_2015" &
      (df.lev[, col_INDEX_CLASS] == "fish02" | 
         df.lev[, col_INDEX_CLASS] == "fish03") &
      df.lev[, col_LEVEL] == 2
    # Final Lev, Recalc
    df.lev[boo_CT_F23_L4, "Level.Membership"] <- min(c(
      df.lev[boo_CT_F23_L4, "MembCalc_Exc0_min"]
      , df.lev[boo_CT_F23_L4, "MembCalc_Exc1_max"])
      , na.rm = TRUE)
    #
  }## IF ~ boo_exceptions ~ END
  
  # replace Inf with NA (Redo, just in case for base and exceptions)
  df.lev[!is.finite(df.lev[, "Level.Membership"]), "Level.Membership"] <- NA

  # add extra to "Level"
  df.lev[, col_LEVEL] <- paste0("L", df.lev[, col_LEVEL])
  
  # column fix
  ## Ensure have expected values
  names(df.lev)[names(df.lev) == col_SAMPLEID] <- "SAMPLEID"
  names(df.lev)[names(df.lev) == col_INDEX_NAME] <- "INDEX_NAME"
  names(df.lev)[names(df.lev) == col_INDEX_CLASS] <- "INDEX_CLASS"
  names(df.lev)[names(df.lev) == col_LEVEL] <- "LEVEL"
  
  # Convert to wide format
  # 202040607, add INDEX_CLASS_ORIG
  df.lev.wide <- reshape2::dcast(df.lev
                                 , SAMPLEID 
                                   + INDEX_NAME 
                                   + INDEX_CLASS 
                                   # + INDEX_CLASS_ORIG
                                 ~ LEVEL
                                 , value.var = "Level.Membership"
                                 )
  
  # Column fix
  ## Return to input parameters
  names(df.lev.wide)[names(df.lev.wide) == "SAMPLEID"] <- toupper(col_SAMPLEID)
  names(df.lev.wide)[names(df.lev.wide) == "INDEX_NAME"] <- toupper(
                                                                col_INDEX_NAME)
  names(df.lev.wide)[names(df.lev.wide) == "INDEX_CLASS"] <- toupper(
                                                                  col_INDEX_CLASS)
  names(df.lev.wide)[names(df.lev.wide) == "LEVEL"] <- toupper(col_LEVEL)
  
  
  # __EXCEPTIONS ----
  # Not sure if need here or elsewhere
  
  
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
  
  # Calculate Final scoring ----
  ## Need to consider other final scores (use apply)
  ### Level Membership affected by previous level assignments.
  # 20180613, added "round" 8 for floating point error 
  # (e.g., a value of 1.1E-16).
  # 20230602, add check no L5 and trigger to calc L5 instead of L6
  
  # Num Rules by model
  df.rules.numruleslev <- dplyr::summarize(dplyr::group_by(df.rules
                                                           , INDEX_NAME
                                                           , INDEX_CLASS)
                                           , .groups = "drop_last"
                                           , rules_lev_min = min(LEVEL
                                                                 , na.rm = TRUE)
                                           , rules_lev_max = max(LEVEL
                                                                 , na.rm = TRUE)
                                    )## summarize ~ END
  # Merge num rules
  df.subtotal <- merge(df.subtotal
                       , df.rules.numruleslev
                       , by = c("INDEX_NAME", "INDEX_CLASS")
                       , all.x = TRUE
                       )
  # name columns so can remove later
  col.ruleslev <- c("rules_lev_min", "rules_lev_max")
  
  rnd_dig <- 8
  
  df.subtotal[, "L1"] <- df.subtotal[, "L1.Sub"]
  
  df.subtotal[, "L2"] <- apply(df.subtotal[, c("L1", "L2.Sub")]
                               , 1
                               , function(x) min(round(1 - x[1], rnd_dig)
                                                 , x[2]
                                                 , na.rm = TRUE))
  
  df.subtotal[, "L3"] <- apply(df.subtotal[, c("L1", "L2", "L3.Sub")]
                               , 1
                               , function(x) min(round(1 - sum(x[1]
                                                               , x[2]
                                                               , na.rm = TRUE)
                                                       , rnd_dig)
                                                 , x[3]
                                                 , na.rm = TRUE))
  
  df.subtotal[, "L4"] <- apply(df.subtotal[, c("L1", "L2", "L3", "L4.Sub")]
                               , 1
                              , function(x) min(round(1 - sum(x[1]
                                                            , x[2]
                                                            , x[3]
                                                            , na.rm = TRUE)
                                                      , rnd_dig)
                                                , x[4], na.rm = TRUE))
  
  df.subtotal[, "L5"] <- apply(df.subtotal[, c("L1"
                                              , "L2"
                                              , "L3"
                                              , "L4"
                                              , "L5.Sub")]
                               , 1
                               , function(x) min(round(1 - sum(x[1]
                                                               , x[2]
                                                               , x[3]
                                                               , x[4]
                                                               , na.rm = TRUE)
                                                       , rnd_dig)
                                                 , x[5], na.rm = TRUE))
  
 
  # Exception for only 4 rules
  # df.subtotal[, "L5"] <- ifelse(df.subtotal[, "rules_lev_max"] == 4
  #                               , 1 - sum(df.subtotal[, c("L1", "L2", "L3", "L4")])
  #                               , df.subtotal[, "L5"])
  boo_L5fix <- df.subtotal[, "rules_lev_max"] == 4
  boo_L5fix[is.na(boo_L5fix)] <- FALSE # 20240807, convert NA to FALSE
  if (sum(boo_L5fix) > 0) {
    df.subtotal[boo_L5fix, "L5"] <- apply(df.subtotal[boo_L5fix
                                           , c("L1", "L2", "L3", "L4")]
                               , 1
                               , function(x) round(1 - sum(x[1]
                                                           , x[2]
                                                           , x[3]
                                                           , x[4]
                                                           , x[5]
                                                           , na.rm = TRUE)
                                                   , rnd_dig))
  }## IF ~ L5fix
  
  
  
  df.subtotal[, "L6"] <- apply(df.subtotal[,c("L1"
                                              , "L2"
                                              , "L3"
                                              , "L4"
                                              , "L5")]
                               , 1
                               , function(x) round(1 - sum(x[1]
                                                           , x[2]
                                                           , x[3]
                                                           , x[4]
                                                           , x[5]
                                                           , na.rm = TRUE)
                                                   , rnd_dig))

  
  # Return RESULTS ####
  # Remove sub fields
  df.results <- df.subtotal[, !(names(df.subtotal) %in% c(col.sub, col.ruleslev))]
  # Results are for each SAMPLEID, INDEX_NAME, INDEX_CLASS, and 
  #                                                  LEVEL Assignment/Membership

  # # INDEX_CLASS, fix
  # # replace tolower(INDEX_CLASS) with INDEX_CLASS_ORIG
  # df.results[, col_INDEX_CLASS] <- df.results[, col_INDEX_CLASS_ORIG]
  # # remove INDEX_CLASS_ORIG
  # col_drop_ICORIG <- !names(df.results) %in% col_INDEX_CLASS_ORIG 
  # df.results <- df.results[, col_drop_ICORIG]
  
  # create output
  return(df.results)
  #
}##FUNCTION.END
