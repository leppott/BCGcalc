#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @title Benthic Master Taxa List, BCG Pacific Northwest
#' 
#' @description Master taxa list for BCG model for Pacific Northwest; 
#' current as of 2018-09-27.
#' 
#' @details To export to file use the code below.
#' 
#' write.csv(TaxaMaster_Ben_BCG_PacNW, "TaxaMaster_Ben_BCG_PacNW_20180314.csv")
#' 
#' @format A data frame with 684 rows and 19 variables:
#' \describe{
#'    \item{TaxaID}{unique taxonomic identifier}
#'    \item{Phylum}{Taxonomic rank, Phylum}
#'    \item{SubPhylum}{Taxonomic rank, SubPhylum}
#'    \item{Class}{Taxonomic rank, Class}
#'    \item{SubClass}{Taxonomic rank, SubClass}
#'    \item{Order}{Taxonomic rank, Order}
#'    \item{Family}{Taxonomic rank, Family}
#'    \item{Tribe}{Taxonomic rank, Tribe}
#'    \item{Genus}{Taxonomic rank, Genus}
#'    \item{SubGenus}{Taxonomic rank, SubGenus}
#'    \item{Species}{Taxonomic rank, Species}
#'    \item{BCG_Attr}{BCG Attribute}
#'    \item{NonTarget}{Non-Target True/False}
#'    \item{Thermal_Indicator}{thermal tolerance indicator}
#'    \item{Long_Lived}{Long-lived indicator}
#'    \item{FFG}{Function Feeding Group}
#'    \item{Habit}{Habit}
#'    \item{Life_Cycle}{Voltinism}
#'    \item{TolVal}{Tolerance Value}
#' }
"TaxaMaster_Ben_BCG_PacNW"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @title Metric Scoring
#' 
#' @description Long Description
#' 
#' @format A data frame with 69 rows and 8 variables:
#' \describe{
#'    \item{Index.Name}{}
#'    \item{Index.Region}{}
#'    \item{Metric}{}
#'    \item{Direction}{}
#'    \item{Thresh.Lo}{}
#'    \item{Thresh.Hi}{}
#'    \item{ScoreRegime}{}
#'    \item{Name_Other}{}
#' }
"metrics_scoring"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
