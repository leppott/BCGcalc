#' Calculate metric values
#'
#' This function calculates metric values for bugs and fish.
#' Inputs are a data frame with SampleID and taxa with phylogenetic and autecological information
#' (see below for required fields by community).
#'
#' No manipulations of the taxa are performed by this routine.  All benthic macroinvertebrate taxa should be identified to genus level.  Any non-count taxa should be identified in the "NonUnique" field as "N". To run the MSW genus level the taxa should be combined before calculating the metrics.
#'
#' Both
#'
#' * Index.Name = Name of index to be used; MBSS_Fish_2005, MBSS_Bugs_2005, MSW_Bugs_1999 (genus index).
#'
#' Benthic Macroinvertebrates
#'
#' Bug metric values assumes the following fields (all upper case)
#'
#' * SITE = MBSS sample identifier.
#'
#' * TAXON = MBSS benthic macroinvertebrate name.
#'
#' * N_TAXA = Number of taxon collected in sample.
#'
#' * EXCLUDE = Non-unique taxa (i.e., parent taxon with one or more children taxa present in sample).  "Y" = do not include in taxa richness metrics.

#' * STRATA_R = Benthic macroinvertebrate region (COASTAL, EPIEDMONT, or HIGHLAND).
#'
#' * Phylogenetic fields
#'
#' + (PHYLUM), CLASS, ORDER, FAMILY, GENUS, OTHER_TAXA, TRIBE, FFG, HABIT, FINALTOLVAL07
#'
#' Valid values for FFG: col, fil, pre, scr, shr
#'
#' Valid values for HABIT: BU, CB, CN, SP, SW
#'
#' MSW data should be first combined to family level and EXCLUDE recalculated.
#'
#' Additional fields needed:
#'
#' + FAM_TV (need to include all the same fields, just leave blank).
#'
#' Fish
#'
#' Fish metric values assumes the following fields (all upper case)
#'
#' * SITE = MBSS sample identifier.
#'
#' * FIBISTRATA = Fish region (COASTAL, EPIEDMONT, WARM, COLD).
#'
#' * ACREAGE = Catchment area in acres.
#'
#' * LEN_SAMP = Length of stream sampled; typically 75-meters.
#'
#' * AVWID = Average stream width (meters) for sampled site.
#'
#' * SPECIES = MBSS fish taxa name.
#'
#' * TOTAL = Number of fish collected in sample.
#'
#' * TYPE = Fish group identifier (ALL CAPS); SCULPIN, DARTER, MADTOM, etc.
#'
#' * TROPHIC_MBSS = MBSS tropic status designations (ALL CAPS); OM, GE, IS, IV, etc.
#'
#' * PTOLR = Pollution tolerance level (ALL CAPS); T, I, NO TYPE.
#'
#' The R library dplyr is required for this function.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param fun.DF Data frame of taxa (list required fields)
#' @param fun.Community Community name for which to calculate metric values (bugs, fish, or algae)
#' @param fun.MetricNames Optional vector of metric names to be returned.  If none are supplied then all will be returned.
#' @param boo.Adjust Optional boolean value on whether to perform adjustments of values prior to scoring.  Default = FALSE but will always be TRUE for fish metrics.
#' @return data frame of SampleID and metric values
#' @examples
#' # Metrics, MBSS Index, Fish
#' myIndex <- "MBSS.2005.Fish"
#' # Thresholds
#' thresh <- metrics_scoring
#' # get metric names for myIndex
#' (myMetrics.Fish <- as.character(droplevels(unique(thresh[thresh[,"Index.Name"]==myIndex,"Metric"]))))
#' # Taxa Data
#' myDF.Fish <- taxa_fish
#' myMetric.Values.Fish <- metric.values(myDF.Fish, "fish", myMetrics.Fish)
#' View(myMetric.Values.Fish)
#'
#' # Metrics, Index, Benthic Macroinvertebrates, genus
#' # (generate values then scores)
#' myIndex <- "MBSS.2005.Bugs"
#' # Thresholds
#' thresh <- metrics_scoring
#' # get metric names for myIndex
#' (myMetrics.Bugs.MBSS <- as.character(droplevels(unique(thresh[thresh[,"Index.Name"]==myIndex,"Metric"]))))
#' # Taxa Data
#' myDF.Bugs.MBSS <- taxa_bugs_genus
#' myMetric.Values.Bugs.MBSS <- metric.values(myDF.Bugs.MBSS, "bugs", myMetrics.Bugs.MBSS)
#' View(myMetric.Values.Bugs.MBSS)
#'
#' # Metrics, MSW Index, Benthic Macroinvertebrates, family
#' myIndex <- "MSW.1999.Bugs"
#' # Thresholds
#' thresh <- metrics_scoring
#' # get metric names for myIndex
#' (myMetrics.Bugs.MSW <- as.character(droplevels(unique(thresh[thresh[,"Index.Name"]==myIndex,"Metric"]))))
#' # Taxa Data
#' myDF.Bugs.MSW <- taxa_bugs_family
#' myMetric.Values.Bugs.MSW <- metric.values(myDF.Bugs.MSW, "bugs", myMetrics.Bugs.MSW)
#' View(myMetric.Values.Bugs.MSW)
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# # QC
# ## Fish
# myIndex <- "MBSS.2005.Fish"
# thresh <- metrics_scoring
# (myMetrics.Fish <- as.character(droplevels(unique(thresh[thresh[,"Index.Name"]==myIndex,"Metric"]))))
# myDF <- myDF.Fish
# myMetric.Values.Fish <- metric.values(myDF.Fish, "SampleID", "fish", myMetrics.Fish, TRUE)
# fun.DF <- myDF.Fish
# fun.SampID <- "SampleID"
# fun.Community <- "fish"
# fun.MetricNames <- myMetrics.Fish
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
metric.values <- function(fun.DF, fun.Community, fun.MetricNames=NULL, boo.Adjust=FALSE){##FUNCTION.metric.values.START
  fun.Community <- toupper(fun.Community)
  # convert community to lowercase
  fun.Community <- tolower(fun.Community)
  # run the proper sub function
  if (fun.Community=="bugs") {##IF.START
    metric.values.bugs(fun.DF, fun.MetricNames, boo.Adjust)
  } else if(fun.Community=="fish"){
    metric.values.fish(fun.DF, fun.MetricNames, boo.Adjust)
  # } else if(fun.Community=="algae"){
  #   metric.values.algae(fun.DF, fun.MetricNames, boo.Adjust)
  }##IF.END
}##FUNCTION.metric.values.START
#
#
#' @export
metric.values.bugs <- function(myDF, MetricNames=NULL, boo.Adjust){##FUNCTION.metric.values.bugs.START
  # convert Field Names to UPPER CASE
  names(myDF) <- toupper(names(myDF))# Remove Non-Target Taxa
  #myDF <- myDF[myDF[,"NonTarget"]==0,]
  # Add extra columns for FFG and Habit (need unique values for functions in summarise)
  # each will be TRUE or FALSE
    myDF["Habit_BU"] <- grepl("BU",toupper(myDF[,"HABIT"]))
    myDF["Habit_CB"] <- grepl("CB",toupper(myDF[,"HABIT"]))
    myDF["Habit_CN"] <- grepl("CN",toupper(myDF[,"HABIT"]))
    myDF["Habit_SP"] <- grepl("SP",toupper(myDF[,"HABIT"]))
    myDF["Habit_SW"] <- grepl("SW",toupper(myDF[,"HABIT"]))
    myDF["FFG_col"] <- grepl("COLLECTOR",toupper(myDF[,"FFG"]))
    myDF["FFG_fil"] <- grepl("FILTERER",toupper(myDF[,"FFG"]))
    myDF["FFG_pre"] <- grepl("PREDATOR",toupper(myDF[,"FFG"]))
    myDF["FFG_scr"] <- grepl("SCRAPER",toupper(myDF[,"FFG"]))
    myDF["FFG_shr"] <- grepl("SHREDDER",toupper(myDF[,"FFG"]))
  # Calculate Metrics (could have used pipe, %>%)
  met.val <- dplyr::summarise(dplyr::group_by(myDF, SITE, INDEX.NAME, STRATA_R)
             #
             # individuals, total
             ,ni_total=sum(N_TAXA)
             #
             # number of individuals
             ,ni_Ephem=sum(N_TAXA[ORDER=="Ephemeroptera"])
             ,ni_Trich=sum(N_TAXA[ORDER=="Trichoptera"])
             ,ni_Pleco=sum(N_TAXA[ORDER=="Plecoptera"])
             ,ni_EPT=sum(N_TAXA[ORDER=="Ephemeroptera" | ORDER=="Trichoptera" | ORDER=="Plecoptera"])
              #
             # percent individuals
             ,pi_Amph=sum(N_TAXA[ORDER=="Amphipoda"]) / ni_total
             ,pi_Bival=sum(N_TAXA[CLASS=="Bivalvia"]) / ni_total
             ,pi_Caen=sum(N_TAXA[FAMILY=="Caenidae"]) / ni_total
             ,pi_Coleo=sum(N_TAXA[ORDER=="Coleoptera"]) / ni_total
             # Cole2Odon,
             # Colesensitive
             ,pi_Corb=sum(N_TAXA[GENUS=="Corbicula"]) / ni_total
             #CruMol
             #Crus
             ,pi_Deca=sum(N_TAXA[ORDER=="Decapoda"]) / ni_total
             , ni_Dipt=sum(N_TAXA[ORDER=="Diptera"])
             ,pi_Dipt= ni_Dipt / ni_total
             , ni_Ephem = sum(N_TAXA[ORDER=="Ephemeroptera"])
             ,pi_Ephem= ni_Ephem/ ni_total
             #EphemNoCaen
             #EPTsenstive
             ,pi_EPT=sum(N_TAXA[ORDER=="Ephemeroptera" | ORDER=="Trichoptera" | ORDER=="Plecoptera"]) / ni_total
             ,pi_Gast=sum(N_TAXA[CLASS=="Gastropoda"]) / ni_total
             ,pi_Iso=sum(N_TAXA[ORDER=="Isopoda"]) / ni_total
             #Moll
             ,pi_NonIns=sum(N_TAXA[ORDER!="Insecta" | is.na(CLASS)]) / ni_total
             ,pi_Odon=sum(N_TAXA[ORDER=="Odonata"]) / ni_total
             #oligo
             ,pi_Pleco=sum(N_TAXA[ORDER=="Plecoptera"]) / ni_total
             ,pi_Trich=sum(N_TAXA[ORDER=="Trichoptera"]) / ni_total
             ,pi_Tubif=sum(N_TAXA[FAMILY=="Tubificidae"]) / ni_total
             #
             # number of taxa
              ,nt_total=dplyr::n_distinct(TAXON[EXCLUDE!="Y"])
              ,nt_Coleo=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & ORDER=="Coleoptera"])
             # ,nt_CruMol=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & (Phylum=="Mollusca" | SubPhylum="Crustacea")])
             ,nt_Dipt=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & ORDER=="Diptera"])
             ,nt_Ephem=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & ORDER=="Ephemeroptera"])
             ,nt_EPT=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & (ORDER=="Ephemeroptera"| ORDER=="Trichoptera" | ORDER=="Plecoptera")])
             ,nt_Oligo=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & CLASS=="Oligochaeta"])
             ,nt_Pleco=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & ORDER=="Plecoptera"])
             ,nt_Ptero=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & GENUS=="Pteronarcys"])
             ,nt_Trich=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & ORDER=="Trichoptera"])
             # Amph, Bival, Gast, Deca, Insect, Isopod, intolMol, Oligo, POET, Tubif
             # intol
             #
             # Midges
             ,nt_Chiro=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FAMILY=="Chironomidae"])
             ,ni_Chiro=sum(N_TAXA[FAMILY=="Chironomidae"])
             ,pi_Chiro= ni_Chiro/ ni_total
             #,pi_CrCh2Chi
             #,pi_Orth2Chi
             #,nt_Ortho
             #MB_pi_OrthocladiinaeCricotopusChironomus2Chironomidae
             ,ni_Tanyt=sum(N_TAXA[TRIBE=="Tanytarsini"])
             ,pi_Tanyt=ni_Tanyt/ ni_total
             #,pi-Tnyt2Chi,
             # COC2Chi
             # tanyp
             # tanyp2Chir
             #
             # percent of taxa
             # Amph, POET, Bival, Chiro, Deca, Dip, Gast, Iso, NonIns, Toler
             # / nt_total
             #
             # tolerance
             ,nt_tv_intol=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FINALTOLVAL07<=3])
             ,nt_tvfam_intol = dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FAM_TV<=3 & !is.na(FAM_TV)])
             ,nt_tv_toler=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FINALTOLVAL07>=7])
             , ni_tv_intolurb = sum(N_TAXA[FINALTOLVAL07<=3 & !is.na(FINALTOLVAL07)])
             #,pi_tv_intolurb=ni_tv_intolurb/sum(N_TAXA[!is.na(FINALTOLVAL07)])
             ,pi_tv_intolurb=ni_tv_intolurb/ni_total
             # pi_Baet2Eph, pi_Hyd2EPT, pi_Hyd2Tri, pi_intol, pi_toler, , nt_intMol,
             # pt toler
             #
             # ffg
             ,nt_ffg_col=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FFG_col==TRUE])
             ,nt_ffg_filt=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FFG_fil==TRUE])
             ,nt_ffg_pred=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FFG_pre==TRUE])
             ,nt_ffg_scrap=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FFG_scr==TRUE])
             ,nt_ffg_shred=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FFG_shr==TRUE])
             ,pi_ffg_col=sum(N_TAXA[FFG_col==TRUE]) / ni_total
             ,pi_ffg_filt=sum(N_TAXA[FFG_fil==TRUE]) / ni_total
             ,pi_ffg_pred=sum(N_TAXA[FFG_pre==TRUE]) / ni_total
             ,ni_ffg_scrap = sum(N_TAXA[FFG_scr==TRUE])
             ,pi_ffg_scrap= ni_ffg_scrap/ ni_total
             ,pi_ffg_shred=sum(N_TAXA[FFG_shr==TRUE]) / ni_total
             # pt for cllct, filtr, pred, scrap, shred
              #
             # habit (need to be wild card)
             ,pi_habit_burrow=sum(N_TAXA[Habit_BU==TRUE]) / ni_total
             , ni_habit_clmbrs=sum(N_TAXA[Habit_CB==TRUE])
             ,pi_habit_clmbrs=ni_habit_clmbrs/ ni_total
             , ni_habit_clngrs=sum(N_TAXA[Habit_CN==TRUE])
             ,pi_habit_clngrs= ni_habit_clngrs/ ni_total
             ,pi_habit_sprawl=sum(N_TAXA[Habit_SP==TRUE]) / ni_total
             , ni_habit_swmmrs = sum(N_TAXA[Habit_SW==TRUE])
             ,pi_habit_swmmrs= ni_habit_swmmrs/ ni_total
             ,nt_habit_burrow=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & Habit_BU==TRUE])
             ,nt_habit_clmbrs=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & Habit_CB==TRUE])
             ,nt_habit_clngrs=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & Habit_CN==TRUE])
             ,nt_habit_sprawl=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & Habit_SP==TRUE])
             ,nt_habit_swmmrs=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & Habit_SW==TRUE])
             # pt for each
              #
             # # voltinism
             # # pi and nt for mltvol, semvol, univol
             # ,pi_volt_multi=sum(N_TAXA[Voltinism=="multivoltine"]) / ni_total
             # ,pi_volt_semi=sum(N_TAXA[Voltinism=="semivoltine"]) / ni_total
             # ,pi_volt_uni=sum(N_TAXA[Voltinism=="univoltine"]) / ni_total
             # ,nt_volt_multi=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & Voltinism=="multivoltine"])
             # ,nt_volt_semi=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & Voltinism=="semivoltine"])
             # ,nt_volt_uni=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & Voltinism=="univoltine"])
             # #
             # indices
             ,pi_dom01=max(N_TAXA)/ni_total
             #,x_Becks.CLASS1=n_distinct(N_TAXA[EXCLUDE!="Y" & TolVal>=0 & TolVal<=2.5])
             #,x_Becks.CLASS2=n_distinct(N_TAXA[EXCLUDE!="Y" & TolVal>=2.5 & TolVal<=4])
             ,x_Becks=(2*dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FINALTOLVAL07>=0 & FINALTOLVAL07<=2.5]))+(1*dplyr::n_distinct(TAXON[EXCLUDE!="Y" & FINALTOLVAL07>=2.5 & FINALTOLVAL07<=4]))
             #,x_HBI_num=sum(N_TAXA*TolVal)
             #,x_HBI_denom=sum(N_TAXA[!is.na(TolVal) & TolVal>0])
             ,x_HBI=sum(N_TAXA*FINALTOLVAL07)/sum(N_TAXA[!is.na(FINALTOLVAL07) & FINALTOLVAL07>0])
           #  ,x_Shan_Num=log(3.14)
          #   ,x_Shan_e=x_Shan_Num/log(exp(1))
          #   ,x_Shan_2=x_Shan_Num/log(2)
          #   ,x_Shan_10=x_Shan_Num/log(10)
             #, x_D Simpson
             #, x_Hbe
             #, x_D_Mg Margalef
             #, x_H
             # Pielou
              # H / Hmax  Hmax is log(nt_total)
             # #
             # # BCG
             # ,nt_BCG_att123=dplyr::n_distinct(TAXON[EXCLUDE!="Y" & (BCG_Atr=="1" | BCG_Atr=="2" | BCG_Atr=="3")])
             # nt_att 12, 123, 2, 23, 234, 4, 5, 5, 56
             # nt_EPT_att123
             # pi_att 12, 123, 23, 45, 5, 56
             # pi_dom01_att 4, 5, 56
             # pi_dom05_att 123, not 456
             # pi_EPT_att123
             # pt_att 12, 123, 23, 234, 5, 56
             # pt_EPT_att 123
          # MBSS metric names
          , ntaxa        = nt_total
          , nept         = nt_EPT
          , nephem       = nt_Ephem
          , totind       = ni_total
          , totephem     = ni_Ephem
          , nscrape      = nt_ffg_scrap
          , totclimb     = ni_habit_clmbrs
          , totchiron    = ni_Chiro
          , totcling     = ni_habit_clngrs
          , tottany      = ni_Tanyt
          , totscrape    = ni_ffg_scrap
          , totswim      = ni_habit_swmmrs
          , totdipt      = ni_Dipt
          , totintol_urb = ni_tv_intolurb
          , pephem       = 100 * pi_Ephem
          , pclimb       = 100 * pi_habit_clmbrs
          , pchiron      = 100 * pi_Chiro
          , pcling       = 100 * pi_habit_clngrs
          , ptany        = 100 * pi_Tanyt
          , pscrape      = 100 * pi_ffg_scrap
          , pswim        = 100 * pi_habit_swmmrs
          , pdipt        = 100 * pi_Dipt
          , pintol_urb   = 100 * pi_tv_intolurb
          # MSW
          , ndipt        = nt_Dipt
          , nintol       = nt_tv_intol
          , becks        = x_Becks
          , nintol_FAM   = nt_tvfam_intol

             #
          )## met.val.END
  # replace NA with 0
  met.val[is.na(met.val)] <- 0
  # # subset to only metrics specified by user
  myFlds.MBSS <- c("totind", "ntaxa", "nept", "nephem", "totephem", "nscrape", "totclimb"
                   , "totchiron", "totcling", "tottany", "totscrape", "totswim"
                   , "totdipt", "totintol_urb", "pephem", "pclimb", "pchiron"
                   , "pcling", "ptany", "pscrape", "pswim", "pdipt", "pintol_urb"
                   , "ndipt", "nintol", "becks", "nintol_FAM")



  if (!is.null(MetricNames)){
    met.val <- met.val[,c("SITE", "STRATA_R", "INDEX.NAME", myFlds.MBSS )] #totind, MetricNames)]
  }
  # df to report back
  return(met.val)
}##FUNCTION.metric.values.bugs.END
#
#
#' @export
metric.values.fish <- function(myDF, SampleID, MetricNames=NULL, boo.Adjust){##FUNCTION.metric.values.fish.START
  # Remove Non-Target Taxa
  #myDF <- myDF[myDF[,"NonTarget"]==0,]
  # set case on fields
  myFlds <- c("SPECIES", "TYPE", "PTOLR", "NATIVE_MBSS", "TROPHIC_MBSS", "SILT", "FIBISTRATA")
  # Error check on fields
  if (length(myFlds)!=sum(myFlds %in% names(myDF))) {
    myMsg <- paste0("Fields missing from input data frame.  Expecting: \n",paste(myFlds,sep="",collapse=", "),collapse="")
    stop(myMsg)
  }
  for (i in myFlds) {
    myDF[,i] <- toupper(myDF[,i])
  }
  # Calculate Metrics (could have used pipe, %>%)
  met.val <- dplyr::summarise(dplyr::group_by(myDF, Index.Name, SITE, FIBISTRATA, ACREAGE, LEN_SAMP, AVWID)
                       #
                       # MBSS 2005, 11 metrics
                       # (can do metrics as one step but MBSS output has numerator so will get that as well)
                       #
                       # individuals, total
                       ,ni_total=sum(TOTAL)
                       #
                       # percent individuals
                       # % RBS
                       ,ni_rbs=sum(TOTAL[TYPE=="SUCKER" & PTOLR!="T"])
                       ,pi_rbs=ni_rbs/ni_total
                       # Pct Brook Trout
                       ,ni_brooktrout=sum(TOTAL[SPECIES=="BROOK TROUT"])
                       ,pi_brooktrout=ni_brooktrout/ni_total
                       # Pct Sculpins
                       ,ni_sculpin=sum(TOTAL[TYPE=="SCULPIN"])
                       ,pi_sculpin=ni_sculpin/ni_total
                        #
                       # number of taxa
                       ,nt_total=dplyr::n_distinct(SPECIES)
                       ,nt_benthic=dplyr::n_distinct(SPECIES[TYPE=="DARTER"|TYPE=="SCULPIN"|TYPE=="MADTOM"|TYPE=="LAMPREY"])
                      #
                       # Feeding
                       # % Lithophilic spawners
                       ,ni_lithophil=sum(TOTAL[SILT=="Y"])
                       ,pi_lithophil=ni_lithophil/ni_total
                       # % gen, omn, invert
                       , ni_genomninvrt=sum(TOTAL[TROPHIC_MBSS=="GE" | TROPHIC_MBSS=="OM" | TROPHIC_MBSS=="IV"])
                       ,pi_genomninvrt=ni_genomninvrt / ni_total
                       # % insectivore
                      ,ni_insectivore=sum(TOTAL[TROPHIC_MBSS=="IS"])
                       ,pi_insectivore= ni_insectivore/ ni_total
                      #
                      # Tolerance
                      , ni_tv_toler= sum(TOTAL[PTOLR=="T"])
                      , pi_tv_toler= ni_tv_toler/ni_total
                      #
                       # indices
                       #,pi_dom01/2/3/5 #last? or nth
                       ,pi_dom01=max(TOTAL)/ni_total
                      #
                       # Other
                       ,area=max(AVWID)*max(LEN_SAMP)
                       # Abund / sq meter
                       ,ni_m2=ni_total/area #/(StWidAvg*StLength)
                       # biomass per square meter
                      , x_biomass_total=max(TOTBIOM)
                       ,x_biomass_m2=x_biomass_total/area #/(StWidAvg*StLength)
                       # #
                       # # BCG
                       # ,nt_BCG_att123=n_distinct(Count[EXCLUDE!="Y" & (BCG_Atr=="1" | BCG_Atr=="2" | BCG_Atr=="3")])
                       #
                       # MBSS metric names
                       , STRMAREA  = area
                       , TOTCNT    = ni_total
                       , ABUNSQM   = ni_m2
                       , PABDOM    = pi_dom01 * 100
                       , TOTBIOM   = x_biomass_total
                       , BIOM_MSQ  = x_biomass_m2
                       , NUMBENTSP = nt_benthic
                       , NUMBROOK  = ni_brooktrout
                       , PBROOK    = pi_brooktrout * 100
                       , NUMGEOMIV = ni_genomninvrt
                       , PGEOMIV   = pi_genomninvrt * 100
                       , NUMIS     = ni_insectivore
                       , P_IS      = pi_insectivore * 100
                       , NUMLITH   = ni_lithophil
                       , P_LITH    = pi_lithophil * 100
                       , NUMROUND  = ni_rbs
                       , PROUND    = pi_rbs * 100
                       , NUMSCULP  = ni_sculpin
                       , PSCULP    = pi_sculpin * 100
                       , NUMTOL    = ni_tv_toler
                       , PTOL      = pi_tv_toler * 100
                       #
  )## met.val.END
  #
  # replace NA with 0
  met.val[is.na(met.val)] <- 0
  #
  # # subset to only metrics specified by user
  # if (!is.null(MetricNames)){
  #   met.val <- met.val[,c(Index.Name, SITE, FIBISTRATA, ACREAGE, LEN_SAMP, MetricNames)]
  # }
  myFlds_Remove <- c("ni_total", "ni_rbs", "pi_rbs", "ni_brooktrout"
                     , "pi_brooktrout", "ni_sculpin", "pi_sculpin", "nt_total"
                     , "nt_benthic", "ni_lithophil", "pi_lithophil", "ni_genomninvrt"
                     , "pi_genomninvrt", "ni_insectivore", "pi_insectivore", "ni_tv_toler"
                     , "pi_tv_toler", "pi_dom01", "area", "ni_m2"
                     , "x_biomass_total", "x_biomass_m2")
  met.val <- met.val[,-match(myFlds_Remove,names(met.val))]


  #
  # Adjust metrics (MBSS always adjust so remove IF/THEN)
  # added as extra columns to output
  #if (boo.Adjust==TRUE) {##IF.boo.Ajust.START
    # MBSS.2005.Fish
    # nt_benthic
      met.val[,"NUMBENTSP_Obs"] <- met.val[,"NUMBENTSP"]
      # Expected constants
      ## m
      met.val[,"NUMBENTSP_m"] <- NA
      met.val[,"NUMBENTSP_m"][met.val[,"FIBISTRATA"]=="COASTAL"]   <- 1.69
      met.val[,"NUMBENTSP_m"][met.val[,"FIBISTRATA"]=="EPIEDMONT"] <- 1.25
      met.val[,"NUMBENTSP_m"][met.val[,"FIBISTRATA"]=="HIGHLAND"]  <- 1.23
      ## b
      met.val[,"NUMBENTSP_b"] <- NA
      met.val[,"NUMBENTSP_b"][met.val[,"FIBISTRATA"]=="COASTAL"]   <- -3.33
      met.val[,"NUMBENTSP_b"][met.val[,"FIBISTRATA"]=="EPIEDMONT"] <- -2.36
      met.val[,"NUMBENTSP_b"][met.val[,"FIBISTRATA"]=="HIGHLAND"]  <- -2.35
      # Calc Expected
      met.val[,"NUMBENTSP_Exp"] <- (met.val[,"NUMBENTSP_m"] * log10(met.val[,"ACREAGE"])) + met.val[,"NUMBENTSP_b"]
      # Calc Adjusted
      met.val[,"NUMBENTSP_Adj"] <- met.val[,"NUMBENTSP_Obs"] / met.val[,"NUMBENTSP_Exp"]
      # Rename base metric with adjusted value
      met.val[,"NUMBENTSP"] <- met.val[,"NUMBENTSP_Adj"]
      # NA to zero
      met.val[,"NUMBENTSP"][is.na(met.val[,"NUMBENTSP"])] <- 0

  #}##IF.boo.Ajust.END
  #
  # df to report back
  return(met.val)
}##FUNCTION.metric.values.fish.END
#
#
#' @export
metric.values.algae <- function(myDF, MetricNames=NULL, boo.Adjust){##FUNCTION.metric.values.algae.START
  # Calculate Metrics (could have used pipe, %>%)
    met.val <- dplyr::summarise(dplyr::group_by(myDF, SampleID, "Index.Name", "Index.Region")
                #
                # individuals, total
                ,ni_total=sum(N_TAXA)
                #
    )##met.val.END
    # replace NA with 0
    met.val[is.na(met.val)] <- 0
    # subset to only metrics specified by user
    if (!is.null(MetricNames)){
      met.val <- met.val[,c(SampleID, "Index.Name", "Index.Region", "ni_total", MetricNames)]
    }
    # df to report back
    return(met.val)
}##FUNCTION.metric.values.algae.END
