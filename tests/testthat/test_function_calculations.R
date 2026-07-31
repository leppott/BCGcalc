# Function Calculations ----
testthat::test_that("bcgcalc", {
  
  # Metrics
  df.metric.values.bugs <- BCGcalc::metrics_values
  
  
  # Import Rules
  df.rules <- readxl::read_excel(system.file("extdata/Rules.xlsx"
                                     , package = "BCGcalc")
                                 , sheet = "Rules") 
  
  # Calculate Metric Memberships
  df.Metric.Membership <- BCGcalc::BCG.Metric.Membership(df.metric.values.bugs
                                                         , df.rules
                                              , col_INDEX_CLASS = "INDEX_CLASS")
  
  # quick check
  mean_membership_calc <- mean(df.Metric.Membership$MEMBERSHIP)
  mean_membership_qc <- 0.7628162
  
  ## _test, metric membership ----
  testthat::expect_equal(mean_membership_calc, mean_membership_qc
                         , tolerance = 0.00001)
  
  
  # Calculate Level Memberships
  df.Level.Membership <- BCGcalc::BCG.Level.Membership(df.Metric.Membership
                                                       , df.rules)
  
  sum_LevMemb_calc <- sum(df.Level.Membership[, c("L1", "L2", "L3", "L4"
                                              , "L5", "L6")])
  sum_LevMemb_qc <- 678
  
  ## _test, level membership, all equal 1 ----
  testthat::expect_equal(sum_LevMemb_calc, sum_LevMemb_qc)
  
  colsums_LevMemb_calc <- as.vector(colSums(df.Level.Membership[
    , c("L1", "L2", "L3", "L4", "L5", "L6")]))
  colSums_LevMemb_qc <- c(0.00000
                       , 61.90711
                       , 295.62095
                       , 161.83706
                       , 104.63021
                       , 54.00467)
  
  ## _test, level membership, colSums ----
  testthat::expect_equal(colsums_LevMemb_calc, colSums_LevMemb_qc)
  
  # Calculate Level Assignments
  df.Levels <- BCGcalc::BCG.Level.Assignment(df.Level.Membership)
  
  sum_LevA_calc <- sum(df.Levels$Continuous_BCG_Level)
  sum_LevA_qc <- 2505.204
  
  ## _test, level assignment, sum of Proportional Number ----
  testthat::expect_equal(sum_LevA_calc, sum_LevA_qc, tolerance = 0.01)

})## Test ~ BCGcalc 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Metric Membership, shape ----
# code coverage, test if different shape works
testthat::test_that("metric membership, long", {
  
  # Metrics
  df.metric.values.bugs <- BCGcalc::metrics_values
  
  # reshape as long
  df.metric.values.bugs$SITE_TYPE <- df.metric.values.bugs$INDEX_CLASS 
  # (same code as in function)
  df.long <- reshape2::melt(
    df.metric.values.bugs, 
    id.vars = c("SAMPLEID", 
                "INDEX_NAME", 
                "SITE_TYPE",
                "INDEX_CLASS"),
    variable.name = "METRIC_NAME", 
    value.name = "METRIC_VALUE")
  
  # Import Rules
  df.rules <- readxl::read_excel(
    system.file("extdata/Rules.xlsx", package = "BCGcalc"),
    sheet = "Rules") 
  
  # Calculate Metric Memberships
  df.Metric.Membership <- BCGcalc::BCG.Metric.Membership(
    df.long,
    df.rules,
    input.shape = "long",
    col_INDEX_CLASS = "INDEX_CLASS")
  
  # quick check
  mean_membership_calc <- mean(df.Metric.Membership$MEMBERSHIP)
  mean_membership_qc <- 0.7628162
  
  ## _test, metric membership, long ----
  testthat::expect_equal(mean_membership_calc, mean_membership_qc
                         , tolerance = 0.00001)
  # same as BCGcalc test
  
})## Test ~ metric membership, long

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Metric Membership, missing metrics ----
# code coverage, test if missing metrics
testthat::test_that("metric membership, missing metrics", {
  
  # Metrics
  df.metric.values.bugs <- BCGcalc::metrics_values
  
  # remove metric to force error
  df.metric.values.bugs$nt_total <- NULL
  
  # Import Rules
  df.rules <- readxl::read_excel(
    system.file("extdata/Rules.xlsx", package = "BCGcalc"),
    sheet = "Rules") 
  
  # Calculate Metric Memberships
  ## bcg_missing_metrics
  testthat::expect_error(
    BCGcalc::BCG.Metric.Membership(
      df.metric.values.bugs,
      df.rules,
      col_INDEX_CLASS = "INDEX_CLASS"),
    class = "bcg_missing_metrics")
  ## bcg_metric_membership
  testthat::expect_error(
    BCGcalc::BCG.Metric.Membership(
      df.metric.values.bugs,
      df.rules,
      col_INDEX_CLASS = "INDEX_CLASS"),
    class = "bcg_metric_membership")
  
})## Test ~ metric membership, missing metrics

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Level Membership, missing metrics ----
# https://github.com/leppott/BCGcalc/issues/54
# 2026-07-31
testthat::test_that("level membership, missing metrics", {
  
  # Metrics
  df.metric.values.bugs <- BCGcalc::metrics_values
  
  
  # Import Rules
  df.rules <- readxl::read_excel(
    system.file("extdata/Rules.xlsx", package = "BCGcalc"),
    sheet = "Rules") 
  
  # Calculate Metric Memberships
  df.Metric.Membership <- BCGcalc::BCG.Metric.Membership(
    df.metric.values.bugs,
    df.rules,
    col_INDEX_CLASS = "INDEX_CLASS")
  
  # quick check
  mean_membership_calc <- mean(df.Metric.Membership$MEMBERSHIP)
  mean_membership_qc <- 0.7628162
  
  ## _test, metric membership ----
  testthat::expect_equal(mean_membership_calc, mean_membership_qc,
                         tolerance = 0.00001)
  
  # remove metric to force error
  df.Metric.Membership <- df.Metric.Membership[
    df.Metric.Membership$METRIC_NAME != "nt_total", ]
  
  # _test, level memberships, missing metrics
  ## bcg_missing_metrics
  testthat::expect_error(
    BCGcalc::BCG.Level.Membership(
      df.Metric.Membership,
      df.rules),
    class = "bcg_missing_metrics")
  ## bcg_level_membership
  testthat::expect_error(
    BCGcalc::BCG.Level.Membership(
      df.Metric.Membership,
      df.rules),
    class = "bcg_level_membership")
  
})## Test ~ metric membership, missing metrics

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
