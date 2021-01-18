# BCGcalc ####
test_that("bcgcalc", {
  #
  # Metrics
  df.metric.values.bugs <- BCGcalc::metrics_values
  
  # Import Rules
  df.rules <- readxl::read_excel(system.file("./extdata/Rules.xlsx"
                                     , package="BCGcalc")
                                 , sheet="BCG_PacNW_v1_500ct") 
  
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
