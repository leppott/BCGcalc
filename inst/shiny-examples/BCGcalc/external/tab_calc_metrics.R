# Calculate Metrics Panel

function() {
  sidebarLayout(
    sidebarPanel(
       h2("2. Calculate Thermal Metrics")
       # , p("This function will render all steps and make available files for download.")
       # , br()
       # , h4("2.A. Upload a file.")
       # , p("If no file name showing below repeat 'Import File' in the left sidebar.")
       # , p(textOutput("fn_input_display"))
       # , h4("2.B. Define Community (for metrics).")
       # , selectInput("si_community_met"
       #               , label = "Community"
       #               , choices = sel_community
       #               , selected = "bugs")
       # , h4("2.C. Exclude Taxa")
       # , checkboxInput("ExclTaxa_met", "Generate Exclude Taxa Column", TRUE)
       # , h4("2.D. Select metric suite.")
       # , p("(Only thermal metric suite of metrics available at this time).")
       # , selectInput("si_metric_suite"
       #               , label = "Metric Suite"
       #               , choices = sel_metric_suites
       #               , selected = "ThermalHydro")
       # #, uiOutput("UI_col_calcmet_Cols2Keep")
       # , h4("2.E. Run Calculations")
       # , p("This button will calculate metrics values, metric memberships
       #     , level membership, and level assignment.")
       # , useShinyjs()
       # , shinyjs::disabled(shinyBS::bsButton("b_calc_met", label = "Run Calculations"))
       # , h4("2.F. Download Results")
       # , p("All input and output files will be available in a single zip file.")
       # , shinyjs::disabled(downloadButton("b_download_met"
       #                                    , "Download Results"))
        )## sidebarPanel ~ END
    , mainPanel(
        tabsetPanel(type = "tabs"
                  , tabPanel(title = "Calc_Metrics_About"
                             , includeHTML(file.path("www"
                                                     , "rmd_html"
                                                     , "ShinyHTML_Calc_Metrics_1About.html"))
                  )
                  , tabPanel(title = "Calc_Metrics_Input"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_Metrics_2Input.html"))
                  )
                  , tabPanel(title = "Calc_Metrics_Output"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_Metrics_3Output.html"))
                  )
        )## tabsetPanel ~ END
    )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
