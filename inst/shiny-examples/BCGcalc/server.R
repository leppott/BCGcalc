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
  
  output$fn_input_display_rep_single <- renderText({
    inFile <- input$fn_input_rep_single
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_rep_single
  
  output$fn_input_display_rep_multi <- renderText({
    inFile <- input$fn_input_rep_multi
    
    if (is.null(inFile)) {
      return("..No file uploaded yet...")
    }##IF~is.null~END
    
    return(paste0("'", inFile$name, "'"))
    
  })## fn_input_display_rep_multi
  
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
    
    # Remove existing files in "results"
    clean_results()
    
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

    # Copy user files to results sub-folder
    copy_import_file(import_file = input$fn_input)
    
    ## button, enable, calc ----
    shinyjs::enable("b_calc_taxatrans")
    shinyjs::enable("b_calc_indexclass")
    shinyjs::enable("b_calc_indexclassparam")
    shinyjs::enable("b_calc_bcg")
    shinyjs::enable("b_calc_met_therm")
    shinyjs::enable("b_calc_modtherm")
    shinyjs::enable("b_calc_mtti")
    shinyjs::enable("b_calc_bdi")
    
    # shinyjs::enable("b_calc_rep_single")
    # shinyjs::enable("b_calc_rep_multi")
    
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
      prog_n <- 7
      prog_sleep <- 0.25
      
      ## Calc, 01, Import User Data ----
      prog_detail <- "Import Data, User"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input)
      
      # result folder and files
      fn_abr <- abr_taxatrans
      fn_abr_save <- paste0("_", fn_abr, "_")
      # path_results_sub <- file.path(path_results
      #                               , paste(abr_results, fn_abr, sep = "_"))
      # # Add "Results" folder if missing
      # boo_Results <- dir.exists(file.path(path_results_sub))
      # if (boo_Results == FALSE) {
      #   dir.create(file.path(path_results_sub))
      # }
      # Add "reference" folder if missing
      path_results_ref <- file.path(path_results, dn_files_ref)
      boo_Results <- dir.exists(file.path(path_results_ref))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_ref))
      }
      # Add "Results" folder based on user selection later in this step
      
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
      fn_taxoff_attr_meta <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                       , "attributes_metadata_filename"] 
      col_taxaid_attr <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                        , "attributes_taxaid"] 
      sel_user_sampid <- input$taxatrans_user_col_sampid
  
      sel_taxaid_drop <-  df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                     , "taxaid_drop"] 
      dir_proj_results <- df_pick_taxoff[df_pick_taxoff$project == sel_proj
                                         , "dir_results"] 
      
      
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

      dn_files <- paste(abr_results, dir_proj_results, sep = "_")
      
      # Add "Results" folder if missing
      path_results_sub <- file.path(path_results, dn_files)
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
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
                , httr::write_disk(temp_taxoff <- tempfile(fileext = ".csv")))
      
      df_taxoff <- read.csv(temp_taxoff)
      
      ## Data, Official Taxa, Meta Data----
      if (!is.null(fn_taxoff_meta)) {
        url_taxoff_meta <- file.path(url_bmt_base
                                     , "taxa_official"
                                     , fn_taxoff_meta)
        httr::GET(url_taxoff_meta
            , httr::write_disk(temp_taxoff_meta <- tempfile(fileext = ".csv")))
        
        df_taxoff_meta <- read.csv(temp_taxoff_meta)
      }## IF ~ fn_taxaoff_meta

      ## Data, Official Attributes----
      if (!is.null(fn_taxoff_attr)) {
        url_taxoff_attr <- file.path(url_bmt_base
                                     , "taxa_official"
                                     , fn_taxoff_attr)
        httr::GET(url_taxoff_attr
            , httr::write_disk(temp_taxoff_attr <- tempfile(fileext = ".csv")))
        
        df_taxoff_attr <- read.csv(temp_taxoff_attr)
      }## IF ~ fn_taxoff_attr
      
      ## Data, Official Attributes, Meta Data----
      if (!is.null(fn_taxoff_meta)) {
        url_taxoff_attr_meta <- file.path(url_bmt_base
                                     , "taxa_official"
                                     , fn_taxoff_attr_meta)
        httr::GET(url_taxoff_attr_meta
                  , httr::write_disk(temp_taxoff_attr_meta <- tempfile(fileext = ".csv")))
        
        df_taxoff_attr_meta <- read.csv(temp_taxoff_attr_meta)
      }## IF ~ fn_taxaoff_meta

      
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
      # 20231201, only if have Noteworthy
      if ("NOTEWORTHY" %in% toupper(taxatrans_results$merge)) {
        taxatrans_results$merge$Noteworthy <- ifelse(is.na(taxatrans_results$merge$Noteworthy)
                                                     , FALSE
                                                     , TRUE)
      }## IF ~ Noteworthy
      
      
      ## Calc, 04, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Save files

      ## File version names
      df_save <- data.frame(Calculation = sel_proj
                            , OperationalTaxonomicUnit = col_taxaid_official_project
                            , TranslationTable = fn_taxoff
                            , AttributeTable = fn_taxoff_attr)
      fn_part <- paste0(dir_proj_results, fn_abr_save, "source", ".csv")
      write.csv(df_save
                , file.path(path_results_sub, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## Taxa User 
      # saved when imported
      
      # 2023-11-03, save original filenames
      # add taxatrans metadata
      
      ## Taxa Official
      # df_save <- df_official
      # fn_part <- paste0(fn_abr_save, "1official", ".csv")
      # write.csv(df_save
      #           , file.path(path_results_ref, paste0(fn_input_base, fn_part))
      #           , row.names = FALSE)
      # rm(df_save, fn_part)
      file.copy(temp_taxoff
                , file.path(path_results_ref, fn_taxoff))
      
      ## Taxa Official, meta data
      # df_save <- taxatrans_results$official_metadata # df_taxoff_meta
      # fn_part <- paste0(fn_abr_save, "1metadata", ".csv")
      # write.csv(df_save
      #           , file.path(path_results_ref, paste0(fn_input_base, fn_part))
      #           , row.names = FALSE)
      # rm(df_save, fn_part)
      file.copy(temp_taxoff_meta
                , file.path(path_results_ref, fn_taxoff_meta))
      
      ## Taxa Official, Attributes
      # df_save <- df_taxoff_attr
      # fn_part <- paste0(path_results_ref, "1attributes", ".csv")
      # write.csv(df_save
      #           , file.path(path_results, paste0(fn_input_base, fn_part))
      #           , row.names = FALSE)
      # rm(df_save, fn_part)
      file.copy(temp_taxoff_attr
                , file.path(path_results_ref, fn_taxoff_attr))
     
      ## Taxa Official, Attributes, meta data
      # df_save <- taxatrans_results$official_metadata # df_taxoff_meta
      # fn_part <- paste0(fn_abr_save, "1metadata", ".csv")
      # write.csv(df_save
      #           , file.path(path_results_ref, paste0(fn_input_base, fn_part))
      #           , row.names = FALSE)
      # rm(df_save, fn_part)
      file.copy(temp_taxoff_attr_meta
                , file.path(path_results_ref, fn_taxoff_attr_meta))
     
      ## translate - crosswalk
      df_save <- taxatrans_results$taxatrans_unique # df_taxoff_meta
      fn_part <- paste0(dir_proj_results, fn_abr_save, "modify", ".csv")
      write.csv(df_save
                , file.path(path_results_sub, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## Non Match
      df_save <- data.frame(taxatrans_results$nonmatch)
      fn_part <- paste0(dir_proj_results, fn_abr_save, "nonmatch", ".csv")
      write.csv(df_save
                , file.path(path_results_sub, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## Taxa Trans
      df_save <- taxatrans_results$merge
      fn_part <- paste0(dir_proj_results, fn_abr_save, "TAXAATTR", ".csv")
      write.csv(df_save
                , file.path(path_results_sub, fn_part)
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
 
      ## Calc, 06, Info Pop Up ----
      prog_detail <- "Calculate, Info"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
     
      # Inform user about number of taxa mismatches
      ## calc number of mismatch
      df_mismatch <- data.frame(taxatrans_results$nonmatch)
      n_taxa_mismatch <- nrow(df_mismatch)
      msg <- paste0("Number of mismatch taxa = ", n_taxa_mismatch, "\n\n"
                    , "Any mismatched taxa in 'mismatch' file in results download.")
      shinyalert::shinyalert(title = "Taxa Translate, Non Matching Taxa"
                             , text = msg
                             , type = "info"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      #validate(msg)
      
      ## Calc, 07, Clean Up ----
      prog_detail <- "Calculate, Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      rm(df_mismatch)
      
      # button, enable, download
      shinyjs::enable("b_download_taxatrans")
      
    }## expr ~ withProgress ~ END
    , message = "Taxa Translator"
    )## withProgress
    
  }##expr ~ ObserveEvent
  
  )##observeEvent ~ b_taxatrans_calc
  
  ## b_download_TaxaTrans ----
  output$b_download_taxatrans <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      fn_abr <- abr_taxatrans
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
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
      prog_n <- 9
      prog_sleep <- 0.25
      
      ## Calc, 01, Import User Data ----
      prog_detail <- "Import Data, User"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input)
      
      # result folder and files
      fn_abr <- abr_bcg
      fn_abr_save <- paste0("_", fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }

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
        # validate(msg)
      }## IF ~ sel_col_sampid
      
      if (sel_col_lat == "") {
        # end process with pop up
        msg <- "'Latitude' column name is missing!"
        shinyalert::shinyalert(title = "Generate Index Class Parameters"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # validate(msg)
      }## IF ~ sel_col_lat
      
      if (sel_col_lon == "") {
        # end process with pop up
        msg <- "'Longitude' column name is missing!"
        shinyalert::shinyalert(title = "Generate Index Class Parameters"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # validate(msg)
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
  
      # 2023-11-04
      # Crashes if include in input file the new fields
      flds_new <- c("COMID"
                    , "WSAREASQKM"
                    , "elev_m"
                    , "IWI"
                    , "ICI"
                    , "PRECIP8110CAT"
                    , "pslope_nhd"
                    , "slopelenkm"
                    , "gnis_name"
                    , "streamorde"
                    , "ftype"
                    , "fcode"
                    , "L3_eco")
      boo_dup <- toupper(names(df_sites)) %in% toupper(flds_new)
      if (sum(boo_dup) > 0) {
        names_dup <- names(df_sites)[boo_dup]
        names_old <- paste0(names(df_sites), "_OLD")
        names(df_sites)[boo_dup] <- names_old[boo_dup]
      }## IF ~ boo_dup
      
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
        # validate(msg)
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
      
      ## Calc, 05, Run Function, Eco_L3 ----
      prog_detail <- "Ecoregion, Level III"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
   
      # verified Lat and Long above

      # Calc Ecoregions
      df_eco3 <- MazamaSpatialUtils::getSpatialData(df_sites[, sel_col_lon]
                                                    , df_sites[, sel_col_lat]
                                                    , data_GIS_eco3_orwa)
      
      # different order from df_sites to df_results
      
      df_eco3[, sel_col_sampid] <- df_sites[, sel_col_sampid]
      df_eco3[, "L3_ECO"] <- df_eco3[, "LEVEL3"]
      df_eco3[, "L3_ECO_NAME"] <- df_eco3[, "LEVEL3_NAM"]
      # Merge with results
      df_results <- merge(df_results
                          , df_eco3[, c(sel_col_sampid
                                        , "L3_ECO"
                                        , "L3_ECO_NAME")]
                          , by = sel_col_sampid
                          , all.x = TRUE)
      
      ## Calc, 06, Munge ----
      prog_detail <- "Modify Variable Names"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Modify names to match Assign Index Class function
      df_results <- dplyr::rename(df_results, pslope_nhd = slope)
      df_results[, "pslope_nhd"] <- 100 * df_results[, "pslope_nhd"]
      
      
      ## Calc, 07, Save Results ----
      prog_detail <- "Save Results"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Save files 
      
      ## save, results
      df_save <- df_results
      fn_part <- paste0("BCG", "_Site_parameters", ".csv")
      write.csv(df_save
                , file.path(path_results_sub, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      
      ## Calc, 08, Create Zip ----
      prog_detail <- "Create Zip File For Download"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Create zip file for download
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      
      ## Calc, 09, Clean Up ----
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
      fn_abr <- abr_taxatrans
      fn_abr_save <- paste0("_", abr_classparam, "_")
      paste0(fn_input_base
             , fn_abr_save
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
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input)
      
      # result folder and files
      fn_abr <- abr_bcg
      fn_abr_save <- paste0("_", fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
      # Add "reference" folder if missing
      path_results_ref <- file.path(path_results, dn_files_ref)
      boo_Results <- dir.exists(file.path(path_results_ref))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_ref))
      }
      
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
        # validate(msg)
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
      fn_part <- paste0("BCG", "_SiteClassCriteria", ".csv")
      write.csv(df_save
                , file.path(path_results_ref, fn_part)
                , row.names = FALSE)
      rm(df_save, fn_part)
      
      ## save, results
      df_save <- df_indexclass_results
      fn_part <- paste0("BCG", "_Site_CLASS", ".csv")
      write.csv(df_save
                , file.path(path_results_sub, fn_part)
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
      fn_abr <- abr_classassign
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
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
    
    # Remove existing files in "results"
    clean_results()
    
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
  
    # result folder and files
    path_results_sub <- file.path(path_results, dn_files_input)
    # Add "Results" folder if missing
    boo_Results <- dir.exists(file.path(path_results_sub))
    if (boo_Results == FALSE) {
      dir.create(file.path(path_results_sub))
    }
    
    # Copy to "Results" sub-folder - Import "as is"
    file.copy(inFile$datapath
              , file.path(path_results_sub, inFile$name))

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
    # Assume import 2nd file after 1st

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
    
    # result folder and files
    path_results_sub <- file.path(path_results, dn_files_input)
    # Add "Results" folder if missing
    boo_Results <- dir.exists(file.path(path_results_sub))
    if (boo_Results == FALSE) {
      dir.create(file.path(path_results_sub))
    }
    
    # Copy to "Results" sub-folder - Import "as is"
    file.copy(inFile$datapath
              , file.path(path_results_sub, inFile$name))

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
     
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input_mf1)
      copy_import_file(import_file = input$fn_input_mf2)
      
      # result folder and files
      fn_abr <- abr_mergefiles
      fn_abr_save <- paste0("_", fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
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
        # validate(msg)
      }## IF ~ is.null (mf1)
      
      if (is.null(fn_mf2)) {
        msg <- "Merge File 2 filename is missing!"
        shinyalert::shinyalert(title = "Merge File Calculation Error"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # validate(msg)
      }## IF ~ is.null (mf1)
      
      # Stop if colname for merge is NA
      if (col_siteid_mf1 == "") {
        msg <- "Merge File 1 merge column is missing!"
        shinyalert::shinyalert(title = "Merge File Calculation Error"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # validate(msg)
      }## IF ~ is.null (mf1)
      
      if (col_siteid_mf2 == "") {
        msg <- "Merge File 2 merge column is missing!"
        shinyalert::shinyalert(title = "Merge File Calculation Error"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # validate(msg)
      }## IF ~ is.null (mf1)
      
      
      
      # Remove non-MergeFiles files
      # Remove all files in "Results" folder
      # 2 file imports so moved Results folder clean up here from import section
      # fn_results <- list.files(path_results
      #                          , full.names = TRUE
      #                          , include.dirs = FALSE
      #                          , recursive = TRUE)
      # message(paste0("Files in 'results' folder (before removal) = "
      #                , length(fn_results)))
      # comment out 2023-11-03
      #
      # # Exclude MF1 and MF2
      # fn_mf_keep <- file.path(path_results
      #                         , c(fn_mf1, fn_mf2))
      # fn_results <- fn_results[!fn_results %in% fn_mf_keep]
      # # Remove non MF files
      # file.remove(fn_results) # ok if no files
      # # QC, repeat 
      # fn_results2 <- list.files(path_results
      #                           , full.names = TRUE
      #                           , include.dirs = FALSE
      #                           , recursive = TRUE)
      # message(paste0("Files in 'results' folder (after removal [should be 2]) = "
      #                , length(fn_results2)))
      
      
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
      
      fn_merge <- paste0(fn_input_base, fn_abr_save, "RESULTS.csv")
      pn_merge <- file.path(path_results_sub, fn_merge)
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
      fn_abr <- abr_mergefiles
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
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
  
  ## BCG, UI ----
  
  output$UI_bcg_modelexp_user_col_eco3 <- renderUI({
    str_col <- "Column, Ecoregion III (L3_ECO)"
    selectInput("bcg_modelexp_user_col_eco3"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "L3_ECO"
                , multiple = FALSE)
  })## UI_colnames
  
  output$UI_bcg_modelexp_user_col_precip <- renderUI({
    str_col <- "Column, Precipitation, mm (PRECIP8110CAT)"
    selectInput("bcg_modelexp_user_col_precip"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "PRECIP8110CAT"
                , multiple = FALSE)
  })## UI_colnames
  
  output$UI_bcg_modelexp_user_col_wshedarea_km2 <- renderUI({
    str_col <- "Column, Watershed Area, km2 (WSAREASQKM)"
    selectInput("bcg_modelexp_user_col_wshedarea_km2"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "WSAREASQKM"
                , multiple = FALSE)
  })## UI_colnames
  
  output$UI_bcg_modelexp_user_col_elev <- renderUI({
    str_col <- "Column, Elevation, m (elev_m)"
    selectInput("bcg_modelexp_user_col_elev"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "elev_m"
                , multiple = FALSE)
  })## UI_colnames
  
  output$UI_bcg_modelexp_user_col_slope <- renderUI({
    str_col <- "Column, Slope, % (pslope_nhd)"
    selectInput("bcg_modelexp_user_col_slope"
                , label = str_col
                , choices = c("", names(df_import()))
                , selected = "pslope_nhd"
                , multiple = FALSE)
  })## UI_colnames
  
  
  ## b_Calc_BCG ----
  observeEvent(input$b_calc_bcg, {
    shiny::withProgress({
      
      ### Calc, 0, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, BCG..."
      message(paste0("\n", prog_detail))
      
      # Number of increments
      prog_n <- 11
      prog_sleep <- 0.25
      
      ## Calc, 1, Initialize ----
      prog_detail <- "Initialize Data"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input)
      
      # result folder and files
      fn_abr <- abr_bcg
      fn_abr_save <- paste0(fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
      # reference folder 
      path_results_ref <- file.path(path_results, dn_files_ref)
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_ref))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_ref))
      }
      
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
      
      # Columns, user selection
      sel_user_eco3 <- toupper(input$bcg_modelexp_user_col_eco3)
      sel_user_precip <- toupper(input$bcg_modelexp_user_col_precip)
      sel_user_wshedarea_km2 <- toupper(input$bcg_modelexp_user_col_wshedarea_km2)
      sel_user_elev <- toupper(input$bcg_modelexp_user_col_elev)
      sel_user_slope <- toupper(input$bcg_modelexp_user_col_slope)
      
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
        fn_excl <- paste0(fn_abr_save, "1markexcl.csv")
        dn_excl <- path_results_sub
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
      fn_rules <- paste0(fn_abr_save, "3metrules.csv")
      dn_rules <- path_results_sub
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
      
      fn_metval <- paste0(fn_abr_save, "2metval_all.csv")
      dn_metval <- path_results_sub
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
      fn_metval_slim <- paste0(fn_abr_save, "2metval_BCG.csv")
      dn_metval_slim <- path_results_sub
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
      fn_metmemb <- paste0(fn_abr_save, "3metmemb.csv")
      dn_metmemb <- path_results_sub
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
      fn_levmemb <- paste0(fn_abr_save, "4levmemb.csv")
      dn_levmemb <- path_results_sub
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
      fn_levassign <- paste0(fn_abr_save, "5levassign.csv")
      dn_levassign <- path_results_sub
      pn_levassign <- file.path(dn_levassign, fn_levassign)
      write.csv(df_levassign, pn_levassign, row.names = FALSE)
      
      
      ## Calc, 8, QC Flags----
      prog_detail <- "Calculate, QC Flags"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # 2023-12-06
      # Split if no flags so doesn't crash
      
      # Check if Flags exist for data
      col_index_metval <- c("INDEX_NAME", "INDEX_CLASS")
      col_index_checks <- c("Index_Name", "INDEX_CLASS")
      index_metval <- unique(df_metval[, col_index_metval])
      index_checks <- unique(df_checks[, col_index_checks])
      index_merge <- merge(index_metval, index_checks
                           , by.x = col_index_metval
                           , by.y = col_index_checks)
      
      if (nrow(index_merge) == 0) {
        
        # create dummy files
        str_nodata <- "No flags for the Index Name/Class combinations present in data"
        # Flags
        df_flags <- data.frame(x = str_nodata
                               , CHECKNAME = "No Flags"
                               , FLAG = NA)
        df_lev_flags <- df_levassign
        # Flags Summary
        df_lev_flags_summ <- data.frame(x = str_nodata)
        # Results
        df_results <- data.frame(x = str_nodata)
        # Flag Metrics
        df_metflags <- data.frame(x = str_nodata)
        
      } else {
        
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
        # Flags Summary
        df_lev_flags_summ <- as.data.frame.matrix(table(df_flags[, "CHECKNAME"]
                                                        , df_flags[, "FLAG"]
                                                        , useNA = "ifany"))
        # Results
        df_results <- df_lev_flags[, !names(df_lev_flags) %in% c(paste0("L", 1:6))]
        ## remove L1:6
        
        # Flag Metrics
        col2keep_metflags <- c("SAMPLEID", "INDEX_NAME", "INDEX_CLASS"
                               , "METRIC_NAME", "CHECKNAME", "METRIC_VALUE"
                               , "SYMBOL", "VALUE", "FLAG")
        df_metflags <- df_flags[, col2keep_metflags]
        
      }## IF ~ check for matching index name and class
      
      
      # Save, Flags Summary
      fn_levflags <- paste0(fn_input_base, fn_abr_save, "6levflags.csv")
      dn_levflags <- path_results_sub
      pn_levflags <- file.path(dn_levflags, fn_levflags)
      write.csv(df_lev_flags_summ, pn_levflags, row.names = TRUE)
      
      # Save, Results
      fn_results <- paste0(fn_input_base, fn_abr_save, "RESULTS.csv")
      dn_results <- path_results_sub
      pn_results <- file.path(dn_results, fn_results)
      write.csv(df_results, pn_results, row.names = FALSE)
      
      # Save, Flag Metrics
      fn_metflags <- paste0(fn_input_base, fn_abr_save, "6metflags.csv")
      dn_metflags <- path_results_sub
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
      strFile.out <- paste0("_", fn_abr_save, "RESULTS.html")
      dir.export <- path_results_sub
      rmarkdown::render(strFile.RMD
                        , output_format = strFile.RMD.format
                        , output_file = strFile.out
                        , output_dir = dir.export
                        , quiet = TRUE)
      
      ## Calc, 09, Info Pop Up ----
      prog_detail <- "Calculate, Model Experience"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1 / prog_n, detail = prog_detail)
      Sys.sleep(2 * prog_sleep)
      
      # Check 
      # data available
      # df_input = all data
      # df_results = BCG output
 
      # Create 
      cols2check <- c("SAMPLEID"
                      , "INDEX_CLASS")
      if (sel_user_eco3 != "") {
        cols2check <- c(cols2check, sel_user_eco3)
      }## IF ~ eco3
      if (sel_user_precip != "") {
        cols2check <- c(cols2check, sel_user_precip)
      }## IF ~ precip
      if (sel_user_wshedarea_km2 != "") {
        cols2check <- c(cols2check, sel_user_wshedarea_km2)
      }## IF ~ wshed area
      if (sel_user_elev != "") {
        cols2check <- c(cols2check, sel_user_elev)
      }## IF ~ wshed area
      if (sel_user_slope != "") {
        cols2check <- c(cols2check, sel_user_slope)
      }## IF ~ wshed area
      
      df_samp_flags <- unique(df_input[, cols2check])
    
      # Add flag columns
      cols_samp_flags <- c("flag"
                           , "flag_sum"
                           , "flag_indexclass"
                           , "flag_eco3"
                           , "flag_precip"
                           , "flag_wshed_small"
                           , "flag_wshed_large"
                           , "flag_elev_trans"
                           , "flag_slope_trans"
                           , "flag_slope_vhigh")
      df_samp_flags[, cols_samp_flags] <- NA
      
      # Evaluate Sample Flags
      
      ## Eval, Index_Class
      df_samp_flags[, "flag_indexclass"] <- tolower(df_samp_flags[, "INDEX_CLASS"]) %in% "lograd-hielev"
      n_bad_indexclass <- sum(df_samp_flags[, "flag_indexclass"], na.rm = TRUE)
      
      ## Eco3
      fld2check <- sel_user_eco3
      if (fld2check != "") {
        eco3_good <- c(1, 2, 3, 4, 77)
        df_samp_flags[, "flag_eco3"] <- !(df_samp_flags[, fld2check] %in% eco3_good)
        n_bad_eco3 <- sum(df_samp_flags[, "flag_eco3"])
      } else {
        n_bad_eco3 <- NA_integer_
      }## IF ~ Eco3
     
      ## Precip
      fld2check <- sel_user_precip
      if (fld2check != "") {
        df_samp_flags[, "flag_precip"] <- df_samp_flags[, fld2check] < 650
        n_bad_precip <- sum(df_samp_flags[, "flag_precip"], na.rm = TRUE)
      } else {
        n_bad_precip <- NA_integer_
      }## IF ~ Wshed Area
      
      ## Watershed
      fld2check <- sel_user_wshedarea_km2
      if (fld2check != "") {
        df_samp_flags[, "flag_wshed_small"] <- df_samp_flags[, fld2check] < 5
        df_samp_flags[, "flag_wshed_large"] <- df_samp_flags[, fld2check] > 260
        n_bad_wshedarea_small <- sum(df_samp_flags[, "flag_wshed_small"], na.rm = TRUE)
        n_bad_wshedarea_large <- sum(df_samp_flags[, "flag_wshed_large"], na.rm = TRUE)
      } else {
        n_bad_wshedarea_small <- NA_integer_
        n_bad_wshedarea_large <- NA_integer_
      }## IF ~ Wshed Area
     
      ## Elev
      fld2check <- sel_user_elev
      if (fld2check != "") {
        df_samp_flags[, "flag_elev_trans"] <- df_samp_flags[, fld2check] >= 700 &
                                                df_samp_flags[, fld2check] <= 800
        n_bad_elev_trans <- sum(df_samp_flags[, "flag_elev_trans"], na.rm = TRUE)
      } else {
        n_bad_elev_trans <- NA_integer_
      }## IF ~ Elevation
      
      ## Slope
      fld2check <- sel_user_slope 
      if (fld2check != "") {
        df_samp_flags[, "flag_slope_trans"] <- df_samp_flags[, fld2check] >= 0.8 &
                                                df_samp_flags[, fld2check] <= 1.2
        df_samp_flags[, "flag_slope_vhigh"] <- df_samp_flags[, fld2check] >= 8
        n_bad_slope_trans <- sum(df_samp_flags[, "flag_slope_trans"], na.rm = TRUE)
        n_bad_slope_vhigh <- sum(df_samp_flags[, "flag_slope_vhigh"], na.rm = TRUE)
      } else {
        n_bad_slope_trans <- NA_integer_
        n_bad_slope_vhigh <- NA_integer_
      }## IF ~ Slope
      
      ## Eval, any
      df_samp_flags[, "flag_sum"] <- rowSums(df_samp_flags[, cols_samp_flags[3:10]]
                                             , na.rm = TRUE)
      df_samp_flags[, "flag"] <- ifelse(df_samp_flags[, "flag_sum"] >= 1
                                        , TRUE
                                        , FALSE)
      n_bad_any <- sum(df_samp_flags[, "flag"], na.rm = TRUE)

      # save info
      write.csv(df_samp_flags, file.path("results", "results_BCG", "_BCG_Sample_FLAGS.csv"))
      
      # Inform user about number of samples outside of experience of model
      msg <- paste0("('NA' if data field not provided in input file).", "\n\n"
                    , n_bad_any, " = Total number of samples outside of model experience", "\n\n"
                    , n_bad_indexclass, " = Index_Class, incorrect (LoGrad-HiElev)", "\n"
                    , n_bad_eco3, " = Ecoregion III, incorrect (not 1, 2, 3, 4, or 77)", "\n"
                    , n_bad_precip, " = precipitation, low (< 650 mm)", "\n"
                    , n_bad_wshedarea_small, " = watershed area, small (< 5 km2)", "\n"
                    , n_bad_wshedarea_large, " = watershed area, large (> 260 km2)", "\n"
                    , n_bad_elev_trans, " = elevation, transitional (700 - 800 m)", "\n"
                    , n_bad_slope_trans, " = slope, transitional (0.8 - 1.2%)", "\n"
                    , n_bad_slope_vhigh, " = slope, very high (>= 8%)"
                    )
      shinyalert::shinyalert(title = "BCG Calculation,\nSamples Outside Model Experience"
                             , text = msg
                             , type = "info"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      
     
      ## Calc, 10, Clean Up----
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
      fn_abr <- abr_bcg
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
    #, contentType = "application/zip"
  )##download ~ BCG
  
  # Calc, THERMAL METRICS ----
  
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
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input)
      
      # result folder and files
      fn_abr <- abr_tmet
      fn_abr_save <- paste0(fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
      # reference folder 
      path_results_ref <- file.path(path_results, dn_files_ref)
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_ref))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_ref))
      }
      
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
        fn_excl <- paste0(fn_abr_save, "1markexcl.csv")
        dn_excl <- path_results_sub
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
        
      fn_metval <- paste0("_", fn_abr_save, "RESULTS.csv")
      dn_metval <- path_results_sub
      pn_metval <- file.path(dn_metval, fn_metval)
      write.csv(df_metval, pn_metval, row.names = FALSE)
      
      # Copy metadata (thermal metrics) to results
      fn_meta <- "ThermPrefMetrics_metadata.xlsx"
      fn_meta_save <- paste0(fn_abr_save, "metadata.xlsx")
      file.copy(file.path("www", "links", fn_meta)
                , file.path(path_results_sub, fn_meta_save))
      
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
      fn_abr <- abr_tmet
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
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
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input)
      
      # result folder and files
      fn_abr <- abr_fuzzy
      fn_abr_save <- paste0(fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
      # reference folder 
      path_results_ref <- file.path(path_results, dn_files_ref)
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_ref))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_ref))
      }
      
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
        fn_excl <- paste0(fn_abr_save, "1markexcl.csv")
        dn_excl <- path_results_sub
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
      fn_rules <- paste0(fn_abr_save, "3metrules.csv")
      dn_rules <- path_results_sub
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
      
      fn_metval <- paste0(fn_abr_save, "2metval_all.csv")
      dn_metval <- path_results_sub
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
      fn_metval_slim <- paste0(fn_abr_save, "2metval_model.csv")
      dn_metval_slim <- path_results_sub
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
      fn_metmemb <- paste0(fn_abr_save, "3metmemb.csv")
      dn_metmemb <- path_results_sub
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
      fn_levmemb <- paste0(fn_abr_save, "4levmemb.csv")
      dn_levmemb <- path_results_sub
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
      fn_levassign <- paste0(fn_abr_save, "5levassign.csv")
      dn_levassign <- path_results_sub
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
      fn_levflags <- paste0(fn_abr_save, "6levflags.csv")
      dn_levflags <- path_results_sub
      pn_levflags <- file.path(dn_levflags, fn_levflags)
      write.csv(df_lev_flags_summ, pn_levflags, row.names = TRUE)
      
      # Create Results
      df_results <- df_lev_flags[, !names(df_lev_flags) %in% c(paste0("L", 1:6))]
      ## remove L1:6
      
      # Save Results
      fn_results <- paste0("_", fn_abr_save, "RESULTS.csv")
      dn_results <- path_results_sub
      pn_results <- file.path(dn_results, fn_results)
      write.csv(df_results, pn_results, row.names = FALSE)
      
      
      ### Calc, 9b, QC Flag Metrics ----
      # create
      col2keep <- c("SAMPLEID", "INDEX_NAME", "INDEX_CLASS", "METRIC_NAME"
                    , "CHECKNAME", "METRIC_VALUE", "SYMBOL", "VALUE", "FLAG")
      df_metflags <- df_flags[, col2keep]
      # save
      fn_metflags <- paste0(fn_abr_save, "6metflags.csv")
      dn_metflags <- path_results_sub
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
      strFile.out <- paste0("_", fn_abr_save, "RESULTS.html")
      dir.export <- path_results_sub
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
      fn_abr <- abr_fuzzy
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
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
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input)
      
      # result folder and files
      fn_abr <- abr_mtti
      fn_abr_save <- paste0(fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
      # no reference subfolder
      
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
      strFile.out <- paste0("_", fn_abr_save, "RESULTS.html")
      dir.export <- path_results_sub
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
      
      fn_save <- paste0("_", fn_abr_save, "RESULTS.csv")
      pn_save <- file.path(path_results_sub, fn_save)
      write.csv(df_results, pn_save, row.names = FALSE)
      
      fn_save <- paste0(fn_abr_save, "flags_1_metrics.csv")
      pn_save <- file.path(path_results_sub, fn_save)
      write.csv(df_met, pn_save, row.names = FALSE)
      
      fn_save <- paste0(fn_abr_save, "flags_2_eval_long.csv")
      pn_save <- file.path(path_results_sub, fn_save)
      write.csv(df_met_flags, pn_save, row.names = FALSE)
      
      fn_save <- paste0(fn_abr_save, "flags_3_eval_summary.csv")
      pn_save <- file.path(path_results_sub, fn_save)
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
      fn_abr <- abr_mtti
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
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
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = input$fn_input)
      
      # result folder and files
      fn_abr <- abr_bdi
      fn_abr_save <- paste0(fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
      # reference folder 
      path_results_ref <- file.path(path_results, dn_files_ref)
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_ref))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_ref))
      }
      
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
        # validate(msg)
      }## IF ~ sel_col_sampid
      
      if (!sel_col_taxaid %in% names(df_input)) {
        # end process with pop up
        msg <- "'TaxaID' column name is missing!"
        shinyalert::shinyalert(title = "BDI Calculation"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # validate(msg)
      }## IF ~ sel_col_taxaid
      
      if (!sel_col_ntaxa %in% names(df_input)) {
        # end process with pop up
        msg <- "'N_Taxa' column name is missing!"
        shinyalert::shinyalert(title = "BDI Calculation"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # validate(msg)
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
          # validate(msg)
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
      myMetrics.Bugs <- unique(as.data.frame(df_thresh_metric)[df_thresh_metric[, "INDEX_NAME"] == myIndex, "METRIC_NAME"])
      message(myMetrics.Bugs)


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
      strFile.out <- paste0("_", fn_abr_save, "RESULTS.html")
      dir.export <- path_results_sub
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
      fn_excl <- paste0(fn_abr_save, "1markexcl.csv")
      dn_excl <- path_results_sub
      pn_excl <- file.path(dn_excl, fn_excl)
      write.csv(df_input, pn_excl, row.names = FALSE)
      
      # RESULTS
      fn_save <- paste0("_", fn_abr_save, "RESULTS.csv")
      pn_save <- file.path(path_results_sub, fn_save)
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
  
  #### b_download_bdi ----
  output$b_download_bdi <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      fn_abr <- abr_bdi
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
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

    # data_GIS_eco3_orwa_bcg <- data_GIS_eco3_orwa_bcg %>%
    #   mutate(Fill = case_when(BCG_Valid == TRUE ~ "#FFFFFF"
    #                           , TRUE ~ "#808080"
    #   )) %>%
    #   mutate(Border = case_when(BCG_Valid == TRUE ~ "#000000"
    #                             , TRUE ~ "#03F"
    #   ))

    # Map
    #leaflet() %>%
    leaflet(data = df_map) %>%
      # Groups, Base
      # addTiles(group="OSM (default)") %>%  #default tile too cluttered
      addProviderTiles("CartoDB.Positron"
                       , group = "Positron") %>%
      addProviderTiles(providers$OpenStreetMap
                       , group = "Open Street Map") %>%
      addProviderTiles(providers$Esri.WorldImagery
                       , group = "ESRI World Imagery") %>%
      # addProviderTiles(providers$USGS.USImagery
      #                  , group = "USGS Imagery") %>%
      # addPolygons(data = data_GIS_eco3_orwa
      #             , group = "Ecoregions, Level III"
      #             , popup = ~paste0(LEVEL3, ", ", LEVEL3_NAM)
      #             , fillColor = ~LEVEL3
      #             ) %>%
      # addPolygons(data = data_GIS_eco3_orwa_bcg
      #             , group = "Ecoregions, Level III"
      #             , popup = ~paste0(US_L3CODE
      #                               , ", "
      #                               , US_L3NAME
      #                               , ", valid for BCG = "
      #                               , BCG_Valid)
      #             , fillColor = ~Fill
      #             , color = ~Border
      #             , weight = 3
      # ) %>%
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
      # hideGroup(c("Ecoregions, Level III"
      #            # , "BCG Class"
      #            # , "NorWeST"
      #            # , "NHD+ Catchments"
      #            # , "NHD+ Flowlines"
      # )) %>%
      # # Mini map
      addMiniMap(toggleDisplay = TRUE) #%>%
      # Legend
      # addLegend("bottomleft"
      #           , title = "L3 Ecoregions, BCG Valid"
      #           , colors = c("#000000", "#03F")
      #           , labels = c("TRUE", "FALSE")
      #           # , layerID = "Ecoregions, Level III"
      #           )



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
      # validate(msg)
    }## IF ~ sel_map_datatype

    if (is.null(sel_map_col_xlong) | sel_map_col_xlong == "") {
      # end process with pop up
      msg <- "'Longitude' column name is missing!"
      shinyalert::shinyalert(title = "Update Map"
                             , text = msg
                             , type = "error"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      # validate(msg)
    }## IF ~ sel_map_col_xlong

    if (is.null(sel_map_col_ylat) | sel_map_col_ylat == "") {
      # end process with pop up
      msg <- "'Latitude' column name is missing!"
      shinyalert::shinyalert(title = "Update Map"
                             , text = msg
                             , type = "error"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      # validate(msg)
    }## IF ~ sel_map_col_ylat

    if (is.null(sel_map_col_sampid) | sel_map_col_sampid == "") {
      # end process with pop up
      msg <- "'SampleID' column name is missing!"
      shinyalert::shinyalert(title = "Update Map"
                             , text = msg
                             , type = "error"
                             , closeOnEsc = TRUE
                             , closeOnClickOutside = TRUE)
      # validate(msg)
    }## IF ~ sel_map_col_sampid

    ### Munge Data ----
    #### Munge, Val, Nar, Size
    if (sel_map_datatype == "BCG") {
      sel_map_col_mapval <- "BCG_Status"
      sel_map_col_mapnar <- "BCG_Status2"
    } else if (sel_map_datatype == "Fuzzy Temp Model") {
      sel_map_col_mapval <- "Therm_Class" #"Continuous_Therm"
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
      # validate(msg)
    }## IF ~ sel_map_col_sampid



    # Rename Columns to known values
    ## Add Jitter to Lat-Long to avoid overlap
    # 1 second ~ 1/3600 ~ 0.000278 ~ 37.5 meters
    # 7 seconds ~ 262.3 meters
    jit_fac <- 0/3600
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
                   , "#7B9BF5"
                   , "#0AE1EC"
                   , "#9AF3FC"
                   , "#BEFEFB"
                   , "#DDFBFF"
                   , "#DDFBFF"
                   , "#C6FFB9"
                   , "#34FB25"
                   , "#FFFF66"
                   , "#FFFFE5"
                   , "#FFFFE5"
                   , "#E4DFEC"
                   , "#FFC000"
                   , "#808080"
      )
      leg_nar <- c("VeryCold"
                   , "VCold_Cold"
                   , "TIE_VCold_Cold"
                   , "TIE_Cold_VCold"
                   , "Cold_VCold"
                   , "Cold"
                   , "Cold_Cool"
                   , "TIE_Cold_Cool"
                   , "TIE_Cool_Cold"
                   , "Cool_Cold"
                   , "Cool"
                   , "Cool_Warm"
                   , "TIE_Cool_Warm"
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
        mutate(map_color = case_when(map_mapnar %in% leg_nar[1] ~ leg_col[1]
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
    # zoom levels, https://leafletjs.com/examples/zoom-levels/

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
      clearShapes() %>%
      clearMarkers() %>%
      # Groups, Overlay
      # addCircles(lng = ~map_xlong
      #            , lat = ~map_ylat
      #            , color = ~map_color
      #            , popup = ~map_popup
      #            , radius = ~map_size
      #            , group = "Samples") %>%
      addCircleMarkers(lng = ~map_xlong
                 , lat = ~map_ylat
                 , color = ~map_color
                 , popup = ~map_popup
                 #, radius = ~map_size
                 , fill = ~map_color
                 , stroke = TRUE
                 , fillOpacity = 0.75
                 , group = "Samples"
                 , clusterOptions = markerClusterOptions(spiderfyDistanceMultiplier=1.5
                                                         , showCoverageOnHover = TRUE
                                                         , freezeAtZoom = 13)
                 ) %>%
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
  
  # IMPORT ----
  file_watch_rep_multi <- reactive({
    # trigger for import_rep_multi()
    input$fn_input_rep_multi
    # NOT WORKING
  })## file_watch
  
  ## IMPORT, rep_multi----
  import_rep_multi <- eventReactive(file_watch_rep_multi(), {
    # use a multi-item reactive so keep on a single line (if needed later)
    
    # NOT WORKING
    # 
    # # Define file
    # fn_inFile <- inFile$datapath
    # 
    # #message(getwd())
    # message(paste0("Import, file name: ", inFile$name))
    # 
    # # Remove existing files in "results"
    # clean_results()
    # 
    # # Copy user files to results sub-folder
    # copy_import_file(import_file = inFile)
    # 
    # # result folder and files
    # fn_abr <- abr_report
    # fn_abr_save <- paste0("_", fn_abr, "_")
    # path_results_sub <- file.path(path_results
    #                               , paste(abr_results, fn_abr, sep = "_"))
    # # Add "Results" folder if missing
    # boo_Results <- dir.exists(file.path(path_results_sub))
    # if (boo_Results == FALSE) {
    #   dir.create(file.path(path_results_sub))
    # }
    # 
    # # button, disable, download
    # shinyjs::disable("b_download_rep_multi")
    # 
    # # unzip
    # zip::unzip(file.path(path_results_sub, inFile$name)
    #            , overwrite = TRUE
    #            , exdir = path_results)
    # 
    
    
    # ## button, enable, calc ----
    shinyjs::enable("b_calc_rep_multi")
    
  })##output$df_import_rep_multi ~ END
  
  
  # Report, Single ----
  observeEvent(input$b_calc_rep_single, {
    shiny::withProgress({
      
      ### Calc, 00, Set Up Shiny Code ----
      
      prog_detail <- "Calculation, Report, Single..."
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
      
      # Define file
      inFile <- input$fn_input_rep_single
      fn_inFile <- inFile$datapath
      #message(getwd())
      message(paste0("Import, file name: ", inFile$name))
      
      if (is.null(inFile)) {
        # end process with pop up
        msg <- "No file uploaded.  Upload a file and try again."
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ is.null(inFile)
      
      # Remove existing files in "results"
      clean_results()
      
      # Copy user files to results sub-folder
      copy_import_file(import_file = inFile)
      
      # result folder and files
      fn_abr <- abr_report
      fn_abr_save <- paste0("_", fn_abr, "_")
      path_results_sub <- file.path(path_results
                                    , paste(abr_results, fn_abr, sep = "_"))
      # Add "Results" folder if missing
      boo_Results <- dir.exists(file.path(path_results_sub))
      if (boo_Results == FALSE) {
        dir.create(file.path(path_results_sub))
      }
      
      # button, disable, download
      shinyjs::disable("b_download_rep_single")
      
      # User Input folder
      path_results_user <- file.path(path_results, dn_files_input)
      
      # unzip
      zip::unzip(file.path(path_results_user, inFile$name)
                 , overwrite = TRUE
                 , exdir = path_results_user)
      
      ## Calc, 02, Gather and Test Inputs  ----
      prog_detail <- "QC Inputs"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      message(paste0("Import, file name, base: ", fn_input_base))
      
      # Template file
      fn_template <- list.files(path_results_user
                                , pattern = "^Template_TemperatureReport.*\\.xlsx$")
      
      if (length(fn_template) == 0) {
        # end process with pop up
        msg <- "'Template_TemperatureReport' file is missing!"
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ length(fn_template) == 0
      
      if (length(fn_template) > 1) {
        # end process with pop up
        msg <- "'Template_TemperatureReport' found more than once!"
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ length(fn_template) > 1
      
      # Files, ALL
      fn_all <- list.files(path = path_results_user
                           , full.names = TRUE
                           , recursive = TRUE)
      len_fn_all <- length(fn_all)
      # Files, DataFrame
      df_fn_all <- data.frame("path" = fn_all
                              , "file" = basename(fn_all)
                              , "dir_full" = dirname(fn_all))
      df_fn_all[, "dir_zip"] <- sub(paste0("^", path_results_user, "/")
                                    , ""
                                    , df_fn_all[, "dir_full"])
      
      # Read Template
      # read template file
      path_template <- file.path(path_results_user, fn_template)
      n_skip <- 3
      
      ### Template, Other
      sh_template <- "other"
      df_template_other <- readxl::read_excel(path = path_template
                                                       , sheet = sh_template
                                                       , skip = n_skip)
      df_template_other[, "sheet"] <- sh_template
      
      ### Template, Summary, Header ----
      sh_template <- "summary_header"
      df_template_summary_header <- readxl::read_excel(path = path_template
                                                       , sheet = sh_template
                                                       , skip = n_skip)
      df_template_summary_header[, "sheet"] <- sh_template
      
      ### Template, Summary, Wide ----
      sh_template <- "summary_wide"
      df_template_summary_wide <- readxl::read_excel(path = path_template
                                                     , sheet = sh_template
                                                     , skip = n_skip)
      df_template_summary_wide[, "sheet"] <- sh_template
      
      ### Template, Top Indicator ----
      sh_template <- "topindicator"
      df_template_topindicator <- readxl::read_excel(path = path_template
                                                     , sheet = sh_template
                                                     , skip = n_skip)
      df_template_topindicator[, "sheet"] <- sh_template
      
      ### Template, Samples ----
      sh_template <- "samples"
      df_template_samples <- readxl::read_excel(path = path_template
                                                , sheet = sh_template
                                                , skip = n_skip)
      df_template_samples[, "sheet"] <- sh_template
      
      ### Template, Flags ----
      sh_template <- "flags"
      df_template_flags <- readxl::read_excel(path = path_template
                                              , sheet = sh_template
                                              , skip = n_skip)
      df_template_flags[, "sheet"] <- sh_template
      
      ### Template, Site ----
      sh_template <- "site"
      df_template_site <- readxl::read_excel(path = path_template
                                             , sheet = sh_template
                                             , skip = n_skip)
      df_template_site[, "sheet"] <- sh_template
      
      ### Template, Taxa Trans ----
      sh_template <- "taxatrans"
      df_template_taxatrans <- readxl::read_excel(path = path_template
                                                  , sheet = sh_template
                                                  , skip = n_skip)
      df_template_taxatrans[, "sheet"] <- sh_template
      
      ### Template, file names ----
      df_template_all <- dplyr::bind_rows(df_template_summary_header
                                          , df_template_summary_wide
                                          , df_template_topindicator
                                          , df_template_samples
                                          , df_template_flags
                                          , df_template_site
                                          , df_template_taxatrans
                                          , .id = "id")
      df_template_sourcefiles <- unique(df_template_all[, c("inclusion", "source folder", "source file (or suffix)"), TRUE])
      df_template_sourcefiles[, c("exact", "csv", "present")] <- NA_integer_
      
      ### QC, File Names----
      # check for each as CSV and Exact
      
      for (i in seq_len(nrow(df_template_sourcefiles))) {
        
        df_template_sourcefiles[i, "exact"] <- sum(grepl(pattern = df_template_sourcefiles[i, "source file (or suffix)"], fn_all))
        
        df_template_sourcefiles[i, "csv"] <- sum(grepl(pattern = paste0(df_template_sourcefiles[i, "source file (or suffix)"], "\\.csv$"), fn_all))
        
      }## FOR ~ i
      
      df_template_sourcefiles[, "present"] <- df_template_sourcefiles[, "exact"] +
        df_template_sourcefiles[, "csv"]
      
      sourcefiles_missing <- dplyr::filter(df_template_sourcefiles
                                           , inclusion == "required"
                                           & (present == 0 | is.na(present)))
      
      if (nrow(sourcefiles_missing) > 0) {
        # end process with pop up
        msg <- paste0("REQUIRED Template Source Files missing!\n"
                      , paste(unique(sourcefiles_missing$`source file (or suffix)`)
                              , collapse = "\n" )
        )
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ nrow(sourcefiles_missing) > 0
      
      ### File Names, Add Path
      for (i in seq_len(nrow(df_template_sourcefiles))) {
        
        df_template_sourcefiles[i, "path"] <- ifelse(df_template_sourcefiles[i, "source folder", TRUE] == "NA"
                                                     , df_template_sourcefiles[, "source file (or suffix)", TRUE]
                                                     , file.path(df_template_sourcefiles[i, "source folder", TRUE]
                                                                 , df_template_sourcefiles[i, "source file (or suffix)", TRUE])
        )
      }## FOR ~ i
      
      ### File Names, Add to col names
      # join or merge
      
      # Check file.exists for each entry.
      df_template_sourcefiles[, "exist_file"] <- NA
      
      # Fail if files don't exist.
      # if (length(fn_template) == 0) {
      #   # end process with pop up
      #   msg <- "'Template_TemperatureReport' file is missing!"
      #   shinyalert::shinyalert(title = "Report"
      #                          , text = msg
      #                          , type = "error"
      #                          , closeOnEsc = TRUE
      #                          , closeOnClickOutside = TRUE)
      #   shiny::validate(msg)
      # }## IF ~ length(fn_template) == 0
      
      # import each file
      # Check for column in file
      df_template_sourcefiles[, "exist_col"] <- NA
      
      ### Primary Keys ----
      pk_stations <- df_template_other[df_template_other[, "file"] == "Stations"
                                       , "primarykey"
                                       , TRUE]
      pk_samples <- df_template_other[df_template_other[, "file"] == "Sample"
                                      , "primarykey"
                                      , TRUE]

 
      ## Calc, 03, Data ----
      prog_detail <- "Calculation, Create Data Tables"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      ### Assemble data for each tab of the report
      
      # read template file
      # read all files
      # merge or join for each worksheet
      
      ### Data, NOTES ----
      notes_head <- as.data.frame(cbind(c("Project Name"
                                          , "Specific Task"
                                          , NA
                                          , "author@email.com"
                                          , as.character(Sys.Date())
                                          , NA
                                          , "Path & FileName"
                                          , "FileName"
                                          , "SheetName"
                                          , NA
                                          , "Description of Work"
                                          , ""
      )
      , c(rep(NA, 6)
          , '=LEFT(@CELL("filename",B7),FIND("]",@CELL("filename",B7)))'
          , '=MID(@CELL("filename",B8),FIND("[",@CELL("filename",B8)),(FIND("]",@CELL("filename",B8))-FIND("[",@CELL("filename",B8)))+1)'
          , '=MID(@CELL("filename",B9),FIND("]",@CELL("filename",B9))+1,LEN(@CELL("filename",B9))-FIND("]",@CELL("filename",B9)))'
          , rep(NA, 3))))
      #, c(rep(NA, 6), rep("formula", 3), rep(NA, 3))))
      class(notes_head[, 2]) <- "formula"
      notes_toc <- as.data.frame(rbind(
        c("NOTES", "Description of work and other worksheets", '=HYPERLINK(FileName&"NOTES"&"!A1","NOTES")')
        , c("summary", "summary", '=HYPERLINK(FileName&"summary"&"!A1","summary")')
        , c("topindicator", "topindicator", '=HYPERLINK(FileName&"topindicator"&"!A1","topindicator")')
        , c("samples", "samples", '=HYPERLINK(FileName&"samples"&"!A1","samples")')
        , c("flags", "flags", '=HYPERLINK(FileName&"flags"&"!A1","flags")')
        , c("site", "site", '=HYPERLINK(FileName&"site"&"!A1","site")')
        , c("taxatrans", "taxatrans", '=HYPERLINK(FileName&"taxatrans"&"!A1","topinditaxatransator")')
      ))
      names(notes_toc) <- c("Worksheet", "Description", "Link")
      class(notes_toc$Link) <- "formula"
      
      ### Data, Summary, Color Thresholds ----
      df_col_thresh <- read.csv(file.path("data"
                                          , "report_color_thresholds.csv"))
      
      # compile each in a helper script
 
      # # Get stations
      # pk_stations <- df_template_other[df_template_other[, "file"] == "Stations"
      #                                  , "primarykey"
      #                                  , TRUE]
      # pk_samples <- df_template_other[df_template_other[, "file"] == "Sample"
      #                                  , "primarykey"
      #                                  , TRUE]

      # zip file extracted to "results/_user_input"
      
      ### Data, Summary, Header ----
      ls_report_summary_header <- build_report_table(df_template_summary_header
                           , fld_name_orig = "original name"
                           , fld_name_disp = "display name"
                           , fld_desc = "descriptor"
                           , fld_incl = "inclusion"
                           , fld_folder = "source folder"
                           , fld_file = "source file (or suffix)"
                           , fld_colr = "color code"
                           , fld_sort = "sort"
                           , path_files = file.path(path_results, "_user_input")
                           , tbl_name = "summary_header")
      
      df_report_summary_header <- ls_report_summary_header$data
      # df_report_summary_header <- mtcars
   
      ### Data, Summary, Wide ----
      ls_report_summary_wide <- build_report_table(df_template_summary_wide
                           , fld_name_orig = "original name"
                           , fld_name_disp = "display name"
                           , fld_desc = "descriptor"
                           , fld_incl = "inclusion"
                           , fld_folder = "source folder"
                           , fld_file = "source file (or suffix)"
                           , fld_colr = "color code"
                           , fld_sort = "sort"
                           , path_files = file.path(path_results, "_user_input")
                           , tbl_name = "summary_wide")
      
      df_report_summary_wide <- ls_report_summary_wide$data
      # df_report_summary_wide <- mtcars
      
      ### Data, Top Indicator ----
      ls_report_topindicator <- build_report_table(df_template_topindicator
                           , fld_name_orig = "original name"
                           , fld_name_disp = "display name"
                           , fld_desc = "descriptor"
                           , fld_incl = "inclusion"
                           , fld_folder = "source folder"
                           , fld_file = "source file (or suffix)"
                           , fld_colr = "color code"
                           , fld_sort = "sort"
                           , path_files = file.path(path_results, "_user_input")
                           , tbl_name = "topindicator")
      
      df_report_topindicator <- ls_report_topindicator$data
      # df_report_topindicator <- iris
      
      ### Data, Samples ----
      ls_report_samples <- build_report_table(df_template_samples
                          , fld_name_orig = "original name"
                          , fld_name_disp = "display name"
                          , fld_desc = "descriptor"
                          , fld_incl = "inclusion"
                          , fld_folder = "source folder"
                          , fld_file = "source file (or suffix)"
                          , fld_colr = "color code"
                          , path_files = file.path(path_results, "_user_input")
                          , tbl_name = "samples")
      
      df_report_samples <- ls_report_samples$data
      # df_report_samples <- ToothGrowth
      
      ### Data, Flags ----
      ls_report_flags <- build_report_table(df_template_flags
                          , fld_name_orig = "original name"
                          , fld_name_disp = "display name"
                          , fld_desc = "descriptor"
                          , fld_incl = "inclusion"
                          , fld_folder = "source folder"
                          , fld_file = "source file (or suffix)"
                          , fld_colr = "color code"
                          , path_files = file.path(path_results, "_user_input")
                          , tbl_name = "flags")
      
      df_report_flags <- ls_report_flags$data
      # df_report_flags <- PlantGrowth
      
      ### Data, Site ----
      ls_report_site <- build_report_table(df_template_site
                           , fld_name_orig = "original name"
                           , fld_name_disp = "display name"
                           , fld_desc = "descriptor"
                           , fld_incl = "inclusion"
                           , fld_folder = "source folder"
                           , fld_file = "source file (or suffix)"
                           , fld_colr = "color code"
                           , fld_sort = "sort"
                           , path_files = file.path(path_results, "_user_input")
                           , tbl_name = "site")
      
      df_report_site <- ls_report_site$data
      # df_report_site <- USArrests

      ### Data, Taxa Trans ----
       ls_report_taxatrans <- build_report_table(df_template_taxatrans
                          , fld_name_orig = "original name"
                          , fld_name_disp = "display name"
                          , fld_desc = "descriptor"
                          , fld_incl = "inclusion"
                          , fld_folder = "source folder"
                          , fld_file = "source file (or suffix)"
                          , fld_colr = "color code"
                          , fld_sort = "sort"
                          , path_files = file.path(path_results, "_user_input")
                          , tbl_name = "taxatrans")
      df_report_taxatrans <- ls_report_taxatrans$data
     # df_report_taxatrans <- cars
      
      ### Data, SampID ----
      # Check and Fail if not present
     
      # SampID_summary_wide
      tbl_name <- "summary_wide"
      df_check_sampid <- df_report_summary_wide
      boo_sampid <- toupper(pk_samples) %in% toupper(names(df_check_sampid))
      if (boo_sampid == FALSE) {
        # end process with pop up
        msg <- paste("REQUIRED column (SampleID) missing!"
                      , paste0("Table: ", tbl_name)
                      , paste0("Value: ", pk_samples)
                      , sep = "\n\n" )
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ boo_sampID ~ summary
      col_sampid_summary_wide <- names(df_check_sampid)[match(toupper(pk_samples), toupper(names(df_check_sampid)))]
      
      # SampID_topindicator
      tbl_name <- "topindicator"
      df_check_sampid <- df_report_topindicator
      boo_sampid <- toupper(pk_samples) %in% toupper(names(df_check_sampid))
      if (boo_sampid == FALSE) {
        # end process with pop up
        msg <- paste("REQUIRED column (SampleID) missing!"
                     , paste0("Table: ", tbl_name)
                     , paste0("Value: ", pk_samples)
                     , sep = "\n\n" )
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ boo_sampID ~ topindicator
      col_sampid_topindicator <- names(df_check_sampid)[match(toupper(pk_samples), toupper(names(df_check_sampid)))]
      
      # SampID_samples
      tbl_name <- "samples"
      df_check_sampid <- df_report_samples
      boo_sampid <- toupper(pk_samples) %in% toupper(names(df_check_sampid))
      if (boo_sampid == FALSE) {
        # end process with pop up
        msg <- paste("REQUIRED column (SampleID) missing!"
                     , paste0("Table: ", tbl_name)
                     , paste0("Value: ", pk_samples)
                     , sep = "\n\n" )
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ boo_sampID ~ samples
      col_sampid_samples <- names(df_check_sampid)[match(toupper(pk_samples), toupper(names(df_check_sampid)))]
      
      # SampID_flags
      tbl_name <- "flags"
      df_check_sampid <- df_report_flags
      boo_sampid <- toupper(pk_samples) %in% toupper(names(df_check_sampid))
      if (boo_sampid == FALSE) {
        # end process with pop up
        msg <- paste("REQUIRED column (SampleID) missing!"
                     , paste0("Table: ", tbl_name)
                     , paste0("Value: ", pk_samples)
                     , sep = "\n\n" )
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ boo_sampID ~ flags
      col_sampid_flags <- names(df_check_sampid)[match(toupper(pk_samples), toupper(names(df_check_sampid)))]
      
      
      # SampID_site
      # not needed for this table
      
      # SampID_taxatrans
      # not needed for this table
      
      # StatID_summary_wide
      tbl_name <- "summary_wide"
      df_check_sampid <- df_report_summary_wide
      boo_statid <- toupper(pk_stations) %in% toupper(names(df_check_sampid))
      if (boo_sampid == FALSE) {
        # end process with pop up
        msg <- paste("REQUIRED column (StationID) missing!"
                     , paste0("Table: ", tbl_name)
                     , paste0("Value: ", pk_samples)
                     , sep = "\n\n" )
        shinyalert::shinyalert(title = "Report"
                               , text = msg
                               , type = "error"
                               , closeOnEsc = TRUE
                               , closeOnClickOutside = TRUE)
        # shiny::validate(msg)
      }## IF ~ boo_statid ~ summary
      col_statid_summary_wide <- names(df_check_sampid)[match(toupper(pk_stations), toupper(names(df_check_sampid)))]
      
      ## Calc, 04, Excel ----
      prog_detail <- "Calculation, Create Excel"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
     
      ### Excel, SUBSET ----
      # Filter for each Station
      
      # Remove all files except Results Excel
      # Then download button only has one file to target
      # reuse code from df_import()
      # fn_results <- list.files(path_results_user
      #                          , full.names = TRUE
      #                          , include.dirs = TRUE
      #                          , recursive = TRUE)
      unlink(path_results_user, recursive = TRUE) # includes directories
      
      
      stations_all <- unique(df_report_site[, pk_stations])
  
      ## create file for each station
      #s <- stations_all[1] #QC
      
      for (s in stations_all) {

        s_num <- match(s, stations_all)
        s_total <- length(stations_all)
        msg <- paste0("Working on Report; Single Station; "
                      , s_num
                      , " of "
                      , s_total
                      , "; "
                      , s)
        message(msg)
        
        # Update progress
        prog_detail <- paste0("Calculation, Create Excel; "
                              , s_num
                              , "/"
                              , s_total)
        message(paste0("\n", prog_detail))
        # Increment the progress bar, and update the detail text.
        incProgress(1/s_total/prog_n, detail = prog_detail)
        Sys.sleep(prog_sleep)
 
      #### Munge Tables---
      # filter for current station
      # use table specific SampleID

      df_report_summary_header_s <- df_report_summary_header %>%
        dplyr::filter(.data[[pk_stations]] == s) %>%
        tidyr::pivot_longer(tidyr::everything()
                            , values_transform = as.character)

      df_report_summary_wide_s <- df_report_summary_wide %>%
        dplyr::filter(.data[[col_statid_summary_wide]] == s)
    
      # Samples for current Stations
      s_samps <- df_report_summary_wide_s %>%
        dplyr::pull(.data[[col_sampid_summary_wide]])
      
      df_report_topindicator_s <- df_report_topindicator  %>%
        dplyr::filter(.data[[col_sampid_topindicator]] %in% s_samps)
      
      df_report_samples_s <- df_report_samples  %>%
        dplyr::filter(.data[[col_sampid_samples]] %in% s_samps)
      
      df_report_flags_s <- df_report_flags  %>%
        dplyr::filter(.data[[col_sampid_flags]] %in% s_samps)
      
      df_report_site_s <- df_report_site %>%
        dplyr::filter(.data[[pk_stations]] == s) %>%
        tidyr::pivot_longer(tidyr::everything()
                            , values_transform = as.character)
      
      df_report_taxatrans_s <- df_report_taxatrans
      
      # transposed df remove names
      names(df_report_summary_header_s) <- c("", "")
      names(df_report_site_s) <- c("", "")
      
      ### Excel, WB, Create----
      # Create WB
      wb <- openxlsx::createWorkbook()
      openxlsx::addWorksheet(wb, "NOTES", tabColour = "darkgray")
      openxlsx::addWorksheet(wb, "summary")
      openxlsx::addWorksheet(wb, "topindicator")
      openxlsx::addWorksheet(wb, "samples")
      openxlsx::addWorksheet(wb, "flags")
      openxlsx::addWorksheet(wb, "site")
      openxlsx::addWorksheet(wb, "taxatrans")
      
      mySR <- 8 # number of rows to skip for new worksheets
      mySR_trans <- 2 # for transposed df, skip worksheet title
      
      ### Excel, Formatting ----
      #### Excel, Formatting, Styles ----
      style_title <- openxlsx::createStyle(fontName = "Cambria"
                                           , fontSize = 18
                                           , fontColour = "#1F497D"
                                           , textDecoration = "bold")
      style_h1 <- openxlsx::createStyle(fontName = "Calibri"
                                        , fontSize = 15
                                        , fontColour = "#1F497D"
                                        , textDecoration = "bold"
                                        , border = "Bottom"
                                        , borderColour = "#4F81BD"
                                        , borderStyle = "thick")
      style_h2 <- openxlsx::createStyle(fontName = "Calibri"
                                        , fontSize = 13
                                        , fontColour = "#1F497D"
                                        , textDecoration = "bold"
                                        , border = "Bottom"
                                        , borderColour = "#A7BFDE"
                                        , borderStyle = "thick")
      style_hyperlink <- openxlsx::createStyle(fontName = "Calibri"
                                               , fontSize = 11
                                               , fontColour = "#0000FF"
                                               , textDecoration = "underline")
      style_bold <- openxlsx::createStyle(textDecoration = "bold")
      style_date <- openxlsx::createStyle(numFmt = "DATE")
      style_halign_center <- openxlsx::createStyle(halign = "center")
      
      # options not exportable
      # openxlsx::options("openxlsx.dateFormat" = "yyyy-mm-dd")
      # openxlsx::options("openxlsx.datetimeFormat" = "yyyy-mm-dd hh:mm:ss")
      
      #### Excel, Formatting, CF, Styles ----
      # fgFill *only* works for Conditinal Formatting
      # no harm in adding bgFill for use with on CF
      style_cf_ft_vcold          <- openxlsx::createStyle(bgFill = "#140AE6"
                                                          , fgFill = "#140AE6")
      style_cf_ft_vcold_cold     <- openxlsx::createStyle(bgFill = "#0066FF"
                                                          , fgFill = "#0066FF")
      style_cf_ft_tie_vcold_cold <- openxlsx::createStyle(bgFill = "#7B9BF5"
                                                          , fgFill = "#7B9BF5")
      style_cf_ft_cold_vcold     <- openxlsx::createStyle(bgFill = "#0AE1EC"
                                                          , fgFill = "#0AE1EC")
      style_cf_ft_cold           <- openxlsx::createStyle(bgFill = "#9AF3FC"
                                                          , fgFill = "#9AF3FC")
      style_cf_ft_cold_cool      <- openxlsx::createStyle(bgFill = "#BEFEFB"
                                                          , fgFill = "#BEFEFB")
      style_cf_ft_tie_cold_cool  <- openxlsx::createStyle(bgFill = "#DDFBFF"
                                                          , fgFill = "#DDFBFF")
      style_cf_ft_cool_cold      <- openxlsx::createStyle(bgFill = "#C6FFB9"
                                                          , fgFill = "#C6FFB9")
      style_cf_ft_cool           <- openxlsx::createStyle(bgFill = "#34FB25"
                                                          , fgFill = "#34FB25")
      style_cf_ft_cool_warm      <- openxlsx::createStyle(bgFill = "#FFFF66"
                                                          , fgFill = "#FFFF66")
      style_cf_ft_tie_warm_cool  <- openxlsx::createStyle(bgFill = "#FFFFE5"
                                                          , fgFill = "#FFFFE5")
      style_cf_ft_warm_cool      <- openxlsx::createStyle(bgFill = "#E4DFEC"
                                                          , fgFill = "#E4DFEC")
      style_cf_ft_warm           <- openxlsx::createStyle(bgFill = "#FFC000"
                                                          , fgFill = "#FFC000")
      style_cf_ft_na             <- openxlsx::createStyle(bgFill = "#808080"
                                                          , fgFill = "#808080")
      style_cf_bcg_1             <- openxlsx::createStyle(bgFill = "blue"
                                                          , fgFill = "blue")
      style_cf_bcg_2             <- openxlsx::createStyle(bgFill = "green"
                                                          , fgFill = "green")
      style_cf_bcg_3             <- openxlsx::createStyle(bgFill = "lightgreen"
                                                          , fgFill = "lightgreen")
      style_cf_bcg_4             <- openxlsx::createStyle(bgFill = "gray"
                                                          , fgFill = "gray")
      style_cf_bcg_5             <- openxlsx::createStyle(bgFill = "orange"
                                                          , fgFill = "orange")
      style_cf_bcg_6             <- openxlsx::createStyle(bgFill = "red"
                                                          , fgFill = "red")
      style_cf_bcg_na            <- openxlsx::createStyle(bgFill = "#808080"
                                                          , fgFill = "#808080")
      style_cf_bdi_high          <- openxlsx::createStyle(bgFill = "blue"
                                                          , fgFill = "blue")
      style_cf_bdi_medium        <- openxlsx::createStyle(bgFill = "lightgreen"
                                                          , fgFill = "lightgreen")
      style_cf_bdi_low           <- openxlsx::createStyle(bgFill = "gray"
                                                          , fgFill = "gray")
      style_cf_bdi_na            <- openxlsx::createStyle(bgFill = "#808080"
                                                          , fgFill = "#808080")
      style_cf_mtti_vcold        <- openxlsx::createStyle(bgFill = "#00B0F0"
                                                          , fgFill = "#00B0F0")
      style_cf_mtti_cold         <- openxlsx::createStyle(bgFill = "#9AF3FC"
                                                          , fgFill = "#9AF3FC")
      style_cf_mtti_cool         <- openxlsx::createStyle(bgFill = "#92D050"
                                                          , fgFill = "#92D050")
      style_cf_mtti_cool_warm    <- openxlsx::createStyle(bgFill = "#FFFF00"
                                                          , fgFill = "#FFFF00")
      style_cf_mtti_warm         <- openxlsx::createStyle(bgFill = "#FFC000"
                                                          , fgFill = "#FFC000")
      style_cf_mtti_na           <- openxlsx::createStyle(bgFill = "#808080"
                                                          , fgFill = "#808080")
      style_cf_bcg2_1            <- openxlsx::createStyle(bgFill = "blue"
                                                          , fgFill = "blue")
      style_cf_bcg2_2            <- openxlsx::createStyle(bgFill = "green"
                                                          , fgFill = "green")
      style_cf_bcg2_2minus       <- openxlsx::createStyle(bgFill = "green"
                                                          , fgFill = "green")
      style_cf_bcg2_tie_2_3      <- openxlsx::createStyle(bgFill = "darkgreen"
                                                          , fgFill = "darkgreen")
      style_cf_bcg2_3plus        <- openxlsx::createStyle(bgFill = "lightgreen"
                                                          , fgFill = "lightgreen")
      style_cf_bcg2_3            <- openxlsx::createStyle(bgFill = "lightgreen"
                                                          , fgFill = "lightgreen")
      style_cf_bcg2_3minus       <- openxlsx::createStyle(bgFill = "lightgreen"
                                                          , fgFill = "lightgreen")
      style_cf_bcg2_tie_3_4      <- openxlsx::createStyle(bgFill = "yellow"
                                                          , fgFill = "yellow")
      style_cf_bcg2_4plus        <- openxlsx::createStyle(bgFill = "gray"
                                                          , fgFill = "gray")
      style_cf_bcg2_4            <- openxlsx::createStyle(bgFill = "gray"
                                                          , fgFill = "gray")
      style_cf_bcg2_4minus       <- openxlsx::createStyle(bgFill = "gray"
                                                          , fgFill = "gray")
      style_cf_bcg2_tie_4_5      <- openxlsx::createStyle(bgFill = "brown"
                                                          , fgFill = "brown")
      style_cf_bcg2_5plus        <- openxlsx::createStyle(bgFill = "orange"
                                                          , fgFill = "orange")
      style_cf_bcg2_5            <- openxlsx::createStyle(bgFill = "orange"
                                                          , fgFill = "orange")
      style_cf_bcg2_5minus       <- openxlsx::createStyle(bgFill = "orange"
                                                          , fgFill = "orange")
      style_cf_bcg2_tie_5_6      <- openxlsx::createStyle(bgFill = "purple"
                                                          , fgFill = "purple")
      style_cf_bcg2_6plus        <- openxlsx::createStyle(bgFill = "red"
                                                          , fgFill = "red")
      style_cf_bcg2_6            <- openxlsx::createStyle(bgFill = "red"
                                                          , fgFill = "red")
      style_cf_bcg2_na           <- openxlsx::createStyle(bgFill = "#808080"
                                                          , fgFill = "#808080")
      
      #### Excel, Formatting, CF, Rules ----
      cf_rule_ft_vcold          <- "VeryCold"
      cf_rule_ft_vcold_cold     <- "VCold_Cold"
      cf_rule_ft_tie_vcold_cold <- "TIE_VCold_Cold"
      cf_rule_ft_cold_vcold     <- '="Cold_VCold"'
      cf_rule_ft_cold           <- '="Cold"'
      cf_rule_ft_cold_cool      <- '="Cold_Cool"'
      cf_rule_ft_tie_cold_cool  <- '="TIE_Cold_Cool"'
      cf_rule_ft_cool_cold      <- '="Cool_Cold"'
      cf_rule_ft_cool           <- '="Cool"'
      cf_rule_ft_cool_warm      <- '="Cool_Warm"'
      cf_rule_ft_tie_warm_cool  <- '="TIE_Warm_Cool"'
      cf_rule_ft_warm_cool      <- '="Warm_Cool"'
      cf_rule_ft_warm           <- '="Warm"'
      cf_rule_ft_na             <- '="NA"'
      cf_rule_bcg_1             <- '="1"'
      cf_rule_bcg_2             <- '="2"'
      cf_rule_bcg_3             <- '="3"'
      cf_rule_bcg_4             <- '="4"'
      cf_rule_bcg_5             <- '="5"'
      cf_rule_bcg_6             <- '="6"'
      cf_rule_bcg_na            <- '="NA"'
      cf_rule_bdi_high          <- '="High"'
      cf_rule_bdi_medium        <- '="Medium"'
      cf_rule_bdi_low           <- '="Low"'
      cf_rule_bdi_na            <- '="NA"'
      cf_rule_mtti_vcold        <- '="Very cold"'
      cf_rule_mtti_cold         <- '="Cold"'
      cf_rule_mtti_cool         <- '="Cool"'
      cf_rule_mtti_cool_warm    <- '="Cool/warm"'
      cf_rule_mtti_warm         <- '="Warm"'
      cf_rule_mtti_na           <- '="NA"'
      cf_rule_bcg2_1            <- '="1"'
      cf_rule_bcg2_2            <- '="2"'
      cf_rule_bcg_2minus        <- '="2-"'
      cf_rule_bcg2_tie_2_3      <- '="2/3 tie"'
      cf_rule_bcg2_3plus        <- '="3+"'
      cf_rule_bcg2_3            <- '="3"'
      cf_rule_bcg2_3minus       <- '="3-"'
      cf_rule_bcg2_tie_3_4      <- '="3/4 tie"'
      cf_rule_bcg2_4plus        <- '="4+"'
      cf_rule_bcg2_4            <- '="4"'
      cf_rule_bcg2_4minus       <- '="4-"'
      cf_rule_bcg2_tie_4_5      <- '="4/5 tie"'
      cf_rule_bcg2_5plus        <- '="5+"'
      cf_rule_bcg2_5            <- '="5"'
      cf_rule_bcg2_5minus       <- '="5-"'
      cf_rule_bcg2_tie_5_6      <- '="5/6 tie"'
      cf_rule_bcg2_6plus        <- '="6+"'
      cf_rule_bcg2_6            <- '="6"'
      cf_rule_bcg2_na           <- '="NA"'
      
      ### Excel, WS, data ----
      #### Excel, WS, data, NOTES----
      openxlsx::writeData(wb
                          , sheet = "NOTES"
                          , x = notes_head
                          , startCol = 1
                          , startRow = 1
                          , colNames = FALSE)
      openxlsx::writeDataTable(wb
                               , sheet = "NOTES"
                               , x = notes_toc
                               , startCol = 1
                               , startRow = 15
                               , colNames = TRUE
                               , tableStyle = "TableStyleMedium9")
      
      openxlsx::addStyle(wb
                         , sheet = "NOTES"
                         , rows = 1
                         , cols = 1
                         , style = style_title)
      openxlsx::addStyle(wb
                         , sheet = "NOTES"
                         , rows = 2
                         , cols = 1
                         , style = style_h1)
      openxlsx::addStyle(wb
                         , sheet = "NOTES"
                         , rows = 4
                         , cols = 1
                         , style = style_hyperlink)
      openxlsx::addStyle(wb
                         , sheet = "NOTES"
                         , rows = 5
                         , cols = 1
                         , style = style_date)
      openxlsx::addStyle(wb
                         , sheet = "NOTES"
                         , rows = 7:9
                         , cols = 1
                         , style = style_bold)
      openxlsx::addStyle(wb
                         , sheet = "NOTES"
                         , rows = 11
                         , cols = 1
                         , style = style_h2)
      
      
      
      #### Excel, WS, data, Summary, Header ----
      # transposed
      openxlsx::writeData(wb
                          , sheet = "summary"
                          , x = df_report_summary_header_s
                          , startCol = 1
                          , startRow = mySR_trans)
      
      #### Excel, WS, data, Summary, Color Thresholds ----
      mySC_colthresh <- 8
      # Title
      openxlsx::writeData(wb
                          , sheet = "summary"
                          , x = "Color Code Thresholds"
                          , startCol = mySC_colthresh
                          , startRow = 1)
      # Title Style
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 1
                         , cols = mySC_colthresh:(mySC_colthresh + ncol(df_col_thresh))
                         , style = style_h2)
      # Body
      openxlsx::writeData(wb
                          , sheet = "summary"
                          , x = df_col_thresh
                          , startCol = mySC_colthresh
                          , startRow = 2
                          , headerStyle = style_bold)
      
     
      #### Excel, WS, data, Summary, Wide ----
      # below transposed header
      mySF_summmary_wide <- mySR_trans +
                                    nrow(df_report_summary_header_s) +
                                    2
      openxlsx::writeData(wb
                    , sheet = "summary"
                    , x = df_report_summary_wide_s
                    , startCol = 1
                    , startRow = mySF_summmary_wide
                    , headerStyle = style_bold
                    , withFilter = TRUE)
      
      #### Excel, WS, data, Top Indicator ----
      openxlsx::writeData(wb
                          , sheet = "topindicator"
                          , x = df_report_topindicator_s
                          , startCol = 1
                          , startRow = mySR
                          , headerStyle = style_bold
                          , withFilter = TRUE)
      
      #### Excel, WS, data, Samples ----
      # transposed
      openxlsx::writeData(wb
                          , sheet = "samples"
                          , x = df_report_samples_s
                          , startCol = 1
                          , startRow = mySR
                          , headerStyle = style_bold
                          , withFilter = TRUE)
      
      
      #### Excel, WS, data, Flags ----
      openxlsx::writeData(wb
                          , sheet = "flags"
                          , x = df_report_flags_s
                          , startCol = 1
                          , startRow = mySR
                          , headerStyle = style_bold
                          , withFilter = TRUE)
      
      #### Excel, WS, data, Site ----
      openxlsx::writeData(wb
                          , sheet = "site"
                          , x = df_report_site_s
                          , startCol = 1
                          , startRow = mySR
                          , headerStyle = style_bold)
      
      #### Excel, WS, data, Taxa Trans ----
      openxlsx::writeData(wb
                          , sheet = "taxatrans"
                          , x = df_report_taxatrans_s
                          , startCol = 1
                          , startRow = mySR
                          , headerStyle = style_bold
                          , withFilter = TRUE)
      
      ### Excel, Freeze Panes----
      openxlsx::freezePane(wb
                           , sheet = "summary"
                           , firstActiveRow = mySF_summmary_wide + 1
                           , firstActiveCol = "E")
      openxlsx::freezePane(wb
                           , sheet = "topindicator"
                           , firstActiveRow = mySR + 1)
      openxlsx::freezePane(wb
                           , sheet = "samples"
                           , firstActiveRow = mySR + 1)
      openxlsx::freezePane(wb
                           , sheet = "flags"
                           , firstActiveRow = mySR + 1)
      openxlsx::freezePane(wb, sheet = "site"
                           , firstActiveRow = mySR + 1)
      openxlsx::freezePane(wb
                           , sheet = "taxatrans"
                           , firstActiveRow = mySR + 1)
      
      ### Excel, Auto-Filter----
      # Add with writeData
      # 
      # openxlsx::addFilter(wb
      #                     , sheet = "summary"
      #                     , rows = mySR
      #                     , cols = 1:ncol(df_report_summary_wide))
      # openxlsx::addFilter(wb
      #                     , sheet = "topindicator"
      #                     , rows = mySR
      #                     , cols = 1:ncol(df_report_topindicator))
      # openxlsx::addFilter(wb
      #                     , sheet = "samples"
      #                     , rows = mySR
      #                     , cols = 1:ncol(df_report_samples))
      # openxlsx::addFilter(wb
      #                     , sheet = "flags"
      #                     , rows = mySR
      #                     , cols = 1:ncol(df_report_flags))
      # openxlsx::addFilter(wb
      #                     , sheet = "site"
      #                     , rows = mySR
      #                     , cols = 1:ncol(df_report_site))
      # openxlsx::addFilter(wb
      #                     , sheet = "taxatrans"
      #                     , rows = mySR
      #                     , cols = 1:ncol(df_report_taxatrans))
      
      
      
      ### Excel, WS Name to A1 ----
      # name
      openxlsx::writeData(wb
                          , sheet = "summary"
                          , x = "summary"
                          , startCol = 1
                          , startRow = 1)
      openxlsx::writeData(wb
                          , sheet = "topindicator"
                          , x = "topindicator"
                          , startCol = 1
                          , startRow = 1)
      openxlsx::writeData(wb
                          , sheet = "samples"
                          , x = "samples"
                          , startCol = 1
                          , startRow = 1)
      openxlsx::writeData(wb
                          , sheet = "flags"
                          , x = "flags"
                          , startCol = 1
                          , startRow = 1)
      openxlsx::writeData(wb
                          , sheet = "site"
                          , x = "site"
                          , startCol = 1
                          , startRow = 1)
      openxlsx::writeData(wb
                          , sheet = "taxatrans"
                          , x = "taxatrans"
                          , startCol = 1
                          , startRow = 1)
      # style
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 1
                         , cols = 1:4
                         , style = style_h1)
      openxlsx::addStyle(wb
                         , sheet = "topindicator"
                         , rows = 1
                         , cols = 1:4
                         , style = style_h1)
      openxlsx::addStyle(wb
                         , sheet = "samples"
                         , rows = 1
                         , cols = 1:4
                         , style = style_h1)
      openxlsx::addStyle(wb
                         , sheet = "flags"
                         , rows = 1
                         , cols = 1:4
                         , style = style_h1)
      openxlsx::addStyle(wb
                         , sheet = "site"
                         , rows = 1
                         , cols = 1:4
                         , style = style_h1)
      openxlsx::addStyle(wb
                         , sheet = "taxatrans"
                         , rows = 1
                         , cols = 1:4
                         , style = style_h1)
      
      ### Excel, Apply Style ----
      
      #### NOTES, Named Range
      openxlsx::createNamedRegion(wb
                                  , sheet = "NOTES"
                                  , name = "FileName"
                                  , rows = 8
                                  , cols = 2)
      

      ##### summary, Color Thresholds----
      ## Center justify to all but last col
      # openxlsx::addStyle(wb
      #                    , sheet = "summary"
      #                    , rows = 3:7
      #                    , cols = 8:16
      #                    , style = style_halign_center
      #                    , gridExpand = TRUE)
      ## NA to all
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 3:7
                         , cols = 8:17
                         , style = style_cf_ft_na
                         , gridExpand = TRUE)
      ##### MTTI----
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 3
                         , cols = 8
                         , style = style_cf_mtti_vcold
                         , gridExpand = TRUE)
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 4
                         , cols = 8
                         , style = style_cf_mtti_cold
                         , gridExpand = TRUE)
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 5
                         , cols = 8
                         , style = style_cf_mtti_cool
                         , gridExpand = TRUE)
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 6
                         , cols = 8
                         , style = style_cf_mtti_cool_warm
                         , gridExpand = TRUE)
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 7
                         , cols = 8
                         , style = style_cf_ft_warm
                         , gridExpand = TRUE)
      ##### thermal metrics----
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 3
                         , cols = c(10:11, 12, 13:15, 17)
                         , style = style_cf_ft_vcold_cold
                         , gridExpand = TRUE)
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 4
                         , cols = c(10, 11, 12, 13:15, 17)
                         , style = style_cf_ft_cold
                         , gridExpand = TRUE)
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 5
                         , cols = c(11, 12, 13, 14, 15, 17)
                         , style = style_cf_ft_cool
                         , gridExpand = TRUE)
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 6
                         , cols = c(11:15, 17)
                         , style = style_cf_ft_tie_warm_cool
                         , gridExpand = TRUE)
      openxlsx::addStyle(wb
                         , sheet = "summary"
                         , rows = 7
                         , cols = c(15:17)
                         , style = style_cf_ft_warm
                         , gridExpand = TRUE)
      
      
 
      ### Excel, col width ----
      # "auto" doesn't seem to work as it only looks at the first row
      # add 2 for filter
      widths_val_filt <- 3
      widths_val_min <- 6
    # not quite right but close enough
    # not sure if getting proper names() for widths
      
      #NOTES
      widths_notes <- c(23, 39, 23)
      openxlsx::setColWidths(wb   
                             , sheet = "NOTES"
                             , cols = seq_len(length(widths_notes))
                             , widths = widths_notes)
      
    
      df_widths <- df_report_summary_wide_s
      widths_min <- rep(widths_val_min, ncol(df_widths))
      widths_df <- unlist(lapply(df_widths, function(x) max(nchar(x), na.rm = TRUE)))
      widths_names <- unlist(lapply(names(df_widths), function(x) max(nchar(x), na.rm = TRUE)))
      widths_excel <- pmax(widths_min
                           , widths_df
                           , widths_names
                           , na.rm = TRUE) + widths_val_filt
      openxlsx::setColWidths(wb
                             , sheet = "summary"
                             , cols = seq_len(ncol(df_widths))
                             , widths = widths_excel)
      rm(df_widths)
      
      df_widths <- df_report_topindicator_s
      widths_min <- rep(widths_val_min, ncol(df_widths))
      widths_df <- unlist(lapply(df_widths, function(x) max(nchar(x), na.rm = TRUE)))
      widths_names <- unlist(lapply(names(df_widths), function(x) max(nchar(x), na.rm = TRUE)))
      widths_excel <- pmax(widths_min
                           , widths_df
                           , widths_names
                           , na.rm = TRUE) + widths_val_filt
      openxlsx::setColWidths(wb
                             , sheet = "topindicator"
                             , cols = seq_len(ncol(df_widths))
                             , widths = widths_excel)
      rm(df_widths)

      df_widths <- df_report_samples_s
      widths_min <- rep(widths_val_min, ncol(df_widths))
      widths_df <- unlist(lapply(df_widths, function(x) max(nchar(x), na.rm = TRUE)))
      widths_names <- unlist(lapply(names(df_widths), function(x) max(nchar(x), na.rm = TRUE)))
      widths_excel <- pmax(widths_min
                           , widths_df
                           , widths_names
                           , na.rm = TRUE) + widths_val_filt
      openxlsx::setColWidths(wb
                             , sheet = "samples"
                             , cols = seq_len(ncol(df_widths))
                             , widths = widths_excel)
      rm(df_widths)
      
      df_widths <- df_report_flags_s
      widths_min <- rep(widths_val_min, ncol(df_widths))
      widths_df <- unlist(lapply(df_widths, function(x) max(nchar(x), na.rm = TRUE)))
      widths_names <- unlist(lapply(names(df_widths), function(x) max(nchar(x), na.rm = TRUE)))
      widths_excel <- pmax(widths_min
                           , widths_df
                           , widths_names
                           , na.rm = TRUE) + widths_val_filt
      openxlsx::setColWidths(wb
                             , sheet = "flags"
                             , cols = seq_len(ncol(df_widths))
                             , widths = widths_excel)
      
      df_widths <- df_report_site_s
      widths_min <- rep(widths_val_min, ncol(df_widths))
      widths_df <- unlist(lapply(df_widths, function(x) max(nchar(x), na.rm = TRUE)))
      widths_names <- unlist(lapply(names(df_widths), function(x) max(nchar(x), na.rm = TRUE)))
      widths_excel <- pmax(widths_min
                           , widths_df
                           , widths_names
                           , na.rm = TRUE) + widths_val_filt
      openxlsx::setColWidths(wb
                             , sheet = "site"
                             , cols = seq_len(ncol(df_widths))
                             , widths = widths_excel)
      rm(df_widths)
     
      df_widths <- df_report_taxatrans_s
      widths_min <- rep(widths_val_min, ncol(df_widths))
      widths_df <- unlist(lapply(df_widths, function(x) max(nchar(x), na.rm = TRUE)))
      widths_names <- unlist(lapply(names(df_widths), function(x) max(nchar(x), na.rm = TRUE)))
      widths_excel <- pmax(widths_min
                           , widths_df
                           , widths_names
                           , na.rm = TRUE) + widths_val_filt
      openxlsx::setColWidths(wb
                             , sheet = "taxatrans"
                             , cols = seq_len(ncol(df_widths))
                             , widths = widths_excel)
      rm(df_widths)

      ### Excel, Conditional Formatting----
      
      #### Excel, CF, Fuzzy Thermal----
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="VeryCold"'
      #                       , style = style_cf_ft_vcold)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="VCold_Cold"'
      #                       , style = style_cf_ft_vcold_cold)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="TIE_VCold_Cold"'
      #                       , style = style_cf_ft_tie_vcold_cold)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="Cold_VCold"'
      #                       , style = style_cf_ft_cold_vcold)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="Cold"'
      #                       , style = style_cf_ft_cold)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="Cold_Cool"'
      #                       , style = style_cf_ft_cold_cool)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="TIE_Cold_Cool"'
      #                       , style = style_cf_ft_tie_cold_cool)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="Cool_Cold"'
      #                       , style = style_cf_ft_cool_cold)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="Cool"'
      #                       , style = style_cf_ft_cool)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="Cool_Warm"'
      #                       , style = style_cf_ft_cool_warm)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="TIE_Warm_Cool"'
      #                       , style = style_cf_ft_tie_warm_cool)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="Warm_Cool"'
      #                       , style = style_cf_ft_warm_cool)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="Warm"'
      #                       , style = style_cf_ft_warm)
      # conditionalFormatting(wb, "Fuzzy_Thermal"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_ft))
      #                       , rule = '="NA"'
      #                       , style = style_cf_ft_na)
      #
      #### Excel, CF, BCG----
      # conditionalFormatting(wb, "BCG"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg))
      #                       , rule = '="1"'
      #                       , style = style_cf_bcg_1)
      # conditionalFormatting(wb, "BCG"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg))
      #                       , rule = '="2"'
      #                       , style = style_cf_bcg_2)
      # conditionalFormatting(wb, "BCG"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg))
      #                       , rule = '="3"'
      #                       , style = style_cf_bcg_3)
      # conditionalFormatting(wb, "BCG"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg))
      #                       , rule = '="4"'
      #                       , style = style_cf_bcg_4)
      # conditionalFormatting(wb, "BCG"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg))
      #                       , rule = '="5"'
      #                       , style = style_cf_bcg_5)
      # conditionalFormatting(wb, "BCG"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg))
      #                       , rule = '="6"'
      #                       , style = style_cf_bcg_6)
      #
      # conditionalFormatting(wb, "BCG"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg))
      #                       , rule = '="NA"'
      #                       , style = style_cf_bcg_na)
      #
      #### Excel, CF, BDI----
      #
      # conditionalFormatting(wb, "BDI"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bdi))
      #                       , rule = '="High"'
      #                       , style = style_cf_bdi_high)
      # conditionalFormatting(wb, "BDI"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bdi))
      #                       , rule = '="Medium"'
      #                       , style = style_cf_bdi_medium)
      # conditionalFormatting(wb, "BDI"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bdi))
      #                       , rule = '="Low"'
      #                       , style = style_cf_bdi_low)
      # conditionalFormatting(wb, "BDI"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bdi))
      #                       , rule = '="NA"'
      #                       , style = style_cf_bdi_na)
      #
      #
      #### Excel, CF, BCG2----
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="1"'
      #                       , style = style_cf_bcg2_1)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="2"'
      #                       , style = style_cf_bcg2_2)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="2-"'
      #                       , style = style_cf_bcg2_2minus)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="2/3 tie"'
      #                       , style = style_cf_bcg2_tie_2_3)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="3+"'
      #                       , style = style_cf_bcg2_3plus)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="3"'
      #                       , style = style_cf_bcg2_3)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="3-"'
      #                       , style = style_cf_bcg2_3minus)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="3/4 tie"'
      #                       , style = style_cf_bcg2_tie_3_4)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="4+"'
      #                       , style = style_cf_bcg2_4plus)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="4"'
      #                       , style = style_cf_bcg2_4)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="4-"'
      #                       , style = style_cf_bcg2_4minus)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="4/5 tie"'
      #                       , style = style_cf_bcg2_tie_4_5)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="5+"'
      #                       , style = style_cf_bcg2_5plus)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="5"'
      #                       , style = style_cf_bcg2_5)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="5-"'
      #                       , style = style_cf_bcg2_5minus)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="5/6 tie"'
      #                       , style = style_cf_bcg2_tie_5_6)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="6+"'
      #                       , style = style_cf_bcg2_6plus)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="6"'
      #                       , style = style_cf_bcg2_6)
      # conditionalFormatting(wb, "BCG2"
      #                       , cols = 2
      #                       , rows = (mySR + 1):(mySR + nrow(df_bcg2))
      #                       , rule = '="NA"'
      #                       , style = style_cf_bcg2_na)
      

      #### Excel, CF, summary, MTTI----
      df_cf <- df_report_summary_wide_s
      cols_cf <- match("MTTI", names(df_cf)) 
      rows_cf <- (mySF_summmary_wide + 1):(mySF_summmary_wide + nrow(df_cf))
      
      # Applied in reverse order in Excel
      openxlsx::conditionalFormatting(wb, "summary"
                            , cols = cols_cf
                            , rows = rows_cf
                            , rule = '="NA"'
                            , style = style_cf_mtti_na)
      openxlsx::conditionalFormatting(wb, "summary"
                            , cols = cols_cf
                            , rows = rows_cf
                            , rule = '>=23'
                            , style = style_cf_mtti_warm)
      openxlsx::conditionalFormatting(wb, "summary"
                            , cols = cols_cf
                            , rows = rows_cf
                            , rule = '<23'
                            , style = style_cf_mtti_cool_warm)
      openxlsx::conditionalFormatting(wb, "summary"
                            , cols = cols_cf
                            , rows = rows_cf
                            , rule = '<21'
                            , style = style_cf_mtti_cool)
      openxlsx::conditionalFormatting(wb, "summary"
                            , cols = cols_cf
                            , rows = rows_cf
                            , rule = '<19'
                            , style = style_cf_mtti_cold)
      openxlsx::conditionalFormatting(wb, "summary"
                            , cols = cols_cf
                            , rows = rows_cf
                            , rule = '<16'
                            , style = style_cf_mtti_vcold)

      #### Excel, CF, summary, Thermal Metrics----
      df_cf <- df_report_summary_wide_s
      rows_cf <- (mySF_summmary_wide + 1):(mySF_summmary_wide + nrow(df_cf))
 
      ##### nt_ti_stenocold----
      myMetNam <- "nt_ti_stenocold"
      cols_cf <- match(myMetNam, names(df_col_thresh)) + mySC_colthresh - 1
      #
      if (!is.na(cols_cf)) {
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '="NA"'
                                        , style = style_cf_ft_na)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=3'
                                        , style = style_cf_ft_vcold_cold)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=1'
                                        , style = style_cf_ft_cold)
      }## IF ~ !is.na(cols_cf)
      
      ##### nt_ti_stenocold_cold----
      myMetNam <- "nt_ti_stenocold_cold"
      cols_cf <- match(myMetNam, names(df_col_thresh)) + mySC_colthresh - 1
      #
      if (!is.na(cols_cf)) {
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '="NA"'
                                        , style = style_cf_ft_na)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=1'
                                        , style = style_cf_ft_tie_warm_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=3'
                                        , style = style_cf_ft_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=5'
                                        , style = style_cf_ft_cold)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=10'
                                        , style = style_cf_ft_vcold_cold)
      }## IF ~ !is.na(cols_cf)
      
      openxlsx::openXL(wb)
      
      ##### nt_ti_stenocold_cold_cool----
      myMetNam <- "nt_ti_stenocold_cold_cool"
      cols_cf <- match(myMetNam, names(df_col_thresh)) + mySC_colthresh - 1
      #
      if (!is.na(cols_cf)) {
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '="NA"'
                                        , style = style_cf_ft_na)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=9'
                                        , style = style_cf_ft_tie_warm_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=20'
                                        , style = style_cf_ft_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=25'
                                        , style = style_cf_ft_cold)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=30'
                                        , style = style_cf_ft_vcold_cold)
      }## IF ~ !is.na(cols_cf)
      
      ##### pt_ti_stenocold_cold_cool----
      myMetNam <- "pt_ti_stenocold_cold_cool"
      cols_cf <- match(myMetNam, names(df_col_thresh)) + mySC_colthresh - 1
      #
      if (!is.na(cols_cf)) {
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '="NA"'
                                        , style = style_cf_ft_na)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=20'
                                        , style = style_cf_ft_tie_warm_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=35'
                                        , style = style_cf_ft_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=50'
                                        , style = style_cf_ft_cold)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=65'
                                        , style = style_cf_ft_vcold_cold)
      }## IF ~ !is.na(cols_cf)
      
      ##### pi_ti_stenocold_cold_cool----
      myMetNam <- "pi_ti_stenocold_cold_cool"
      cols_cf <- match(myMetNam, names(df_col_thresh)) + mySC_colthresh - 1
      #
      if (!is.na(cols_cf)) {
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '="NA"'
                                        , style = style_cf_ft_na)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=10'
                                        , style = style_cf_ft_tie_warm_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=30'
                                        , style = style_cf_ft_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=40'
                                        , style = style_cf_ft_cold)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=55'
                                        , style = style_cf_ft_vcold_cold)
      }## IF ~ !is.na(cols_cf)
      
      ##### pt_ti_warm_stenowarm----
      myMetNam <- "pt_ti_warm_stenowarm"
      cols_cf <- match(myMetNam, names(df_col_thresh)) + mySC_colthresh - 1
      #
      if (!is.na(cols_cf)) {
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '="NA"'
                                        , style = style_cf_ft_na)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=40'
                                        , style = style_cf_ft_warm)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '<40'
                                        , style = style_cf_ft_tie_warm_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '<15'
                                        , style = style_cf_ft_cool)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '<10'
                                        , style = style_cf_ft_cold)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '<5'
                                        , style = style_cf_ft_vcold_cold)
      }## IF ~ !is.na(cols_cf)
     
      ##### nt_ti_stenowarm----
      myMetNam <- "nt_ti_stenowarm"
      cols_cf <- match(myMetNam, names(df_col_thresh)) + mySC_colthresh - 1
      #
      if (!is.na(cols_cf)) {
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '="NA"'
                                        , style = style_cf_ft_na)
        openxlsx::conditionalFormatting(wb, "summary"
                                        , cols = cols_cf
                                        , rows = rows_cf
                                        , rule = '>=2'
                                        , style = style_cf_ft_warm)
      }## IF ~ !is.na(cols_cf)
      
      
      # # CF, data bar
      # addWorksheet(wb, "databar")
      # writeData(wb, "databar", -5:5)
      # conditionalFormatting(wb, "databar", cols = 1, rows = 1:12, type = "databar")
      
      ### Excel, WB, Save  ----
      # prog_detail <- "Save Results"
      # message(paste0("\n", prog_detail))
      # # Increment the progress bar, and update the detail text.
      # incProgress(1/prog_n, detail = prog_detail)
      # Sys.sleep(prog_sleep)
      # 

      # Save new Excel file.
      fn_wb <- file.path(path_results_sub, paste0("results_", s, ".xlsx"))
      openxlsx::saveWorkbook(wb, fn_wb, overwrite = TRUE)
      
      }## FOR ~ s
      
      ## Calc, 04, Zip Results ----
      prog_detail <- "Create Zip File"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      fn_4zip <- list.files(path = path_results
                            , full.names = TRUE)
      zip::zip(file.path(path_results, "results.zip"), fn_4zip)
      
      
      ## Calc, 05, Clean Up ----
      prog_detail <- "Clean Up"
      message(paste0("\n", prog_detail))
      # Increment the progress bar, and update the detail text.
      incProgress(1/prog_n, detail = prog_detail)
      Sys.sleep(prog_sleep)
      
      # button, enable, download
      shinyjs::enable("b_download_rep_single")
      
    }## expr ~ withProgress ~
    , message = "Calculating Report, Single"
    )## withProgress ~
  }##expr ~ ObserveEvent ~
  )##observeEvent ~ b_calc_rep_single
  
  
  
  ## b_download_rep_multi ----
  output$b_download_rep_multi <- downloadHandler(
    
    filename = function() {
      inFile <- input$fn_input_rep_multi
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      fn_abr <- abr_report
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".xlsx")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, dn_files_report, "results.xlsx"), fname)
      
    }##content~END
  )##download ~ Report Single

  
  ## b_download_rep_single ----
  output$b_download_rep_single <- downloadHandler(
  
    filename = function() {
      inFile <- input$fn_input_rep_single
      fn_input_base <- tools::file_path_sans_ext(inFile$name)
      fn_abr <- abr_report
      fn_abr_save <- paste0("_", fn_abr, "_")
      paste0(fn_input_base
             , fn_abr_save
             , format(Sys.time(), "%Y%m%d_%H%M%S")
             , ".zip")
    } ,
    content = function(fname) {##content~START
      
      file.copy(file.path(path_results, "results.zip"), fname)
      
    }##content~END
  )##download ~ Report single
  
 # Report, Multi ----

  ## b_Calc_rep_multi ----
 
  
  
  
})##shinyServer ~ END
