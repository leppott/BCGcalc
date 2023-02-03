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
  output$fn_input_display_bcg <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'",inFile$name,"'"))
    
  })## fn_input_display_bcg
  
  output$fn_input_display_taxatrans <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'",inFile$name,"'"))
    
  })## fn_input_display_taxatrans
  
  output$fn_input_display_indexclass <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'",inFile$name,"'"))
    
  })## fn_input_display_indexclass
  
  output$fn_input_display_met_therm <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'",inFile$name,"'"))
    
  })## fn_input_display_indexclass
  
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
    
    if (is.null(inFile)) {
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
    # many permutations of BCG_Attr so check for it first then import
    
    df_header <- read.delim(fn_inFile
                            , header = TRUE
                            , sep = ","
                            , stringsAsFactors = FALSE
                            , na.strings = c("", "NA")
                            , nrows = 0)
    col_num_bcgattr <- grep("BCG_ATTR", toupper(names(df_header)))
    
    if (identical(col_num_bcgattr, integer(0))) {
      # BCG_Attr present = FALSE
      # define classes = FALSE
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = ","
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
    } else {
      # BCG_Attr present = TRUE
      # define classes = TRUE
      classes_df <- sapply(df_header, class)
      classes_df[col_num_bcgattr] <- "character"
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = ","
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA")
                             , colClasses = classes_df)
    }## IF ~ col_num_bcgattr == integer(0)
    
    
    # OLD
    # Will get a 'warning' for unknown columns but harmless
    # df_input <- read.delim(fn_inFile
    #                        , header = TRUE
    #                        , sep = ","
    #                        , stringsAsFactors = FALSE
    #                        , colClasses = c("BCG_Attr" = "character"
    #                                         , "BCG_ATTR" = "character"
    #                                         , "bcg_attr" = "character"
    #                                         , "BCG_attr" = "character"))
    
    # Copy to "Results" folder - Import "as is"
    file.copy(input$fn_input$datapath, file.path(path_results
                                                 , input$fn_input$name))
    
    # button, enable, calc
    shinyjs::enable("b_bcg_calc")
    shinyjs::enable("b_taxatrans_calc")
    shinyjs::enable("b_indexclass_calc")
    shinyjs::enable("b_calc_met_therm")
    
    # update cb_taxatrans_sum 
    # doesn't work here as timing is after the file is created
    
    return(df_input)
    
  })##output$df_import ~ END
  
  ## IMPORT, df_import_DT ----
  output$df_import_DT <- DT::renderDT({
    df_data <- df_import()
  }##expression~END
  , filter = "top"
  , caption = "Table. Imported data."
  , options = list(scrollX = TRUE
                   , pageLength = 5
                   , lengthMenu = c(5, 10, 25, 50, 100, 1000)
                   , autoWidth = TRUE)
  )##df_import_DT~END
  
  ## IMPORT, col names ----
  col_import <- eventReactive(file_watch(), {
    
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return(NULL)
    }##IF~is.null~END
    
    # temp df
    df_temp <- df_import()
    # Column Names
    input_colnames <- names(df_temp)
    #
    return(input_colnames)
    
  })## col_import
  
 
  # b_Calc_BCG ----
  observeEvent(input$b_bcg_calc, {
    shiny::withProgress({
      
      ## Calc, 0, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, BCG..."
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
      if (is.null(df_input)) {
        return(NULL)
      }
    
      # QC, names to upper case
      names(df_input) <- toupper(names(df_input))
      
      # Calc, 2, Exclude Taxa ----
      prog_detail <- "Calculate, Exclude Taxa"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      
      message(paste0("User response to generate ExclTaxa = ", input$ExclTaxa))

      if (input$ExclTaxa) {
        ## Get TaxaLevel names present in user file
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
        phylo_all <- toupper(phylo_all) # so matches rest of file
        
        # case and matching of taxa levels handled inside of markExluded 
        
        # overwrite current data frame
        df_input <- BioMonTools::markExcluded(df_samptax = df_input
                                              , SampID = "SAMPLEID"
                                              , TaxaID = "TAXAID"
                                              , TaxaCount = "N_TAXA"
                                              , Exclude = "EXCLUDE"
                                              , TaxaLevels = phylo_all
                                              , Exceptions = NA)
        
        # Save Results
        fn_excl <- paste0(fn_input_base, "_bcgcalc_1markexcl.csv")
        dn_excl <- path_results
        pn_excl <- file.path(dn_excl, fn_excl)
        write.csv(df_input, pn_excl, row.names = FALSE)
        
      }## IF ~ input$ExclTaxa
      
   
      # Calc, 3, BCG Flag Cols ----
      # get columns from Flags (non-metrics) to carry through
      prog_detail <- "Calculate, Keep BCG Model Columns"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Rules - should all be metrics but leaving here just in case
      # Flags - not always metrics,
      # Index Name for import data
      import_IndexName <- unique(df_input$INDEX_NAME)
      # QC Flags for chosen BCG model (non-metrics)
      cols_flags <- unique(df_checks[df_checks$Index_Name == import_IndexName
                                 , "Metric_Name"])
      # can also add other columns to keep if feel so inclined
      cols_flags_keep <- cols_flags[cols_flags %in% names(df_input)]
      
   
      # Calc, 3b, Rules ----
      prog_detail <- "Calculate, BCG Rules"
      message(paste0("\n", prog_detail))
      message(paste0("Community = ", input$si_community))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # filter for data Index_Name in data (drop 2 extra columns)
      df_rules <- df_bcg_models[df_bcg_models$Index_Name == import_IndexName
                    , !names(df_bcg_models) %in% c("SITE_TYPE", "INDEX_REGION")]
      # Save
      fn_rules <- paste0(fn_input_base, "_bcgcalc_3metrules.csv")
      dn_rules <- path_results
      pn_rules <- file.path(dn_rules, fn_rules)
      write.csv(df_rules, pn_rules, row.names = FALSE)
      
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
     
      if (length(cols_flags_keep) > 0) {
        # keep extra cols from Flags (non-metric)
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
      
      #df_metval$INDEX_CLASS <- df_metval$INDEX_CLASS
      ## Save Results ----
      fn_metval <- paste0(fn_input_base, "_bcgcalc_2metval_all.csv")
      dn_metval <- path_results
      pn_metval <- file.path(dn_metval, fn_metval)
      write.csv(df_metval, pn_metval, row.names = FALSE)

      ## Save Results (BCG) ----
      # Munge
      ## Model and QC Flag metrics only
      # cols_flags defined above
      cols_model_metrics <- unique(df_bcg_models[
                  df_bcg_models$Index_Name == import_IndexName, "Metric_Name"])
      cols_req <- c("SAMPLEID", "INDEX_NAME", "INDEX_CLASS"
                    , "ni_total", "nt_total")
      cols_metrics_flags_keep <- unique(c(cols_req
                                          , cols_flags
                                          , cols_model_metrics))
    df_metval_slim <- df_metval[, names(df_metval) %in% cols_metrics_flags_keep]
      # Save
      fn_metval_slim <- paste0(fn_input_base, "_bcgcalc_2metval_BCG.csv")
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
                                       , value.var = "FLAG")
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
       
      # Create Results
     df_results <- df_lev_flags[, !names(df_lev_flags) %in% c(paste0("L", 1:6))]
      ## remove L1:6
      
      # Save Results
      fn_results <- paste0(fn_input_base, "_bcgcalc_RESULTS.csv")
      dn_results <- path_results
      pn_results <- file.path(dn_results, fn_results)
      write.csv(df_results, pn_results, row.names = FALSE)

            
      # Calc, 8b, QC Flag Metrics ----
      # create
      col2keep <- c("SAMPLEID", "INDEX_NAME", "INDEX_CLASS", "METRIC_NAME"
                    , "CHECKNAME", "METRIC_VALUE", "SYMBOL", "VALUE", "FLAG")
      df_metflags <- df_flags[, col2keep]
      # save
      fn_metflags <- paste0(fn_input_base, "_bcgcalc_6metflags.csv")
      dn_metflags <- path_results
      pn_metflags <- file.path(dn_metflags, fn_metflags)
      write.csv(df_metflags, pn_metflags, row.names = FALSE)
      
   
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
  
  # b_download_BCG ----
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
  )##download ~ BCG
  
  # TAXATRANS ----
  ## TaxaTrans, UI ----
  
  output$UI_taxatrans_pick_official <- renderUI({
    str_col <- "Calculation"
    selectInput("taxatrans_pick_official"
                , label = str_col
                , choices = df_pick_taxoff[, "project"]
                , multiple = FALSE)
  })## UI_colnames
  
  # output$UI_taxatrans_pick_official_project <- renderUI({
  #   browser()
  #   str_col <- "Official Taxa Data, Column Taxa_ID"
  #   selectInput("taxatrans_pick_official_project"
  #               , label = str_col
  #               , choices = names(df_pick_taxoff)
  #               , multiple = FALSE)
  # })## UI_colnames
  
  output$UI_taxatrans_user_col_taxaid <- renderUI({
    str_col <- "Column, TaxaID"
    selectInput("taxatrans_user_col_taxaid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "TaxaID"
                , multiple = FALSE)
  })## UI_colnames
  
  output$UI_taxatrans_user_col_drop <- renderUI({
    str_col <- "Columns to Drop"
    selectInput("taxatrans_user_col_drop"
                , label = str_col
                , choices = c("", names(df_import()))
                , multiple = TRUE)
  })## UI_colnames  
  
  output$UI_taxatrans_user_col_n_taxa <- renderUI({
    str_col <- "Column, Taxa Count (number of individuals or N_Taxa)"
    selectInput("taxatrans_user_col_n_taxa"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "N_Taxa"
                , multiple = FALSE)
  })## UI_colnames  
  
  output$UI_taxatrans_user_col_groupby <- renderUI({
    str_col <- "Columns to Keep in Output"
    selectInput("taxatrans_user_col_groupby"
                , label = str_col
                , choices = c("", names(df_import()))
                , multiple = TRUE)
  })## UI_colnames  
  
  output$UI_taxatrans_user_col_sampid <- renderUI({
    str_col <- "Column, Unique Sample Identifier (e.g., SampleID)"
    selectInput("taxatrans_user_col_sampid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "SampleID"
                , multiple = FALSE)
  })## UI_colnames  
  
  
  # ## TaxaTrans, combine ----
  # observeEvent(input$cb_TaxaTrans_Summ, {
  #   # turn on/off extra selection boxes based on checkbox
  #   if(input$cb_TaxaTrans_Summ == TRUE) {
  #     shinyjs::enable("UI_taxatrans_user_col_n_taxa")
  #     shinyjs::enable("UI_taxatrans_user_col_groupby")
  #   } else {
  #     shinyjs::disable("UI_taxatrans_user_col_n_taxa")
  #     shinyjs::disable("UI_taxatrans_user_col_groupby")
  #   }## IF ~ checkbox
  # 
  # }, ignoreInit = FALSE
  # , ignoreNULL = FALSE)## observerEvent ~ cb_TaxaTrans_Summ
  # #})
  
  
  ## b_Calc_TaxaTrans ----
  observeEvent(input$b_taxatrans_calc, {
    shiny::withProgress({
 
      ### Calc, 00, Initialize ----
      prog_detail <- "Calculation, Taxa Translator..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 6
      prog_sleep <- 0.25
      
      ## Calc, 01, Import User Data ----
      prog_detail <- "Import Data, User"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_taxatrans_download")
      
      # Import data
      # data
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      message(paste0("Import, file name, base: ", fn_input_base))
      df_input <- read.delim(inFile$datapath
                             , header = TRUE
                             , sep = input$sep
                             , stringsAsFactors = FALSE)
      # QC, FAIL if TRUE
      if (is.null(df_input)) {
        return(NULL)
      }
      
      ## Calc, 02, Gather and Test Inputs  ----
      prog_detail <- "QC Inputs"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
       
      # Fun Param, Define
      sel_proj <- input$taxatrans_pick_official
      sel_user_taxaid <- input$taxatrans_user_col_taxaid
      #sel_col_drop <- unlist(input$taxatrans_user_col_drop)
      sel_user_ntaxa <- input$taxatrans_user_col_n_taxa
      sel_user_groupby <- unlist(input$taxatrans_user_col_groupby)
      sel_summ <- input$cb_TaxaTrans_Summ
      
      fn_taxoff <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                  , "filename"]
      fn_taxoff_meta <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                       , "metadata_filename"] 
      col_taxaid_official_match <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                                  , "taxaid"]
      col_taxaid_official_project <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                                    , "calc_taxaid"]
      col_drop_project <- unlist(strsplit(df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                         , "col_drop"], ","))
      fn_taxoff_attr <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                       , "attributes_filename"] 
      col_taxaid_attr <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                        , "attributes_taxaid"] 
      sel_user_sampid <- input$taxatrans_user_col_sampid
  
      sel_taxaid_drop <-  df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                     , "taxaid_drop"] 
      
      # include = yes; unique(sel_user_groupby)
      # include sampid, taxaid, and n_taxa so not dropped
      user_col_keep <- names(df_input)[names(df_input) %in% c(sel_user_groupby
                                                              , sel_user_sampid
                                                              , sel_user_taxaid
                                                              , sel_user_ntaxa)]
      # flip to col_drop
      user_col_drop <- names(df_input)[!names(df_input) %in% user_col_keep]
      
      # Fun Param, Test
    
      if (sel_proj == "") {
        # end process with pop up
      }## IF ~ sel_proj

      if (is.na(fn_taxoff_meta) | fn_taxoff_meta == "") {
        # set value to NULL 
        df_official_metadata <- NULL
      }## IF ~ fn_taxaoff_meta
      
      if (is.na(sel_user_ntaxa) | sel_user_ntaxa == "") {
        sel_user_ntaxa <- NULL
      }## IF ~ fn_taxaoff_meta

      if (is.null(sel_summ)) {
        sel_summ <- FALSE
      }## IF ~ sel_summ
 
      if (sel_taxaid_drop == "NULL") {
        sel_taxaid_drop <- NULL
      }## IF ~ sel_taxaid_drop
      
     
      message(paste0("User response to summarize duplicate sample taxa = "
               , sel_summ)) 
      
      ## Calc, 03, Import Official Data (and Metadata)  ----
      prog_detail <- "Import Data, Official and Metadata"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
 
      ### Data,  Official Taxa----
      url_taxoff <- file.path(url_bmt_base
                              , "taxa_official"
                              , fn_taxoff)
      GET(url_taxoff, write_disk(temp_taxoff <- tempfile(fileext = ".csv")))
      df_taxoff <- read.csv(temp_taxoff)
      
      ### Data, Official Taxa, Meta Data----
      if (!is.null(fn_taxoff_meta)) {
        url_taxoff_meta <- file.path(url_bmt_base
                                     , "taxa_official"
                                     , fn_taxoff_meta)
        GET(url_taxoff_meta
            , write_disk(temp_taxoff_meta <- tempfile(fileext = ".csv")))
        df_taxoff_meta <- read.csv(temp_taxoff_meta)
      }## IF ~ fn_taxaoff_meta

      ### Data, Official Attributes----
      if (!is.null(fn_taxoff_attr)) {
        url_taxoff_attr <- file.path(url_bmt_base
                                     , "taxa_official"
                                     , fn_taxoff_attr)
        GET(url_taxoff_attr
            , write_disk(temp_taxoff_attr <- tempfile(fileext = ".csv")))
        df_taxoff_attr <- read.csv(temp_taxoff_attr)
      }## IF ~ fn_taxoff_attr
      

      ## Calc, 03, Run Function ----
      prog_detail <- "Calculate, Taxa Trans"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)

      # function parameters
      df_user                 <- df_input
      df_official             <- df_taxoff
      df_official_metadata    <- df_taxoff_meta
      taxaid_user             <- sel_user_taxaid
      taxaid_official_match   <- col_taxaid_official_match
      taxaid_official_project <- col_taxaid_official_project
      taxaid_drop             <- sel_taxaid_drop
      col_drop                <- user_col_drop #NULL #sel_col_drop
      sum_n_taxa_boo          <- TRUE
      sum_n_taxa_col          <- sel_user_ntaxa
      sum_n_taxa_group_by     <- c(sel_user_sampid
                                   , sel_user_taxaid
                                   , sel_user_groupby)

      ### run the function ----
      taxatrans_results <- BioMonTools::taxa_translate(df_user
                                                       , df_official
                                                       , df_official_metadata
                                                       , taxaid_user
                                                       , taxaid_official_match
                                                       , taxaid_official_project
                                                       , taxaid_drop
                                                       , col_drop
                                                       , sum_n_taxa_boo
                                                       , sum_n_taxa_col
                                                       , sum_n_taxa_group_by)
     
      ### Munge ----
 
      # Remove non-project taxaID cols
      # Specific to shiny project, not a part of the taxa_translate function
      col_keep <- !names(taxatrans_results$merge) %in% col_drop_project
      taxatrans_results$merge <- taxatrans_results$merge[, col_keep]
   
      # Attributes if have 2nd file
      if (!is.na(fn_taxoff_attr)) {
        df_ttrm <- taxatrans_results$merge
        # drop translation file columns
        col_keep_ttrm <- names(df_ttrm)[names(df_ttrm) %in% c(sel_user_sampid
                                                            , sel_user_taxaid
                                                            , sel_user_ntaxa
                                                            , "Match_Official"
                                                            , sel_user_groupby)]
        df_ttrm <- df_ttrm[, col_keep_ttrm]
        # merge with attributes
        df_merge_attr <- merge(df_ttrm
                               , df_taxoff_attr
                               , by.x = taxaid_user
                               , by.y = col_taxaid_attr
                               , all.x = TRUE
                               , sort = FALSE
                               , suffixes = c("_xDROP", "_yKEEP"))
        # Drop duplicate names from Trans file (x)
        col_keep <- names(df_merge_attr)[!grepl("_xDROP$"
                                                , names(df_merge_attr))]
        df_merge_attr <- df_merge_attr[, col_keep]
        # KEEP and rename duplicate names from Attribute file (y)
        names(df_merge_attr) <- gsub("_yKEEP$", "", names(df_merge_attr))
        # Save back to results list
        taxatrans_results$merge <- df_merge_attr
        
        # QC check
        # testthat::expect_equal(nrow(df_merge_attr), nrow(df_ttrm))
        # testthat::expect_equal(sum(df_merge_attr[, sel_user_ntaxa], na.rm = TRUE)
        #                        , sum(df_ttrm[, sel_user_ntaxa], na.rm = TRUE))
      }## IF ~ !is.na(fn_taxoff_attr)
      
      # Reorder by SampID and TaxaID
      taxatrans_results$merge <- taxatrans_results$merge[
           order(taxatrans_results$merge[, sel_user_sampid]
                   , taxatrans_results$merge[, sel_user_taxaid]), ]
    
      # Add input filenames
      taxatrans_results$merge[, "file_taxatrans"] <- fn_taxoff
      taxatrans_results$merge[, "file_attributes"] <- fn_taxoff_attr
      
      
      # Resort columns
      col_start <- c(sel_user_sampid
                     , sel_user_taxaid
                     , sel_user_ntaxa
                     , "file_taxatrans"
                     , "file_attributes")
      col_other <- names(taxatrans_results$merge)[!names(taxatrans_results$merge) 
                                                  %in% col_start]
      taxatrans_results$merge <- taxatrans_results$merge[, c(col_start
                                                             , col_other)]
      
      # Convert required file names to standard
      ## do at end so don't have to modify any other variables
      boo_req_names <- TRUE
      if (boo_req_names == TRUE) {
        names(taxatrans_results$merge)[names(taxatrans_results$merge) 
                                       %in% sel_user_sampid] <- "SampleID"
        names(taxatrans_results$merge)[names(taxatrans_results$merge) 
                                       %in% sel_user_taxaid] <- "TaxaID"
        names(taxatrans_results$merge)[names(taxatrans_results$merge) 
                                       %in% sel_user_ntaxa] <- "N_Taxa"
      }## IF ~ boo_req_names
      
      
      ## Calc, 04, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Save files
 
      ## File version names
      df_save <- data.frame(project = sel_proj
                            , file_translations = fn_taxoff
                            , taxaid_translations = col_taxaid_official_project
                            , file_metadata = fn_taxoff_attr
                            , file_attributes = fn_taxoff_attr
                            , taxaid_attributes = col_taxaid_attr)
      fn_part <- paste0("_taxatrans_", "0fileversions", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## Taxa User 
      # saved when imported
      
      ## Taxa Official
      df_save <- df_official
      fn_part <- paste0("_taxatrans_", "1official", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## Taxa Official, Attributes
      df_save <- df_taxoff_attr
      fn_part <- paste0("_taxatrans_", "1attributes", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
     
      ## meta data
      df_save <- taxatrans_results$official_metadata # df_taxoff_meta
      fn_part <- paste0("_taxatrans_", "1metadata", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
     
      ## translate - crosswalk
      df_save <- taxatrans_results$taxatrans_unique # df_taxoff_meta
      fn_part <- paste0("_taxatrans_", "2taxamatch", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## Non Match
      df_save <- data.frame(taxatrans_results$nonmatch)
      fn_part <- paste0("_taxatrans_", "3nonmatch", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## Taxa Trans
      df_save <- taxatrans_results$merge
      fn_part <- paste0("_taxatrans_", "MERGED", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## Calc, 05, Create Zip ----
      prog_detail <- "Create Zip File For Download"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Create zip file for download
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      utils::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      
      ## Calc, 06, Clean Up ----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, enable, download
      shinyjs::enable("b_taxatrans_download")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating BCG"
    )## withProgress
    
  }##expr ~ ObserveEvent
  
  )##observeEvent ~ b_taxatrans_calc
  
  ## b_download_TaxaTrans ----
  output$b_taxatrans_download <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_TaxaTrans_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ TaxaTrans
  
  # INDEX_CLASS ----
  
  ## IndexClass, UI ----
  
  # output$UI_indexclass_user_col_indexclass <- renderUI({
  #   str_col <- "Column, Index_Class (can be blank if not in data)"
  #   selectInput("indexclass_user_col_indexclass"
  #               , label = str_col
  #               , choices = c("", names(df_import()))
  #               , selected = "Index_Class"
  #               , multiple = FALSE)
  # })## UI_colnames  
  # 
  # output$UI_indexclass_user_col_indexname <- renderUI({
  #   str_col <- "Column, Index_Name"
  #   selectInput("indexclass_user_col_indexname"
  #               , label = str_col
  #               , choices = c("", names(df_import()))
  #               , selected = "Index_Name"
  #               , multiple = FALSE)
  # })## UI_colnames  
  
  output$UI_indexclass_user_col_sampid <- renderUI({
    str_col <- "Column, SampleID"
    selectInput("indexclass_user_col_sampid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "SampleID"
                , multiple = FALSE)
  })## UI_colnames  
  
  output$UI_indexclass_indexname <- renderUI({
    str_col <- "Index Name"
    selectInput("indexclass_indexname"
                , label = str_col
                , choices = c("", sel_indexclass_indexnames)
                , selected = "BCG_MariNW_Bugs500ct"
                , multiple = FALSE)
  })## UI_colnames  
  
  # hard code for expediency for PacNW
  # later change to variable
  output$UI_indexclass_user_col_elev <- renderUI({
    str_col <- "Column, Elevation (meters) [StreamCat]"
    selectInput("indexclass_user_col_elev"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "elev_m"
                , multiple = FALSE)
  })## UI_colnames  
  
  output$UI_indexclass_user_col_slope <- renderUI({
    str_col <- "Column, Slope (percent) [NHDplus]"
    selectInput("indexclass_user_col_slope"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "pslope_nhd"
                , multiple = FALSE)
  })## UI_colnames  
  
  
  ## b_Calc_IndexClass ----
  observeEvent(input$b_indexclass_calc, {
    shiny::withProgress({
  
      ### Calc, 00, Initialize ----
      prog_detail <- "Calculation, Assign Index Class..."
      message(paste0("\n", prog_detail))
    
      # Number of increments
      prog_n <- 6
      prog_sleep <- 0.25
   
      ## Calc, 01, Import User Data ----
      prog_detail <- "Import Data, User"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_indexclass_download")
      
      # Import data
      # data
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      message(paste0("Import, file name, base: ", fn_input_base))
      df_input <- read.delim(inFile$datapath
                             , header = TRUE
                             , sep = input$sep
                             , stringsAsFactors = FALSE)
      # QC, FAIL if TRUE
      if (is.null(df_input)) {
        return(NULL)
      }
      
     
      ## Calc, 02, Gather and Test Inputs  ----
      prog_detail <- "QC Inputs"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
     
      # Fun Param, Define
      sel_col_indexname  <- "INDEX_NAME" #input$indexclass_user_col_indexname
      sel_col_indexclass <- "INDEX_CLASS" #input$indexclass_user_col_indexclass
      sel_col_sampid     <- input$indexclass_user_col_sampid
      
      sel_indexname <- input$indexclass_indexname
      sel_col_elev <- input$indexclass_user_col_elev
      sel_col_slope <- input$indexclass_user_col_slope
       
      # if(sel_col_indexclass == "") {
      #   sel_col_indexclass <- "INDEX_CLASS"
      # }## IF ~ sel_col_indexclass
      
      # if(sel_col_indexname == "") {
      #   # end process with pop up
      # }## IF ~ sel_col_indexname
      
      if (sel_col_sampid == "") {
        # end process with pop up
        msg <- "'SampleID' column name is missing!"
        shinyalert::shinyalert(title = "Assign Index Class"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ sel_col_sampid
      
      # # Check if required fields present in input
      # boo_col_indexclass <- sel_col_indexclass %in% names(df_input)
      # if(boo_col_indexclass == FALSE) {
      #  # df_input[, sel_col_indexclass] <- NA_character_
      #   # if add it as blank it messes up the main function
      # }
      
      # boo_col_indexname <- sel_col_indexname %in% names(df_input)
      # if(boo_col_indexname == FALSE) {
      #   df_input[, sel_col_indexname] <- NA_character_
      # }
    
      boo_col_sampid <- sel_col_sampid %in% names(df_input)
      if (boo_col_sampid == FALSE) {
        df_input[, sel_col_sampid] <- NA_character_
      }
   
      # Check if required fields for criteria
      #user_indexname <- sort(unique(df_input[, sel_col_indexname]))
      #message(paste0("User Index_Name = ", user_indexname))
      message(paste0("User Index_Name = ", sel_indexname))

      indexclass_fields <- sort(
                            unique(
                              df_indexclass_crit[df_indexclass_crit[
                                               , "INDEX_NAME"] == sel_indexname
                                             , "FIELD", TRUE]))
      # change from user_indexname to sel_indexname
      indexclass_fields_user <- c(sel_col_elev, sel_col_slope)
       
      # # add fields if not present so can continue without errors
      # indexclass_fields_missing <- indexclass_fields[!indexclass_fields %in% 
      #                                                  names(df_input)]
      # if(length(indexclass_fields_missing) > 0) {
      #   df_input[, indexclass_fields_missing] <- NA_character_
      # }## length
      
      # to upper
      # names(df_input) <- toupper(names(df_input))
      # names(df_indexclass_crit) <- toupper(names(df_indexclass_crit))
      # sel_col_indexclass <- toupper(sel_col_indexclass)
      # sel_col_indexname <- toupper(sel_col_indexname)
      # sel_col_sampid <- toupper(sel_col_sampid)
      ## handled in the function
      
      # Update official index classification file with user fields
      df_indexclass_crit[df_indexclass_crit[, "FIELD"] == "elev_m"
                         , "FIELD"] <- sel_col_elev
      df_indexclass_crit[df_indexclass_crit[, "FIELD"] == "pslope_nhd"
                         , "FIELD"] <- sel_col_slope
    
      # Add Index_Name
      df_input[, sel_col_indexname] <- sel_indexname
      # Add Index_Class
      ## can crash if case is different
      ### Rename to standard
      position_IC <- grep(sel_col_indexclass
                          , names(df_input)
                          , ignore.case = TRUE)
      if (!identical(position_IC, integer(0))) {
        names(df_input)[position_IC] <- sel_col_indexclass
      }## IF ~ position_IC
      ### Add (if not present) or Change to NA
      df_input[, sel_col_indexclass] <- NA_character_ 
      ### Remove
      df_input[, sel_col_indexclass] <- NULL 

      ## Calc, 03, Run Function ----
      prog_detail <- "Calculate, Index Class"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
   
      ### run the function ----
      df_indexclass_results <- BioMonTools::assign_IndexClass(data = df_input
                                          , criteria = df_indexclass_crit
                                          , name_indexclass = sel_col_indexclass
                                          , name_indexname = sel_col_indexname
                                          , name_siteid = sel_col_sampid
                                          , data_shape = "WIDE")
      
      ## Calc, 04, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Save files 
      
      ## save, criteria
      df_save <- df_indexclass_crit
      fn_part <- paste0("_indexclass_", "0criteria", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## save, results
      df_save <- df_indexclass_results
      fn_part <- paste0("_indexclass_", "1results", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      
      ## Calc, 05, Create Zip ----
      prog_detail <- "Create Zip File For Download"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Create zip file for download
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      utils::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      
      ## Calc, 06, Clean Up ----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, enable, download
      shinyjs::enable("b_indexclass_download")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating Index Class"
    )## withProgress
    
  }##expr ~ ObserveEvent
  
  )##observeEvent ~ b_indexclass_calc
  
  ## b_download_IndexClass ----
  output$b_indexclass_download <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_IndexClass_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ TaxaTrans
  
  # THERMAL METRICS ----
  
  # b_Calc_Met_Therm ----
  observeEvent(input$b_calc_met_therm, {
    shiny::withProgress({

      ## Calc, 00, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, Thermal Metrics..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 5
      prog_sleep <- 0.25
      
      # Calc, 01, Initialize ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_download_met_therm")
      
      # data
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      message(paste0("Import, file name, base: ", fn_input_base))
      df_input <- read.delim(inFile$datapath
                             , header = TRUE
                             , sep = input$sep
                             , stringsAsFactors = FALSE)
      # QC, FAIL if TRUE
      if (is.null(df_input)) {
        return(NULL)
      }
      
      # QC, names to upper case
      names(df_input) <- toupper(names(df_input))
      
     
      # Calc, 02, Exclude Taxa ----
      prog_detail <- "Calculate, Exclude Taxa"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      
      message(paste0("User response to generate ExclTaxa = ", input$ExclTaxa))
      
      if (input$ExclTaxa_thermal) {
        ## Get TaxaLevel names present in user file
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
        phylo_all <- toupper(phylo_all) # so matches rest of file
        
        # case and matching of taxa levels handled inside of markExluded 
        
        # overwrite current data frame
        df_input <- BioMonTools::markExcluded(df_samptax = df_input
                                              , SampID = "SAMPLEID"
                                              , TaxaID = "TAXAID"
                                              , TaxaCount = "N_TAXA"
                                              , Exclude = "EXCLUDE"
                                              , TaxaLevels = phylo_all
                                              , Exceptions = NA)
        
        # Save Results
        fn_excl <- paste0(fn_input_base, "_met_therm_1markexcl.csv")
        dn_excl <- path_results
        pn_excl <- file.path(dn_excl, fn_excl)
        write.csv(df_input, pn_excl, row.names = FALSE)
        
      }## IF ~ input$ExclTaxa
      
      # Calc, 03, MetVal----
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
      
    
      # filter for thermal metrics
      ## Metric Names (from global from BioMonTools pkg)
      ## Filter on community
      df_metname_thermhydr <- dplyr::filter(df_metricnames
                                    , Sort_Group == "ThermalHydro"
                                    , Community == input$si_community_met_therm)
      
      
      ## final set of metrics
      names_met_therm_calc <- c("ni_total"
                                 , "pi_dom01"
                                 , "pi_dom02"
                                 , "x_Shan_2"
                                 , "nt_total"
                                 , df_metname_thermhydr[, "METRIC_NAME", TRUE])
      
      
      #if(length(cols_flags_keep) > 0){
      #  # keep extra cols from Flags (non-metric)
        df_metval <- BioMonTools::metric.values(df_input
                                  , fun.Community = input$si_community_met_therm
                                  , fun.MetricNames = names_met_therm_calc
                                  #, fun.cols2keep = cols_flags_keep
                                  , boo.Shiny = TRUE
                                  , verbose = TRUE)
     # } else {
      #   df_metval <- BioMonTools::metric.values(df_input
      #                             , fun.Community = input$si_community_met_therm
      #                             , fun.MetricNames = names_met_therm_calc
      #                             , boo.Shiny = TRUE
      #                             , verbose = TRUE)
      # }## IF ~ length(col_rules_keep)
      
      #df_metval$INDEX_CLASS <- df_metval$INDEX_CLASS
  
      # Calc, 04, Save Results ----
      fn_metval <- paste0(fn_input_base, "_met_therm_RESULTS.csv")
      dn_metval <- path_results
      pn_metval <- file.path(dn_metval, fn_metval)
      write.csv(df_metval, pn_metval, row.names = FALSE)
      
      
      # Calc, 05, Clean Up----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      # Calc, 5, Create zip file of results
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      utils::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      # button, enable, download
      shinyjs::enable("b_download_met_therm")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating Metrics Thermal"
    )## withProgress ~ END
  }##expr ~ ObserveEvent ~ END
  )##observeEvent ~ b_calc_met_therm ~ END
  
  # b_download_Met_Therm ----
  output$b_download_met_therm <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_Metrics_Thermal_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ Met Therm
  
  # MERGE FILES ----
  
  ## Merge, Import ----
  ### Merge, Import, FileWatch ----
  file_watch_mf1 <- reactive({
    # trigger for df_import()
    input$fn_input_mf1
  })## file_watch
  
  file_watch_mf2 <- reactive({
    # trigger for df_import()
    input$fn_input_mf2
  })## file_watch
  
  ### Merge, Import, df_import_mf1 ----
  df_import_mf1 <- eventReactive(file_watch_mf1(), {
    # use a multi-item reactive so keep on a single line (if needed later)
    
    # input$df_import_mf1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
   
    inFile <- input$fn_input_mf1
    
    if (is.null(inFile)) {
      return(NULL)
    }##IF~is.null~END
    
    # Define file
    fn_inFile <- inFile$datapath
    
    #message(getwd())
   # message(paste0("Import, separator: '", input$sep,"'"))
    message(paste0("Import, file name: ", inFile$name))
    
    # Move Results folder clean up to calc button

    # Read user imported file
    # Add extra colClasses parameter for BCG_Attr
    # the "i" values default to complex numbers
    # many permutations of BCG_Attr so check for it first then import
    df_header <- read.delim(fn_inFile
                          , header = TRUE
                          , sep = ","
                          , stringsAsFactors = FALSE
                          , na.strings = c("", "NA")
                          , nrows = 0)
    col_num_bcgattr <- grep("BCG_ATTR", toupper(names(df_header)))
    
    if (identical(col_num_bcgattr, integer(0))) {
      # BCG_Attr present = FALSE
      # define classes = FALSE
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = ","
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
    } else {
      # BCG_Attr present = TRUE
      # define classes = TRUE
      classes_df <- sapply(df_header, class)
      classes_df[col_num_bcgattr] <- "character"
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = ","
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA")
                             , colClasses = classes_df)
                             
    }## IF ~ col_num_bcgattr == integer(0)
    

    # OLD
    # Will get a 'warning' for unknown columns but harmless
    # df_input <- read.delim(fn_inFile
    #                        , header = TRUE
    #                        , sep = ","
    #                        , stringsAsFactors = FALSE
    #                        , colClasses = c("BCG_Attr" = "character"
    #                                         , "BCG_ATTR" = "character"
    #                                         , "bcg_attr" = "character"
    #                                         , "BCG_attr" = "character"))
    
    # Copy to "Results" folder - Import "as is"
    file.copy(inFile$datapath
              , file.path(path_results, inFile$name))
    
    # button, enable, calc
    shinyjs::enable("b_mergefiles_calc")
    
    # activate tab Panel with table of imported data
    updateTabsetPanel(session = getDefaultReactiveDomain()
                      , "MF_mp_tsp"
                      , selected = "tab_MF_1")
    
    # Return Value
    return(df_input)
    
  })##output$df_import_mf1 ~ END
  
  
  ### Merge, Import, df_import_mf2----
  df_import_mf2 <- eventReactive(file_watch_mf2(), {
    # use a multi-item reactive so keep on a single line (if needed later)
    
    # input$df_import_mf1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$fn_input_mf2
    
    if (is.null(inFile)) {
      return(NULL)
    }##IF~is.null~END
    
    # Define file
    fn_inFile <- inFile$datapath
    
    #message(getwd())
    #message(paste0("Import, separator: '", input$sep,"'"))
    message(paste0("Import, file name: ", inFile$name))
    
    # Move Results folder clean up to calc button
    
    # Read user imported file
    # Add extra colClasses parameter for BCG_Attr
    # the "i" values default to complex numbers
    # many permutations of BCG_Attr so check for it first then import
    df_header <- read.delim(fn_inFile
                            , header = TRUE
                            , sep = ","
                            , stringsAsFactors = FALSE
                            , na.strings = c("", "NA")
                            , nrows = 0)
    col_num_bcgattr <- grep("BCG_ATTR", toupper(names(df_header)))
    
    if (identical(col_num_bcgattr, integer(0))) {
      # BCG_Attr present = FALSE
      # define classes = FALSE
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = ","
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
    } else {
      # BCG_Attr present = TRUE
      # define classes = TRUE
      classes_df <- sapply(df_header, class)
      classes_df[col_num_bcgattr] <- "character"
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = ","
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA")
                             , colClasses = classes_df)
      
    }## IF ~ col_num_bcgattr == integer(0)
    
    
    # OLD
    # Will get a 'warning' for unknown columns but harmless
    # df_input <- read.delim(fn_inFile
    #                        , header = TRUE
    #                        , sep = ","
    #                        , stringsAsFactors = FALSE
    #                        , colClasses = c("BCG_Attr" = "character"
    #                                         , "BCG_ATTR" = "character"
    #                                         , "bcg_attr" = "character"
    #                                         , "BCG_attr" = "character"))
    
    # Copy to "Results" folder - Import "as is"
    file.copy(inFile$datapath
              , file.path(path_results, inFile$name))
    
    # button, enable, calc
    shinyjs::enable("b_mergefiles_calc")
    
    # activate tab Panel with table of imported data
    updateTabsetPanel(session = getDefaultReactiveDomain()
                      , "MF_mp_tsp"
                      , selected = "tab_MF_2")
    
    # Return Value
    return(df_input)
    
  })##output$df_import_mf2 ~ END
  
  ### Merge, Import, df_import_mf1_DT ----
  output$df_import_mf1_DT <- DT::renderDT({
    df_data <- df_import_mf1()
  }##expression~END
  , filter = "top"
  , caption = "Table. MergeFile 1 (Samples)."
  , options = list(scrollX = TRUE
                   , pageLength = 5
                   , lengthMenu = c(5, 10, 25, 50, 100, 1000)
                   , autoWidth = TRUE)
  )##df_import_mf1_DT ~ END
  
  ### Merge, Import, df_import_mf2_DT ----
  output$df_import_mf2_DT <- DT::renderDT({
    df_data <- df_import_mf2()
  }##expression~END
  , filter = "top"
  , caption = "Table. MergeFile 2 (Sites)."
  , options = list(scrollX = TRUE
                   , pageLength = 5
                   , lengthMenu = c(5, 10, 25, 50, 100, 1000)
                   , autoWidth = TRUE)
  )##df_import_mf1_DT ~ END
  
  # ### Merge, df_mf_merge_DT ----
  # # repeat merge statement in calc section for merge files
  # output$df_mf_merge_DT <- DT::renderDT({
  #   ## column names
  #   col_siteid_mf1 <- input$mergefiles_f1_col_merge
  #   col_siteid_mf2 <- input$mergefiles_f2_col_merge
  #   # QC
  #   validate(need(col_siteid_mf1, "Missing merge column, file 1.")
  #            , need(col_siteid_mf2, "Missing merge column, file 2."))
  #   df_merge <- merge(df_import_mf1()
  #                     , df_import_mf2() 
  #                     , by.x = col_siteid_mf1
  #                     , by.y = col_siteid_mf2
  #                     , suffixes = c(".x", ".y")
  #                     , all.x = TRUE
  #                     , sort = FALSE
  #   )
  #
  #  # move MF2 columns to the start (at end after merge)
  #  ## use index numbers
  #  ncol_1x <- ncol(df_import_mf1())
  #  ncol_merge <- ncol(df_merge)
  #  df_merge <- df_merge[, c(1, seq(ncol_1x + 1, ncol_merge), 2:ncol_1x)]
  #
  #   return(df_merge)
  # }##expression~END
  # , filter = "top"
  # , caption = "Table. MergeFile 2 (Sites)."
  # , options = list(scrollX = TRUE
  #                  , pageLength = 5
  #                  , lengthMenu = c(5, 10, 25, 50, 100, 1000)
  #                  , autoWidth = TRUE)
  # )##df_import_mf1_DT ~ END
  
  ## Merge, UI----
  
  output$UI_mergefiles_f1_col_merge <- renderUI({
    str_col <- "Merge Identifier, Primary File, Column Name"
    selectInput("mergefiles_f1_col_merge"
                , label = str_col
                # , choices = c("SiteID", "feature", "in progress")
                , choices = c("", names(df_import_mf1()))
                , selected = "SiteID"
                , multiple = FALSE)
  })## UI_colnames  
  
  output$UI_mergefiles_f2_col_merge <- renderUI({
    str_col <- "Merge Identifier, Secondary File, Column Name"
    selectInput("mergefiles_f2_col_merge"
                , label = str_col
                #, choices = c("SiteID", "feature", "in progress")
                , choices = c("", names(df_import_mf2()))
                , selected = "SiteID"
                , multiple = FALSE)
  })## UI_colnames  
  
  ## b_Calc_MergeFiles ----
  observeEvent(input$b_mergefiles_calc, {
    shiny::withProgress({
      
      ### Calc, 00, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, Thermal Metrics..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 5
      prog_sleep <- 0.25
      
      ## Calc, 01, Initialize ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_download_mergefiles")
      
      ## Calc, 02, Gather and Test Inputs  ----
      prog_detail <- "QC Inputs"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
     
      # inputs
      ## file names
      fn_mf1 <- input$fn_input_mf1$name
      fn_mf2 <- input$fn_input_mf2$name
      ## column names
      col_siteid_mf1 <- input$mergefiles_f1_col_merge
      col_siteid_mf2 <- input$mergefiles_f2_col_merge
      ## file name base (file 1)
      fn_input_base <- tools::file_path_sans_ext(fn_mf1)
      
      # Stop if don't have both MF1 and MF2
      if (is.null(fn_mf1)) {
        msg <- "Merge File 1 filename is missing!"
        shinyalert::shinyalert(title = "Merge File Calculation Error"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ is.null (mf1)
      
      if (is.null(fn_mf2)) {
        msg <- "Merge File 2 filename is missing!"
        shinyalert::shinyalert(title = "Merge File Calculation Error"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ is.null (mf1)
      
      # Stop if colname for merge is NA
      if (col_siteid_mf1 == "") {
        msg <- "Merge File 1 merge column is missing!"
        shinyalert::shinyalert(title = "Merge File Calculation Error"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ is.null (mf1)
      
      if (col_siteid_mf2 == "") {
        msg <- "Merge File 2 merge column is missing!"
        shinyalert::shinyalert(title = "Merge File Calculation Error"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ is.null (mf1)
      
      
      
      # Remove non-MergeFiles files
      # Remove all files in "Results" folder
      # 2 file imports so moved Results folder clean up here from import section
      fn_results <- list.files(path_results
                               , full.names = TRUE
                               , include.dirs = FALSE
                               , recursive = TRUE)
      message(paste0("Files in 'results' folder (before removal) = "
                     , length(fn_results)))
      
      # Exclude MF1 and MF2
      fn_mf_keep <- file.path(path_results
                              , c(fn_mf1, fn_mf2))
      fn_results <- fn_results[!fn_results %in% fn_mf_keep]
      # Remove non MF files
      file.remove(fn_results) # ok if no files
      # QC, repeat 
      fn_results2 <- list.files(path_results
                                , full.names = TRUE
                                , include.dirs = FALSE
                                , recursive = TRUE)
      message(paste0("Files in 'results' folder (after removal [should be 2]) = "
                     , length(fn_results2)))
      
    
      ## Calc, 03, Run Function----
      suff_1x <- ".x"
      suff_2y <- ".y"
      df_merge <- merge(df_import_mf1()
                        , df_import_mf2() 
                        , by.x = col_siteid_mf1
                        , by.y = col_siteid_mf2
                        , suffixes = c(suff_1x, suff_2y)
                        , all.x = TRUE
                        , sort = FALSE
                        )
      # ***REPEAT*** same merge statement in DT statement for display on tab

      # move MF2 columns to the start (at end after merge)
      ## use index numbers
      ncol_1x <- ncol(df_import_mf1())
      ncol_merge <- ncol(df_merge)
      df_merge <- df_merge[, c(1, seq(ncol_1x + 1, ncol_merge), 2:ncol_1x)]
      
      ## Calc, 04, Save Results ----
      fn_merge <- paste0(fn_input_base, "_MergeFiles_RESULTS.csv")
      pn_merge <- file.path(path_results, fn_merge)
      write.csv(df_merge, pn_merge, row.names = FALSE)
      
    
      ## Calc, 05, Clean Up----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      # # activate tab Panel with table of imported data
      # updateTabsetPanel(session = getDefaultReactiveDomain()
      #                   , "MF_mp_tsp"
      #                   , selected = "tab_MF_merge")

      
      ## Calc, 06, Zip Results ----
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      utils::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      # button, enable, download
      shinyjs::enable("b_download_mergefiles")
      
    }## expr ~ withProgress ~ END
    , message = "Merging Files"
    )## withProgress ~ END
  }##expr ~ ObserveEvent ~ END
  )##observeEvent ~ b_calc_met_therm ~ END    
      
    
  ## b_download_mergefiles ----
  output$b_download_mergefiles <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input_mf2
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_MergeFiles_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ MergeFiles

})##shinyServer ~ END
