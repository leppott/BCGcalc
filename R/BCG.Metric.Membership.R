#' @title BCG Metric Membership
#' 
#' @description Biological Condition Gradient fuzzy membership for metrics.
#' 
#' @details Converts metric values into BCG membership values.  
#' Uses a rules table to define the metrics, scoring range, and direction for 
#' each named index. 
#' 
#' @param df.metrics Wide data frame with metric values to be evaluated.
#' @param df.rules  Data frame of metric thresholds to check.
#' @param input.shape Shape of df.metrics; wide or long.  Default is wide.
#' @param col_SAMPLEID Column name for sample id.  Default = "SAMPLEID"
#' @param col_INDEX_NAME Column name for index name. Default = "INDEX_NAME"
#' @param col_SITE_TYPE Column name for site type  Default = "SITE_TYPE"
#' Site Type is used over Index_Region for BCG calculations
#' @param col_LEVEL Column name for level.  Default = "LEVEL"
#' @param col_METRIC_NAME Column name for metric name.  Default = "METRIC_NAME"
#' @param col_RULE_TYPE Column name for rule type (e.g., Rule0).
#' Default = "RULE_TYPE"
#' @param col_LOWER Column name for lower limit.  Default = "LOWER"
#' @param col_UPPER Column name for upper limit.  Default = "UPPER"
#' @param col_METRIC_VALUE Column name for metric value.  
#' Default = "METRIC_VALUE"
#' @param col_INCREASE Column name for if the metric increases. 
#' Default = "INCREASE"
#' 
#' @return Returns a data frame of results in the long format.
#' 
#' @examples
#' # library(readxl)
#' # library(BioMonTools)
#' 
#' # Calculate Metrics
#' df_samps_bugs <- readxl::read_excel(
#'                                  system.file("./extdata/Data_BCG_PacNW.xlsx"
#'                                              , package="BCGcalc")
#'                            , guess_max = 10^6)
#' myDF <- df_samps_bugs
#' myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2"
#'             , "Site_Type")
#' # populate missing columns prior to metric calculation
#' col_missing <- c("INFRAORDER", "HABITAT", "UFC", "ELEVATION_ATTR"
#'                  , "GRADIENT_ATTR", "WSAREA_ATTR")
#' myDF[, col_missing] <- NA
#' df_met_val_bugs <- BioMonTools::metric.values(myDF
#'                                               , "bugs"
#'                                               , fun.cols2keep = myCols)
#' 
#' 
#' # Import Rules
#' df_rules <- readxl::read_excel(system.file("./extdata/Rules.xlsx"
#'                                            , package = "BCGcalc")
#'                       , sheet="Rules") 
#' 
#' # Run function
#' df_met_memb <- BCG.Metric.Membership(df_met_val_bugs, df_rules)
#' 
#' # Show Results
#' #View(df_met_memb)
#' 
#' # Save Results
#' write.table(df_met_memb
#'             , file.path(tempdir(), "Metric_Membership.tsv")
#'             , row.names = FALSE
#'             , col.names = TRUE
#'             , sep = "\t")
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# df.metrics <- df_met_val_bugs
# df.rules <- df_rules
# input.shape <- "wide"
# scores <- BCG.Metric.Membership(df.metrics, df.rules, "wide")
# col_SAMPLEID = "SAMPLEID"
#  col_INDEX_NAME = "INDEX_NAME"
#  col_SITE_TYPE = "SITE_TYPE"
#  col_LEVEL = "LEVEL"
#  col_METRIC_NAME = "METRIC_NAME"
#  col_RULE_TYPE = "RULE_TYPE"
#  col_LOWER = "LOWER"
#  col_UPPER = "UPPER"
#  col_METRIC_VALUE = "METRIC_VALUE"
#  col_INCREASE = "INCREASE"
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Metric.Membership <- function(df.metrics
                                  , df.rules
                                  , input.shape = "wide"
                                  , col_SAMPLEID = "SAMPLEID"
                                  , col_INDEX_NAME = "INDEX_NAME"
                                  , col_SITE_TYPE = "SITE_TYPE"
                                  , col_LEVEL = "LEVEL"
                                  , col_METRIC_NAME = "METRIC_NAME"
                                  , col_RULE_TYPE = "RULE_TYPE"
                                  , col_LOWER = "LOWER"
                                  , col_UPPER = "UPPER"
                                  , col_METRIC_VALUE = "METRIC_VALUE"
                                  , col_INCREASE = "INCREASE") {
  #
  # scrub off "Tibble" as it throws off other data operations below
  df.metrics <- as.data.frame(df.metrics)
  df.rules <- as.data.frame(df.rules)
  #
  # QC, Column names
  ## use inputs
  #
  # Metrics to long
  if (input.shape == "wide") {##IF.input.shape.START
    df.long <- reshape2::melt(df.metrics
                        , id.vars=c(col_SAMPLEID
                                    , col_INDEX_NAME
                                    , col_SITE_TYPE)
                              , variable.name = col_METRIC_NAME
                              , value.name = col_METRIC_VALUE)
  } else {
    df.long <- df.metrics
  }##IF.input.shape.END
  #
  # ColNames to Upper Case
## has to be df.long if upper case df.metrics the metric names become upper case
  names(df.long) <- toupper(names(df.long))
  names(df.rules) <- toupper(names(df.rules))
  #
  # SITE_TYPE to lowercase
  df.long[, col_SITE_TYPE] <- tolower(df.long[, col_SITE_TYPE])
  df.rules[, col_SITE_TYPE] <- tolower(df.rules[, col_SITE_TYPE])
  #
  # Extra columns may have text (convert to numeric)
  suppressWarnings(df.long[, col_METRIC_VALUE] <- as.numeric(df.long[
    , col_METRIC_VALUE]))
  #
  # Check for Missing Metrics (only for index provided in metric df)
  ## ignore site type for checking 
  ### added back 20220214, for when run a single index region 
  #                                             & rules has more than one
  ### and metrics are not the same in each region
  index.data <- unique(df.long[, col_INDEX_NAME])
  index.data.region <- unique(df.long[, col_SITE_TYPE])
  rules.metrics.names <- unique(df.rules[(df.rules[, col_INDEX_NAME] %in% 
                                            index.data
                                          & df.rules[, col_SITE_TYPE] %in% 
                                            index.data.region)
                                         , col_METRIC_NAME])
  rules.metrics.TF <- rules.metrics.names %in% unique(df.long[
    , col_METRIC_NAME])
  rules.metrics.len <- length(rules.metrics.names)
  #
  if(sum(rules.metrics.TF)!= rules.metrics.len) {##IF.RulesCount.START
    Msg <- paste0("Data provided does not include all metrics in rules table. "
                  , "The following metrics are missing: "
                  , paste(rules.metrics.names[!rules.metrics.TF]
                          , collapse=", "))
    stop(Msg)
  }##IF.RulesCount.END
  
  
  # merge metrics and checks
  df.merge <- merge(df.long, df.rules
                    , by.x=c(col_INDEX_NAME, col_SITE_TYPE, col_METRIC_NAME)
                    , by.y=c(col_INDEX_NAME, col_SITE_TYPE, col_METRIC_NAME))
  #
  # The above only returns a single match, not all.
  # dplyr version
  #df.merge2 <- df.long %>% left_join(df.rules)
  #
  
  # Excel FuzzyMembership function is much simpler than the Access code
  # need to apply only to select rows
  df.merge[, "MEMBERSHIP"] <- NA
  #
  boo.score.0 <- df.merge[, col_METRIC_VALUE] <= df.merge[, col_LOWER]
  # 
  boo.score.1 <- df.merge[, col_METRIC_VALUE] >= df.merge[, col_UPPER]
  #
  # Use ifelse() to avoid errors with NA
  df.merge[, "MEMBERSHIP"] <- ifelse(boo.score.0
                                     , 0
                                     , ifelse(boo.score.1
                                              , 1
                                              , NA)
                                      )
  #
  boo.score.calc <- is.na(df.merge[,"MEMBERSHIP"])
  df.merge[boo.score.calc, "MEMBERSHIP"] <- df.merge[boo.score.calc
                                                     , col_METRIC_VALUE] / 
    (df.merge[boo.score.calc, col_UPPER] - df.merge[boo.score.calc
                                                    , col_LOWER]) - 
     df.merge[boo.score.calc, col_LOWER] / 
    (df.merge[boo.score.calc, col_UPPER] - df.merge[boo.score.calc, col_LOWER])
  # direction
  boo.direction <- df.merge[, col_INCREASE]
  df.merge[!boo.direction, "MEMBERSHIP"] <- 1 - df.merge[!boo.direction
                                                         , "MEMBERSHIP"]
      # can mess up 0 and 1
  
  # Access uses 2 different formulas

  # wide name
  df.merge[,"NAME_WIDE"] <- paste0(df.merge[, col_SITE_TYPE]
                                   , "_L"
                                   , df.merge[, col_LEVEL]
                                   , "_"
                                   , df.merge[, col_RULE_TYPE]
                                   , "_"
                                   , df.merge[, col_METRIC_NAME])
  #
  # create output
  return(df.merge)
  #
}##FUNCTION.END
