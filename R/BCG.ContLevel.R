#' @title BCG Continuous Value to Text Level
#' 
#' @description Convert Biological Condition Gradient (BCG) continuous value to 
#' level text.
#' 
#' @details Internal function to get narrative BCG level based on the 
#' continuous level.
#' 
#' 'status' is the BCG Level as a number 
#' (x/y tie is x.5, the rest are integers).
#' 
#' 'status_pm' is the BCG Level with +/- descriptors. 
#' 
#' @param ContValue Vector of continuous BCG levels (0 to 6).
#' 
#' @return Returns a dataframe of BCG levels ('status' and 'status_pm') along
#' with input values ('value').
#' 
#' @keywords internal
#' 
#' @examples 
#' # construct a dummy dataset
#' L1 <- c(rep(0, 12))
#' L2 <- c(0.4, 0, 0.4, rep(0,7), 0, 0)
#' L3 <- c(0.6, 0, 0.6, 0, 0.42, 0, 1, 1, 0.22, 0.33, 0.5, 0)
#' L4 <- c(0, 0.9, 0, 0, 0.58, 0.05, 0, 0, 0.78, 0.67, 0.5, 0)
#' L5 <- c(0, 0.1, 0, 1, 0, 0.95, rep(0,4), 0, 1)
#' L6 <- c(rep(0, length(L1)))
#' SAMPLEID <- LETTERS[1:length(L1)]
#' df_lev_memb <- data.frame(SAMPLEID = SAMPLEID
#'                           , L1 = L1
#'                           , L2 = L2
#'                           , L3 = L3
#'                           , L4 = L4
#'                           , L5 = L5
#'                           , L6 = L6)
#' 
#' # Calculate BCG Level Assignments
#' df_Levels <- BCG.Level.Assignment(df_lev_memb)
#' 
#' # Run Function
#' BCG_Status <- BCG.ContLevelText(df_Levels[, "Continuous_BCG_Level"])
#' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.ContLevelText <- function(ContValue) {
  
  # global variable binding
  #df_Lev_Memb <- NULL
  
  # QC
  boo_QC <- FALSE
  if (isTRUE(boo_QC)) {
    # QC dataset
    data_QC <- 3
    if (data_QC == 1) {
      # construct a dummy dataset
      L1 <- c(rep(0, 12))
      L2 <- c(0.4, 0, 0.4, rep(0,7), 0, 0)
      L3 <- c(0.6, 0, 0.6, 0, 0.42, 0, 1, 1, 0.22, 0.33, 0.5, 0)
      L4 <- c(0, 0.9, 0, 0, 0.58, 0.05, 0, 0, 0.78, 0.67, 0.5, 0)
      L5 <- c(0, 0.1, 0, 1, 0, 0.95, rep(0,4), 0, 1)
      L6 <- c(rep(0, length(L1)))
      SAMPLEID <- LETTERS[seq_len(L1)]
      df_lev_memb <- data.frame(SAMPLEID = SAMPLEID
                                , L1 = L1
                                , L2 = L2
                                , L3 = L3
                                , L4 = L4
                                , L5 = L5
                                , L6 = L6)
      # Calculate BCG Level Assignments
      df_Levels <- BCG.Level.Assignment(df_lev_memb)
      # function inputs
      ContValue <- df_Levels$Continuous_BCG_Level 
    } else if (data_QC == 2) {
      # Random Values
      ContValue <- sort(round(runif(100, 2, 6), 2))
    } else {
      ContValue <- seq(1.5, 6, by = 0.01) # n = 401
    }## IF ~ data_QC
  }## IF ~ boo_QC ~ END
  
  # to numeric
  ContValue <- round(as.numeric(ContValue), 2)
  
  # values to text
  df_data <- data.frame(Value = ContValue)
  
  df_data[, "Round"] <- round(df_data[, "Value"], 0)
  
  df_data[, "Round_Remainder"] <- df_data["Round"] - df_data[, "Value"]
  
  df_data[, "Sign"] <- sign(df_data[, "Round_Remainder"])
  
  df_data[, "Sign_Nar"] <- ifelse(df_data[, "Sign"] == -1
                                  , "-"
                                  , ifelse(df_data[, "Sign"] == 1
                                           , "+"
                                           , ""))
  
  df_data[, "Floor"] <- floor(df_data[, "Value"])
  
  # |lo  |hi  | Level integer (int) | Level plus minus (pm) | 
  # |:--:|:--:|:-------------------:|:---------------------:|
  # |x.00|x.10| x                   | x                     | 
  # |x.11|x.45| x                   | x-                    | 
  # |x.46|x.55| x/(x+1) tie         | x/(x+1) tie           |
  # |x.56|x.89| (x+1)               | (x+1)+                | 
  # |x.90|x.99| (x+1)               | (x+1)                 |    

  df_data[, "Floor_Remainder"] <- df_data["Value"] - df_data[, "Floor"]
  
  df_data[, "Level_pm_v1"] <- paste0(df_data[, "Round"], df_data[, "Sign_Nar"])
  
  df_data$cut_int <- cut(df_data$Floor_Remainder
                     , c(0, 0.45, 0.55, 0.999)
                     , c("x", "tie", "x+1")
                     , include.lowest = TRUE)
   
  df_data$cut_pm_v2 <- cut(df_data$Floor_Remainder
                           , c(0, 0.101, 0.45, 0.55, 0.891, 0.999)
                           , c("x", "x-", "tie", "x+1+", "x+1")
                           , include.lowest = TRUE)
  

  # put tie last since should happen the least
  df_data[, "Level_int"] <- ifelse(df_data[, "cut_int"] == "x"
                               , df_data[, "Floor"]
                            , ifelse(df_data[, "cut_int"] == "x+1"
                                     , as.numeric(df_data[, "Floor"]) + 1
                            , ifelse(df_data[, "cut_int"] == "tie"
                                     , as.numeric(df_data[, "Floor"]) + 0.5
                                     , "ERROR"))) 
   
  df_data[, "Level_pm_v2"] <- ifelse(df_data[, "cut_pm_v2"] == "x"
                                   , df_data[, "Floor"]
                              , ifelse(df_data[, "cut_pm_v2"] == "x-"
                                   , paste0(df_data[, "Floor"], "-")
                              , ifelse(df_data[, "cut_pm_v2"] == "x+1+"
                                   , paste0(as.numeric(df_data[, "Floor"]) + 1
                                            , "+")
                              , ifelse(df_data[, "cut_pm_v2"] == "x+1"
                                   , as.numeric(df_data[, "Floor"]) + 1
                              , ifelse(df_data[, "cut_pm_v2"] == "tie" 
                                   , paste0(df_data[, "Floor"]
                                            , "/"
                                            , as.numeric(df_data[, "Floor"]) + 1
                                            , " tie")
                                   , "ERROR")))))
  
  
  # QC, check output
  if (isTRUE(boo_QC)) {
    # QC vs. Jen's file
    write.table(df_data, "clipboard", sep = "\t", row.names = FALSE)
    write.csv(df_data, file.path(tempdir(), "calc_lev.csv"), row.names = FALSE)
    shell.exec(tempdir())
  }## IF ~ boo_QC, output
  
  # create output
  col_return <- c("Value", "Level_int", "Level_pm_v2")
  df_results <- df_data[, col_return]
  names(df_results) <- c("value", "status", "status_pm")
  return(df_results)
  #
}##FUNCTION.END
