#' @title BCG Tiers
#' 
#' @description Biological Condition Gradient tier assignment given Level memberships.
#' 
#' @details Input is L1 to L6 with membership values of 0 to 1.  
#' Result is 1st and 2nd Tiers (narrative and membership).  
#' Also give close.
#' 
#' @param df.levels Wide data frame with level memberships (0-1).  L1 to L6.
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
#' SampID <- LETTERS[1:10]
#' df.levels <- as.data.frame(SampID, stringsAsFactors=FALSE)
#' df.levels[,"L1"] <- L1
#' df.levels[,"L2"] <- L2
#' df.levels[,"L3"] <- L3
#' df.levels[,"L4"] <- L4
#' df.levels[,"L5"] <- L5
#' df.levels[,"L6"] <- L6
#' 
#' df.Tiers <- BCG.Tiers(df.levels)
#' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# SampID <- LETTERS[1:10]
# df.levels <- as.data.frame(SampID, stringsAsFactors=FALSE)
# df.levels[,"L1"] <- L1
# df.levels[,"L2"] <- L2
# df.levels[,"L3"] <- L3
# df.levels[,"L4"] <- L4
# df.levels[,"L5"] <- L5
# df.levels[,"L6"] <- L6
#~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
BCG.Tiers <- function(df.levels){##FUNCTION.START
  #
  # QC check membership (should be 1)
  df.levels[,"Memb.Total"] <- rowSums(df.levels[,paste0("L",1:6)], na.rm=TRUE)
  df.levels[,"Memb.QC"] <- "FAIL"
  df.levels[df.levels[,"Memb.Total"]==1, "Memb.QC"] <- "PASS"
  #
  # Max
  df.levels[, "Tier1.Memb"] <- apply(df.levels[, c(paste0("L",1:6))], 1, max, na.rm=TRUE)
  # df.levels[, "Tier1.Name"] <- apply(df.levels, 1, function(x) match(df.levels[,"Tier1.Memb"]
  #                                                                    , df.levels[,paste0("L",1:6)]))
  # quick and dirty
  for (i in 1:nrow(df.levels)){##FOR.i.START
    # Max Value Tier
    df.levels[i, "Tier1.Name"] <- match(df.levels[i, "Tier1.Memb"], df.levels[i, paste0("L",1:6)])
    # Remove max and get max of remainder
    df.levels[i, "Tier2.Memb"]  <- max(df.levels[i, paste0("L",1:6)][-df.levels[i, "Tier1.Name"]], na.rm=TRUE)
    # match 2nd
    if(df.levels[i, "Tier1.Memb"]==1){##IF.START
      df.levels[i, "Tier2.Name"] <- NA
    } else {
      df.levels[i, "Tier2.Name"] <- match(df.levels[i, "Tier2.Memb"], df.levels[i, paste0("L",1:6)]) 
    }##IF.END
    #
    df.levels[i, "Tier.Memb.Diff"] <- df.levels[i, "Tier1.Memb"] - df.levels[i, "Tier2.Memb"]
    #df.levels[i, "Tier.Memb.close"] <- NA
    
    if(df.levels[i,"Tier.Memb.Diff"]<0.2){
      df.levels[i, "Tier.Memb.close"] <- "yes"
    }
    if(df.levels[i,"Tier.Memb.Diff"]<0.1){
      df.levels[i, "Tier.Memb.close"] <- "tie"
    }
  }##FOR.i.END
  
  # Close
  # df.levels[, "Tier.Memb.Diff"] <- df.levels[, "Tier1.Memb"] - df.levels[, "Tier2.Memb"]
  # df.levels[,"Tier.Memb.close"] <- NA
  # df.levels[df.levels[,"Tier.Memb.Diff"]<0.2, "Tier.Memb.close"] <- "yes"
  # df.levels[df.levels[,"Tier.Memb.Diff"]<0.1, "Tier.Memb.close"] <- "tie"

  # create output
  return(df.levels)
  #
}##FUNCTION.END
