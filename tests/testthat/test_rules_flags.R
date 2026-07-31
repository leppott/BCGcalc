# Rules and Flags ----

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Num Digits, xlRules ----
testthat::test_that("thresholds, num digits, xlRules", {
  # Packages
  #library(readxl) # part of BCGcalc
  
  # Thresholds
  fn_thresh <- file.path(system.file(package = "BCGcalc")
                         , "extdata"
                         , "Rules.xlsx")
  df_thresh <- readxl::read_excel(fn_thresh, sheet = "Rules")
  
  # Number of Characters (as character)
  metric_thresh_lo <- nchar(as.character(df_thresh$Lower))
  metric_thresh_hi <- nchar(as.character(df_thresh$Upper))
  
  # Number of "bad" entries
  # Max is 11 (MBSS)
  digmax <- 5
  # after that is most likely a floating point error that needs correction
  metric_thresh_lo_nbad  <- sum(metric_thresh_lo > digmax, na.rm = TRUE)
  metric_thresh_hi_nbad  <- sum(metric_thresh_hi > digmax, na.rm = TRUE)
  
  # Find those rows in Excel with errors
  which(metric_thresh_lo  %in% metric_thresh_lo[metric_thresh_lo > digmax])
  which(metric_thresh_hi  %in% metric_thresh_hi[metric_thresh_hi > digmax])
  
  # test
  testthat::expect_true(metric_thresh_lo_nbad == 0)
  testthat::expect_true(metric_thresh_hi_nbad == 0)
})## Test ~ thresholds, num digits

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Num Digits, xlFlags ----
testthat::test_that("thresholds, num digits, xlFlags", {
  # Packages
  #library(readxl) # part of BioMonTools
  
  # Thresholds
  fn_thresh <- file.path(system.file(package = "BCGcalc")
                         , "extdata"
                         , "MetricFlags.xlsx")
  df_thresh <- readxl::read_excel(fn_thresh, sheet = "Flags")
  
  # Number of Characters (as character)
  index_thresh01 <- nchar(as.character(df_thresh$Value))
  
  # Number of "bad" entries
  # Max is 11 (MBSS)
  digmax <- 5
  # after that is most likely a floating point error that needs correction
  index_thresh01_nbad <- sum(index_thresh01 > digmax, na.rm = TRUE)
  
  # Find those rows in Excel with errors
  which(index_thresh01  %in% index_thresh01[index_thresh01 > digmax])
  
  # test
  testthat::expect_true(index_thresh01_nbad == 0)
})## Test ~ thresholds, num digits

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Symbols, xlRules ----
testthat::test_that("symbols, xlRules", {
  # Packages
  #library(readxl) # part of BioMonTools
  
  # Thresholds
  fn_rules <- file.path(system.file(package = "BCGcalc")
                         , "extdata"
                         , "Rules.xlsx")
  df_rules <- readxl::read_excel(fn_rules, sheet = "Rules")

  # symbols
  symbols_qc <- c(">", "<", ">=", "<=", "==", "!=")
  symbols_rules <- unique(df_rules$Symbol)
  
  #
  qc_sum <- sum(symbols_rules %in% symbols_qc)
  qc_len <- length(symbols_rules)
  
  # Find, non matching symbols
  symbols_rules[symbols_rules %in% symbols_qc]
  
  # test
  testthat::expect_true(qc_sum == qc_len)
})## Test ~ thresholds, num digits

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Symbols, xlFlags ----
testthat::test_that("symbols, Flags", {
  # Packages
  #library(readxl) # part of BioMonTools
  
  # Thresholds
  fn_flags <- file.path(system.file(package = "BCGcalc")
                         , "extdata"
                         , "MetricFlags.xlsx")
  df_flags <- readxl::read_excel(fn_flags, sheet = "Flags")
  
  # symbols
  symbols_qc <- c(">", "<", ">=", "<=", "==", "!=")
  symbols_flags <- unique(df_flags$Symbol)
  
  #
  qc_sum <- sum(symbols_flags %in% symbols_qc)
  qc_len <- length(symbols_flags)
  
  # Find, non matching symbols
  symbols_flags[symbols_flags %in% symbols_qc]

  # test
  testthat::expect_true(qc_sum == qc_len)
})## Test ~ thresholds, num digits

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Flags, Metric Names, xlFlags,  BioMonTools xlNames ----
testthat::test_that("Flags, Metrics, BioMonTools", {
  # Import Flags
  fn_flags <- file.path(system.file(package = "BCGcalc")
                        , "extdata"
                        , "MetricFlags.xlsx")
  df_flags <- readxl::read_excel(fn_flags, sheet = "Flags")
  
  # Import MetricNames
  fn_metnam <- file.path(system.file(package = "BioMonTools")
                        , "extdata"
                        , "MetricNames.xlsx")
  df_metnam <- readxl::read_excel(fn_metnam
                                  , sheet = "MetricMetadata"
                                  , skip = 4)
  #
  metnam_flags <- unique(df_flags[df_flags$BioMonTools_MetNam == TRUE
                                  , "Metric_Name", TRUE])
  metnam_bmt <- unique(df_metnam$METRIC_NAME)
  
  # Check names vs. BioMonTools
  len_metnam_flags <- length(metnam_flags)
  sum_metnam_match <- sum(metnam_flags %in% metnam_bmt)
  
  ## Show Failures
  metnam_flags[!metnam_flags %in% metnam_bmt]
  
  ## test, BMT == TRUE ----
  # ensure all flag metrics are included in BioMonTools metric names
  testthat::expect_equal(sum_metnam_match, len_metnam_flags)
  
  #~~~~~
  # Check all names
  metnam_flags_all <- unique(df_flags[, "Metric_Name", TRUE])
  # Remove known non-metrics
  names_notmetrics <- c("Area_mi2",
                        "CollMonth",
                        "Density_ft2",
                        "Density_m2",
                        "DrArea_mi2",
                        "pcSLOPE",
                        "Precip8110Cat",
                        "SfcArea_ft2",
                        "Subsample_percent",
                        "SurfaceArea",
                        "pslope_nhd",
                        "WSAREASQKM",
                        "WsAreaSqKm",
                        "PRECIP8110CAT",
                        "nt_largeriver")
  metnam_flags_check <- metnam_flags_all[!metnam_flags_all %in% 
                                           names_notmetrics]
  # Compare
  metnam_flags_check_match <- metnam_flags_check[metnam_flags_check %in% 
                                                   metnam_bmt]
  
  ## Show Failures
  # should be character(0)
  metnam_flags_check[!metnam_flags_check %in% metnam_bmt]
  
  ## test, All non known non-metrics ----
  testthat::expect_equal(length(metnam_flags_check_match)
                         , length(metnam_flags_check))
  
  ## Show Failures
  # should be character(0)
  metnam_flags_check[!metnam_flags_check %in% metnam_bmt]
  
  ## test, for those marked TRUE in flags----
  testthat::expect_equal(len_metnam_flags, length(metnam_flags_check))
  
})## Test ~ flags, metrics, BioMonTools

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Metric Names, BCGcalc xlRules, BioMonTools xlNames----
testthat::test_that("Rules, Metrics, BioMonTools", {
  # Import Flags
  fn_rules <- file.path(system.file(package = "BCGcalc")
                        , "extdata"
                        , "Rules.xlsx")
  df_rules <- readxl::read_excel(fn_rules, sheet = "Rules")
  
  # Import MetricNames
  fn_metnam <- file.path(system.file(package = "BioMonTools")
                         , "extdata"
                         , "MetricNames.xlsx")
  df_metnam <- readxl::read_excel(fn_metnam
                                  , sheet = "MetricMetadata"
                                  , skip = 4)
  #
  metnam_rules <- unique(df_rules[, "Metric_Name", TRUE])
  metnam_bmt <- unique(df_metnam$METRIC_NAME)
  
  # Check Rules vs. BioMonTools
  len_metnam_rules <- length(metnam_rules)
  sum_metnam_match <- sum(metnam_rules %in% metnam_bmt)
  
  ## Show Failures
  metnam_rules[!metnam_rules %in% metnam_bmt]
  
  ## test, BMT == TRUE ----
  # ensure all rules metrics are included in BioMonTools metric names
  testthat::expect_equal(sum_metnam_match, len_metnam_rules)
  
})## Test ~ flags, metrics, BioMonTools
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Rules, Duplicate Metrics ----
testthat::test_that("rules, duplicate metrics", {
  # Packages
  #library(readxl) # part of BioMonTools
  
  # Thresholds
  fn_rules <- file.path(system.file(package = "BCGcalc")
                        , "extdata"
                        , "Rules.xlsx")
  df_rules <- readxl::read_excel(fn_rules, sheet = "Rules")
  
  # find dups
  df_rules_metdup <- df_rules |>
    dplyr::summarize(n = dplyr::n(),
                     .by = c(Index_Name,
                             INDEX_CLASS,
                             Level,
                             Rule_Type,
                             Symbol,
                             Increase,
                             Metric_Name)) |>
    dplyr::filter(n > 1L)
  
  #
  qc_calc <- nrow(df_rules_metdup) #disable
  qc_exp  <- 0
  
  # Find, non matching symbols
  df_rules_metdup
  
  # test
  testthat::expect_true(qc_calc == qc_exp) 

})## Test ~ Rules, Duplicate Metrics

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

