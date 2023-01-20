# Panel, Thermal Metrics

function() {
  sidebarLayout(
    sidebarPanel(
       h2("Calculate Thermal Metrics")
       , p("This function will render all steps and make available files for download.")
       , br()
       , h4("A. Upload a file.")
       , p("If no file name showing below repeat 'Import File' in the left sidebar.")
       , p(textOutput("fn_input_display_met_therm"))
       , h4("B. Define Community (for metrics).")
       , selectInput("si_community_met_therm"
                      , label = "Community"
                      , choices = sel_community
                      , selected = "bugs")
       , h4("C. Exclude Taxa")
       , checkboxInput("ExclTaxa_thermal", "Generate Exclude Taxa Column", TRUE)
       , h4("D. Define Metric Suite")
       , p("(Only thermal metric suite of metrics available at this time).")
       , selectInput("si_metric_suite"
                     , label = "Metric Suite"
                     , choices = sel_metric_suites
                     , selected = "ThermalHydro")
       # #, uiOutput("UI_col_calcmet_Cols2Keep")
       , h4("E. Run Calculations")
       , p("This button will calculate metrics values.")
       , useShinyjs()
       , shinyjs::disabled(shinyBS::bsButton("b_calc_met_therm", label = "Run Calculations"))
       , h4("E. Download Results")
       , p("All input and output files will be available in a single zip file.")
      , shinyjs::disabled(downloadButton("b_download_met_therm"
                                         , "Download Results"))
        )## sidebarPanel ~ END
    , mainPanel(
        tabsetPanel(type = "tabs"
                  , tabPanel(title = "Calc_Metrics_Thermal_About"
                             , includeHTML(file.path("www"
                                                     , "rmd_html"
                                                     , "ShinyHTML_Calc_Metrics_Thermal_1About.html"))
                  )
                  , tabPanel(title = "Calc_Metrics_Thermal_Input"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_Metrics_Thermal_2Input.html"))
                  )
                  , tabPanel(title = "Calc_Metrics_Thermal_Output"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_Metrics_Thermal_3Output.html"))
                  )
        )## tabsetPanel ~ END
    )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
