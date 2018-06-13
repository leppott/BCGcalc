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
#'                                        , package="BCGcalc"))
#'                                         
#' # Columns to keep
#' myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2")
#' 
#' # Run Function
#' myDF <- df.samps.bugs
#' df.metric.values.bugs <- metric.values(myDF, "bugs", fun.cols2keep=myCols)                                       
#' 
#' # Import Checks
#' df.checks <- read_excel(system.file("./extdata/MetricFlags.xlsx"
#'                                           , package="BCGcalc"), sheet="Flags") 
#'                                           
#' 
#' # Run Function
#' df.flags <- qc.checks(df.metric.values.bugs, df.checks)
#' 
#' # Summarize Results
#' table(df.flags[,"CHECKNAME"], df.flags[,"FLAG"])
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# # Rename UPPER CASE myCols in metric.values output
# for (i in myCols){##IF.i.START
#   i.match <- match(toupper(i), names(df.metric.values.bugs))
#   if(!is.na(i.match)){##IF.is.na.START
#       names(df.metric.values.bugs)[i.match] <- i
#    }##IF.is.na.END
# }##IF.i.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# df.metrics <- df.metric.values.bugs
# df.checks <- df.checks
# input.shape <- "wide"
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
qc.checks <- function(df.metrics, df.checks, input.shape="wide"){##FUNCTION.START
  #
  # to data frame (from Tibble)
  df.metrics <- as.data.frame(df.metrics)
  df.checks <- as.data.frame(df.checks)
  #
  # Metrics to long
  if (input.shape=="wide") {##IF.input.shape.START
    df.long <- reshape2::melt(df.metrics, id.vars=c("SAMPLEID", "INDEX_NAME", "SITE_TYPE")
                             , variable.name="METRIC_NAME", value.name="METRIC_VALUE")
  } else {
    df.long <- df.metrics
  }##IF.input.shape.END
  #
  # Names to Upper Case
  names(df.long) <- toupper(names(df.long))
  names(df.checks) <- toupper(names(df.checks))
  #
  df.long[,"SITE_TYPE"] <- tolower(df.long[,"SITE_TYPE"])
  df.checks[,"SITE_TYPE"] <- tolower(df.checks[,"SITE_TYPE"])
  #
  # merge metrics and checks
  df.merge <- merge(df.long, df.checks
                    , by.x=c("INDEX_NAME", "SITE_TYPE", "METRIC_NAME")
                    , by.y=c("INDEX_NAME", "SITE_TYPE", "METRIC_NAME"))
  #
  # perform evaluation (adds Pass/Fail, default is NA)

  # >
  # <
  # >=
  # <=
  # ==
  # !=
  
  df.merge[,"EXPR"] <- eval(expression(paste(df.merge[,"METRIC_VALUE"], df.merge[,"SYMBOL"], df.merge[,"VALUE"])))
  
  # y <- apply(df.merge$Expr, 1, function(x) eval(parse(text=x)))
  # 
  # x <- "1 < 2"
  # eval(parse(text=x))
  
  # temporary (quick and dirty)
  for (i in 1:nrow(df.merge)){
    df.merge[i, "EVAL"] <- eval(parse(text=df.merge[i, "EXPR"]))
  }
  
  # apply?
  # deparse etc
  
  ## default to NA
  df.merge[,"FLAG"] <- NA
  
  df.merge[df.merge[,"EVAL"]==FALSE, "FLAG"] <- "PASS"
  df.merge[df.merge[,"EVAL"]==TRUE,  "FLAG"] <- "FAIL"
  
  #
  # create output
  return(as.data.frame(df.merge))
  #
}##FUNCTION.END