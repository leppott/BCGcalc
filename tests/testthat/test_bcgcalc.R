# BCGcalc ####
test_that("bcgcalc", {
  #
  # Metrics
  df.metric.values.bugs <- BCGcalc::metrics_values
  
  # Import Rules
  df.rules <- readxl::read_excel(system.file("./extdata/Rules.xlsx"
                                     , package="BCGcalc")
                                 , sheet="Rules") 
  
  # Calculate Metric Memberships
  df.Metric.Membership <- BCGcalc::BCG.Metric.Membership(df.metric.values.bugs
                                                         , df.rules)
  
  # quick check
  mean_membership_calc <- mean(df.Metric.Membership$MEMBERSHIP)
  mean_membership_qc <- 0.7628162
  
  

  # _test, metric membership ----
  testthat::expect_equal(mean_membership_calc, mean_membership_qc
                         , tolerance = 0.00001)
  
  
  # Calculate Level Memberships
  df.Level.Membership <- BCG.Level.Membership(df.Metric.Membership, df.rules)
  
  sum_LevMemb_calc <- sum(df.Level.Membership[, c("L1", "L2", "L3", "L4"
                                              , "L5", "L6")])
  sum_LevMemb_qc <- 678
  
  # _test, level membership, all equal 1 ----
  testthat::expect_equal(sum_LevMemb_calc, sum_LevMemb_qc)
  
  colsums_LevMemb_calc <- as.vector(colSums(df.Level.Membership[
    , c("L1", "L2", "L3", "L4", "L5", "L6")]))
  colSums_LevMemb_qc <- c(0.00000
                       , 61.90711
                       , 295.62095
                       , 161.83706
                       , 104.63021
                       , 54.00467)
  
  # _test, level membership, colSums ----
  testthat::expect_equal(colsums_LevMemb_calc, colSums_LevMemb_qc)
  
  # Calculate Level Assignments
  df.Levels <- BCG.Level.Assignment(df.Level.Membership)
  
  sum_LevA_calc <- sum(df.Levels$Lev.Prop.Num)
  sum_LevA_qc <- 2505.204
  
  # _test, level assignment, sum of Proportional Number ----
  testthat::expect_equal(sum_LevA_calc, sum_LevA_qc, tolerance = 0.01)

})## Test ~ BCGcalc ~ END

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Num Digits, Rules ----

test_that("thresholds, num digits, rules", {
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
})## Test ~ thresholds, num digits ~ END

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Num Digits, Flags ----

test_that("thresholds, num digits, flags", {
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
})## Test ~ thresholds, num digits ~ END

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Flags, symbols ----

test_that("Flags, symbols", {
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
})## Test ~ thresholds, num digits ~ END

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Flags, Metric Names, BioMonTools ----
test_that("Flags, Metrics, BioMonTools", {
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
  testthat::expect_equal(sum_metnam_match, len_metnam_flags)
  
  #~~~~~
  # Check all names
  metnam_flags_all <- unique(df_flags[, "Metric_Name", TRUE])
  # Remove known non-metrics
  names_notmetrics <- c("Area_mi2"
                        , "CollMonth"
                        , "Density_ft2"
                        , "Density_m2"
                        , "DrArea_mi2"
                        , "pcSLOPE"
                        , "Precip8110Cat"
                        , "SfcArea_ft2"
                        , "Subsample_percent"
                        , "SurfaceArea")
  metnam_flags_check <- metnam_flags_all[!metnam_flags_all %in% 
                                           names_notmetrics]
  # Compare
  metnam_flags_check_match <- metnam_flags_check[metnam_flags_check %in% 
                                                   metnam_bmt]
  
  ## Show Failures
  metnam_flags_check[!metnam_flags_check %in% metnam_bmt]
  
  # test, All non known non-metrics ----
  testthat::expect_equal(length(metnam_flags_check_match)
                         , length(metnam_flags_check))
  
  ## Show Failures
  metnam_flags_check[!metnam_flags_check %in% metnam_bmt]
  
  # test, for those marked TRUE in flags----
  testthat::expect_equal(len_metnam_flags, length(metnam_flags_check))
  
  
})## Test ~ flags, metrics, BioMonTools




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~