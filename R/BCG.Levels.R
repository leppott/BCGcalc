#' @title BCG Levels
#' 
#' @description Biological Condition Gradient Level assignment given metric memberships.
#' 
#' @details Input is metric memberships and a rules tables.  Output are 
#' 
#' @param df.membership Data frame of metric memberships (long format, the same as the output of BCG.Membership).
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
#' # Calculate Membership
#' df.Membership <- BCG.Membership(df.metric.values.bugs, df.rules)
#' 
#' # Calculate Levels
#' df.Levels <- BCG.Levels(df.Membership, df.rules)
#' 
#' # show results
#' View(df.Levels)
#' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
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
# df.membership <- BCG.Membership(df.metric.values.bugs, df.rules)
# #
# input.shape <- "long"
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Levels <- function(df.membership, df.rules){##FUNCTION.START
  #
  # # convert membership to long format if provided
  # # Metrics to long
  # if (input.shape=="wide") {##IF.input.shape.START
  #   df.long <- reshape2::melt(df.membership, id.vars=c("SAMPLEID", "INDEX_NAME", "REGION")
  #                             , variable.name="metric.name", value.name="metric.value")
  # } else {
  #   df.long <- df.membership
  # }##IF.input.shape.END
  
  # Drop extra columns from df.membership
  # (otherwise duplicates in merge)
  col.drop <- c("Numeric rules", "Symbol", "Lower", "Upper", "Increase", "Description", "LevelRule")
  col.keep <- names(df.membership)[!(names(df.membership) %in% col.drop)]
  
  # merge metrics and rules
  df.merge <- merge(df.membership[,col.keep], df.rules
                    , by.x=c("INDEX_NAME", "REGION", "Level", "metric.name")
                    , by.y=c("Index_Name", "Region", "Level", "Metric.Name"))
  
  # Min of Alt2
  
  # Max of Alt1 (with Min of Alt2)
  
  
  # Min of Rule0 (with alt above)
  
  
  # Results are for each SAMPLEID, INDEX_NAME, REGION, and TIER/LEVEL
  
  df.results <- df.merge

  # create output
  return(df.results)
  #
}##FUNCTION.END
