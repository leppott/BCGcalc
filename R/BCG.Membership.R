#' @title BCG Membership
#' 
#' @description Biological Condition Gradient fuzzy membership for metrics.
#' 
#' @details used reshape2 package.....
#' 
#' 
#' @param df.metrics Wide data frame with metric values to be evaluated.
#' @param df.rules  Data frame of metric thresholds to check.
#' @param input.shape Shape of df.metrics; wide or long.  Default is wide.
#' 
#' @return Returns a data frame of results in the long format.
#' 
#' @examples
#' library(readxl)
#' 
#' # Calculate Metrics
#' df.samps.bugs <- read_excel("./data-raw/Data_BCG_PacNW.xlsx")
#' myDF <- df.samps.bugs
#' df.metric.values.bugs <- metric.values(myDF, "bugs")
#' 
#' # Import Rules
#' df.rules.PacNW <- read_excel("./inst/extdata/Rules.xlsx", sheet="BCG_PacNW_2018") 
#' 
#' # Run function
#' df.Membership <- BCG.Membership(df.metric.values.bugs, df.rules.PacNW)
#' 
#' # show results
#' View(df.Membership)
#' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# df.metrics <- df.metric.values.bugs
# df.rules <- df.rules.PacNW
# input.shape <- "wide"
# scores <- BCG.Membership(df.metrics, df.rules, "wide")
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Membership <- function(df.metrics, df.rules, input.shape="wide"){##FUNCTION.START
  #
  # Metrics to long
  if (input.shape=="wide") {##IF.input.shape.START
    df.long <- reshape2::melt(df.metrics, id.vars=c("SAMPLEID", "INDEX_NAME", "REGION")
                             , variable.name="metric.name", value.name="metric.value")
  } else {
    df.long <- df.metrics
  }##IF.input.shape.END
  #
  # merge metrics and checks
  df.merge <- merge(df.long, df.rules
                    , by.x=c("INDEX_NAME", "REGION", "metric.name")
                    , by.y=c("Index_Name", "Region", "Metric.Name"))
  #

  # Excel FuzzyMembership function is much simpler than the Access code
  # need to apply only to select rows
  df.merge[,"Membership"] <- NA
  #
  boo.score.0 <- df.merge[,"metric.value"] < df.merge[,"Lower"]
  boo.score.1 <- df.merge[,"metric.value"] > df.merge[,"Upper"]
  boo.score.calc <- is.na(df.merge[,"Membership"])
  #
  df.merge[boo.score.0, "Membership"] <- 0
  df.merge[boo.score.1, "Membership"] <- 1
  df.merge[boo.score.calc, "Membership"] <- df.merge[,"metric.value"] / (df.merge[,"Upper"] - df.merge[,"Lower"]) - 
                                        df.merge[,"Lower"] / (df.merge[,"Upper"] - df.merge[,"Lower"])
  # direction
  boo.direction <- df.merge[,"Increase"]
  df.merge[!boo.direction, "Membership"] <- 1-df.merge[,"Membership"]
      # can mess up 0 and 1
  
  
  
  # wide name
  df.merge[,"name.wide"] <- paste0("L", df.merge[,"Level"], "_", df.merge[,"metric.name"])
  
  
  #
  # create output
  return(df.merge)
  #
}##FUNCTION.END
