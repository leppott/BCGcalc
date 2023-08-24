# Panel, Thermal Fuzzy

function() {
  sidebarLayout(
    sidebarPanel(
       h2("Calculate Fuzzy Set Temperature Model")
       , p("This function will render all steps and make available files for download.")
       , br()
       , h4("A. Upload a file.")
       , p("If no file name showing below repeat 'Import File' in the left sidebar.")
       , p(textOutput("fn_input_display_modtherm"))
       , h4("B. Define Community (for metrics).")
       , selectInput("si_community_modtherm"
                     , label = "Community"
                     , choices = sel_community
                     , selected = "bugs")
       , h4("C. Exclude Taxa")
       , checkboxInput("ExclTaxa_modtherm", "Generate Exclude Taxa Column", TRUE)
       , h4("D. Fuzzy-set Model.")
       #, p("Determined by INDEX_NAME and INDEX_CLASS in data input file.")
       , p("If INDEX_NAME and INDEX_CLASS not provided then default values will be used ('Therm_ORWA_Bugs500ct' and 'ORWA').")
       # , selectInput("si_model"
       #               , label = "BCG Model"
       #               , choices = sel_bcg_models
       #               , selected = "BCG_MariNW_Bugs500ct")
       #, uiOutput("UI_col_calcmet_Cols2Keep")
       , h4("E. Run Calculations")
       , p("This button will calculate metrics values, metric memberships
           , level membership, and level assignment.")
       , useShinyjs()
       , shinyjs::disabled(shinyBS::bsButton("b_calc_modtherm", label = "Run Calculations"))
       , h4("F. Download Results")
       , p("All input and output files will be available in a single zip file.")
       , shinyjs::disabled(downloadButton("b_download_modtherm"
                                          , "Download Results"))
        )## sidebarPanel ~ END
    , mainPanel(
        tabsetPanel(type = "tabs"
                  , tabPanel(title = "Calc_FuzzySet_About"
                             , includeHTML(file.path("www"
                                                     , "rmd_html"
                                                     , "ShinyHTML_Calc_Model_Thermal_1About.html"))
                  )
                  , tabPanel(title = "Calc_FuzzySet_Input"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_Model_Thermal_2Input.html"))
                  )
                  , tabPanel(title = "Calc_FuzzySet_Output"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_Model_Thermal_3Output.html"))
                  )
      )## tabsetPanel ~ END
    )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
