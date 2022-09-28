#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Misc Names ####
  output$fn_input_display <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)){
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'",inFile$name,"'"))
    
    })
  
  # df_import ####
  output$df_import_DT <- renderDT({
    # input$df_import will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
 
    inFile <- input$fn_input
    
    if (is.null(inFile)){
      return(NULL)
    }##IF~is.null~END
    
    #message(getwd())
    message(paste0("Import, separator: '", input$sep,"'"))
    message(paste0("Import, file name: ", input$fn_input$name))
    
    # # Add "Results" folder if missing
    # boo_Results <- dir.exists(file.path(".", "results"))
    # if(boo_Results==FALSE){
    #   dir.create(file.path(".", "Results"))
    # }
    
    # Remove all files in "Results" folder
    # Triggered here so can run different files
    fn_results <- list.files(path_results
                             , full.names=TRUE
                             , include.dirs = FALSE
                             , recursive = TRUE)
    file.remove(fn_results) # ok if no files
    
    # Read user imported file
    df_input <- read.delim(inFile$datapath
                         , header = TRUE
                         , sep = input$sep
                         , stringsAsFactors = FALSE)
    
    # Copy to "Results" folder - Import "as is"
    file.copy(input$fn_input$datapath, file.path(path_results
                                                 , input$fn_input$name))
    
    # button, enable, calc
    shinyjs::enable("b_bcg_calc")
    
    return(df_input)
    
  }##expression~END
  , filter="top", options=list(scrollX=TRUE)
  )##output$df_import_DT~END
  
  # b_Calc ----
  observeEvent(input$b_bcg_calc, {
    shiny::withProgress({
    
      ## Calc, Initialize ----
      message("\nCalculation...")
      
      # Number of increments
      n_inc <- 7
      
      # Increment the progress bar, and update the detail text.
      incProgress(1/n_inc, detail = "Initialize Data")
      Sys.sleep(0.25)
      
      # button, disable, download
      shinyjs::disable("b_bcg_download")
 browser()     
      # data
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      message(paste0("Import, file name, base: ", fn_input_base))
      df_input <- read.delim(inFile$datapath
                             , header = TRUE
                             , sep = input$sep
                             , stringsAsFactors = FALSE)
      # QC, FAIL if TRUE
      if (is.null(df_input)){
        return(NULL)
      }
      
      # Calc, 1 MetVal----
      message("\nCalc, MetVal")
      message(paste0("Community = ", input$si_community))
      # Increment the progress bar, and update the detail text.
      incProgress(1/n_inc, detail = "Calculate, Metric, Values")
      Sys.sleep(0.25)
      # Calc
      # QC
      # df_input <- read.csv(file.path("inst", "extdata", "Data_BCG_PacNW.csv"))
      # df_metval <- BioMonTools::metric.values(df_input, "bugs", boo.Shiny = TRUE)
      df_metval <- BioMonTools::metric.values(df_input
                                              , input$si_community
                                              , boo.Shiny = TRUE
                                              , verbose = TRUE)
      df_metval$SITE_TYPE <- df_metval$INDEX_REGION
      # Save Results
      fn_metval <- paste0(fn_input_base, "_bcgcalc_1metval.csv")
      dn_metval <- path_results
      pn_metval <- file.path(dn_metval, fn_metval)
      write.csv(df_metval, pn_metval, row.names = FALSE)

      # Calc, 2 MetMemb----
      message("\nCalc, MetMemb")
      # Increment the progress bar, and update the detail text.
      incProgress(1/n_inc, detail = "Calculate, Metric, Membership")
      Sys.sleep(0.25)
      # Calc
      df_metmemb <- BCGcalc::BCG.Metric.Membership(df_metval, df_bcg_models)
      # Save Results
      fn_metmemb <- paste0(fn_input_base, "_bcgcalc_2metmemb.csv")
      dn_metmemb <- path_results
      pn_metmemb <- file.path(dn_metmemb, fn_metmemb)
      write.csv(df_metmemb, pn_metmemb, row.names = FALSE)

      # Calc, 3 LevMemb----
      message("\nCalc, LevMemb")
      # Increment the progress bar, and update the detail text.
      incProgress(1/n_inc, detail = "Calculate, Level, Membership")
      Sys.sleep(0.25)
      # Calc
      df_levmemb <- BCGcalc::BCG.Level.Membership(df_metmemb, df_bcg_models)
      # Save Results
      fn_levmemb <- paste0(fn_input_base, "_bcgcalc_3levmemb.csv")
      dn_levmemb <- path_results
      pn_levmemb <- file.path(dn_levmemb, fn_levmemb)
      write.csv(df_levmemb, pn_levmemb, row.names = FALSE)

      # Calc, 4 LevAssign---- 
      message("\nCalc, LevAssign")
      # Increment the progress bar, and update the detail text.
      incProgress(1/n_inc, detail = "Calculate, Level, Assignment")
      Sys.sleep(0.25)
      # Calc
      df_levassign <- BCGcalc::BCG.Level.Assignment(df_levmemb)
      # Save Results
      fn_levassign <- paste0(fn_input_base, "_bcgcalc_4levassign.csv")
      dn_levassign <- path_results
      pn_levassign <- file.path(dn_levassign, fn_levassign)
      write.csv(df_levassign, pn_levassign, row.names = FALSE)
  
      # Calc, 5 QC Flags----
      message("\nCalc, QC Flags")
      # Increment the progress bar, and update the detail text.
      incProgress(1/n_inc, detail = "Calculate, QC Flags")
      Sys.sleep(0.25)
      # Calc
      # df_checks loaded in global.R
      df_flags <- BioMonTools::qc.checks(df_metval, df_checks)
      # Change terminology; PASS/FAIL to NA/flag
      df_flags[, "FLAG"][df_flags[, "FLAG"] == "FAIL"] <- "flag"
      df_flags[, "FLAG"][df_flags[, "FLAG"] == "PASS"] <- NA
      # long to wide format
      df_flags_wide <- reshape2::dcast(df_flags
                                       , SAMPLEID ~ CHECKNAME
                                       , value.var="FLAG")
      # Calc number of "flag"s by row.
      df_flags_wide$NumFlags <- rowSums(df_flags_wide == "flag", na.rm = TRUE)
      # Rearrange columns
      NumCols <- ncol(df_flags_wide)
      df_flags_wide <- df_flags_wide[, c(1, NumCols, 2:(NumCols - 1))]
      # Merge Levels and Flags
      df_lev_flags <- merge(df_levassign
                            , df_flags_wide
                            , by.x = "SampleID"
                            , by.y = "SAMPLEID"
                            , all.x = TRUE)
      # Summarize Flags
      df_lev_flags_summ <- as.data.frame.matrix(table(df_flags[, "CHECKNAME"]
                                                     , df_flags[, "FLAG"]
                                                     , useNA = "ifany"))
      
      # Save Flags Summary
      fn_levflags <- paste0(fn_input_base, "_bcgcalc_5levflags.csv")
      dn_levflags <- path_results
      pn_levflags <- file.path(dn_levflags, fn_levflags)
      write.csv(df_lev_flags_summ, pn_levflags, row.names = TRUE)
      
      # Save Results
      fn_results <- paste0(fn_input_base, "_bcgcalc_RESULTS.csv")
      dn_results <- path_results
      pn_results <- file.path(dn_results, fn_results)
      write.csv(df_lev_flags, pn_results, row.names = FALSE)
      
      # Calc, Clean Up----
      message("\nCalc, Clean Up")
      # Increment the progress bar, and update the detail text.
      incProgress(1/n_inc, detail = "Calculate, Clean Up")
      Sys.sleep(0.5)
   
      # Create zip file of results
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      utils::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      # button, enable, download
      shinyjs::enable("b_bcg_download")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating BCG"
    )## withProgress ~ END
  }##expr ~ ObserveEvent ~ END
  )##observeEvent ~ b_bcg_calc ~ END
  
  # b_download ----
  output$b_bcg_download <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_BCGcalc_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
     
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##downloadData~END
  

})##shinyServer ~ END
