# File Builder Panel

function() {
  sidebarLayout(
    sidebarPanel(h2("2. File Builder")
            , useShinyjs()
            
            , p("The process below will combine user data with an official taxa list.")
            #, br()
            , h4("2.A. Upload a file.")
            , p("If no file name showing below repeat 'Import File' in the left sidebar.")
            , p(textOutput("fn_input_display2"))
            
            , h4("2.B. Select Official File.")
            , uiOutput("UI_taxatrans_pick_official")
            #, uiOutput("UI_taxatrans_pick_official_project")
            
            , h4("2.C. User File Options")
            , uiOutput("UI_taxatrans_user_col_taxaid")
            # , p("Select any columns to drop from output. All other columns will be retained.")
            # , uiOutput("UI_taxatrans_user_col_drop")
            
            , h4("2.D. Combine Duplicate Taxa Within Samples")
            , p("Taxa names that have more than one entry in a sample are combined into one entry per sample, with summed counts. For example, a taxon that has multiple entries due to differences in OTU are consolidated into one entry for the calculation.")
            , checkboxInput("cb_TaxaTrans_Summ"
                            , "Combine same taxa in samples"
                            , value = TRUE)
            , p("If TRUE select boxes below (between lines) are used when running operation.")
            , hr(style = "border-top: 1px solid #000000;")
            # only if checkbox above is TRUE
            #, shinyjs::disableduiOutput("UI_taxatrans_user_col_n_taxa"))
            , uiOutput("UI_taxatrans_user_col_n_taxa")
            , p("Select user file columns for grouping the taxa counts after combining with official taxa file.")
            , p("All other columns will be dropped.")
            , p("For example, SAMPID and TAXA_ID")
            #, shinyjs::disabled(uiOutput("UI_taxatrans_user_col_groupby"))
            , uiOutput("UI_taxatrans_user_col_groupby")
            , hr(style = "border-top: 1px solid #000000;")
           
            , h4("2.E. Run Operation")
            , p("This button will merge the user file with the official taxa file")
            , shinyjs::disabled(shinyBS::bsButton("b_taxatrans_calc"
                                                  , label = "Run Operation"))
            
            , h4("2.F. Download Results")
            , p("All input and output files will be available in a single zip file.")
            , shinyjs::disabled(downloadButton("b_taxatrans_download"
                                               , "Download Results"))
           
    )## sidebarPanel ~ END
           
           
    , mainPanel(
      p("Apply taxa translation before running calculations")
      # tabsetPanel(type = "tabs"
      #             , tabPanel(title = "Calc_BCG_About"
      #                        ,includeHTML(file.path("www", "rmd_html", "ShinyHTML_Calc_BCG_1About.html"))
      #             )
      #             , tabPanel(title = "Calc_BCG_Input"
      #                        ,includeHTML(file.path("www", "rmd_html", "ShinyHTML_Calc_BCG_2Input.html"))
      #             )
      #             , tabPanel(title = "Calc_BCG_Output"
      #                        ,includeHTML(file.path("www", "rmd_html", "ShinyHTML_Calc_BCG_3Output.html"))
      #             )
      # )## tabsetPanel ~ END
      , p("URLs for Official taxa file and metadata are below:")
      , p("Both files are included in the output of the taxa translator function.")
      , p("Temporary link to GitHub (all files).")
      , p("A future update will link directly to the selected dataset.")
      , a("Taxa Translate Official Files on GitHub"
          , href = "https://github.com/leppott/BioMonTools_SupportFiles/tree/main/data/taxa_official"
          , target = "_blank")
      
    )## mainPanel ~ END
  )##sidebarLayout ~ END
  
  
}##FUNCTION ~ END
