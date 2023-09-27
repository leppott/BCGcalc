# Help Panel

function() {
  sidebarLayout(
    sidebarPanel(
      h2("Map Data")
      , p("This function will render points on a map.")
      , br()
      , h4("A. Upload a file.")
      , p("If no file name showing below repeat 'Import File' in the left sidebar.")
      , p(textOutput("fn_input_display_map"))
      , h4("B. Define Data Type")
      , uiOutput("UI_map_datatype")
      , h4("C. Define Column Names")
      , uiOutput("UI_map_col_xlong")
      , uiOutput("UI_map_col_ylat")
      , uiOutput("UI_map_col_sampid")
      # , uiOutput("UI_map_col_keep")
      , h4("D. Update Map")
      , p("After making changes above click the button below to update the map.")
      , bsButton("but_map_update", "Update Map")
      , hr()
      , includeHTML(file.path("www", "rmd_html", "ShinyHTML_Map.html"))
      
      # , h4("C. Exclude Taxa")
      # , checkboxInput("ExclTaxa_modtherm", "Generate Exclude Taxa Column", TRUE)
      # , h4("D. Fuzzy-set Model.")
      # , p("Determined by INDEX_NAME and INDEX_CLASS in data input file.")
      # # , selectInput("si_model"
      # #               , label = "BCG Model"
      # #               , choices = sel_bcg_models
      # #               , selected = "BCG_MariNW_Bugs500ct")
      # #, uiOutput("UI_col_calcmet_Cols2Keep")
      # , h4("E. Run Calculations")
      # , p("This button will calculate metrics values, metric memberships
      #      , level membership, and level assignment.")
      # , useShinyjs()
      # , shinyjs::disabled(shinyBS::bsButton("b_calc_modtherm", label = "Run Calculations"))
      # , h4("F. Download Results")
      # , p("All input and output files will be available in a single zip file.")
      # , shinyjs::disabled(downloadButton("b_download_modtherm"
      #                                    , "Download Results"))
    )## sidebarPanel ~ END
    , mainPanel(
      # tabsetPanel(type = "tabs"
      #             , tabPanel(title = "Map"
      #                        , leafletOutput("map_leaflet"
      #                                        , height = "85vh")
      #             )## tabPanel
      #             
      #             
      # )## tabsetPanel ~ END
      leafletOutput("map_leaflet"
                    , height = "85vh")
    )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END
