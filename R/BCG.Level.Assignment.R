#' @title BCG Level Assignment
#' 
#' @description Biological Condition Gradient level assignment (1st and 2nd) given Level memberships.
#' 
#' @details Input is L1 to L6 with membership values of 0 to 1.  
#' Result is 1st (primary) and 2nd (secondary) Level.  
#' Also give close.
#' 
#' Add QC Checks.
#' 
#' @param df.level.membership Wide data frame with level memberships (0-1).  L1 to L6.
#' 
#' @return Returns a data frame of results in the wide format.
#' 
#' @examples
#' 
#' # construct a dummy dataset
#' L1 <- rep(0, 10)
#' L2 <- c(0.4, 0, 0.4, rep(0,7))
#' L3 <- c(0.6, 0, 0.6, 0, 0.42, 0, 1, 1, 0.22, 0.33)
#' L4 <- c(0, 0.9, 0, 0, 0.58, 0.05, 0, 0, 0.78, 0.67)
#' L5 <- c(0, 0.1, 0, 1, 0, 0.95, rep(0,4))
#' L6 <- rep(0, 10)
#' SampleID <- LETTERS[1:10]
#' df.Level.Membership <- as.data.frame(SampleID, stringsAsFactors=FALSE)
#' df.Level.Membership[,"L1"] <- L1
#' df.Level.Membership[,"L2"] <- L2
#' df.Level.Membership[,"L3"] <- L3
#' df.Level.Membership[,"L4"] <- L4
#' df.Level.Membership[,"L5"] <- L5
#' df.Level.Membership[,"L6"] <- L6
#' 
#' # Run Function
#' df.Levels <- BCG.Level.Assignment(df.Level.Membership)
#' 
#' # Show Results
#' View(df.Levels)
#' 
#' # Save Results
#' write.table(df.Levels, "Levels.tsv"
#'             , row.names=FALSE, col.names=TRUE, sep="\t")
#' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# SampleID <- LETTERS[1:10]
# df.Level.Membership <- as.data.frame(SampleID, stringsAsFactors=FALSE)
# df.Level.Membership[,"L1"] <- L1
# df.Level.Membership[,"L2"] <- L2
# df.Level.Membership[,"L3"] <- L3
# df.Level.Membership[,"L4"] <- L4
# df.Level.Membership[,"L5"] <- L5
# df.Level.Membership[,"L6"] <- L6
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Level.Assignment <- function(df.level.membership){##FUNCTION.START
  #
  # QC check membership (should be 1)
  df.level.membership[,"Memb.Total"] <- rowSums(df.level.membership[,paste0("L",1:6)], na.rm=TRUE)
  df.level.membership[,"Memb.QC"] <- "FAIL"
  df.level.membership[df.level.membership[,"Memb.Total"]==1, "Memb.QC"] <- "PASS"
  #
  # Max
  df.level.membership[, "Lev.1.Memb"] <- apply(df.level.membership[, c(paste0("L",1:6))], 1, max, na.rm=TRUE)
  # df.level.membership[, "Lev.1.Name"] <- apply(df.level.membership, 1, function(x) match(df.level.membership[,"Lev.1.Memb"]
  #                                                                    , df.level.membership[,paste0("L",1:6)]))
  # quick and dirty
  for (i in 1:nrow(df.level.membership)){##FOR.i.START
    # Max Value Lev
    df.level.membership[i, "Lev.1.Name"] <- match(df.level.membership[i, "Lev.1.Memb"], df.level.membership[i, paste0("L",1:6)])
    # Remove max and get max of remainder
    df.level.membership[i, "Lev.2.Memb"]  <- max(df.level.membership[i, paste0("L",1:6)][-df.level.membership[i, "Lev.1.Name"]], na.rm=TRUE)
    # match 2nd
    if(df.level.membership[i, "Lev.1.Memb"]==1){##IF.START
      df.level.membership[i, "Lev.2.Name"] <- NA
    } else {
      df.level.membership[i, "Lev.2.Name"] <- match(df.level.membership[i, "Lev.2.Memb"], df.level.membership[i, paste0("L",1:6)]) 
    }##IF.END
    #
    df.level.membership[i, "Lev.Memb.Diff"] <- df.level.membership[i, "Lev.1.Memb"] - df.level.membership[i, "Lev.2.Memb"]
    #df.levels[i, "Lev.Memb.close"] <- NA
    
    if(df.level.membership[i,"Lev.Memb.Diff"]<0.2){
      df.level.membership[i, "Lev.Memb.close"] <- "yes"
    }
    if(df.level.membership[i,"Lev.Memb.Diff"]<0.1){
      df.level.membership[i, "Lev.Memb.close"] <- "tie"
    }
  }##FOR.i.END
  
  # Close
  # df.level.membership[, "Lev.Memb.Diff"] <- df.level.membership[, "Lev.1.Memb"] - df.level.membership[, "Lev.2.Memb"]
  # df.level.membership[,"Lev.Memb.close"] <- NA
  # df.level.membership[df.level.membership[,"Lev.Memb.Diff"]<0.2, "Lev.Memb.close"] <- "yes"
  # df.level.membership[df.level.membership[,"Lev.Memb.Diff"]<0.1, "Lev.Memb.close"] <- "tie"

  # create output
  return(df.level.membership)
  #
}##FUNCTION.END
