#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# nolint start
library(shiny)
# nolint end

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # INPUT Display Names ####
  
  output$fn_input_display_bcg <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_bcg
  
  output$fn_input_display_taxatrans <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_taxatrans
  
  output$fn_input_display_indexclass <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_indexclass
  
  output$fn_input_display_indexclassparam <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_indexclassparam
  
  output$fn_input_display_met_therm <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_met_therm
  
  output$fn_input_display_modtherm <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_modtherm
  
  output$fn_input_display_mtti <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_mtti
  
  output$fn_input_display_bdi <- renderText({
    inFile <- input$fn_input
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_bdi
  
  output$fn_input_display_map <- renderText({
    inFile <- input$fn_input

    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END

    return(paste0("'", inFile$name, "'"))

  })## fn_input_display_map
  
  # ~~~~IMPORT~~~~----
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
  
    sep_user <- input$sep
    
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
    
    ### Mod, BCG_ATTR----
    # Read user imported file
    # Add extra colClasses parameter for BCG_Attr
    # the "i" values default to complex numbers
    # many permutations of BCG_Attr so check for it first then import
    
    df_header <- read.delim(fn_inFile
                            , header = TRUE
                            , sep = sep_user
                            , stringsAsFactors = FALSE
                            , na.strings = c("", "NA")
                            , nrows = 0)
    col_num_bcgattr <- grep("BCG_ATTR", toupper(names(df_header)))
    classes_df <- sapply(df_header, class)
    col_name_bcgattr <- names(df_header)[col_num_bcgattr]

    if (identical(col_num_bcgattr, integer(0))) {
      # BCG_Attr present = FALSE
      # define classes = FALSE
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
    } else if (as.vector(classes_df[col_num_bcgattr]) != "complex") {
      # BCG_Attr present = TRUE
      # BCG_Attr Class is complex = FALSE
      # define classes on import = FALSE (change to text after import)
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
      df_input[, col_num_bcgattr] <- as.character(df_input[, col_num_bcgattr])
    } else {
      # BCG_Attr present = TRUE
      # BCG_Attr Class is complex = TRUE
      # define classes on import = TRUE
      #classes_df <- sapply(df_header, class)
      classes_df[col_num_bcgattr] <- "character"
      df_input <- read.table(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA")
                             #, colClasses = c(col_name_bcgattr = "character"))
                            # , colClasses = classes_df)
                             , colClasses = classes_df[col_name_bcgattr])
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
    
    ## button, enable, calc ----
    shinyjs::enable("b_calc_bcg")
    shinyjs::enable("b_calc_taxatrans")
    shinyjs::enable("b_calc_indexclass")
    shinyjs::enable("b_calc_indexclassparam")
    shinyjs::enable("b_calc_met_therm")
    shinyjs::enable("b_calc_modtherm")
    shinyjs::enable("b_calc_mtti")
    shinyjs::enable("b_calc_bdi")
    
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
  
  # ~~~~FILE BUILDER~~~~ ----
  # FB, TAXATRANS ----
  ## TaxaTrans, UI ----
  
  output$UI_taxatrans_pick_official <- renderUI({
    str_col <- "Calculation"
    selectInput("taxatrans_pick_official"
                , label = str_col
                , choices = c("", df_pick_taxoff[, "project"])
                , multiple = FALSE)
  })## UI_colnames
  
  # output$UI_taxatrans_pick_official_project <- renderUI({
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
  observeEvent(input$b_calc_taxatrans, {
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
      shinyjs::disable("b_download_taxatrans")
      
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
 
      ## Data,  Official Taxa----
      url_taxoff <- file.path(url_bmt_base
                              , "taxa_official"
                              , fn_taxoff)
      httr::GET(url_taxoff
                , write_disk(temp_taxoff <- tempfile(fileext = ".csv")))
      
      df_taxoff <- read.csv(temp_taxoff)
      
      ## Data, Official Taxa, Meta Data----
      if (!is.null(fn_taxoff_meta)) {
        url_taxoff_meta <- file.path(url_bmt_base
                                     , "taxa_official"
                                     , fn_taxoff_meta)
        httr::GET(url_taxoff_meta
            , write_disk(temp_taxoff_meta <- tempfile(fileext = ".csv")))
        
        df_taxoff_meta <- read.csv(temp_taxoff_meta)
      }## IF ~ fn_taxaoff_meta

      ## Data, Official Attributes----
      if (!is.null(fn_taxoff_attr)) {
        url_taxoff_attr <- file.path(url_bmt_base
                                     , "taxa_official"
                                     , fn_taxoff_attr)
        httr::GET(url_taxoff_attr
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

      ## run the function ----
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
     
      ## Munge ----
 
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
      
      # Hack/Fix
      # Noteworthy NA causing issue later in Shiny app
      taxatrans_results$merge$Noteworthy <- ifelse(is.na(taxatrans_results$merge$Noteworthy)
                                                   , FALSE
                                                   , TRUE)
      
      
      ## Calc, 04, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Save files
 
      ## File version names
      df_save <- data.frame(Calculation = sel_proj
                            , OperationalTaxonomicUnit = fn_taxoff
                            , TranslationTable = col_taxaid_official_project
                            , AttributeTable = fn_taxoff_attr)
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
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      
      ## Calc, 06, Clean Up ----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, enable, download
      shinyjs::enable("b_download_taxatrans")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating BCG"
    )## withProgress
    
  }##expr ~ ObserveEvent
  
  )##observeEvent ~ b_taxatrans_calc
  
  ## b_download_TaxaTrans ----
  output$b_download_taxatrans <- downloadHandler(
    
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
  
  # FB, INDEX_CLASS_PARAM ----
  
  ## IndexClassParam, UI ----
  output$UI_indexclassparam_indexname <- renderUI({
    str_col <- "Index Name"
    selectInput("indexclassparam_indexname"
                , label = str_col
                #, choices = c("", sel_indexclassparam_indexnames)
                , choices = c("", "BCG_MariNW_Bugs500ct")
                , selected = "BCG_MariNW_Bugs500ct"
                , multiple = FALSE)
  })## UI_colnames 
  
  output$UI_indexclassparam_user_col_sampid <- renderUI({
    str_col <- "Column, SampleID (unique station or sample identifier)"
    selectInput("indexclassparam_user_col_sampid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "SampleID"
                , multiple = FALSE)
  })## UI_colnames 
  
  output$UI_indexclassparam_user_col_lat <- renderUI({
    str_col <- "Column, Latitude (decimal degrees)"
    selectInput("indexclassparam_user_col_lat"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "Latitude"
                , multiple = FALSE)
  })## UI_colnames 
  
  output$UI_indexclassparam_user_col_lon <- renderUI({
    str_col <- "Column, Longitude (decimal degrees)"
    selectInput("indexclassparam_user_col_lon"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "Longitude"
                , multiple = FALSE)
  })## UI_colnames 
  
  output$UI_indexclassparam_user_col_epsg <- renderUI({
    m1 <- "Column, EPSG (datum), e.g., NAD83 North America is 4269."
    m2 <- "Column can be left blank and default of 4269 will be used."
    str_col <- paste(m1, m2, sep = "\n")
    selectInput("indexclassparam_user_col_epsg"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "EPSG"
                , multiple = FALSE)
  })## UI_colnames 
  
  ## b_Calc_IndexClassParam ----
  observeEvent(input$b_calc_indexclassparam, {
    shiny::withProgress({
    
      ### Calc, 00, Initialize ----
      prog_detail <- "Calculation, Generate Index Class Parameters..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 8
      prog_sleep <- 0.25
      
      ## Calc, 01, Import User Data ----
      prog_detail <- "Import Data, User"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_download_indexclassparam")
      
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
      
      df_sites <- df_input
      
      
      # get StreamCat data?
      # Load with file, 240 MB, don't want to do every time app is used
   
      
      ## Calc, 02, Gather and Test Inputs  ----
      prog_detail <- "QC Inputs"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # # Fun Param, Define
      sel_col_sampid <- input$indexclassparam_user_col_sampid
      sel_col_lat    <- input$indexclassparam_user_col_lat
      sel_col_lon    <- input$indexclassparam_user_col_lon
      sel_col_epsg   <- input$indexclassparam_user_col_epsg
      
      # Test each input
      if (sel_col_sampid == "") {
        # end process with pop up
        msg <- "'SampleID' column name is missing!"
        shinyalert::shinyalert(title = "Generate Index Class Parameters"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ sel_col_sampid
      
      if (sel_col_lat == "") {
        # end process with pop up
        msg <- "'Latitude' column name is missing!"
        shinyalert::shinyalert(title = "Generate Index Class Parameters"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ sel_col_lat
      
      if (sel_col_lon == "") {
        # end process with pop up
        msg <- "'Longitude' column name is missing!"
        shinyalert::shinyalert(title = "Generate Index Class Parameters"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ sel_col_lon
      
      # need a value to evaluate in the next IF..
      if (sel_col_epsg == "") {
        epsg_user <- NA
      } else {
        epsg_user <- unique(df_sites[, sel_col_epsg])
      }## IF ~ sel_col_epsg
      
      # Define default EPSG if not provided
      if (sel_col_epsg == "") {
        # No Field selected
        # use default EPSG
        value_epsg <- epsg_default
      } else if (all(is.na(epsg_user))) {
        # All user values are NA
        # use default EPSG
        value_epsg <- epsg_default
      } else {
        # user provided value
        epsg_user <- unique(df_sites[, sel_col_epsg])
        value_epsg <- as.numeric(epsg_user[!is.na(epsg_user)])
      }## IF ~ sel_col_epsg
 
      msg <- paste0("EPSG = ", value_epsg)
      message(msg)
      
      # add EPSG to data (in case changed)
      df_sites[, "EPSG_CALC"] <- value_epsg
      
      ## Calc, 03, Run Function, StreamCat ----
      prog_detail <- "Stream Cat; COMID and elev"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # COMID
      comid <- StreamCatTools::sc_get_comid(df_sites
                                            , xcoord = sel_col_lon
                                            , ycoord = sel_col_lat
                                            , crsys = value_epsg)
      
      # Add COMID to data
      df_sites[, "COMID"] <- strsplit(comid, ",")
      
      # END if COMID all NA
      comid_unique <- unique(df_sites[, "COMID"])
      if (length(comid_unique) == 1 & any(comid_unique == "NA")) {
        # end process with pop up
        m1 <- "'COMID' all NA!"
        m2 <- "Lat-Long and/or EPSG not valid."
        m3 <- "Or try again with existing Lat-Long with default EPSG (WGS84)"
        msg <- paste(m1, m2, m3, sep = "\n")
        shinyalert::shinyalert(title = "Generate Index Class Parameters"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ sel_col_lat
 

      ## elevation and precip (PRISM 1981-2010)
      df_sc <- StreamCatTools::sc_get_data(
        comid = paste(df_sites[, "COMID"], collapse = ",")
        , metric = "elev,Precip8110,ICI,IWI")
      
      # cols to keep
      sc_names_drop <- c("CATAREASQKM", "ELEVWS", "PRECIP8110WS")
      sc_names_keep <- names(df_sc)[!names(df_sc) %in% sc_names_drop]
      
      # add elev to sites
      df_results <- merge(df_sites
                          , df_sc[, sc_names_keep]
                          , by.x = "COMID"
                          , by.y = "COMID"
                          , all.x = TRUE)
      
      # rename StreamCat ELEVCAT to elev_m
      df_results <- dplyr::rename(df_results, elev_m = ELEVCAT)
      
      ## Calc, 04, Run Function, NHD+ ----
      prog_detail <- "NHDplus; slope"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # NHDplus
      ## download VAA
      nhdplusTools::nhdplusTools_data_dir(file.path("data")) # set dir
      nhdplusTools::download_vaa(path = nhdplusTools::get_vaa_path()
                                 , force = FALSE
                                 , updated_network = FALSE)
      # get_vaa_names() # VAA table names
      vaa_names2get <- c("slope"
                         , "slopelenkm"
                         , "gnis_name"
                         , "streamorde"
                         , "ftype"
                         , "fcode"
                         #, "lengthkm"
                         #, "totdasqkm"
                         #, "areasqkm"
                         )
      nhdplus_vaa <- nhdplusTools::get_vaa(vaa_names2get)
      ## merge with sites_sc
      df_results <- merge(df_results
                          , nhdplus_vaa
                          , by.x = "COMID"
                          , by.y = "comid"
                          , all.x = TRUE)
      
      
      ## Calc, 05, Munge ----
      prog_detail <- "Modify Variable Names"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Modify names to match Assign Index Class function
      df_results <- dplyr::rename(df_results, pslope_nhd = slope)
      df_results[, "pslope_nhd"] <- 100 * df_results[, "pslope_nhd"]
      
      
      ## Calc, 06, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Save files 
      
      ## save, results
      df_save <- df_results
      fn_part <- paste0("_indexclassparam_", "RESULTS", ".csv")
      write.csv(df_save
                , file.path(path_results, paste0(fn_input_base, fn_part))
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      
      ## Calc, 07, Create Zip ----
      prog_detail <- "Create Zip File For Download"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Create zip file for download
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      
      ## Calc, 08, Clean Up ----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, enable, download
      shinyjs::enable("b_download_indexclassparam")
      
    }## expr ~ withProgress ~ END
    , message = "Generating Index Class Parameters"
    )## withProgress
    
  }##expr ~ ObserveEvent
  )##observeEvent ~ b_calc_indexclassparam
  
  # b_download_IndexClassParam ----
  output$b_download_indexclassparam <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_IndexClassParam_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ IndexClassParam
  
  # FB, INDEX_CLASS_ASSIGN ----
  
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
    str_col <- "Column, Elevation (meters)"
    selectInput("indexclass_user_col_elev"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "elev_m"
                , multiple = FALSE)
  })## UI_colnames  
  
  output$UI_indexclass_user_col_slope <- renderUI({
    str_col <- "Column, Slope (percent)"
    selectInput("indexclass_user_col_slope"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "pslope_nhd"
                , multiple = FALSE)
  })## UI_colnames  
  
  
  ## b_Calc_IndexClassAssign ----
  observeEvent(input$b_calc_indexclass, {
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
      shinyjs::disable("b_download_indexclass")
      
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
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      
      ## Calc, 06, Clean Up ----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, enable, download
      shinyjs::enable("b_download_indexclass")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating Index Class"
    )## withProgress
    
  }##expr ~ ObserveEvent
  
  )##observeEvent ~ b_calc_indexclass
  
  ## b_download_IndexClassAssign ----
  output$b_download_indexclass <- downloadHandler(
    
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
  
  
  
  # FB, MERGE FILES ----
  
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
    
    sep_user <- input$sep
    
    # Define file
    fn_inFile <- inFile$datapath
    
    #message(getwd())
    # message(paste0("Import, separator: '", input$sep,"'"))
    message(paste0("Import, file name: ", inFile$name))
    
    # Move Results folder clean up to calc button
    
    #### Mod, BCG_ATTR----
    # Read user imported file
    # Add extra colClasses parameter for BCG_Attr
    # the "i" values default to complex numbers
    # many permutations of BCG_Attr so check for it first then import
    df_header <- read.delim(fn_inFile
                            , header = TRUE
                            , sep = sep_user
                            , stringsAsFactors = FALSE
                            , na.strings = c("", "NA")
                            , nrows = 0)
    col_num_bcgattr <- grep("BCG_ATTR", toupper(names(df_header)))
    classes_df <- sapply(df_header, class)
    col_name_bcgattr <- names(df_header)[col_num_bcgattr]
    
    if (identical(col_num_bcgattr, integer(0))) {
      # BCG_Attr present = FALSE
      # define classes = FALSE
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
    } else if (as.vector(classes_df[col_num_bcgattr]) != "complex") {
      # BCG_Attr present = TRUE
      # BCG_Attr Class is complex = FALSE
      # define classes on import = FALSE (change to text after import)
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
      df_input[, col_num_bcgattr] <- as.character(df_input[, col_num_bcgattr])
    } else {
      # BCG_Attr present = TRUE
      # define classes = TRUE
      classes_df <- sapply(df_header, class)
      classes_df[col_num_bcgattr] <- "character"
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA")
                             #, colClasses = classes_df)
                             #, colClasses = c(col_name_bcgattr = "character"))
                             , colClasses = classes_df[col_name_bcgattr])
      
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
    shinyjs::enable("b_calc_mergefiles")
    
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
    
    sep_user <- input$sep
    
    #message(getwd())
    #message(paste0("Import, separator: '", input$sep,"'"))
    message(paste0("Import, file name: ", inFile$name))
    
    # Move Results folder clean up to calc button
    
    #### Mod, BCG_ATTR----
    # Read user imported file
    # Add extra colClasses parameter for BCG_Attr
    # the "i" values default to complex numbers
    # many permutations of BCG_Attr so check for it first then import
    df_header <- read.delim(fn_inFile
                            , header = TRUE
                            , sep = sep_user
                            , stringsAsFactors = FALSE
                            , na.strings = c("", "NA")
                            , nrows = 0)
    col_num_bcgattr <- grep("BCG_ATTR", toupper(names(df_header)))
    classes_df <- sapply(df_header, class)
    col_name_bcgattr <- names(df_header)[col_num_bcgattr]
    
    if (identical(col_num_bcgattr, integer(0))) {
      # BCG_Attr present = FALSE
      # define classes = FALSE
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
    } else if (as.vector(classes_df[col_num_bcgattr]) != "complex") {
      # BCG_Attr present = TRUE
      # BCG_Attr Class is complex = FALSE
      # define classes on import = FALSE (change to text after import)
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA"))
      df_input[, col_num_bcgattr] <- as.character(df_input[, col_num_bcgattr])
    } else {
      # BCG_Attr present = TRUE
      # define classes = TRUE
      classes_df <- sapply(df_header, class)
      classes_df[col_num_bcgattr] <- "character"
      df_input <- read.delim(fn_inFile
                             , header = TRUE
                             , sep = sep_user
                             , stringsAsFactors = FALSE
                             , na.strings = c("", "NA")
                             # , colClasses = classes_df)
                             #, colClasses = c(col_name_bcgattr = "character"))
                             , colClasses = classes_df[col_name_bcgattr])
      
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
    shinyjs::enable("b_calc_mergefiles")
    
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
  observeEvent(input$b_calc_mergefiles, {
    shiny::withProgress({
      
      ### Calc, 00, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, Merge Files..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 6
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
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
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
  
  #~~~~CALC~~~~----
  
  # Calc, BCG ----
  ## b_Calc_BCG ----
  observeEvent(input$b_calc_bcg, {
    shiny::withProgress({
      
      ### Calc, 0, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, BCG..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 10
      prog_sleep <- 0.25
      
      ## Calc, 1, Initialize ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_download_bcg")
      
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
      
      ## Calc, 2, Exclude Taxa ----
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
      
      
      ## Calc, 3, BCG Flag Cols ----
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
      
      
      ## Calc, 3b, Rules ----
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
      
      ## Calc, 4, MetVal----
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
      
      
      ## Calc, 5, MetMemb----
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
      
      
      ## Calc, 6, LevMemb----
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
      
      
      ## Calc, 7, LevAssign----
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
      
      
      ## Calc, 8, QC Flags----
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
      
      
      ## Calc, 8b, QC Flag Metrics ----
      # create
      col2keep <- c("SAMPLEID", "INDEX_NAME", "INDEX_CLASS", "METRIC_NAME"
                    , "CHECKNAME", "METRIC_VALUE", "SYMBOL", "VALUE", "FLAG")
      df_metflags <- df_flags[, col2keep]
      # save
      fn_metflags <- paste0(fn_input_base, "_bcgcalc_6metflags.csv")
      dn_metflags <- path_results
      pn_metflags <- file.path(dn_metflags, fn_metflags)
      write.csv(df_metflags, pn_metflags, row.names = FALSE)

       
      ## Calc, 9, RMD----
      prog_detail <- "Calculate, Create Report"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      strFile.RMD <- file.path("external"
                               , "RMD_Results"
                               , "Results_BCG_Summary.Rmd")
      strFile.RMD.format <- "html_document"
      strFile.out <- paste0(fn_input_base, "_bcgcalc_RESULTS.html")
      dir.export <- path_results
      rmarkdown::render(strFile.RMD
                        , output_format = strFile.RMD.format
                        , output_file = strFile.out
                        , output_dir = dir.export
                        , quiet = TRUE)
      
      ## Calc, 9, Clean Up----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      # Create zip file of results
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      # button, enable, download
      shinyjs::enable("b_download_bcg")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating BCG"
    )## withProgress ~ END
  }##expr ~ ObserveEvent ~ END
  )##observeEvent ~ b_calc_bcg ~ END
  
  ## b_download_BCG ----
  output$b_download_bcg <- downloadHandler(
    
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
  
  ## Calc, THERMAL METRICS ----
  
  ## b_Calc_Met_Therm ----
  observeEvent(input$b_calc_met_therm, {
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
      
     
      ## Calc, 02, Exclude Taxa ----
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
      
      ## Calc, 03, MetVal----
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
        
      ## Calc, 04, Save Results ----
      fn_metval <- paste0(fn_input_base, "_met_therm_RESULTS.csv")
      dn_metval <- path_results
      pn_metval <- file.path(dn_metval, fn_metval)
      write.csv(df_metval, pn_metval, row.names = FALSE)
      
      # Copy metadata (thermal metrics) to results
      fn_meta <- "ThermPrefMetrics_metadata.xlsx"
      file.copy(file.path("www", "links", fn_meta)
                , file.path("results", fn_meta))
      
      ## Calc, 05, Clean Up----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      # Calc, 5, Create zip file of results
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      # button, enable, download
      shinyjs::enable("b_download_met_therm")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating Metrics Thermal"
    )## withProgress ~ END
  }##expr ~ ObserveEvent ~ END
  )##observeEvent ~ b_calc_met_therm ~ END
  
  ## b_download_Met_Therm ----
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
  
  
  
  # Calc, FUZZY THERMAL ----
  
  ## b_Calc_modtherm ----
  observeEvent(input$b_calc_modtherm, {
    shiny::withProgress({
    
      ### Calc, 0, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, Thermal Model..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 11
      prog_sleep <- 0.25
      
      ## Calc, 1, Initialize and Test ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_download_modtherm")
     
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
     
      # Test, INDEX_NAME, column missing
      if (!"INDEX_NAME" %in% names(df_input)) {
        # add default value
        df_input[, "INDEX_NAME"] <- "Therm_ORWA_Bugs500ct"
        # # end process with pop up
        # msg <- "'INDEX_NAME' column name is missing!"
        # shinyalert::shinyalert(title = "Fuzzy Thermal Calculation"
        #                        , text = msg
        #                        , type = "error"
        #                        , closeOnEsc = TRUE
        #                        , closeOnClickOutside = TRUE)
        # validate(msg)
      }## IF ~ INDEX_NAME, column missing

      # Test, INDEX_CLASS, column missing
      if (!"INDEX_CLASS" %in% names(df_input)) {
        # add default value
        df_input[, "INDEX_CLASS"] <- "ORWA"
        # # end process with pop up
        # msg <- "'INDEX_CLASS' column name is missing!"
        # shinyalert::shinyalert(title = "Fuzzy Thermal Calculation"
        #                        , text = msg
        #                        , type = "error"
        #                        , closeOnEsc = TRUE
        #                        , closeOnClickOutside = TRUE)
        # validate(msg)
      }## IF ~ INDEX_CLASS, column missing
      
      # Test, INDEX_NAME, column blank
      if (sum(is.na(df_input[, "INDEX_NAME"])) == nrow(df_input)) {
        # add default value
        df_input[, "INDEX_NAME"] <- "Therm_ORWA_Bugs500ct"
      }## IF ~ INDEX_NAME, column blank
      
      # Test, INDEX_CLASS, column blank
      if (sum(is.na(df_input[, "INDEX_CLASS"])) == nrow(df_input)) {
        # add default value
        df_input[, "INDEX_CLASS"] <- "ORWA"
      }## IF ~ INDEX_CLASS, column blank
      
      ## Calc, 2, Exclude Taxa ----
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
        fn_excl <- paste0(fn_input_base, "_modtherm_1markexcl.csv")
        dn_excl <- path_results
        pn_excl <- file.path(dn_excl, fn_excl)
        write.csv(df_input, pn_excl, row.names = FALSE)
        
      }## IF ~ input$ExclTaxa
      
      
      ## Calc, 3, BCG Flag Cols ----
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
      
      
      ## Calc, 4, Rules ----
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
      fn_rules <- paste0(fn_input_base, "_modtherm_3metrules.csv")
      dn_rules <- path_results
      pn_rules <- file.path(dn_rules, fn_rules)
      write.csv(df_rules, pn_rules, row.names = FALSE)
      
      ## Calc, 5, MetVal----
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
      ### Save Results ----
      fn_metval <- paste0(fn_input_base, "_modtherm_2metval_all.csv")
      dn_metval <- path_results
      pn_metval <- file.path(dn_metval, fn_metval)
      write.csv(df_metval, pn_metval, row.names = FALSE)
      
      ### Save Results (BCG) ----
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
      fn_metval_slim <- paste0(fn_input_base, "_modtherm_2metval_BCG.csv")
      dn_metval_slim <- path_results
      pn_metval_slim <- file.path(dn_metval_slim, fn_metval_slim)
      write.csv(df_metval_slim, pn_metval_slim, row.names = FALSE)
      
     
      ## Calc, 6, MetMemb----
      prog_detail <- "Calculate, Metric, Membership"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      df_metmemb <- BCGcalc::BCG.Metric.Membership(df_metval, df_bcg_models)
      # Save Results
      fn_metmemb <- paste0(fn_input_base, "_modtherm_3metmemb.csv")
      dn_metmemb <- path_results
      pn_metmemb <- file.path(dn_metmemb, fn_metmemb)
      write.csv(df_metmemb, pn_metmemb, row.names = FALSE)
      
    
      ## Calc, 7, LevMemb----
      prog_detail <- "Calculate, Level, Membership"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      df_levmemb <- BCGcalc::BCG.Level.Membership(df_metmemb, df_bcg_models)
      # Save Results
      fn_levmemb <- paste0(fn_input_base, "_modtherm_4levmemb.csv")
      dn_levmemb <- path_results
      pn_levmemb <- file.path(dn_levmemb, fn_levmemb)
      write.csv(df_levmemb, pn_levmemb, row.names = FALSE)
      
      
      ## Calc, 8, LevAssign----
      prog_detail <- "Calculate, Level, Assignment"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      # Calc
      df_levassign <- BCGcalc::BCG.Level.Assignment(df_levmemb)
      
      # Munge Results
      # Change names from BCG-centric to Thermal model specific
      colnames(df_levassign)[colnames(df_levassign) %in% "Primary_BCG_Level"] <- 
        "Primary_Therm"
      colnames(df_levassign)[colnames(df_levassign) %in% "Secondary_BCG_Level"] <- 
        "Secondary_Therm"
      colnames(df_levassign)[colnames(df_levassign) %in% "Continuous_BCG_Level"] <- 
        "Continuous_Therm"
      colnames(df_levassign)[colnames(df_levassign) %in% "BCG_Status"] <- 
        "Therm_Status"
      colnames(df_levassign)[colnames(df_levassign) %in% "BCG_Status2"] <- 
        "Therm_Status2"
      
      df_levassign <- dplyr::mutate(df_levassign
                                    , "Primary_Therm_Nar" = NA
                                    , .after = "Primary_Therm")
      df_levassign <- dplyr::mutate(df_levassign
                                    , "Secondary_Therm_Nar" = NA
                                    , .after = "Secondary_Therm")
      # df_levassign[, "ThermClass"] <- NA
      
      # dplyr::case_match not working
      lab_therm <- c("VeryCold", "Cold", "Cool", "Warm")
      df_levassign[, "Primary_Therm_Nar"] <- cut(df_levassign$Primary_Therm
                                                 , breaks = 2:6
                                                 , labels = lab_therm
                                                 , include.lowest = TRUE
                                                 , right = FALSE
                                                 , ordered_result = TRUE)
      df_levassign[, "Secondary_Therm_Nar"] <- cut(df_levassign$Secondary_Therm
                                                 , breaks = 2:6
                                                 , labels = lab_therm
                                                 , include.lowest = TRUE
                                                 , right = FALSE
                                                 , ordered_result = TRUE)
    
      status2_val <- c("2"
                       , "2-"
                       , "2/3 tie"
                       , "3+"
                       , "3"
                       , "3-"
                       , "3/4 tie"
                       , "4+"
                       , "4"
                       , "4-"
                       , "4/5 tie"
                       , "5+"
                       , "5"
                       , "5-"
                       #, "6+"
                       #, "6"
                       )
      Therm_Class <- c("VeryCold"
                       , "VCold_Cold"
                       , "TIE_VCold_Cold"
                       , "Cold_VCold"
                       , "Cold"
                       , "Cold_Cool"
                       , "TIE_Cold_Cool"
                       , "Cool_Cold"
                       , "Cool"
                       , "Cool_Warm"
                       , "TIE_Cool_Warm"
                       , "Warm_Cool"
                       , "Warm"
                       , "Warm"
                       #, "unless I screwed something up (entirely possible) we shouldn't get 6s"
                       #, "unless I screwed something up (entirely possible) we shouldn't get 6s"
                      )
      df_status2 <- data.frame(cbind(status2_val, Therm_Class))
      df_levassign <- merge(df_levassign
                            , df_status2
                            , by.x = "Therm_Status2"
                            , by.y = "status2_val"
                            , all.x = TRUE
                            , sort = FALSE
                            )
      # move columns
      df_levassign <- dplyr::relocate(df_levassign
                                      , "Therm_Status2"
                                      , .after = "Therm_Status")
      
      
      # Save Results
      fn_levassign <- paste0(fn_input_base, "_modtherm_5levassign.csv")
      dn_levassign <- path_results
      pn_levassign <- file.path(dn_levassign, fn_levassign)
      write.csv(df_levassign, pn_levassign, row.names = FALSE)
      
      ## Calc, 9, QC Flags----
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
      fn_levflags <- paste0(fn_input_base, "_modtherm_6levflags.csv")
      dn_levflags <- path_results
      pn_levflags <- file.path(dn_levflags, fn_levflags)
      write.csv(df_lev_flags_summ, pn_levflags, row.names = TRUE)
      
      # Create Results
      df_results <- df_lev_flags[, !names(df_lev_flags) %in% c(paste0("L", 1:6))]
      ## remove L1:6
      
      # Save Results
      fn_results <- paste0(fn_input_base, "_modtherm_RESULTS.csv")
      dn_results <- path_results
      pn_results <- file.path(dn_results, fn_results)
      write.csv(df_results, pn_results, row.names = FALSE)
      
      
      ### Calc, 9b, QC Flag Metrics ----
      # create
      col2keep <- c("SAMPLEID", "INDEX_NAME", "INDEX_CLASS", "METRIC_NAME"
                    , "CHECKNAME", "METRIC_VALUE", "SYMBOL", "VALUE", "FLAG")
      df_metflags <- df_flags[, col2keep]
      # save
      fn_metflags <- paste0(fn_input_base, "_modtherm_6metflags.csv")
      dn_metflags <- path_results
      pn_metflags <- file.path(dn_metflags, fn_metflags)
      write.csv(df_metflags, pn_metflags, row.names = FALSE)

      ## Calc, 10, RMD----
      prog_detail <- "Calculate, Create Report"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      strFile.RMD <- file.path("external"
                               , "RMD_Results"
                               , "Results_FuzzyThermal_Summary.Rmd")
      strFile.RMD.format <- "html_document"
      strFile.out <- paste0(fn_input_base, "_modtherm_RESULTS.html")
      dir.export <- path_results
      rmarkdown::render(strFile.RMD
                        , output_format = strFile.RMD.format
                        , output_file = strFile.out
                        , output_dir = dir.export
                        , quiet = TRUE)
      
      ## Calc, 11, Clean Up----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      # Create zip file of results
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      # button, enable, download
      shinyjs::enable("b_download_modtherm")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating Thermal Model"
    )## withProgress ~ END
  }##expr ~ ObserveEvent ~ END
  )##observeEvent ~ b_calc_modtherm ~ END
  
  ## b_download_modtherm ----
  output$b_download_modtherm <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_ModTherm_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ Model (Fuzzy) Thermal
  
  
  # Calc, MTTI ----
  
  ## MTTI, UI ----
  output$UI_mtti_user_col_taxaid <- renderUI({
    str_col <- "Column, TaxaID"
    selectInput("mtti_user_col_taxaid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "TaxaID"
                , multiple = FALSE)
  })## UI_colnames
  
  output$UI_mtti_user_col_ntaxa <- renderUI({
    str_col <- "Column, Taxa Count (number of individuals or N_Taxa)"
    selectInput("mtti_user_col_ntaxa"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "N_Taxa"
                , multiple = FALSE)
  })## UI_colnames  
  
  output$UI_mtti_user_col_sampid <- renderUI({
    str_col <- "Column, Unique Sample Identifier (e.g., SampleID)"
    selectInput("mtti_user_col_sampid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "SampleID"
                , multiple = FALSE)
  })## UI_colnames  
  
  ## b_Calc_MTTI ----
  observeEvent(input$b_calc_mtti, {
    shiny::withProgress({

    
      ### Calc, 00, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, MTTI..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 10
      prog_sleep <- 0.25
      
      ## Calc, 01, Initialize ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_download_mtti")
      
      ## Calc, 02, Gather and Test Inputs  ----
      prog_detail <- "QC Inputs"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
   
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
      
      df_data <- df_input
      
      # Fun Param, Define
      sel_col_sampid <- input$mtti_user_col_sampid
      sel_col_taxaid <- input$mtti_user_col_taxaid
      sel_col_ntaxa  <- input$mtti_user_col_ntaxa
    
      # Data, Model
      fn_model <- "wa_MTTI.mar23.Rdata"
      dn_model <- file.path("data", "MTTI_model")
      load(file.path(dn_model, fn_model))
      # **FUTURE** load from GitHub repo
      
      # Data, Taxa List Official
      ## get from BioMonTools_SupportFiles GitHub Repo
      # df_pick_taxoff from GLOBAL
      fn_taxoff <- df_pick_taxoff[df_pick_taxoff$project == 
                                    "MTTI (Oregon/Washington)"
                                  , "filename"]
      
      url_taxa_official <- file.path(url_bmt_base
                                          , "taxa_official"
                                          , fn_taxoff)
      
      # download so ensure have it before read
      httr::GET(url_taxa_official
          , httr::write_disk(temp_taxa_official <- tempfile(fileext = ".csv")))
      
      df_tax <- read.csv(temp_taxa_official)
      
      ## Calc, 03, Run Function----
      
      # Munge
      prog_detail <- "Calculation, Munge"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      ## Munge, Data 
      df_data <- df_data %>%
        dplyr::rename(sample.id = dplyr::all_of(sel_col_sampid)) %>%
        dplyr::rename(Taxon_orig = dplyr::all_of(sel_col_taxaid)) %>%
        dplyr::rename(Count = dplyr::all_of(sel_col_ntaxa))
      
      if (input$MTTI_OTU) {
        # Leave alone for now
        # Don't think an issue if already converted to OTU names
        # OTU names should be in the taxa_orig column
      }## MTTI_OTU
      
      # limit to necessary fields to void messy joins
      df_tax_otu <- df_tax %>%
        dplyr::select(Taxon_orig, OTU_MTTI) 
      
      ### Data Prep----
      # need relative abundances
      prog_detail <- "Calculation, Data Prep"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      df_abunds <- df_data %>% 			
        dplyr::group_by(sample.id) %>% 
        dplyr::summarize(tot.abund = sum(Count))
      
      df_abunds <- as.data.frame(df_abunds)
      
      df_data <- df_data %>%
        dplyr::left_join(df_abunds, by = 'sample.id')
      
      df_data_RA <- df_data %>%
        dplyr::group_by(sample.id, Taxon_orig) %>%
        dplyr::summarize(RA = (Count / tot.abund), .groups = "drop_last")
      
      #	join bugs and OTUs, filter out 'DNI' taxa, sum across OTUs within a sample
      # join
      df_bugs_otu <- df_data_RA %>%
        # join dataframes
        dplyr::left_join(df_tax_otu, by = 'Taxon_orig') %>% 
        # filter out DNI taxa
        dplyr::filter(OTU_MTTI != 'DNI')						
      
      # sum RA's across all OTUs--should see a reduction in rows.  
      # Also limits to the following: dataset (CAL/VAL/not), sample, OTU, (summed) RA
      
      df_data_otu_sum_RA <- plyr::ddply(.data = df_bugs_otu
                                        , c('sample.id', 'OTU_MTTI')
                                        , plyr::summarize
                                        , RA = sum(RA))
      
      #	Prepare data sets for modeling
      #	need to crosstab the bug data (turn into a wide format) so that OTUs are columns
      # then split into separate CAl and VAl datasets 
      
      df_data_cross <- df_data_otu_sum_RA %>% 
        tidyr::pivot_wider(id_cols = c(sample.id)
                           , names_from = OTU_MTTI
                           , values_from = RA
                           , values_fn = sum) 
      
      
      df_data_cross[is.na(df_data_cross)] <- 0 
      
      df_data_cross <-	tibble::column_to_rownames(df_data_cross, 'sample.id') 
      
      ### Model----
      
      prog_detail <- "Calculation, Model"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      ## Model, Calculation
      model_pred <- predict(wa_MTTI.mar23
                            , newdata = df_data_cross)
      # , sse = TRUE
      # , nboot = 100
      # , match.data = TRUE
      # , verbose = TRUE)
      
      ## Model, Munge
      df_results_model <- as.data.frame(model_pred$fit)
      
      df_results_model <- df_results_model %>%
        dplyr::select(WA.cla.tol) %>% 
        dplyr::rename("MTTI" = "WA.cla.tol")
      
      # rownames to column 1
      df_results_model <- tibble::rownames_to_column(df_results_model
                                                     , sel_col_sampid)
 
      ### Flags----
      prog_detail <- "Calculation, Flags"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
 
      # Import Checks
      df_checks <- read_excel(system.file("./extdata/MetricFlags.xlsx"
                                           , package = "BioMonTools")
                             , sheet = "Flags")
      # Data
      ## Data, Optima
      df_optima <- tibble::rownames_to_column(data.frame(wa_MTTI.mar23$coefficients)
                                       , "TAXAID")

      ## Data, bug samples for metric calc
      df_bugs_met <- df_data %>%
        # join dataframes
        dplyr::left_join(df_tax_otu, by = 'Taxon_orig') %>%
        dplyr::rename("SAMPLEID" = "sample.id"
                      , "TAXAID" = "OTU_MTTI"
                      , "N_TAXA" = "Count") %>%
        dplyr::mutate("EXCLUDE" = FALSE
                      , "INDEX_NAME" = "MTTI"
                      , "INDEX_CLASS" = "MTTI") %>%
        dplyr::left_join(df_optima, by = "TAXAID")
      
     # if checked Convert to OTU  
     if (input$MTTI_OTU == TRUE) {
       df_bugs_met <- dplyr::rename(df_bugs_met, "TOLVAL2" = "Optima")
       # NONTARGET
     }## IF ~ input$MTTI_OTU
      
      # Calc Metrics (MTTI)
      df_met <- BioMonTools::metric.values(df_bugs_met
                                           , "bugs"
                                           , boo.Shiny = TRUE
                                           , metric_subset = "MTTI")
      
      # Add site score
      df_met <-  merge(df_met
                       , df_results_model
                       , by.x = "SAMPLEID"
                       , by.y = sel_col_sampid
                       , all.x = TRUE)
      
      # WAopt range check
      df_met[, "MTTI_LO"] <- df_met[, "MTTI"] < df_met[, "x_tv2_min"]
      df_met[, "MTTI_HI"] <- df_met[, "MTTI"] > df_met[, "x_tv2_max"]

      # Munge
      df_met <- df_met %>% 
        dplyr::relocate("MTTI", "MTTI_LO", "MTTI_HI", .after = "INDEX_CLASS")
        
      # Generate Flags
      df_met_flags <- qc.checks(df_met, df_checks)
      df_met_flags_summary <- table(df_met_flags[, "CHECKNAME"]
                                    , df_met_flags[, "FLAG"]
                                    , useNA = "ifany")
      
      # Change terminology; PASS/FAIL to NA/flag
      df_met_flags[, "FLAG"][df_met_flags[, "FLAG"] == "FAIL"] <- "flag"
      df_met_flags[, "FLAG"][df_met_flags[, "FLAG"] == "PASS"] <- NA
      # long to wide format
      df_flags_wide <- reshape2::dcast(df_met_flags
                                       , SAMPLEID ~ CHECKNAME
                                       , value.var = "FLAG")
      
      
      # Calc number of "flag"s by row.
      df_flags_wide$NumFlags <- rowSums(df_flags_wide == "flag", na.rm = TRUE)
      # Rearrange columns
      NumCols <- ncol(df_flags_wide)
      df_flags_wide <- df_flags_wide[, c(1, NumCols, 2:(NumCols - 1))]
      
      # Merge model results and Flags
      df_results <- merge(df_results_model
                            , df_flags_wide
                            , by.x = sel_col_sampid
                            , by.y = "SAMPLEID"
                            , all.x = TRUE)
 
      
      ## Calc, 08, RMD ----
      prog_detail <- "Calculate, Create Report"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      strFile.RMD <- file.path("external"
                               , "RMD_Results"
                               , "Results_MTTI_Summary.Rmd")
      strFile.RMD.format <- "html_document"
      strFile.out <- paste0(fn_input_base, "_MTTI_RESULTS.html")
      dir.export <- path_results
      rmarkdown::render(strFile.RMD
                        , output_format = strFile.RMD.format
                        , output_file = strFile.out
                        , output_dir = dir.export
                        , quiet = TRUE)
      
      ## Calc, 09, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      fn_save <- paste0(fn_input_base, "_MTTI_RESULTS.csv")
      pn_save <- file.path(path_results, fn_save)
      write.csv(df_results, pn_save, row.names = FALSE)
      
      fn_save <- paste0(fn_input_base, "_MTTI_flags_1_metrics.csv")
      pn_save <- file.path(path_results, fn_save)
      write.csv(df_met, pn_save, row.names = FALSE)
      
      fn_save <- paste0(fn_input_base, "_MTTI_flags_2_eval_long.csv")
      pn_save <- file.path(path_results, fn_save)
      write.csv(df_met_flags, pn_save, row.names = FALSE)
      
      fn_save <- paste0(fn_input_base, "_MTTI_flags_3_eval_summary.csv")
      pn_save <- file.path(path_results, fn_save)
      write.csv(df_met_flags_summary, pn_save, row.names = TRUE)
     
      ## Calc, 10, Zip Results ----
      prog_detail <- "Create Zip File"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      # button, enable, download
      shinyjs::enable("b_download_mtti")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating MTTI"
    )## withProgress ~ END
  }##expr ~ ObserveEvent ~ END
  )##observeEvent ~ b_calc_mtti ~ END
  
  #### b_download_mtti ----
  output$b_download_mtti <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_MTTI_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ MTTI
  
  # Calc, BDI ----
  
  ## BDI, UI ----
  output$UI_bdi_user_col_taxaid <- renderUI({
    str_col <- "Column, TaxaID"
    selectInput("bdi_user_col_taxaid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "TaxaID"
                , multiple = FALSE)
  })## UI_colnames
  
  output$UI_bdi_user_col_ntaxa <- renderUI({
    str_col <- "Column, Taxa Count (number of individuals or N_Taxa)"
    selectInput("bdi_user_col_ntaxa"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "N_Taxa"
                , multiple = FALSE)
  })## UI_colnames  
  
  output$UI_bdi_user_col_sampid <- renderUI({
    str_col <- "Column, Unique Sample Identifier (e.g., SampleID)"
    selectInput("bdi_user_col_sampid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "SampleID"
                , multiple = FALSE)
  })## UI_colnames  
  
  output$UI_bdi_user_col_exclude <- renderUI({
    str_col <- "Column, Exclude"
    selectInput("bdi_user_col_exclude"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "Exclude"
                , multiple = FALSE)
  })## UI_colnames
  
  # bdi_excl_watch <- reactive({
  #   # trigger for Exclude Column for BDI
  #   input$BDI_ExclTaxa
  # })## file_watch
  
  observeEvent(input$BDI_ExclTaxa, {
    cat("BDI Excl Taxa = ", input$BDI_ExclTaxa, "\n")

    # Turn on and off Excl Col selectInput
    if (input$BDI_ExclTaxa == FALSE) {
      cat("BDI Excl select, enable.\n")
      shinyjs::enable(uiOutput("UI_bdi_user_col_exclude"))
    } else if (input$BDI_ExclTaxa == TRUE) {
      cat("BDI Excl select, disable.\n")
      shinyjs::disable(uiOutput("UI_bdi_user_col_exclude"))
    } else {
      cat("BDI Excl select, enable.\n")
      shinyjs::enable(uiOutput("UI_bdi_user_col_exclude"))
    }
  })
  
  
  
  ## b_Calc_BDI ----
  observeEvent(input$b_calc_bdi, {
    shiny::withProgress({
      # 20231002, Remove user selection for Excluded taxa
      
      ### Calc, 00, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, BDI..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 10
      prog_sleep <- 0.25
      
      ## Calc, 01, Initialize ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, disable, download
      shinyjs::disable("b_download_bdi")
      
      ## Calc, 02, Gather and Test Inputs  ----
      prog_detail <- "QC Inputs"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
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
      
      df_data <- df_input
     
      # Fun Param, Define
      sel_col_sampid  <- input$bdi_user_col_sampid
      sel_col_taxaid  <- input$bdi_user_col_taxaid
      sel_col_ntaxa   <- input$bdi_user_col_ntaxa
      sel_col_exclude <- "Exclude" # input$bdi_user_col_exclude
      
      # Test Params
      
      if (!sel_col_sampid %in% names(df_input)) {
        # end process with pop up
        msg <- "'SampleID' column name is missing!"
        shinyalert::shinyalert(title = "BDI Calculation"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ sel_col_sampid
      
      if (!sel_col_taxaid %in% names(df_input)) {
        # end process with pop up
        msg <- "'TaxaID' column name is missing!"
        shinyalert::shinyalert(title = "BDI Calculation"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ sel_col_taxaid
      
      if (!sel_col_ntaxa %in% names(df_input)) {
        # end process with pop up
        msg <- "'N_Taxa' column name is missing!"
        shinyalert::shinyalert(title = "BDI Calculation"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        validate(msg)
      }## IF ~ sel_col_ntaxa
 
      if (!sel_col_exclude %in% names(df_input)) {
        if (input$BDI_ExclTaxa == FALSE) {
          # end process with pop up
          msg <- "'Exclude' column name is missing!"
          shinyalert::shinyalert(title = "BDI Calculation"
                                 , text = msg
                                 , type = "error"
                                 , closeOnEsc = TRUE
                                 , closeOnClickOutside = TRUE)
          validate(msg)
        } else {
          # Add column
          cat("Exclude column added.\n")
          sel_col_exclude <- "Exclude"
          df_input[, sel_col_exclude] <- NA
        }## IF ~ Calc ExclTaxa
      } ## IF ~ sel_col_exclude
      
      ## Calc, 03, OTU----
      prog_detail <- "Calculation, OTU"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Munge, Data 
      df_data <- df_data %>%
        dplyr::rename(sample.id = dplyr::all_of(sel_col_sampid)) %>%
        dplyr::rename(Taxon_orig = dplyr::all_of(sel_col_taxaid)) %>%
        dplyr::rename(Count = dplyr::all_of(sel_col_ntaxa))
      
      if (input$MTTI_OTU) {
        # Leave alone for now
        # Don't think an issue if already converted to OTU names
        # OTU names should be in the taxa_orig column
      }## MTTI_OTU
      
      ## Calc, 04, Exclude Taxa ----
      prog_detail <- "Calculate, Exclude Taxa"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      message(paste0("User response to generate ExclTaxa = "
                     , input$BDI_ExclTaxa))
     
      if (input$BDI_ExclTaxa) {
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
        df_input <- BioMonTools::markExcluded(df_samptax   = df_input
                                              , SampID     = sel_col_sampid
                                              , TaxaID     = sel_col_taxaid
                                              , TaxaCount  = sel_col_ntaxa
                                              , Exclude    = sel_col_exclude
                                              , TaxaLevels = phylo_all
                                              , Exceptions = NA)
        
      } else {
       # rename user input for Excl
        df_input[, "Exclude"] <- df_input[, sel_col_exclude]
      }## IF ~ input$ExclTaxa

      print(table(df_input$Exclude, useNA = "ifany"))
      
      ## Calc, 05, BDI, Metric, Values ----
      prog_detail <- "Calculate, BDI, Metric, Values"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Thresholds (came with package installation, in the MetricScoring Excel file in the extdata folder)
      fn_thresh <- file.path(system.file(package = "BioMonTools")
                             , "extdata"
                             , "MetricScoring.xlsx")
      df_thresh_metric <- read_excel(fn_thresh, sheet = "metric.scoring")
      df_thresh_index <- read_excel(fn_thresh, sheet = "index.scoring")
   
      # load data
      #path_rp <- path_excl
      #df_rp <- read.csv(path_data, stringsAsFactors = FALSE)
      df_rp <- df_input
 
      # calculate metrics for Bob's Biodiversity Index; 
      # limit output to index input metrics only
      myIndex <- "BCG_PacNW_L1"
      df_rp$INDEX_NAME   <- myIndex
      df_rp$INDEX_CLASS <- "ALL"
      (myMetrics.Bugs <- unique(as.data.frame(df_thresh_metric)[df_thresh_metric[, "INDEX_NAME"] == myIndex, "METRIC_NAME"]))


      # Run Function
      df_metric_values_bugs <- metric.values(df_rp
                                             , "bugs"
                                             , fun.MetricNames = myMetrics.Bugs
                                             , boo.Shiny = TRUE)
      
      
      ## Calc, 06, BDI, Metric, Scores ----
      prog_detail <- "Calculate, BDI, Metric, Scores"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # SCORE Metrics
      df_metric_scores_bugs <- metric.scores(DF_Metrics = df_metric_values_bugs
                                             , col_MetricNames = myMetrics.Bugs
                                             , col_IndexName = "INDEX_NAME"
                                             , col_IndexRegion = "INDEX_CLASS"
                                             , DF_Thresh_Metric = df_thresh_metric
                                             , DF_Thresh_Index = df_thresh_index)
      
      # save at end
 

      ## Calc, 08, RMD ----
      prog_detail <- "Calculate, Create Report"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      # Add factor levels
      df_metric_scores_bugs$Index_Nar <- factor(df_metric_scores_bugs$Index_Nar,
                                                levels = c("Low", "Medium", "High"))
      table(df_metric_scores_bugs$Index
            , df_metric_scores_bugs$Index_Nar
            , useNA = "ifany")
      
      strFile.RMD <- file.path("external"
                               , "RMD_Results"
                               , "Results_BDI_Summary.Rmd")
      strFile.RMD.format <- "html_document"
      strFile.out <- paste0(fn_input_base, "_BDI_RESULTS.html")
      dir.export <- path_results
      rmarkdown::render(strFile.RMD
                        , output_format = strFile.RMD.format
                        , output_file = strFile.out
                        , output_dir = dir.export
                        , quiet = TRUE)
      
      ## Calc, 09, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Excluded Taxa
      fn_excl <- paste0(fn_input_base, "_bdi_1markexcl.csv")
      dn_excl <- path_results
      pn_excl <- file.path(dn_excl, fn_excl)
      write.csv(df_input, pn_excl, row.names = FALSE)
      
      # RESULTS
      fn_save <- paste0(fn_input_base, "_BDI_RESULTS.csv")
      pn_save <- file.path(path_results, fn_save)
      write.csv(df_metric_scores_bugs, pn_save, row.names = FALSE)
      
      ## Calc, 10, Zip Results ----
      prog_detail <- "Create Zip File"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      # button, enable, download
      shinyjs::enable("b_download_bdi")
      
    }## expr ~ withProgress ~ END
    , message = "Calculating BDI"
    )## withProgress ~ END
  }##expr ~ ObserveEvent ~ END
  )##observeEvent ~ b_calc_bdi ~ END
  
  #### b_download_mtti ----
  output$b_download_bdi <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      paste0(fn_input_base
             , "_BDI_"
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ BDI
  
  #~~~~MAP~~~~----
  # MAP ----
  
  ## Map, UI ----
  
  output$UI_map_datatype <- renderUI({
    str_col <- "Select data type (calculation) to map."
    selectInput("map_datatype"
                , label = str_col
                , choices = c("", map_datatypes)
                , multiple = FALSE)
  })## UI_datatype
  
  output$UI_map_col_xlong <- renderUI({
    str_col <- "Column, Longitude (decimal degrees))"
    selectInput("map_col_xlong"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "Longitude"
                , multiple = FALSE)
  })## UI_colnames

  output$UI_map_col_ylat <- renderUI({
    str_col <- "Column, Latitude (decimal degrees)"
    selectInput("map_col_ylat"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "Latitude"
                , multiple = FALSE)
  })## UI_colnames
  
  output$UI_map_col_sampid <- renderUI({
    str_col <- "Column, SampleID (unique station or sample identifier)"
    selectInput("map_col_sampid"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "SampleID"
                , multiple = FALSE)
  })## UI_colnames 
  
  output$UI_map_col_mapval <- renderUI({
    str_col <- "Column, Value to Map (e.g., BCG, MTTI, or metric value)"
    selectInput("map_col_mapval"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "SampleID"
                , multiple = FALSE)
  })## UI_colnames 
  
  output$UI_map_col_keep <- renderUI({
    str_col <- "Additional Columns to Keep in Map Popup"
    selectInput("map_col_keep"
                , label = str_col
                , choices = c("", names(df_import()))
                , multiple = TRUE)
  })## UI_colnames  
  
  ## Map, Leaflet ----
  output$map_leaflet <- renderLeaflet({
    
    # data for plot
    df_map <- df_import()
  
#     # Rename columns based on user selection
#     df_map[, ]
    

    # 
    # col_Stations <- "blue"
    # col_Segs     <- "black" # "grey59"
    # fill_Segs    <- "lightskyblue" 
    
    
    # Map
    #leaflet() %>%
    leaflet(data = df_map) %>%
      # Groups, Base
      # addTiles(group="OSM (default)") %>%  #default tile too cluttered
      addProviderTiles("CartoDB.Positron"
                       , group = "Positron") %>%
      addProviderTiles(providers$Stamen.TonerLite
                       , group = "Toner Lite") %>%
      addProviderTiles(providers$OpenStreetMap
                       , group = "Open Street Map") %>%
      addProviderTiles(providers$Esri.WorldImagery
                       , group = "ESRI World Imagery") %>%
      # addProviderTiles(providers$USGS.USImagery
      #                  , group = "USGS Imagery") %>%
      addPolygons(data = data_GIS_eco3_orwa
                  , group = "Ecoregions, Level III"
                  , popup = ~paste0(LEVEL3, ", ", LEVEL3_NAM)) %>% 
      # addPolygons(data = data_GIS_BCGclass
      #             , group = "BCG Class"
      #             , popup = ~BCGclass_v
      #             , fillColor = rgb(255, 0, 195, maxColorValue = 255)) %>%
      # addPolygons(data = data_GIS_NorWeST_ORWA
      #             , group = "NorWeST"
      #             , popup = ~Unit_OBSPR) %>%
      # addPolygons(data = data_GIS_NHDplus_catch_ORWA
      #             , group = "NHD+ Catchments") %>%
      # addPolylines(data = data_GIS_NHDplus_flowline_ORWA
      #              , group = "NHD+ Flowline") %>%
      # # # Groups, Overlay
      # addCircles(lng = ~longitude
      #            , lat = ~latitude
      #            , color = col_Stations
      #            , popup = ~paste0("Station: ", station, as.character("<br>")
      #                            , "Latitude: ", latitude, as.character("<br>")
      #                            , "Longitude: ", longitude, as.character("<br>")
      #                            )
      #            , radius = 30
      #            , group = "Stations") %>%
      # # Legend
      # addLegend("bottomleft"
      #           , colors = c(col_Stations, col_Segs)
      #           , labels = c("Stations", "CB Outline")
      #           , values = NA) %>%
      # Layers, Control
      addLayersControl(baseGroups = c("Positron"
                                      , "Toner Lite"
                                      , "Open Street Map"
                                      , "ESRI World Imagery"
                                      # , "USGS Imagery"
                                      )
                       , overlayGroups = c("Ecoregions, Level III"
                                           # , "BCG Class"
                                           # , "NorWeST"
                                           # , "NHD+ Catchments"
                                          # , "NHD+ Flowlines"
                                           )
                       ) %>%
      # Layers, Hide
      hideGroup(c("Ecoregions, Level III"
                 # , "BCG Class"
                 # , "NorWeST"
                 # , "NHD+ Catchments"
                 # , "NHD+ Flowlines"
      )) %>%
      # # Mini map
      addMiniMap(toggleDisplay = TRUE) #%>%
      # # Hide Groups
      # hideGroup("CB Outline")
    
        
  })## map_leaflet ~ END
  
  ## Map, Leaflet, Proxy ----
  # update map based on user selections
  # tied to Update button
  # https://rstudio.github.io/leaflet/shiny.html
  # need a reactive to trigger, use map update button
  observeEvent(input$but_map_update, {
    
    ### Data ----
    df_map <- df_import()
    names_data <- names(df_map)
    
    no_narrative <- "No Narrative Designation"    
    size_default <- 50
    
    ### Map_L_P, Gather and Test Inputs----
    sel_map_datatype   <- input$map_datatype
    sel_map_col_xlong  <- input$map_col_xlong
    sel_map_col_ylat   <- input$map_col_ylat
    sel_map_col_sampid <- input$map_col_sampid
    sel_map_col_keep   <- input$map_col_keep
    
    sel_map_col_mapval <- NA_character_
    sel_map_col_mapnar <- NA_character_
    sel_map_col_color  <- NA_character_
    
    if (is.null(sel_map_datatype) | sel_map_datatype == "") {
      # end process with pop up
      msg <- "'Data Type' name is missing!"
      shinyalert::shinyalert(title = "Update Map"
                             , text = msg
                             , type = "error"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      validate(msg)
    }## IF ~ sel_map_datatype
    
    if (is.null(sel_map_col_xlong) | sel_map_col_xlong == "") {
      # end process with pop up
      msg <- "'Longitude' column name is missing!"
      shinyalert::shinyalert(title = "Update Map"
                             , text = msg
                             , type = "error"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      validate(msg)
    }## IF ~ sel_map_col_xlong
    
    if (is.null(sel_map_col_ylat) | sel_map_col_ylat == "") {
      # end process with pop up
      msg <- "'Latitude' column name is missing!"
      shinyalert::shinyalert(title = "Update Map"
                             , text = msg
                             , type = "error"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      validate(msg)
    }## IF ~ sel_map_col_ylat
    
    if (is.null(sel_map_col_sampid) | sel_map_col_sampid == "") {
      # end process with pop up
      msg <- "'SampleID' column name is missing!"
      shinyalert::shinyalert(title = "Update Map"
                             , text = msg
                             , type = "error"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      validate(msg)
    }## IF ~ sel_map_col_sampid
 
    ### Munge Data ----
    #### Munge, Val, Nar, Size
    if (sel_map_datatype == "BCG") {
      sel_map_col_mapval <- "BCG_Status"
      sel_map_col_mapnar <- "BCG_Status2"
    } else if (sel_map_datatype == "Fuzzy Temp Model") {
      sel_map_col_mapval <- "Continuous_Therm"
      sel_map_col_mapnar <- "Therm_Class"
    } else if (sel_map_datatype == "MTTI") {
      sel_map_col_mapval <- "MTTI"
      sel_map_col_mapnar <- "Map_Nar"
      df_map[, sel_map_col_mapnar] <- NA_character_
      cut_brk <- c(-1, 16, 19, 21, 23, 9999)
      cut_lab <- c("< 16"
                  , "16 - 18.9"
                  , "19 - 20.9"
                  , "21 - 22.9"
                  , ">= 23")
      df_map[, sel_map_col_mapnar] <- cut(df_map[, sel_map_col_mapval]
                                   , breaks = cut_brk
                                   , labels = cut_lab
                                   , include.lowest = TRUE
                                   , right = FALSE
                                   , ordered_result = TRUE)
    } else if (sel_map_datatype == "BDI") {
      sel_map_col_mapval <- "Index"
      sel_map_col_mapnar <- "Index_Nar"
    } else if (sel_map_datatype == "Thermal Metrics, nt_ti_stenocold") {
      sel_map_col_mapval <- "nt_ti_stenocold"
      sel_map_col_mapnar <- "Map_Nar"
      df_map[, sel_map_col_mapnar] <- NA_character_
      cut_brk <- c(-1, 1, 3, 9999)
      cut_lab <- c("absent"
                   , "1 or 2"
                   , ">= 3")
      df_map[, sel_map_col_mapnar] <- cut(df_map[, sel_map_col_mapval]
                                          , breaks = cut_brk
                                          , labels = cut_lab
                                          , include.lowest = TRUE
                                          , right = FALSE
                                          , ordered_result = TRUE)
    } else if (sel_map_datatype == "Thermal Metrics, nt_ti_stenocold_cold") {
      sel_map_col_mapval <- "nt_ti_stenocold_cold"
      sel_map_col_mapnar <- "Map_Nar"
      df_map[, sel_map_col_mapnar] <- NA_character_
      cut_brk <- c(-1, 1, 3, 5, 10, 9999)
      cut_lab <- c("absent"
                   , "1 or 2"
                   , "3 or 4"
                   , "5 - 9"
                   , ">= 10
                   ")
      df_map[, sel_map_col_mapnar] <- cut(df_map[, sel_map_col_mapval]
                                          , breaks = cut_brk
                                          , labels = cut_lab
                                          , include.lowest = TRUE
                                          , right = FALSE
                                          , ordered_result = TRUE)
    } else if (sel_map_datatype == "Thermal Metrics, nt_ti_stenocold_cold_cool") {
      sel_map_col_mapval <- "nt_ti_stenocold_cold_cool"
      sel_map_col_mapnar <- "Map_Nar"
      df_map[, sel_map_col_mapnar] <- NA_character_
      cut_brk <- c(-1, 9, 20, 25, 30, 9999)
      cut_lab <- c("< 9"
                   , "9 - 19"
                   , "20 - 24"
                   , "25 - 29"
                   , ">= 30")
      df_map[, sel_map_col_mapnar] <- cut(df_map[, sel_map_col_mapval]
                                          , breaks = cut_brk
                                          , labels = cut_lab
                                          , include.lowest = TRUE
                                          , right = FALSE
                                          , ordered_result = TRUE)
      
    } else if (sel_map_datatype == "Thermal Metrics, pt_ti_stenocold_cold_cool") {
      sel_map_col_mapval <- "pt_ti_stenocold_cold_cool"
      sel_map_col_mapnar <- "Map_Nar"
      df_map[, sel_map_col_mapnar] <- NA_character_
      cut_brk <- c(-1, 20, 35, 50, 65, 9999)
      cut_lab <- c("< 20"
                   , "20 - 34.9"
                   , "35 - 49.9"
                   , "50 - 64.9"
                   , ">= 65")
      df_map[, sel_map_col_mapnar] <- cut(df_map[, sel_map_col_mapval]
                                          , breaks = cut_brk
                                          , labels = cut_lab
                                          , include.lowest = TRUE
                                          , right = FALSE
                                          , ordered_result = TRUE)
      
    } else if (sel_map_datatype == "Thermal Metrics, pi_ti_stenocold_cold_cool") {
      sel_map_col_mapval <- "pi_ti_stenocold_cold_cool"
      sel_map_col_mapnar <- "Map_Nar"
      df_map[, sel_map_col_mapnar] <- NA_character_
      cut_brk <- c(-1, 10, 30, 40, 55, 9999)
      cut_lab <- c("< 10"
                   , "10 - 29.9"
                   , "30 - 39.9"
                   , "40 - 54.9"
                   , ">= 55")
      df_map[, sel_map_col_mapnar] <- cut(df_map[, sel_map_col_mapval]
                                          , breaks = cut_brk
                                          , labels = cut_lab
                                          , include.lowest = TRUE
                                          , right = FALSE
                                          , ordered_result = TRUE)
      
    } else if (sel_map_datatype == "Thermal Metrics, pt_ti_warm_stenowarm") {
      sel_map_col_mapval <- "pt_ti_warm_stenowarm"
      sel_map_col_mapnar <- "Map_Nar"
      df_map[, sel_map_col_mapnar] <- NA_character_
      cut_brk <- c(-1, 5, 10, 15, 40, 9999)
      cut_lab <- c("< 5"
                   , "5 - 9.9"
                   , "10 - 14.9"
                   , "15 - 39.9"
                   , ">= 40")
      df_map[, sel_map_col_mapnar] <- cut(df_map[, sel_map_col_mapval]
                                          , breaks = cut_brk
                                          , labels = cut_lab
                                          , include.lowest = TRUE
                                          , right = FALSE
                                          , ordered_result = TRUE)
      
    } else if (sel_map_datatype == "Thermal Metrics, nt_ti_warm_stenowarm") {
      sel_map_col_mapval <- "nt_ti_warm_stenowarm"
      sel_map_col_mapnar <- "Map_Nar"
      df_map[, sel_map_col_mapnar] <- NA_character_
      cut_brk <- c(-1, 2, 9999)
      cut_lab <- c("NA"
                   , ">= 2")
      df_map[, sel_map_col_mapnar] <- cut(df_map[, sel_map_col_mapval]
                                          , breaks = cut_brk
                                          , labels = cut_lab
                                          , include.lowest = TRUE
                                          , right = FALSE
                                          , ordered_result = TRUE)
      
    }## IF ~ sel_datatype ~ END
    

    # QC, Value in data frame
    boo_map_col_mapval <- sel_map_col_mapval %in% names_data
    if (boo_map_col_mapval == FALSE) {
      # end process with pop up
      msg <- paste0("Map Value column name ("
                    , sel_map_col_mapval
                    , ") is missing!")
      shinyalert::shinyalert(title = "Update Data"
                             , text = msg
                             , type = "error"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      validate(msg)
    }## IF ~ sel_map_col_sampid
    

    
    # Rename Columns to known values
    ## Add Jitter to Lat-Long to avoid overlap
    # 1 second ~ 1/3600 ~ 0.000278 ~ 37.5 meters
    # 7 seconds ~ 262.3 meters
    jit_fac <- 7/3600 
    nrow_data <- nrow(df_map)
    noise_y <- runif(nrow_data, -jit_fac, jit_fac)
    noise_x <- runif(nrow_data, -jit_fac, jit_fac)
    
    df_map <- df_map %>%
      mutate(map_ID = df_map[, sel_map_col_sampid]
             # , map_ylat = jitter(df_map[, sel_map_col_ylat], jit_fac)
             # , map_xlong = jitter(df_map[, sel_map_col_xlong], jit_fac)
             , map_ylat = df_map[, sel_map_col_ylat] + noise_y
             , map_xlong = df_map[, sel_map_col_xlong] + noise_x
             , map_mapval = df_map[, sel_map_col_mapval]
             , map_mapnar = df_map[, sel_map_col_mapnar]
             , map_color = NA_character_
             , map_size = NA_real_
             , map_popup = paste0(as.character("<b>"), "SampleID: ", as.character("</b>"), df_map[, sel_map_col_sampid], as.character("<br>")
                                  , as.character("<b>"), "Latitude: ", as.character("</b>"), df_map[, sel_map_col_ylat], as.character("<br>")
                                  , as.character("<b>"), "Longitude: ", as.character("</b>"), df_map[, sel_map_col_xlong], as.character("<br>")
                                  , as.character("<b>"), "Data Type: ", as.character("</b>"), sel_map_datatype, as.character("<br>")
                                  , as.character("<b>"), "Value: ", as.character("</b>"), df_map[, sel_map_col_mapval], as.character("<br>")
                                  , as.character("<b>"), "Narrative: ", as.character("</b>"), df_map[, sel_map_col_mapnar], as.character("<br>")
                                  )
             )
    
    ### Munge, Color, Size, Legend
    # by index value or narrative
    if (sel_map_datatype == "BCG") {
      leg_title <- "Biological Condition Gradient"
      # cut_brk <- seq(0.5, 6.5, 1)
      # cut_lab <- c("blue", "green", "lightgreen", "gray", "orange", "red")
      # leg_col <- cut_lab
      # leg_nar <- paste0("L", 1:6)
      # df_map[, "map_color"] <- cut(df_map[, "map_mapval"]
      #                              , breaks = cut_brk
      #                              , labels = cut_lab
      #                              , include.lowest = TRUE
      #                              , right = FALSE
      #                              , ordered_result = TRUE)
      leg_col <- c("blue"
                   , "green" 
                   , "darkgreen"
                   , "lightgreen"
                   , "yellow"
                   , "gray"
                   , "brown"
                   , "orange"
                   , "purple"
                   , "red"
                   , "#808080"
      )
      leg_nar <- c("1"
                   , "2"
                   , "2.5"
                   , "3"
                   , "3.5"
                   , "4"
                   , "4.5"
                   , "5"
                   , "5.5"
                   , "6"
                   , "NA"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapval == leg_nar[1] ~ leg_col[1]
                                     , map_mapval == leg_nar[2] ~ leg_col[2]
                                     , map_mapval == leg_nar[3] ~ leg_col[3]
                                     , map_mapval == leg_nar[4] ~ leg_col[4]
                                     , map_mapval == leg_nar[5] ~ leg_col[5]
                                     , map_mapval == leg_nar[6] ~ leg_col[6]
                                     , map_mapval == leg_nar[7] ~ leg_col[7]
                                     , map_mapval == leg_nar[8] ~ leg_col[8]
                                     , map_mapval == leg_nar[9] ~ leg_col[9]
                                     , map_mapval == leg_nar[10] ~ leg_col[10]
                                     , TRUE ~ leg_col[11]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- size_default
    } else if (sel_map_datatype == "Fuzzy Temp Model") {
      leg_title <- "Fuzzy Temp Model"
      ## v1
      # leg_col <- c("#00B0F0"
      #              , "#8EA9DB" 
      #              , "#8EA9DB" 
      #              , "#8EA9DB"
      #              , "#B4C6E7"
      #              , "#BDD7EE"
      #              , "#BDD7EE"
      #              , "#BDD7EE"
      #              , "#DDEBF7"
      #              , "#F2F2F2"
      #              , "#F2F2F2"
      #              , "#F2F2F2"
      #              , "#F8CBAD"
      #              , "#808080"
      # )
      ## v2
      # leg_col <- c(blues9[9]
      #              , blues9[8]
      #              , blues9[8]
      #              , blues9[8]
      #              , blues9[7]
      #              , blues9[6]
      #              , blues9[6]
      #              , blues9[6]
      #              , blues9[5]
      #              , blues9[4]
      #              , blues9[4]
      #              , blues9[4]
      #              , "#F8CBAD"
      #              , "#808080"
      # )
      ## v3
      leg_col <- c("#140AE6"
                   , "#0066FF"
                   , "#7B9BF5"
                   , "#0AE1EC"
                   , "#9AF3FC"
                   , "#BEFEFB"
                   , "#DDFBFF"
                   , "#C6FFB9"
                   , "#34FB25"
                   , "#FFFF66"
                   , "#FFFFE5"
                   , "#E4DFEC"
                   , "#FFC000"
                   , "#808080"
      )
      leg_nar <- c("VeryCold"
                   , "VCold_Cold"
                   , "TIE_VCold_Cold"
                   , "Cold_VCold"
                   , "Cold"
                   , "Cold_Cool"
                   , "TIE_Cold_Cool"
                   , "Cool_Cold"
                   , "Cool"
                   , "Cool_Warm"
                   , "TIE_Warm_Cool"
                   , "Warm_Cool"
                   , "Warm"
                   , "NA"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , map_mapnar == leg_nar[2] ~ leg_col[2]
                                     , map_mapnar == leg_nar[3] ~ leg_col[3]
                                     , map_mapnar == leg_nar[4] ~ leg_col[4]
                                     , map_mapnar == leg_nar[5] ~ leg_col[5]
                                     , map_mapnar == leg_nar[6] ~ leg_col[6]
                                     , map_mapnar == leg_nar[7] ~ leg_col[7]
                                     , map_mapnar == leg_nar[8] ~ leg_col[8]
                                     , map_mapnar == leg_nar[9] ~ leg_col[9]
                                     , map_mapnar == leg_nar[10] ~ leg_col[10]
                                     , map_mapnar == leg_nar[11] ~ leg_col[11]
                                     , map_mapnar == leg_nar[12] ~ leg_col[12]
                                     , map_mapnar == leg_nar[13] ~ leg_col[13]
                                     , TRUE ~ leg_col[14]
                                      ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- size_default
    } else if (sel_map_datatype == "MTTI") {
      leg_title <- "MTTI"
      leg_col <- c("#00B0F0"
                   , "#9AF3FC" 
                   , "#92D050" 
                   , "#FFFF00"
                   , "#FFC000"
                   , "#808080"
      )
      leg_nar <- c("< 16"
                     , "16 - 18.9"
                     , "19 - 20.9"
                     , "21 - 22.9"
                     , ">= 23"
                   , "NA"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , map_mapnar == leg_nar[2] ~ leg_col[2]
                                     , map_mapnar == leg_nar[3] ~ leg_col[3]
                                     , map_mapnar == leg_nar[4] ~ leg_col[4]
                                     , map_mapnar == leg_nar[5] ~ leg_col[5]
                                     , TRUE ~ leg_col[6]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- df_map$map_mapval
    } else if (sel_map_datatype == "BDI") {
      leg_title <- "BioDiversity Index"
      cut_brk <- c(0, 20, 30, 999)
      cut_lab <- c("gray", "lightgreen", "blue")
      leg_col <- rev(cut_lab)
      leg_nar <- rev(c("Low", "Medium", "High"))
      df_map[, "map_color"] <- cut(df_map[, "map_mapval"]
                                   , breaks = cut_brk
                                   , labels = cut_lab
                                   , include.lowest = TRUE
                                   , right = FALSE
                                   , ordered_result = TRUE)
      df_map[, "map_size"] <- size_default
      # REVERSE ORDER FOR LEGEND
      
      
    } else if (sel_map_datatype == "Thermal Metrics, nt_ti_stenocold") {
      leg_title <- "cold stenotherm taxa"
      leg_col <- c("#00B0F0"
                   , "#9AF3FC" 
                   , "#808080"
      )
      leg_nar <- c(">= 3"
                   , "1 or 2"
                   , "absent"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , map_mapnar == leg_nar[2] ~ leg_col[2]
                                     , TRUE ~ leg_col[3]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- df_map$map_mapval
    } else if (sel_map_datatype == "Thermal Metrics, nt_ti_stenocold_cold") {
      leg_title <- "cold stenotherm + cold taxa"
      leg_col <- c("#00B0F0"
                   , "#9AF3FC" 
                   , "#92D050" 
                   , "#FFFF00"
                   , "#808080"
      )
      leg_nar <- c(">= 10"
                   , "5 - 9"
                   , "3 or 4"
                   , "1 or 2"
                   , "absent"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , map_mapnar == leg_nar[2] ~ leg_col[2]
                                     , map_mapnar == leg_nar[3] ~ leg_col[3]
                                     , map_mapnar == leg_nar[4] ~ leg_col[4]
                                     , TRUE ~ leg_col[5]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- df_map$map_mapval
    } else if (sel_map_datatype == "Thermal Metrics, nt_ti_stenocold_cold_cool") {
      leg_title <- "# cold stenotherm + cold + cool taxa"
      leg_col <- c("#00B0F0"
                   , "#9AF3FC" 
                   , "#92D050" 
                   , "#FFFF00"
                   , "#FFC000"
                   , "#808080"
      )
      leg_nar <- c(">= 30"
                   , "25 - 29"
                   , "20 - 24"
                   , "9 - 19"
                   , "< 9"
                   , "NA"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , map_mapnar == leg_nar[2] ~ leg_col[2]
                                     , map_mapnar == leg_nar[3] ~ leg_col[3]
                                     , map_mapnar == leg_nar[4] ~ leg_col[4]
                                     , map_mapnar == leg_nar[5] ~ leg_col[5]
                                     , TRUE ~ leg_col[6]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- df_map$map_mapval
    } else if (sel_map_datatype == "Thermal Metrics, pt_ti_stenocold_cold_cool") {
      leg_title <- "% cold stenotherm + cold + cool taxa"
      leg_col <- c("#00B0F0"
                   , "#9AF3FC" 
                   , "#92D050" 
                   , "#FFFF00"
                   , "#FFC000"
                   , "#808080"
      )
      leg_nar <- c(">= 65"
                   , "50 - 64.9"
                   , "35 - 49.9"
                   , "20 - 34.9"
                   , "< 20"
                   , "NA"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , map_mapnar == leg_nar[2] ~ leg_col[2]
                                     , map_mapnar == leg_nar[3] ~ leg_col[3]
                                     , map_mapnar == leg_nar[4] ~ leg_col[4]
                                     , map_mapnar == leg_nar[5] ~ leg_col[5]
                                     , TRUE ~ leg_col[6]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- df_map$map_mapval
    } else if (sel_map_datatype == "Thermal Metrics, pi_ti_stenocold_cold_cool") {
      leg_title <- "% cold stenotherm + cold + cool indiv"
      leg_col <- c("#00B0F0"
                   , "#9AF3FC" 
                   , "#92D050" 
                   , "#FFFF00"
                   , "#FFC000"
                   , "#808080"
      )
      leg_nar <- c(">= 55"
                   , "40 - 54.9"
                   , "30 - 39.9"
                   , "10 - 29.9"
                   , "< 10"
                   , "NA"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , map_mapnar == leg_nar[2] ~ leg_col[2]
                                     , map_mapnar == leg_nar[3] ~ leg_col[3]
                                     , map_mapnar == leg_nar[4] ~ leg_col[4]
                                     , map_mapnar == leg_nar[5] ~ leg_col[5]
                                     , TRUE ~ leg_col[6]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- df_map$map_mapval
    } else if (sel_map_datatype == "Thermal Metrics, pt_ti_warm_stenowarm") {
      leg_title <- "% warm + warm stenotherm taxa"
      leg_col <- c("#00B0F0"
                   , "#9AF3FC" 
                   , "#92D050" 
                   , "#FFFF00"
                   , "#FFC000"
                   , "#808080"
      )
      leg_nar <- c("< 5"
                   , "5 - 9.9"
                   , "10 - 14.9"
                   , "15 - 39.9"
                   , ">= 40"
                   , "NA"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , map_mapnar == leg_nar[2] ~ leg_col[2]
                                     , map_mapnar == leg_nar[3] ~ leg_col[3]
                                     , map_mapnar == leg_nar[4] ~ leg_col[4]
                                     , map_mapnar == leg_nar[5] ~ leg_col[5]
                                     , TRUE ~ leg_col[6]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- df_map$map_mapval
    } else if (sel_map_datatype == "Thermal Metrics, nt_ti_warm_stenowarm") {
      leg_title <- "warm stenotherm taxa"
      leg_col <- c("#FFC000"
                   , "#808080"
      )
      leg_nar <- c(">= 2"
                   , "NA"
      )
      df_map <- df_map %>%
        mutate(map_color = case_when(map_mapnar == leg_nar[1] ~ leg_col[1]
                                     , TRUE ~ leg_col[2]
        ))
      # TRUE is ELSE and #808080 is gray
      df_map[, "map_size"] <- df_map$map_mapval
    } else {
      leg_title <- NA
      df_map[, "map_color"] <- "gray"
      df_map[, "map_size"] <- size_default
      leg_col <- "gray"
      leg_nar <- no_narrative
    }## IF ~ sel_datatype ~ COLOR
    
    

    ### Map ----
    # Bounding box
    map_bbox <- c(min(df_map[, sel_map_col_xlong], na.rm = TRUE)
                  , min(df_map[, sel_map_col_ylat], na.rm = TRUE)
                  , max(df_map[, sel_map_col_xlong], na.rm = TRUE)
                  , max(df_map[, sel_map_col_ylat], na.rm = TRUE)
    )
    
    #~~~~~~~~~~~~~~~~~~~~~~
    # repeat code from base
    #~~~~~~~~~~~~~~~~~~~~~~
    
    #leaflet() %>%
    leafletProxy("map_leaflet", data = df_map) %>%
      # Groups, Base
      # addProviderTiles("CartoDB.Positron"
      #                  , group = "Positron") %>%
      # addProviderTiles(providers$Stamen.TonerLite
      #                  , group = "Toner Lite") %>%
      # addProviderTiles(providers$OpenStreetMap
      #                  , group = "Open Street Map") %>%
      clearControls() %>%
      # Groups, Overlay
      addCircles(lng = ~map_xlong
                 , lat = ~map_ylat
                 , color = ~map_color
                 , popup = ~map_popup
                 , radius = ~map_size
                 , group = "Samples") %>%
      # Test different points
      # addAwesomeMarkers(lng = ~map_xlong
      #                   , lat = ~map_ylat
      #                   , popup = ~map_popup
      #                   , clusterOptions = markerClusterOptions()) %>%
      # Legend
      addLegend("bottomleft"
                , colors = leg_col
                , labels = leg_nar
                , values = NA
                , title = leg_title) %>%
      # Layers, Control
      addLayersControl(baseGroups = c("Positron"
                                      , "Toner Lite"
                                      , "Open Street Map"
                                      , "ESRI World Imagery")
                       , overlayGroups = c("Samples"
                                           , "Ecoregions, Level III"
                                           #, "BCG Class"
                                           # , "NorWeST"
                                           # , "NHD+ Catchments"
                                          # , "NHD+ Flowlines"
                                           )
                      ) %>%
      # Layers, Hide
      hideGroup(c("Ecoregions, Level III"
                 # , "BCG Class"
                 # , "NorWeST"
                 # , "NHD+ Catchments"
                 # , "NHD+ Flowlines"
                )) %>%
      # Bounds
      fitBounds(map_bbox[1], map_bbox[2], map_bbox[3], map_bbox[4])
      

  })## MAP, Leaflet, PROXY
  
  
  #~~~~REPORTS~~~~----
  
})##shinyServer ~ END
