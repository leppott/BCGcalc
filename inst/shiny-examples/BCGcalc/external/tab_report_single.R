# Report, Single Site

function() {
  sidebarLayout(
    sidebarPanel(
           h2("Report, Single Site")
           , p("This function will render all steps and make available files for download.")
           , br()

           , h4("A. Upload a zip file.")
           , p("If no file name showing below repeat 'Import File' in the left sidebar.")
           , p(textOutput("fn_input_display_rep_single"))
           , p("Template file in root folder of zip file contains the necessary files and locations.")

           # , h4("D. Run Operation")
           # , p("This button will generate the report")
           # , shinyjs::disabled(shinyBS::bsButton("b_calc_rep_ss_ms"
           #                                       , label = "Run Operation"))
           #
           # , h4("E. Download Output")
           # , p("All input and output files will be available in a single zip file.")
           # , shinyjs::disabled(downloadButton("b_download_rep_ss_ms"
           #                                    , "Download Results"))

    )## sidebarPanel
    , mainPanel(
        tabsetPanel(type = "tabs"
                  , tabPanel(title = "Calc_Report_Single_About"
                             # ,includeHTML(file.path("www"
                             #                        , "rmd_html"
                             #                        , "ShinyHTML_Report_Single_1About.html"))
                  )## tabPanel
        )## tabsetPanel
    )## mainPanel ~ END
  )##sidebarLayout ~ END
}##FUNCTION ~ END

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
