# Calculate BCG Panel

function() {
  sidebarLayout(
    sidebarPanel(
       h2("2. Calculate BCG Model")
       , p("This function will render all steps and make available files for download.")
       , br()
       , h4("2.A. Upload a file.")
       , p("If no file name showing below repeat 'Import File' in the left sidebar.")
       , p(textOutput("fn_input_display"))
       , h4("2.B. Define Community (for metrics).")
       , selectInput("si_community"
                     , label = "Community"
                     , choices = sel_community
                     , selected = "bugs")
       , h4("2.C. Excluded Taxa")
       , checkboxInput("ExclTaxa", "Generate Excluded Taxa Column", TRUE)
       , h4("2.D. Define BCG Model.")
       , p("Determined by INDEX_NAME and INDEX_REGION in data input file.")
       # , selectInput("si_model"
       #               , label = "BCG Model"
       #               , choices = sel_bcg_models
       #               , selected = "BCG_MariNW_Bugs500ct")
       #, uiOutput("UI_col_calcmet_Cols2Keep")
       , h4("2.E. Run Calculations")
       , p("This button will calculate metrics values, metric memberships
           , level membership, and level assignment.")
       , useShinyjs()
       , shinyjs::disabled(shinyBS::bsButton("b_bcg_calc", label = "Run Calculations"))
       , h4("2.F. Download Results")
       , p("All input and output files will be available in a single zip file.")
       , shinyjs::disabled(downloadButton("b_bcg_download"
                                          , "Download Results"))
        )## sidebarPanel ~ END
    , mainPanel(
        tabsetPanel(type = "tabs"
                    , tabPanel("Calc_BCG_About"
                               ,includeHTML(file.path("www", "rmd_html", "ShinyHTML_Calc_BCG.html"))
                               )
                    , tabPanel("Calc_BCG_2")
                    , tabPanel("Calc_BCG3")
                    )## tabsetPanel ~ END
      
    )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
