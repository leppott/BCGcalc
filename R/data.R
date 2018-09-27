#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @title rarify example data
#' 
#' @description A dataset with example benthic macroinvertebrate data (500 count) 
#' to be used with the rarify function.
#' 
#' @format A data frame with 223 rows and 28 variables:
#' \describe{
#'    \item{SampleID}{Sample ID}
#'    \item{SampID}{SampID}
#'    \item{Type_pSlope}{slope}
#'    \item{NHD_pSLOPE}{slope from NHD+}
#'    \item{Site_Type}{type of site; hi or lo}
#'    \item{Area_mi2}{watershed area, square miles}
#'    \item{SurfaceArea}{surface area of sample collected}
#'    \item{TaxaID}{unique taxonomic identifier}
#'    \item{N_taxa}{number of individuals in sample}
#'    \item{Exclude}{Taxa to remove from taxa richness metrics}
#'    \item{NonTarget}{Non-Target True/False, e.g., a fish in a bug sample}
#'    \item{BCG_Attr}{BCG Attribute}
#'    \item{FFG}{Function Feeding Group}
#'    \item{Thermal_Indicator}{thermal tolerance indicator}
#'    \item{Phylum}{Taxonomic rank, Phylum}
#'    \item{SubPhylum}{Taxonomic rank, SubPhylum}
#'    \item{Class}{Taxonomic rank, Class}
#'    \item{SubClass}{Taxonomic rank, SubClass}
#'    \item{Class}{Taxonomic rank, Class}
#'    \item{Order}{Taxonomic rank, Order}
#'    \item{Family}{Taxonomic rank, Family}
#'    \item{Tribe}{Taxonomic rank, Tribe}
#'    \item{Genus}{Taxonomic rank, Genus}
#'    \item{SubGenus}{Taxonomic rank, SubGenus}
#'    \item{Species}{Taxonomic rank, Species}
#'    \item{Habit}{Habit}
#'    \item{Life_Cycle}{Voltinism}
#'    \item{TolVal}{Tolerance Value}
#' }
#' @source example data
"data_bio2rarify"
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
#'    \item{Class}{Taxonomic rank, Class}
#'    \item{Order}{Taxonomic rank, Order}
#'    \item{Family}{Taxonomic rank, Family}
#'    \item{Tribe}{Taxonomic rank, Tribe}
#'    \item{Genus}{Taxonomic rank, Genus}
#'    \item{SubGenus}{Taxonomic rank, SubGenus}
#'    \item{Species}{Taxonomic rank, Species}
#'    \item{BCG_Attr}{BCG Attribute}
#'    \item{NonTarget}{Non-Target True/False}
#'    \item{Thermal indicator}{thermal tolerance indicator}
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
#' @title Example sample benthic taxa data, family-level
#' 
#' @description Long Description
#' 
#' @format A data frame with 2749 rows and 20 variables:
#' \describe{
#'    \item{Index.Name}{}
#'    \item{SITE}{}
#'    \item{DATE}{}
#'    \item{TAXON}{}
#'    \item{N_TAXA}{}
#'    \item{N_GRIDS}{}
#'    \item{EXCLUDE}{}
#'    \item{strata_r}{}
#'    \item{Phylum}{}
#'    \item{Class}{}
#'    \item{Order}{}
#'    \item{Family}{}
#'    \item{Genus}{}
#'    \item{Other_Taxa}{}
#'    \item{Tribe}{}
#'    \item{FFG}{}
#'    \item{FAM_TV}{}
#'    \item{Habit}{}
#'    \item{FinalTolVal07}{}
#'    \item{FinalTolVal08}{}
#' }
"taxa_bugs_family"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @title Example benthic taxa data, genus-level
#' 
#' @description Long Description
#' 
#' @format A data frame with 5066 rows and 20 variables:
#' \describe{
#'    \item{Index.Name}{}
#'    \item{SITE}{}
#'    \item{DATE}{}
#'    \item{TAXON}{}
#'    \item{N_TAXA}{}
#'    \item{N_GRIDS}{}
#'    \item{EXCLUDE}{}
#'    \item{strata_r}{}
#'    \item{Phylum}{}
#'    \item{Class}{}
#'    \item{Order}{}
#'    \item{Family}{}
#'    \item{Genus}{}
#'    \item{Other_Taxa}{}
#'    \item{Tribe}{}
#'    \item{FFG}{}
#'    \item{FAM_TV}{}
#'    \item{Habit}{}
#'    \item{FinalTolVal07}{}
#'    \item{FinalTolVal08}{}
#' }
"taxa_bugs_genus"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @title Example sample fish taxa data
#' 
#' @description Long Description
#' 
#' @format A data frame with 1693 rows and 15 variables:
#' \describe{
#'    \item{SITE}{}
#'    \item{SPECIES}{}
#'    \item{TOTAL}{}
#'    \item{TYPE}{}
#'    \item{PTOLR}{}
#'    \item{NATIVE_MBSS}{}
#'    \item{TROPHIC_MBSS}{}
#'    \item{SILT}{}
#'    \item{PIRHALLA}{}
#'    \item{FIBISTRATA}{}
#'    \item{ACREAGE}{}
#'    \item{LEN_SAMP}{}
#'    \item{AVWID}{}
#'    \item{TOTBIOM}{}
#'    \item{Index.Name}{}
#' }
"taxa_fish"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~