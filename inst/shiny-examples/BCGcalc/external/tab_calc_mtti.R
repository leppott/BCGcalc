# mtti Panel

function() {
  sidebarLayout(
    sidebarPanel(
      h2("Calculate MMTI")
      , p("This function will render all steps and make available files for download.")
      , br()
      , h4("A. Upload a file.")
      , p("If no file name showing below repeat 'Import File' in the left sidebar.")
      , p(textOutput("fn_input_display_mtti"))
      
      , h4("B. Convert User Taxa Names to Operational Taxonomic Units")
      , checkboxInput("MTTI_OTU", "Convert to OTU", TRUE)
      
      , h4("C. User File Column Names")
      
      , h6("Required Fields")
      , p("If the default values are present they will be auto-populated.")

      , uiOutput("UI_mtti_user_col_sampid")
      , uiOutput("UI_mtti_user_col_taxaid")
      , uiOutput("UI_mtti_user_col_ntaxa")
      
      , h4("D. Run Operation")
      , p("This button will generate the MTTI")
      , shinyjs::disabled(shinyBS::bsButton("b_calc_mtti"
                                            , label = "Run Operation"))
      
      , h4("E. Download Output")
      , p("All input and output files will be available in a single zip file.")
      , shinyjs::disabled(downloadButton("b_download_mtti"
                                         , "Download Results"))
      
    )## sidebarPanel
    , mainPanel(
      tabsetPanel(type = "tabs"
                  , tabPanel(title = "Calc_MTTI_About"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_MTTI_1About.html"))
                  )
                  , tabPanel(title = "Calc_MTTI_Input"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_MTTI_2Input.html"))
                  )
                  , tabPanel(title = "Calc_MTTI_Output"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_MTTI_3Output.html"))
                  )
      )## tabsetPanel ~ END
      
    )## mainPanel ~ END
  )##sidebarLayout ~ END  
}##FUNCTION ~ END

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
