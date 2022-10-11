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
    
  })## fn_input_display
  
  # IMPORT ----
  file_watch <- reactive({
    # trigger for df_import()
    input$fn_input
  })## file_watch
  
  ## IMPORT, df_import ####
  df_import <- eventReactive(file_watch(), {
    # use a multi-item reactive so keep on a single line (if needed later)
    
    # input$df_import will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
 
    inFile <- input$fn_input
    
    if (is.null(inFile)){
      return(NULL)
    }##IF~is.null~END
    
    # Define file
    fn_inFile <- inFile$datapath
    
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
                             , full.names = TRUE
                             , include.dirs = FALSE
                             , recursive = TRUE)
    message(paste0("Files in 'results' folder (before removal) = "
                   , length(fn_results)))
    file.remove(fn_results) # ok if no files
    # QC, repeat 
    fn_results2 <- list.files(path_results
                             , full.names = TRUE
                             , include.dirs = FALSE
                             , recursive = TRUE)
    message(paste0("Files in 'results' folder (after removal [should be 0]) = "
                   , length(fn_results2)))
    
    # Read user imported file
    # Add extra colClasses parameter for BCG_Attr
    # the "i" values default to complex numbers
    # Will get a 'warning'
    # coded into BioMonTools::metric.values() but being extra careful
    df_input <- read.delim(fn_inFile
                         , header = TRUE
                         , sep = input$sep
                         , stringsAsFactors = FALSE
                         , colClasses = c("BCG_Attr" = "character"
                                          , "BCG_ATTR" = "character"
                                          , "bcg_attr" = "character"))
    
    # Copy to "Results" folder - Import "as is"
    file.copy(input$fn_input$datapath, file.path(path_results
                                                 , input$fn_input$name))
    
    # button, enable, calc
    shinyjs::enable("b_bcg_calc")
    
    return(df_input)
    
  })##output$df_import ~ END
  
  ## IMPORT, df_import_DT ----
  output$df_import_DT <- DT::renderDT({
    df_data <- df_import()
  }##expression~END
  , filter="top"
  , caption = "Table. Imported data."
  , options = list(scrollX = TRUE
                   , pageLength = 10
                   , lengthMenu = c(5, 10, 25, 50, 100, 1000)
                   , autoWidth = TRUE)
  )##df_import_DT~END
  
  ## IMPORT, col names ----
  col_import <- eventReactive(file_watch(), {
    
    inFile <- input$fn_input
    
    if (is.null(inFile)){
      return(NULL)
    }##IF~is.null~END
    
    # temp df
    df_temp <- df_import()
    # Column Names
    input_colnames <- names(df_temp)
    #
    return(input_colnames)
    
  })## col_import
  
  # b_Calc ----
  observeEvent(input$b_bcg_calc, {
    shiny::withProgress({
      
      ## Calc, 0, Set Up Shiny Code ----
      
      prog_detail <- "Calculation..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 10
      prog_sleep <- 0.25
      
      # Calc, 1, Initialize ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_bcg_download")
    
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
      
      
      # Calc, 2, Excluded Taxa ----
      prog_detail <- "Calculate, Excluded Taxa"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      
      message(paste0("User response to generate ExclTaxa = ", input$ExclTaxa))

      if(input$ExclTaxa) {
        ## Get TaxaLevel names present in user file
        names_df <- names(df_input)
        phylo_all <- c("Kingdom"
                       , "Phylum"
                       , "SubPhylum"
                       , "Class"
                       , "SubClass"
                       , "Order"
                       , "SubOrder"
                       , "InfraOrder"
                       , "SuperFamily"
                       , "Family"
                       , "SubFamily"
                       , "Tribe"
                       , "Genus"
                       , "SubGenus"
                       , "Species"
                       , "Variety")
        fun_TaxaLevels <- phylo_all[toupper(phylo_all) %in% toupper(names_df)]
        
        # overwrite current data frame
        df_input <- BioMonTools::markExcluded(df_samptax = df_input
                                              , SampID = "SAMPLEID"
                                              , TaxaID = "TAXAID"
                                              , TaxaCount = "N_TAXA"
                                              , Exclude = "EXCLUDED"
                                              , TaxaLevels = fun_TaxaLevels
                                              , Exceptions = NA)
        
        # Save Results
        fn_excl <- paste0(fn_input_base, "_bcgcalc_1markexcl.csv")
        dn_excl <- path_results
        pn_excl <- file.path(dn_excl, fn_excl)
        write.csv(df_input, pn_excl, row.names = FALSE)
        
      }## IF ~ input$ExclTaxa
      
      
      # Calc, 3, BCG Model Cols ----
      # get columns from Flags to carry through
      prog_detail <- "Calculate, Keep BCG Model Columns"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Rules - should all be metrics but leaving here just in case
      # Flags - not always metrics,
      # Index Name for import data
      import_IndexName <- unique(df_input$Index_Name)
      # QC Flags for chosen BCG model
      cols_flags <- unique(df_checks[df_checks$Index_Name == import_IndexName
                                 , "Metric_Name"])
      # can also add other columns to keep if feel so inclined
      cols_flags_keep <- cols_flags[cols_flags %in% names(df_input)]
      
      
      # Calc, 4, MetVal----
      prog_detail <- "Calculate, Metric, Values"
      message(paste0("\n", prog_detail))
      message(paste0("Community = ", input$si_community))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      # QC
      # df_input <- read.csv(file.path("inst", "extdata", "Data_BCG_PacNW.csv"))
      # df_metval <- BioMonTools::metric.values(df_input, "bugs", boo.Shiny = TRUE)
     
      if(length(cols_flags_keep) > 0){
        df_metval <- BioMonTools::metric.values(df_input
                                                , input$si_community
                                              , fun.cols2keep = cols_flags_keep
                                                , boo.Shiny = TRUE
                                                , verbose = TRUE)
      } else {
        df_metval <- BioMonTools::metric.values(df_input
                                              , input$si_community
                                              , boo.Shiny = TRUE
                                              , verbose = TRUE)
      }## IF ~ length(col_rules_keep)
      
      df_metval$SITE_TYPE <- df_metval$INDEX_REGION
      # Save Results
      fn_metval <- paste0(fn_input_base, "_bcgcalc_2metval_all.csv")
      dn_metval <- path_results
      pn_metval <- file.path(dn_metval, fn_metval)
      write.csv(df_metval, pn_metval, row.names = FALSE)

          
      # Munge
      ## Model and QC Flag metrics only
      # cols_flags defined above
      cols_model_metrics <- unique(df_bcg_models[
                  df_bcg_models$Index_Name == import_IndexName, "Metric_Name"])
      cols_req <- c("SAMPLEID", "INDEX_NAME", "INDEX_REGION"
                    , "ni_total", "nt_total")
      cols_metrics_flags_keep <- unique(c(cols_req
                                          , cols_flags
                                          , cols_model_metrics))
    df_metval_slim <- df_metval[, names(df_metval) %in% cols_metrics_flags_keep]
      # Save
      fn_metval_slim <- paste0(fn_input_base, "_bcgcalc_2metval_slim.csv")
      dn_metval_slim <- path_results
      pn_metval_slim <- file.path(dn_metval_slim, fn_metval_slim)
      write.csv(df_metval_slim, pn_metval_slim, row.names = FALSE)

      
      # Calc, 5, MetMemb----
      prog_detail <- "Calculate, Metric, Membership"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      df_metmemb <- BCGcalc::BCG.Metric.Membership(df_metval, df_bcg_models)
      # Save Results
      fn_metmemb <- paste0(fn_input_base, "_bcgcalc_3metmemb.csv")
      dn_metmemb <- path_results
      pn_metmemb <- file.path(dn_metmemb, fn_metmemb)
      write.csv(df_metmemb, pn_metmemb, row.names = FALSE)

      
      # Calc, 6, LevMemb----
      prog_detail <- "Calculate, Level, Membership"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      df_levmemb <- BCGcalc::BCG.Level.Membership(df_metmemb, df_bcg_models)
      # Save Results
      fn_levmemb <- paste0(fn_input_base, "_bcgcalc_4levmemb.csv")
      dn_levmemb <- path_results
      pn_levmemb <- file.path(dn_levmemb, fn_levmemb)
      write.csv(df_levmemb, pn_levmemb, row.names = FALSE)

      
      # Calc, 7, LevAssign----
      prog_detail <- "Calculate, Level, Assignment"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      df_levassign <- BCGcalc::BCG.Level.Assignment(df_levmemb)
      # Save Results
      fn_levassign <- paste0(fn_input_base, "_bcgcalc_5levassign.csv")
      dn_levassign <- path_results
      pn_levassign <- file.path(dn_levassign, fn_levassign)
      write.csv(df_levassign, pn_levassign, row.names = FALSE)
  
      
      # Calc, 8, QC Flags----
      prog_detail <- "Calculate, QC Flags"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
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
      fn_levflags <- paste0(fn_input_base, "_bcgcalc_6levflags.csv")
      dn_levflags <- path_results
      pn_levflags <- file.path(dn_levflags, fn_levflags)
      write.csv(df_lev_flags_summ, pn_levflags, row.names = TRUE)
      
      # Save Results
      fn_results <- paste0(fn_input_base, "_bcgcalc_RESULTS.csv")
      dn_results <- path_results
      pn_results <- file.path(dn_results, fn_results)
      write.csv(df_lev_flags, pn_results, row.names = FALSE)
   
      # Calc, 9, RMD----
      prog_detail <- "Calculate, Create Report"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      strFile.RMD <- file.path("external", "Results_Summary.Rmd")
      strFile.RMD.format <- "html_document"
      strFile.out <- paste0(fn_input_base, "_bcgcalc_RESULTS.html")
      dir.export <- path_results
      rmarkdown::render(strFile.RMD
                        , output_format = strFile.RMD.format
                        , output_file = strFile.out
                        , output_dir = dir.export
                        , quiet = TRUE)
      
      # Calc, 9, Clean Up----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
   
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
