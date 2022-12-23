# mtti Panel

function() {
  sidebarLayout(
    sidebarPanel(
      h2("2. Calculate MMTI")
      , p("This function will render all steps and make available files for download.")
      , br()
      , h4("2.A. Upload a file.")
      , p("If no file name showing below repeat 'Import File' in the left sidebar.")
      #, p(textOutput("fn_input_display"))
    )## sidebarPanel
    , mainPanel(
      tabsetPanel(type = "tabs"
                  , tabPanel(title = "Calc_MTTI_About"
                             ,includeHTML(file.path("www"
                                                    , "rmd_html"
                                                    , "ShinyHTML_Calc_MTTI.html"))
                  )
                  # , tabPanel(title = "Calc_MTTI_Input"
                  #            ,includeHTML(file.path("www"
                  #                                   , "rmd_html"
                  #                                   , "ShinyHTML_Calc_MTTI_2Input.html"))
                  # )
                  # , tabPanel(title = "Calc_MTTI_Output"
                  #            ,includeHTML(file.path("www"
                  #                                   , "rmd_html"
                  #                                   , "ShinyHTML_Calc_MTTI_3Output.html"))
                  # )
      )## tabsetPanel ~ END
      
    )## mainPanel ~ END
  )##sidebarLayout ~ END  
}##FUNCTION ~ END

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
