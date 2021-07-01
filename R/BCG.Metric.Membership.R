#' @title BCG Metric Membership
#' 
#' @description Biological Condition Gradient fuzzy membership for metrics.
#' 
#' @details Converts metric values into BCG membership values.  
#' Uses a rules table to define the metrics, scoring range, and direction for each named index. 
#' 
#' @param df.metrics Wide data frame with metric values to be evaluated.
#' @param df.rules  Data frame of metric thresholds to check.
#' @param input.shape Shape of df.metrics; wide or long.  Default is wide.
#' 
#' @return Returns a data frame of results in the long format.
#' 
#' @examples
#' library(readxl)
#' library(BioMonTools)
#' 
#' # Calculate Metrics
#' df.samps.bugs <- read_excel(system.file("./extdata/Data_BCG_PacNW.xlsx"
#'                                         , package="BCGcalc")
#'                            , guess_max = 10^6)
#' myDF <- df.samps.bugs
#' myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2", "Site_Type")
#' df.metric.values.bugs <- metric.values(myDF, "bugs", fun.cols2keep=myCols)
#' 
#' # Import Rules
#' df.rules <- read_excel(system.file("./extdata/Rules.xlsx"
#'                              , package="BCGcalc"), sheet="Rules") 
#' 
#' # Run function
#' df.Metric.Membership <- BCG.Metric.Membership(df.metric.values.bugs, df.rules)
#' 
#' \dontrun{
#' # Show Results
#' #View(df.Metric.Membership)
#' 
#' # Save Results
#' write.table(df.Metric.Membership, "Metric.Membership.tsv"
#'               , row.names=FALSE, col.names=TRUE, sep="\t")
#' }
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# df.metrics <- df.metric.values.bugs
# df.rules <- df.rules
# input.shape <- "wide"
# scores <- BCG.Metric.Membership(df.metrics, df.rules, "wide")
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Metric.Membership <- function(df.metrics, df.rules, input.shape="wide"){##FUNCTION.START
  #
  # scrub off "Tibble" as it throws off other data operations below
  df.metrics <- as.data.frame(df.metrics)
  df.rules <- as.data.frame(df.rules)
  #
  #
  # Metrics to long
  if (input.shape=="wide") {##IF.input.shape.START
    df.long <- reshape2::melt(df.metrics, id.vars=c("SAMPLEID", "INDEX_NAME", "SITE_TYPE")
                             , variable.name="METRIC_NAME", value.name="METRIC_VALUE")
  } else {
    df.long <- df.metrics
  }##IF.input.shape.END
  #
  # ColNames to Upper Case
  ## has to be df.long if upper case df.metrics the metric names become upper case.
  names(df.long) <- toupper(names(df.long))
  names(df.rules) <- toupper(names(df.rules))
  #
  # SITE_TYPE to lowercase
  df.long[,"SITE_TYPE"] <- tolower(df.long[,"SITE_TYPE"])
  df.rules[,"SITE_TYPE"] <- tolower(df.rules[,"SITE_TYPE"])
  #
  # Extra columns may have text (convert to numeric)
  suppressWarnings(df.long[,"METRIC_VALUE"] <- as.numeric(df.long[,"METRIC_VALUE"]))
  #
  # Check for Missing Metrics (only for index provided in metric df)
  ## ignore site type for checking
  index.data <- unique(df.long[, "INDEX_NAME"])
  rules.metrics.names <- unique(df.rules[df.rules[,"INDEX_NAME"]==index.data, "METRIC_NAME"])
  rules.metrics.TF <- rules.metrics.names %in% unique(df.long[, "METRIC_NAME"])
  rules.metrics.len <- length(rules.metrics.names)
  #
  if(sum(rules.metrics.TF)!=rules.metrics.len){##IF.RulesCount.START
    Msg <- paste0("Data provided does not include all metrics in rules table. "
                  , "The following metrics are missing: "
                  , paste(rules.metrics.names[!rules.metrics.TF], collapse=", "))
    stop(Msg)
  }##IF.RulesCount.END
  
  
  # merge metrics and checks
  df.merge <- merge(df.long, df.rules
                    , by.x=c("INDEX_NAME", "SITE_TYPE", "METRIC_NAME")
                    , by.y=c("INDEX_NAME", "SITE_TYPE", "METRIC_NAME"))
  #
  # The above only returns a single match, not all.
  # dplyr version
  #df.merge2 <- df.long %>% left_join(df.rules)
  #
  
  # Excel FuzzyMembership function is much simpler than the Access code
  # need to apply only to select rows
  df.merge[,"MEMBERSHIP"] <- NA
  #
  boo.score.0 <- df.merge[,"METRIC_VALUE"] < df.merge[,"LOWER"]
  df.merge[boo.score.0, "MEMBERSHIP"] <- 0 
  #
  boo.score.1 <- df.merge[,"METRIC_VALUE"] > df.merge[,"UPPER"]
  df.merge[boo.score.1, "MEMBERSHIP"] <- 1
  #
  boo.score.calc <- is.na(df.merge[,"MEMBERSHIP"])
  df.merge[boo.score.calc, "MEMBERSHIP"] <- df.merge[boo.score.calc,"METRIC_VALUE"] / 
    (df.merge[boo.score.calc,"UPPER"] - df.merge[boo.score.calc,"LOWER"]) - 
     df.merge[boo.score.calc,"LOWER"] / 
    (df.merge[boo.score.calc,"UPPER"] - df.merge[boo.score.calc,"LOWER"])
  # direction
  boo.direction <- df.merge[,"INCREASE"]
  df.merge[!boo.direction, "MEMBERSHIP"] <- 1-df.merge[!boo.direction,"MEMBERSHIP"]
      # can mess up 0 and 1

  # wide name
  df.merge[,"NAME_WIDE"] <- paste0(df.merge[,"SITE_TYPE"],"_L", df.merge[,"LEVEL"], "_", df.merge[,"RULE_TYPE"]
                                   , "_", df.merge[,"METRIC_NAME"])
  #
  # create output
  return(df.merge)
  #
}##FUNCTION.END
