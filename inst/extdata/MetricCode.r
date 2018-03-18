> metric.values.bugs
function (myDF, MetricNames = NULL, boo.Adjust) 
{
    myDF <- as.data.frame(myDF)
    names(myDF) <- toupper(names(myDF))
    myDF[, "HABIT"] <- toupper(myDF[, "HABIT"])
    myDF[, "FFG"] <- toupper(myDF[, "FFG"])
    myDF[, "LIFECYCLE"] <- toupper(myDF[, "LIFE_CYCLE"])
    myDF[, "HABIT_BU"] <- grepl("BU", myDF[, "HABIT"])
    myDF[, "HABIT_CB"] <- grepl("CB", myDF[, "HABIT"])
    myDF[, "HABIT_CN"] <- grepl("CN", myDF[, "HABIT"])
    myDF[, "HABIT_SP"] <- grepl("SP", myDF[, "HABIT"])
    myDF[, "HABIT_SW"] <- grepl("SW", myDF[, "HABIT"])
    myDF[, "FFG_COL"] <- grepl("COLLECTOR", myDF[, "FFG"])
    myDF[, "FFG_FIL"] <- grepl("FILTERER", myDF[, "FFG"])
    myDF[, "FFG_PRE"] <- grepl("PREDATOR", myDF[, "FFG"])
    myDF[, "FFG_SCR"] <- grepl("SCRAPER", myDF[, "FFG"])
    myDF[, "FFG_SHR"] <- grepl("SHREDDER", myDF[, "FFG"])
	
    met.val <- dplyr::summarise(dplyr::group_by(myDF, SAMPLEID, 
        INDEX_NAME, SITE_TYPE)
		
			, ni_total = sum(N_TAXA)
		
		
			, pi_Amph = sum(N_TAXA[ORDER == "Amphipoda"])/ni_total
			, pi_Bival = sum(N_TAXA[CLASS == "Bivalvia"])/ni_total
			, pi_Caen = sum(N_TAXA[FAMILY == "Caenidae"])/ni_total
			, pi_Coleo = sum(N_TAXA[ORDER == "Coleoptera"])/ni_total
			, pi_Corb = sum(N_TAXA[GENUS == "Corbicula"])/ni_total
			, pi_Deca = sum(N_TAXA[ORDER == "Decapoda"])/ni_total
			, pi_Dipt = sum(N_TAXA[ORDER == "Diptera"])/ni_total
			, pi_Ephem = sum(N_TAXA[ORDER == "Ephemeroptera"])/ni_total
			, pi_EPT = sum(N_TAXA[ORDER == "Ephemeroptera" | ORDER == "Trichoptera" | ORDER == "Plecoptera"])/ni_total
			, pi_Gast = sum(N_TAXA[CLASS == "Gastropoda"])/ni_total
			, pi_Iso = sum(N_TAXA[ORDER == "Isopoda"])/ni_total
			, pi_NonIns = sum(N_TAXA[ORDER != "Insecta" | is.na(CLASS)])/ni_total
			, pi_Odon = sum(N_TAXA[ORDER == "Odonata"])/ni_total
			, pi_Pleco = sum(N_TAXA[ORDER == "Plecoptera"])/ni_total
			, pi_Trich = sum(N_TAXA[ORDER == "Trichoptera"])/ni_total
			#, pi_Tubif = sum(N_TAXA[FAMILY == "Tubificidae"])/ni_total
			
			
			
			, nt_total = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE], na.rm = TRUE)
			, nt_Amph = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & ORDER == "Amphipoda"], na.rm = TRUE)
			, nt_Bival = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & CLASS == "Bivalvia"], na.rm = TRUE)
			, nt_Coleo = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & ORDER == "Coleoptera"], na.rm = TRUE)
			, nt_CruMol = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & PHYLUM == "Mollusca"], na.rm = TRUE) + 
							dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & SUBPHYLUM == "Crustacea"], na.rm = TRUE)
			, nt_Deca = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & ORDER == "Decapoda"], na.rm = TRUE)
			, nt_Dipt = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & ORDER == "Diptera"], na.rm = TRUE)
			, nt_Ephem = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & ORDER == "Ephemeroptera"], na.rm = TRUE)
			, nt_EPT = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE 
						& (ORDER == "Ephemeroptera" | ORDER == "Trichoptera" | ORDER == "Plecoptera")], na.rm = TRUE)
			, nt_Gast = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & CLASS == "Gastropoda"], na.rm = TRUE)
			, nt_Insect = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & CLASS == "Insect"], na.rm = TRUE)
			, nt_Isop = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & ORDER == "Isopoda"], na.rm = TRUE)
			, nt_Oligo = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & CLASS == "Oligochaeta"], na.rm = TRUE)
			, nt_Pleco = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & ORDER == "Plecoptera"], na.rm = TRUE)
			, nt_Ptero = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & GENUS == "Pteronarcys"], na.rm = TRUE)
			, nt_Trich = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & ORDER == "Trichoptera"], na.rm = TRUE)
			
			
			
			, ni_Chiro = sum(N_TAXA[FAMILY == "Chironomidae"])
			, nt_Chiro = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & FAMILY == "Chironomidae"], na.rm = TRUE)
			, pi_Chiro = ni_Chiro/ni_total
			, pi_Tanyt = sum(N_TAXA[TRIBE == "Tanytarsini"])/ni_total
			
			
			
			, pt_EPT = nt_EPT/nt_total
			
			
			
			, nt_tv_intol = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & TOLVAL <= 3], na.rm = TRUE)
			, nt_tv_toler = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & TOLVAL >= 7], na.rm = TRUE)
			#, ni_tv_intolurb = sum(N_TAXA[TOLVAL <= 3 & !is.na(TOLVAL)])
			#, pi_tv_intolurb = ni_tv_intolurb/ni_total
			
			
			
			, nt_ffg_col = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & FFG_COL == TRUE], na.rm = TRUE)
			, nt_ffg_filt = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & FFG_FIL == TRUE], na.rm = TRUE)
			, nt_ffg_pred = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & FFG_PRE == TRUE], na.rm = TRUE)
			, nt_ffg_scrap = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & FFG_SCR == TRUE], na.rm = TRUE)
			, nt_ffg_shred = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & FFG_SHR == TRUE], na.rm = TRUE)
			, pi_ffg_col = sum(N_TAXA[FFG_COL == TRUE])/ni_total
			
			, pi_ffg_filt = sum(N_TAXA[FFG_FIL == TRUE])/ni_total
			, pi_ffg_pred = sum(N_TAXA[FFG_PRE == TRUE])/ni_total
			, pi_ffg_scrap = sum(N_TAXA[FFG_SCR == TRUE])/ni_total
			, pi_ffg_shred = sum(N_TAXA[FFG_SHR == TRUE])/ni_total
			
			, pt_ffg_col = nt_ffg_col/nt_total
			, pt_ffg_filt = nt_ffg_filt/nt_total
			, pt_ffg_pred = nt_ffg_pred/nt_total
			, pt_ffg_scrap = nt_ffg_scrap/nt_total
			, pt_ffg_shred = nt_ffg_shred/nt_total
		
		
		
		
			, pi_habit_burrow = sum(N_TAXA[HABIT_BU == TRUE])/ni_total
			, pi_habit_clmbrs = sum(N_TAXA[HABIT_CB == TRUE])/ni_total
			, pi_habit_clngrs = sum(N_TAXA[HABIT_CN == TRUE])/ni_total
			, pi_habit_sprawl = sum(N_TAXA[HABIT_SP == TRUE])/ni_total
			, pi_habit_swmmrs = sum(N_TAXA[HABIT_SW == TRUE])/ni_total
			, nt_habit_burrow = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & HABIT_BU == TRUE], na.rm = TRUE)
			, nt_habit_clmbrs = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & HABIT_CB == TRUE], na.rm = TRUE)
			, nt_habit_clngrs = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & HABIT_CN == TRUE], na.rm = TRUE)
			, nt_habit_sprawl = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & HABIT_SP == TRUE], na.rm = TRUE)
			, nt_habit_swmmrs = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & HABIT_SW == TRUE], na.rm = TRUE)
			
			
			
			
			, pi_dom01 = max(N_TAXA)/ni_total
			, x_Becks = (2 * dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & TOLVAL >= 0 & TOLVAL <= 2.5], na.rm = TRUE)) + 
						(1 * dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & TOLVAL >= 2.5 & TOLVAL <= 4], na.rm = TRUE))
			, x_HBI = sum(N_TAXA * TOLVAL)/sum(N_TAXA[!is.na(TOLVAL) & TOLVAL > 0])
			
			
			
			
			
			, 
        nt_BCG_att12 = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & 
            (BCG_ATTR == 1 | BCG_ATTR == 2)], na.rm = TRUE), 
        nt_BCG_att123 = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & 
            (BCG_ATTR == 1 | BCG_ATTR == 2 | BCG_ATTR == 3)], 
            na.rm = TRUE), nt_BCG_att2 = dplyr::n_distinct(TAXAID[EXCLUDE != 
            TRUE & (BCG_ATTR == 2)], na.rm = TRUE), nt_BCG_att23 = dplyr::n_distinct(TAXAID[EXCLUDE != 
            TRUE & (BCG_ATTR == 2 | BCG_ATTR == 3)], na.rm = TRUE), 
        nt_BCG_att234 = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & 
            (BCG_ATTR == 2 | BCG_ATTR == 3 | BCG_ATTR == 4)], 
            na.rm = TRUE), nt_BCG_att4 = dplyr::n_distinct(TAXAID[EXCLUDE != 
            TRUE & (BCG_ATTR == 4)], na.rm = TRUE), nt_BCG_att45 = dplyr::n_distinct(TAXAID[EXCLUDE != 
            TRUE & (BCG_ATTR == 4 | BCG_ATTR == 5)], na.rm = TRUE), 
        nt_BCG_att5 = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & 
            (BCG_ATTR == 5)], na.rm = TRUE), nt_BCG_att56 = dplyr::n_distinct(TAXAID[EXCLUDE != 
            TRUE & (BCG_ATTR == 5 | BCG_ATTR == 6)], na.rm = TRUE), 
        nt_BCG_att6 = dplyr::n_distinct(TAXAID[EXCLUDE != TRUE & 
            (BCG_ATTR == 6)], na.rm = TRUE), nt_EPT_BCG_att123 = dplyr::n_distinct(TAXAID[EXCLUDE != 
            TRUE & (ORDER == "Ephemeroptera" | ORDER == "Trichoptera" | 
            ORDER == "Plecoptera") & (BCG_ATTR == 1 | BCG_ATTR == 
            2 | BCG_ATTR == 3)], na.rm = TRUE), pi_BCG_att12 = sum(N_TAXA[(BCG_ATTR == 
            1 | BCG_ATTR == 2)])/ni_total, pi_BCG_att123 = sum(N_TAXA[(BCG_ATTR == 
            1 | BCG_ATTR == 2 | BCG_ATTR == 3)])/ni_total, pi_BCG_att23 = sum(N_TAXA[(BCG_ATTR == 
            2 | BCG_ATTR == 3)])/ni_total, pi_BCG_att234 = sum(N_TAXA[(BCG_ATTR == 
            2 | BCG_ATTR == 3 | BCG_ATTR == 4)])/ni_total, pi_BCG_att4 = sum(N_TAXA[(BCG_ATTR == 
            4)])/ni_total, pi_BCG_att45 = sum(N_TAXA[(BCG_ATTR == 
            4 | BCG_ATTR == 5)])/ni_total, pi_BCG_att5 = sum(N_TAXA[(BCG_ATTR == 
            5)])/ni_total, pi_BCG_att56 = sum(N_TAXA[(BCG_ATTR == 
            5 | BCG_ATTR == 6)])/ni_total, pi_BCG_att6 = sum(N_TAXA[(BCG_ATTR == 
            6)])/ni_total, pi_EPT_BCG_att123 = sum(N_TAXA[(ORDER == 
            "Ephemeroptera" | ORDER == "Trichoptera" | ORDER == 
            "Plecoptera") & (BCG_ATTR == 1 | BCG_ATTR == 2 | 
            BCG_ATTR == 3)])/ni_total, pt_BCG_att12 = nt_BCG_att12/nt_total, 
        pt_BCG_att123 = nt_BCG_att123/nt_total, pt_BCG_att2 = nt_BCG_att2/nt_total, 
        pt_BCG_att23 = nt_BCG_att23/nt_total, pt_BCG_att234 = nt_BCG_att234/nt_total, 
        pt_BCG_att4 = nt_BCG_att4/nt_total, pt_BCG_att45 = nt_BCG_att45/nt_total, 
        pt_BCG_att5 = nt_BCG_att5/nt_total, pt_BCG_att56 = nt_BCG_att56/nt_total, 
        pt_BCG_att6 = nt_BCG_att6/nt_total, pt_EPT_BCG_att123 = nt_EPT_BCG_att123/nt_total)
		
		
    met.val[is.na(met.val)] <- 0
    if (!is.null(MetricNames)) {
        met.val <- met.val[, c("SAMPLEID", "SITE_TYPE", "INDEX_NAME", 
            ni_total, MetricNames)]
    }
    return(met.val)
}
