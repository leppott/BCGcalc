# BioDiversity Index Panel

function() {
  sidebarLayout(
    sidebarPanel(
      h2("Calculate BDI [DRAFT]")
      , p("This function will render all steps and make available files for download.")
      , br()
      , h4("A. Upload a file.")
      , p("If no file name showing below repeat 'Import File' in the left sidebar.")
      , p(textOutput("fn_input_display_bdi"))
      
      , h4("B. Convert User Taxa Names to Operational Taxonomic Units")
      , checkboxInput("BDI_OTU", "Convert to BDI OTU", TRUE)
      
      , h4("C. Mark Redundant (Non-Distinct) Taxa")
      , includeHTML(file.path("www", "rmd_html", "ShinyHTML_RedundantTaxa.html"))
      , checkboxInput("BDI_ExclTaxa", "Generate Redundant Taxa Column", TRUE)
      , p("If uncheck need define Redundant column in next step.")
      
      , h4("D. User File Column Names")
      
      , h6("Required Fields")
      , p("If the default values are present they will be auto-populated.")
      
      , uiOutput("UI_bdi_user_col_sampid")
      , uiOutput("UI_bdi_user_col_taxaid")
      , uiOutput("UI_bdi_user_col_ntaxa")
      #, uiOutput("UI_bdi_user_col_exclude")
      , p("Redundant column only used if Redundant checkbox above is unchecked.")
      
      , h4("D. Run Operation")
      , p("This button will generate the BDI")
      , shinyjs::disabled(shinyBS::bsButton("b_calc_bdi"
                                            , label = "Run Operation"))
      
      , h4("E. Download Output")
      , p("All input and output files will be available in a single zip file.")
      , shinyjs::disabled(downloadButton("b_download_bdi"
                                         , "Download Results"))
      
    )## sidebarPanel
    , mainPanel(
      tabsetPanel(type = "tabs"
                  , tabPanel(title = "Calc_BDI_About"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_BDI_1About.html"))
                  )
                  , tabPanel(title = "Calc_BDI_Input"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_BDI_2Input.html"))
                  )
                  , tabPanel(title = "Calc_BDI_Output"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_BDI_3Output.html"))
                  )
      )## tabsetPanel ~ END
      
    )## mainPanel ~ END
  )##sidebarLayout ~ END  
}##FUNCTION ~ END
  

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
