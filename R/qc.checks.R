#' @title QC checks on metric values
#' 
#' @description Long Description
#' 
#' @details used reshape2 package
#' 
#' @param df.metrics Wide data frame with metric values to be evaluated.
#' @param df.checks  Data frame of metric thresholds to check.
#' @param input.shape Shape of df.metrics; wide or long.  Default is wide.
#' 
#' @return Returns a data frame of SampleID checks and results; Pass and Fail.
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
#' # Import Checks
#' df.checks <- read_excel(system.file("./extdata/MetricFlags.xlsx"
#'                                           , package="BCGcalc"), sheet="Flags") 
#' 
#' # Run Function
#' df.flags <- qc.checks(df.metric.values.bugs, df.checks)
#' 
#' # Summarize Results
#' table(df.flags[,"CheckName"], df.flags[,"Flag"])
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# df.metrics <- df.metric.values.bugs
# df.checks <- df.checks.PacNW
# input.shape <- "wide"
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
qc.checks <- function(df.metrics, df.checks, input.shape="wide"){##FUNCTION.START
  #
  # Metrics to long
  if (input.shape=="wide") {##IF.input.shape.START
    df.long <- reshape2::melt(df.metrics, id.vars=c("SAMPLEID", "INDEX_NAME", "SITETYPE")
                             , variable.name="metric.name", value.name="metric.value")
  } else {
    df.long <- df.metrics
  }##IF.input.shape.END
  #
  # merge metrics and checks
  df.merge <- merge(df.long, df.checks
                    , by.x=c("INDEX_NAME", "SITETYPE", "metric.name")
                    , by.y=c("Index_Name", "SiteType", "Metric"))
  #
  # perform evaluation (adds Pass/Fail, default is NA)

  # >
  # <
  # >=
  # <=
  # ==
  # !=
  
  df.merge$Expr <- eval(expression(paste(df.merge$metric.value, df.merge$Symbol, df.merge$Value)))
  
  # y <- apply(df.merge$Expr, 1, function(x) eval(parse(text=x)))
  # 
  # x <- "1 < 2"
  # eval(parse(text=x))
  
  # temporary (quick and dirty)
  for (i in 1:nrow(df.merge)){
    df.merge[i, "Eval"] <- eval(parse(text=df.merge[i, "Expr"]))
  }
  
  # apply?
  # deparse etc
  
  ## default to NA
  df.merge[,"Flag"] <- NA
  
  df.merge[df.merge[,"Eval"]==FALSE,"Flag"] <- "PASS"
  df.merge[df.merge[,"Eval"]==TRUE,"Flag"] <- "FAIL"
  
  
  
  #
  # create output
  return(df.merge)
  #
}##FUNCTION.END