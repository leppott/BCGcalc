# Calculate BCG Panel

function() {
  sidebarLayout(
    sidebarPanel(
       h2("Calculate BCG Model")
       , p("This function will render all steps and make available files for download.")
       , br()
       
       , h4("A. Upload a file.")
       , p("If no file name showing below repeat 'Import File' in the left sidebar.")
       , p(textOutput("fn_input_display_bcg"))
       
       , h4("B. Define Community (for metrics).")
       , selectInput("si_community"
                     , label = "Community"
                     , choices = sel_community
                     , selected = "bugs")
       
       , h4("C. Mark Redundant (Non-Distinct) Taxa")
       , includeHTML(file.path("www", "rmd_html", "ShinyHTML_RedundantTaxa.html"))
       , checkboxInput("ExclTaxa"
                       , "Generate Redundant Taxa Column"
                       , TRUE)
       
       , h4("D. Define BCG Model.")
       , p("Determined by INDEX_NAME and INDEX_CLASS in data input file.")
       # , selectInput("si_model"
       #               , label = "BCG Model"
       #               , choices = sel_bcg_models
       #               , selected = "BCG_MariNW_Bugs500ct")
       #, uiOutput("UI_col_calcmet_Cols2Keep")
       
       , h4("E. User File Column Names")
       
       , h6("Model Experience Fields")
       , p("These fields will be used to check if sites are within the experience of the model.")
       , p("If the default values are present they will be auto-populated.")
       # SampleID (really for group_by)
       , uiOutput("UI_bcg_modelexp_user_col_eco3")
       , uiOutput("UI_bcg_modelexp_user_col_precip")
       , uiOutput("UI_bcg_modelexp_user_col_wshedarea_km2")
       
       , h4("F. Run Calculations")
       , p("This button will calculate metrics values, metric memberships
           , level membership, and level assignment.")
       , useShinyjs()
       , shinyjs::disabled(shinyBS::bsButton("b_calc_bcg"
                                             , label = "Run Calculations"))
       
       , h4("G. Download Results")
       , p("All input and output files will be available in a single zip file.")
       , shinyjs::disabled(downloadButton("b_download_bcg"
                                          , "Download Results"))
        )## sidebarPanel ~ END
    , mainPanel(
        tabsetPanel(type = "tabs"
                    , tabPanel(title = "Calc_BCG_About"
                               ,includeHTML(file.path("www"
                                                      , "rmd_html"
                                            , "ShinyHTML_Calc_BCG_1About.html"))
                               )
                    , tabPanel(title = "Calc_BCG_Input"
                               ,includeHTML(file.path("www"
                                                      , "rmd_html"
                                            , "ShinyHTML_Calc_BCG_2Input.html"))
                               )
                    , tabPanel(title = "Calc_BCG_Output"
                               ,includeHTML(file.path("www"
                                                      , "rmd_html"
                                          , "ShinyHTML_Calc_BCG_3Output.html"))
                               )
                    )## tabsetPanel ~ END
      
    )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
