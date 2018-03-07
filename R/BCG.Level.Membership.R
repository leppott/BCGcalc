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
# df.Metric.Membership <- BCG.Level.Membership(df.metric.values.bugs, df.rules)
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
  
  # Drop extra columns from df.metric.membership
  # (otherwise duplicates in merge)
  col.drop <- c("Numeric rules", "Symbol", "Lower", "Upper", "Increase", "Description", "LevelRule")
  col.keep <- names(df.metric.membership)[!(names(df.metric.membership) %in% col.drop)]
  
  # merge metrics and rules
  df.merge <- merge(df.metric.membership[,col.keep], df.rules
                    , by.x=c("INDEX_NAME", "SITETYPE", "Level", "metric.name")
                    , by.y=c("Index_Name", "SiteType", "Level", "Metric.Name"))
  
  # Min of Alt2
  
  # Max of Alt1 (with Min of Alt2)
  
  
  # Min of Rule0 (with alt above)
  
  
  # Results are for each SAMPLEID, INDEX_NAME, SITETYPE, and TIER/LEVEL
  
  df.results <- df.merge

  # create output
  return(df.results)
  #
}##FUNCTION.END
