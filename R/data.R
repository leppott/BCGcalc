#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TaxaMaster ----
#' @title Benthic Master Taxa List, BCG Puget Lowlands Willamette Valley
#' 
#' @description Master taxa list for BCG model for Puget Lowlands Willamette 
#' Valley; current as of 2018-09-27.
#' 
#' This list is included for demonstration purposes only! Contact the proper
#' entities to get a updated list for any analyses.
#' 
#' @details To export to file use the code below.
#' 
#' write.csv(TaxaMaster_Ben_BCG_PugLowWilVal
#'          , "TaxaMaster_Ben_BCG_PugLowWilVal_20180314.csv")
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
#'    \item{TolVal}{Tolerance Value, all 7's, demonstration only}
#' }
"TaxaMaster_Ben_BCG_PugLowWilVal"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# metrics_values----
#' @title Metric Values
#' 
#' @description Example metric values
#' 
#' @format A data frame with 678 observations on the following 312 variables.:
#'\describe{
#'  \item{\code{SAMPLEID}}{a character vector}
#'  \item{\code{AREA_MI2}}{a numeric vector}
#'  \item{\code{SURFACEAREA}}{a character vector}
#'  \item{\code{DENSITY_M2}}{a logical vector}
#'  \item{\code{DENSITY_FT2}}{a logical vector}
#'  \item{\code{INDEX_NAME}}{a character vector}
#'  \item{\code{INDEX_CLASS}}{a character vector}
#'  \item{\code{ni_total}}{a numeric vector}
#'  \item{\code{li_total}}{a numeric vector}
#'  \item{\code{ni_Chiro}}{a numeric vector}
#'  \item{\code{ni_EPT}}{a numeric vector}
#'  \item{\code{ni_Trich}}{a numeric vector}
#'  \item{\code{ni_Americo}}{a numeric vector}
#'  \item{\code{ni_Gnorimo}}{a numeric vector}
#'  \item{\code{ni_brackish}}{a numeric vector}
#'  \item{\code{ni_Ramello}}{a numeric vector}
#'  \item{\code{nt_total}}{a numeric vector}
#'  \item{\code{nt_Amph}}{a numeric vector}
#'  \item{\code{nt_Bival}}{a numeric vector}
#'  \item{\code{nt_Coleo}}{a numeric vector}
#'  \item{\code{nt_COET}}{a numeric vector}
#'  \item{\code{nt_CruMol}}{a numeric vector}
#'  \item{\code{nt_Deca}}{a numeric vector}
#'  \item{\code{nt_Dipt}}{a numeric vector}
#'  \item{\code{nt_Ephem}}{a numeric vector}
#'  \item{\code{nt_Ephemerellid}}{a numeric vector}
#'  \item{\code{nt_EPT}}{a numeric vector}
#'  \item{\code{nt_ET}}{a numeric vector}
#'  \item{\code{nt_Gast}}{a numeric vector}
#'  \item{\code{nt_Hepta}}{a numeric vector}
#'  \item{\code{nt_Insect}}{a numeric vector}
#'  \item{\code{nt_Isop}}{a numeric vector}
#'  \item{\code{nt_Mega}}{a numeric vector}
#'  \item{\code{nt_Nemour}}{a numeric vector}
#'  \item{\code{nt_NonIns}}{a numeric vector}
#'  \item{\code{nt_Odon}}{a numeric vector}
#'  \item{\code{nt_OET}}{a numeric vector}
#'  \item{\code{nt_Oligo}}{a numeric vector}
#'  \item{\code{nt_Perlid}}{a numeric vector}
#'  \item{\code{nt_Pleco}}{a numeric vector}
#'  \item{\code{nt_POET}}{a numeric vector}
#'  \item{\code{nt_Ptero}}{a numeric vector}
#'  \item{\code{nt_Rhya}}{a numeric vector}
#'  \item{\code{nt_Tipulid}}{a numeric vector}
#'  \item{\code{nt_Trich}}{a numeric vector}
#'  \item{\code{nt_Tromb}}{a numeric vector}
#'  \item{\code{nt_Tubif}}{a numeric vector}
#'  \item{\code{pi_Ampe}}{a logical vector}
#'  \item{\code{pi_AmpeHaust}}{a logical vector}
#'  \item{\code{pi_Amph}}{a numeric vector}
#'  \item{\code{pi_AmphIsop}}{a numeric vector}
#'  \item{\code{pi_Baet}}{a numeric vector}
#'  \item{\code{pi_Bival}}{a numeric vector}
#'  \item{\code{pi_Caen}}{a numeric vector}
#'  \item{\code{pi_Coleo}}{a numeric vector}
#'  \item{\code{pi_COET}}{a numeric vector}
#'  \item{\code{pi_Corb}}{a numeric vector}
#'  \item{\code{pi_Cru}}{a numeric vector}
#'  \item{\code{pi_CruMol}}{a numeric vector}
#'  \item{\code{pi_Deca}}{a numeric vector}
#'  \item{\code{pi_Dipt}}{a numeric vector}
#'  \item{\code{pi_Ephem}}{a numeric vector}
#'  \item{\code{pi_EphemNoCae}}{a numeric vector}
#'  \item{\code{pi_EphemNoCaeBae}}{a numeric vector}
#'  \item{\code{pi_EPT}}{a numeric vector}
#'  \item{\code{pi_EPTNoBaeHydro}}{a numeric vector}
#'  \item{\code{pi_EPTNoCheu}}{a numeric vector}
#'  \item{\code{pi_ET}}{a numeric vector}
#'  \item{\code{pi_Gast}}{a numeric vector}
#'  \item{\code{pi_Hydro}}{a numeric vector}
#'  \item{\code{pi_Hydro2EPT}}{a numeric vector}
#'  \item{\code{pi_Hydro2Trich}}{a numeric vector}
#'  \item{\code{pi_Insect}}{a numeric vector}
#'  \item{\code{pi_Isop}}{a numeric vector}
#'  \item{\code{pi_IsopGastHiru}}{a numeric vector}
#'  \item{\code{pi_Mega}}{a numeric vector}
#'  \item{\code{pi_Mol}}{a numeric vector}
#'  \item{\code{pi_NonIns}}{a numeric vector}
#'  \item{\code{pi_Odon}}{a numeric vector}
#'  \item{\code{pi_OET}}{a numeric vector}
#'  \item{\code{pi_Oligo}}{a numeric vector}
#'  \item{\code{pi_Pleco}}{a numeric vector}
#'  \item{\code{pi_POET}}{a numeric vector}
#'  \item{\code{pi_Trich}}{a numeric vector}
#'  \item{\code{pi_TrichNoHydro}}{a numeric vector}
#'  \item{\code{pi_Tubif}}{a numeric vector}
#'  \item{\code{pt_Amph}}{a numeric vector}
#'  \item{\code{pt_Bival}}{a numeric vector}
#'  \item{\code{pt_Coleo}}{a numeric vector}
#'  \item{\code{pt_COET}}{a numeric vector}
#'  \item{\code{pt_Deca}}{a numeric vector}
#'  \item{\code{pt_Dipt}}{a numeric vector}
#'  \item{\code{pt_Ephem}}{a numeric vector}
#'  \item{\code{pt_EPT}}{a numeric vector}
#'  \item{\code{pt_ET}}{a numeric vector}
#'  \item{\code{pt_Gast}}{a numeric vector}
#'  \item{\code{pt_Insect}}{a numeric vector}
#'  \item{\code{pt_Isop}}{a numeric vector}
#'  \item{\code{pt_Mega}}{a numeric vector}
#'  \item{\code{pt_NonIns}}{a numeric vector}
#'  \item{\code{pt_Odon}}{a numeric vector}
#'  \item{\code{pt_OET}}{a numeric vector}
#'  \item{\code{pt_Oligo}}{a numeric vector}
#'  \item{\code{pt_Pleco}}{a numeric vector}
#'  \item{\code{pt_POET}}{a numeric vector}
#'  \item{\code{pt_Trich}}{a numeric vector}
#'  \item{\code{nt_Chiro}}{a numeric vector}
#'  \item{\code{pi_Chiro}}{a numeric vector}
#'  \item{\code{pt_Chiro}}{a numeric vector}
#'  \item{\code{pi_Ortho}}{a numeric vector}
#'  \item{\code{pi_Tanyt}}{a numeric vector}
#'  \item{\code{pi_Tanyp}}{a numeric vector}
#'  \item{\code{pi_COC2Chi}}{a numeric vector}
#'  \item{\code{pi_ChCr2Chi}}{a numeric vector}
#'  \item{\code{pi_Orth2Chi}}{a numeric vector}
#'  \item{\code{pi_Tanyp2Chi}}{a numeric vector}
#'  \item{\code{pi_ChiroAnne}}{a numeric vector}
#'  \item{\code{nt_NonInsArachDeca_BCG_att456}}{a numeric vector}
#'  \item{\code{pi_NonInsArachDeca_BCG_att456}}{a numeric vector}
#'  \item{\code{pt_NonInsArachDeca_BCG_att456}}{a numeric vector}
#'  \item{\code{nt_NonInsArachDecaJugaRiss_BCG_att456}}{a numeric vector}
#'  \item{\code{pi_NonInsArachDecaJugaRiss_BCG_att456}}{a numeric vector}
#'  \item{\code{pt_NonInsArachDecaJugaRiss_BCG_att456}}{a numeric vector}
#'  \item{\code{pi_dom02_BCG_att456_NoJugaRiss}}{a numeric vector}
#'  \item{\code{nt_NonIns_BCG_att456}}{a numeric vector}
#'  \item{\code{pi_NonIns_BCG_att456}}{a numeric vector}
#'  \item{\code{pt_NonIns_BCG_att456}}{a numeric vector}
#'  \item{\code{nt_NonInsJugaRiss_BCG_att456}}{a numeric vector}
#'  \item{\code{pi_NonInsJugaRiss_BCG_att456}}{a numeric vector}
#'  \item{\code{pt_NonInsJugaRiss_BCG_att456}}{a numeric vector}
#'  \item{\code{pi_SimBtri}}{a numeric vector}
#'  \item{\code{pi_Colesens}}{a numeric vector}
#'  \item{\code{nt_longlived}}{a numeric vector}
#'  \item{\code{nt_noteworthy}}{a numeric vector}
#'  \item{\code{nt_ffg2_pred}}{a numeric vector}
#'  \item{\code{nt_ti_c}}{a numeric vector}
#'  \item{\code{nt_ti_cc}}{a numeric vector}
#'  \item{\code{nt_ti_cw}}{a numeric vector}
#'  \item{\code{nt_ti_w}}{a numeric vector}
#'  \item{\code{pi_ti_c}}{a numeric vector}
#'  \item{\code{pi_ti_cc}}{a numeric vector}
#'  \item{\code{pi_ti_cw}}{a numeric vector}
#'  \item{\code{pi_ti_w}}{a numeric vector}
#'  \item{\code{pt_ti_c}}{a numeric vector}
#'  \item{\code{pt_ti_cc}}{a numeric vector}
#'  \item{\code{pt_ti_cw}}{a numeric vector}
#'  \item{\code{pt_ti_w}}{a numeric vector}
#'  \item{\code{nt_tv_intol}}{a numeric vector}
#'  \item{\code{nt_tv_intol4}}{a numeric vector}
#'  \item{\code{nt_tv_toler}}{a numeric vector}
#'  \item{\code{pi_tv_intol}}{a numeric vector}
#'  \item{\code{pi_tv_intol4}}{a numeric vector}
#'  \item{\code{pi_tv_toler}}{a numeric vector}
#'  \item{\code{pi_tv_toler6}}{a numeric vector}
#'  \item{\code{pt_tv_intol}}{a numeric vector}
#'  \item{\code{pt_tv_intol4}}{a numeric vector}
#'  \item{\code{pt_tv_toler}}{a numeric vector}
#'  \item{\code{nt_tv_intol4_EPT}}{a numeric vector}
#'  \item{\code{nt_tv_ntol}}{a numeric vector}
#'  \item{\code{nt_tv_stol}}{a numeric vector}
#'  \item{\code{pi_tv_ntol}}{a numeric vector}
#'  \item{\code{pi_tv_stol}}{a numeric vector}
#'  \item{\code{pt_tv_ntol}}{a numeric vector}
#'  \item{\code{pt_tv_stol}}{a numeric vector}
#'  \item{\code{pi_tv2_intol}}{a numeric vector}
#'  \item{\code{pi_tv2_toler_ISA_SalHi_xFL}}{a logical vector}
#'  \item{\code{pi_tv2_intol_ISA_SalHi_xFL}}{a logical vector}
#'  \item{\code{pt_tv2_intol_ISA_SalHi_xFL}}{a logical vector}
#'  \item{\code{nt_ffg_col}}{a numeric vector}
#'  \item{\code{nt_ffg_filt}}{a numeric vector}
#'  \item{\code{nt_ffg_pred}}{a numeric vector}
#'  \item{\code{nt_ffg_scrap}}{a numeric vector}
#'  \item{\code{nt_ffg_shred}}{a numeric vector}
#'  \item{\code{pi_ffg_col}}{a numeric vector}
#'  \item{\code{pi_ffg_filt}}{a numeric vector}
#'  \item{\code{pi_ffg_pred}}{a numeric vector}
#'  \item{\code{pi_ffg_scrap}}{a numeric vector}
#'  \item{\code{pi_ffg_shred}}{a numeric vector}
#'  \item{\code{pt_ffg_col}}{a numeric vector}
#'  \item{\code{pt_ffg_filt}}{a numeric vector}
#'  \item{\code{pt_ffg_pred}}{a numeric vector}
#'  \item{\code{pt_ffg_scrap}}{a numeric vector}
#'  \item{\code{pt_ffg_shred}}{a numeric vector}
#'  \item{\code{nt_ffg2_intface}}{a logical vector}
#'  \item{\code{nt_ffg2_subsurf}}{a logical vector}
#'  \item{\code{pi_ffg2_scavburr}}{a logical vector}
#'  \item{\code{nt_habit_burrow}}{a numeric vector}
#'  \item{\code{nt_habit_climb}}{a numeric vector}
#'  \item{\code{nt_habit_cling}}{a numeric vector}
#'  \item{\code{nt_habit_sprawl}}{a numeric vector}
#'  \item{\code{nt_habit_swim}}{a numeric vector}
#'  \item{\code{pi_habit_burrow}}{a numeric vector}
#'  \item{\code{pi_habit_climb}}{a numeric vector}
#'  \item{\code{pi_habit_cling}}{a numeric vector}
#'  \item{\code{pi_habit_sprawl}}{a numeric vector}
#'  \item{\code{pi_habit_swim}}{a numeric vector}
#'  \item{\code{pt_habit_burrow}}{a numeric vector}
#'  \item{\code{pt_habit_climb}}{a numeric vector}
#'  \item{\code{pt_habit_cling}}{a numeric vector}
#'  \item{\code{pt_habit_sprawl}}{a numeric vector}
#'  \item{\code{pt_habit_swim}}{a numeric vector}
#'  \item{\code{pi_habit_cling_PlecoNoCling}}{a numeric vector}
#'  \item{\code{nt_volt_multi}}{a numeric vector}
#'  \item{\code{nt_volt_semi}}{a numeric vector}
#'  \item{\code{nt_volt_uni}}{a numeric vector}
#'  \item{\code{pi_volt_multi}}{a numeric vector}
#'  \item{\code{pi_volt_semi}}{a numeric vector}
#'  \item{\code{pi_volt_uni}}{a numeric vector}
#'  \item{\code{pt_volt_multi}}{a numeric vector}
#'  \item{\code{pt_volt_semi}}{a numeric vector}
#'  \item{\code{pt_volt_uni}}{a numeric vector}
#'  \item{\code{pi_dom01}}{a numeric vector}
#'  \item{\code{pi_dom02}}{a numeric vector}
#'  \item{\code{pi_dom03}}{a numeric vector}
#'  \item{\code{pi_dom04}}{a numeric vector}
#'  \item{\code{pi_dom05}}{a numeric vector}
#'  \item{\code{pi_dom06}}{a numeric vector}
#'  \item{\code{pi_dom07}}{a numeric vector}
#'  \item{\code{pi_dom08}}{a numeric vector}
#'  \item{\code{pi_dom09}}{a numeric vector}
#'  \item{\code{pi_dom10}}{a numeric vector}
#'  \item{\code{x_Becks}}{a numeric vector}
#'  \item{\code{x_Becks3}}{a numeric vector}
#'  \item{\code{x_HBI}}{a numeric vector}
#'  \item{\code{x_HBI2}}{a numeric vector}
#'  \item{\code{x_NCBI}}{a numeric vector}
#'  \item{\code{x_Shan_e}}{a numeric vector}
#'  \item{\code{x_Shan_2}}{a numeric vector}
#'  \item{\code{x_Shan_10}}{a numeric vector}
#'  \item{\code{x_D}}{a numeric vector}
#'  \item{\code{x_D_G}}{a numeric vector}
#'  \item{\code{x_D_Mg}}{a numeric vector}
#'  \item{\code{x_Evenness}}{a numeric vector}
#'  \item{\code{nt_habitat_brac}}{a numeric vector}
#'  \item{\code{nt_habitat_depo}}{a numeric vector}
#'  \item{\code{nt_habitat_gene}}{a numeric vector}
#'  \item{\code{nt_habitat_head}}{a numeric vector}
#'  \item{\code{nt_habitat_rheo}}{a numeric vector}
#'  \item{\code{nt_habitat_rive}}{a numeric vector}
#'  \item{\code{nt_habitat_spec}}{a numeric vector}
#'  \item{\code{nt_habitat_unkn}}{a numeric vector}
#'  \item{\code{pi_habitat_brac}}{a numeric vector}
#'  \item{\code{pi_habitat_depo}}{a numeric vector}
#'  \item{\code{pi_habitat_gene}}{a numeric vector}
#'  \item{\code{pi_habitat_head}}{a numeric vector}
#'  \item{\code{pi_habitat_rheo}}{a numeric vector}
#'  \item{\code{pi_habitat_rive}}{a numeric vector}
#'  \item{\code{pi_habitat_spec}}{a numeric vector}
#'  \item{\code{pi_habitat_unkn}}{a numeric vector}
#'  \item{\code{pt_habitat_brac}}{a numeric vector}
#'  \item{\code{pt_habitat_depo}}{a numeric vector}
#'  \item{\code{pt_habitat_gene}}{a numeric vector}
#'  \item{\code{pt_habitat_head}}{a numeric vector}
#'  \item{\code{pt_habitat_rheo}}{a numeric vector}
#'  \item{\code{pt_habitat_rive}}{a numeric vector}
#'  \item{\code{pt_habitat_spec}}{a numeric vector}
#'  \item{\code{pt_habitat_unkn}}{a numeric vector}
#'  \item{\code{nt_BCG_att1}}{a numeric vector}
#'  \item{\code{nt_BCG_att1i}}{a numeric vector}
#'  \item{\code{nt_BCG_att1m}}{a numeric vector}
#'  \item{\code{nt_BCG_att12}}{a numeric vector}
#'  \item{\code{nt_BCG_att1i2}}{a numeric vector}
#'  \item{\code{nt_BCG_att123}}{a numeric vector}
#'  \item{\code{nt_BCG_att1i23}}{a numeric vector}
#'  \item{\code{nt_BCG_att2}}{a numeric vector}
#'  \item{\code{nt_BCG_att23}}{a numeric vector}
#'  \item{\code{nt_BCG_att234}}{a numeric vector}
#'  \item{\code{nt_BCG_att3}}{a numeric vector}
#'  \item{\code{nt_BCG_att4}}{a numeric vector}
#'  \item{\code{nt_BCG_att45}}{a numeric vector}
#'  \item{\code{nt_BCG_att5}}{a numeric vector}
#'  \item{\code{nt_BCG_att56}}{a numeric vector}
#'  \item{\code{nt_BCG_att6}}{a numeric vector}
#'  \item{\code{nt_BCG_attNA}}{a numeric vector}
#'  \item{\code{nt_EPT_BCG_att123}}{a numeric vector}
#'  \item{\code{nt_EPT_BCG_att1i23}}{a numeric vector}
#'  \item{\code{pi_BCG_att1}}{a numeric vector}
#'  \item{\code{pi_BCG_att1i}}{a numeric vector}
#'  \item{\code{pi_BCG_att1m}}{a numeric vector}
#'  \item{\code{pi_BCG_att12}}{a numeric vector}
#'  \item{\code{pi_BCG_att1i2}}{a numeric vector}
#'  \item{\code{pi_BCG_att123}}{a numeric vector}
#'  \item{\code{pi_BCG_att1i23}}{a numeric vector}
#'  \item{\code{pi_BCG_att2}}{a numeric vector}
#'  \item{\code{pi_BCG_att23}}{a numeric vector}
#'  \item{\code{pi_BCG_att234}}{a numeric vector}
#'  \item{\code{pi_BCG_att3}}{a numeric vector}
#'  \item{\code{pi_BCG_att4}}{a numeric vector}
#'  \item{\code{pi_BCG_att45}}{a numeric vector}
#'  \item{\code{pi_BCG_att5}}{a numeric vector}
#'  \item{\code{pi_BCG_att56}}{a numeric vector}
#'  \item{\code{pi_BCG_att6}}{a numeric vector}
#'  \item{\code{pi_BCG_attNA}}{a numeric vector}
#'  \item{\code{pi_EPT_BCG_att123}}{a numeric vector}
#'  \item{\code{pt_BCG_att1}}{a numeric vector}
#'  \item{\code{pt_BCG_att1i}}{a numeric vector}
#'  \item{\code{pt_BCG_att1m}}{a numeric vector}
#'  \item{\code{pt_BCG_att12}}{a numeric vector}
#'  \item{\code{pt_BCG_att1i2}}{a numeric vector}
#'  \item{\code{pt_BCG_att123}}{a numeric vector}
#'  \item{\code{pt_BCG_att1i23}}{a numeric vector}
#'  \item{\code{pt_BCG_att2}}{a numeric vector}
#'  \item{\code{pt_BCG_att23}}{a numeric vector}
#'  \item{\code{pt_BCG_att234}}{a numeric vector}
#'  \item{\code{pt_BCG_att3}}{a numeric vector}
#'  \item{\code{pt_BCG_att4}}{a numeric vector}
#'  \item{\code{pt_BCG_att45}}{a numeric vector}
#'  \item{\code{pt_BCG_att5}}{a numeric vector}
#'  \item{\code{pt_BCG_att56}}{a numeric vector}
#'  \item{\code{pt_BCG_att6}}{a numeric vector}
#'  \item{\code{pt_BCG_attNA}}{a numeric vector}
#'  \item{\code{pt_EPT_BCG_att123}}{a numeric vector}
#'}
"metrics_values"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

