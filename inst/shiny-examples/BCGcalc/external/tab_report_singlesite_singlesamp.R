# About Panel

function() {
  tabPanel("tabpan_rep_ss_ss"
           , h2("Report, Single Site, Single Sample")
           , p("Some information about reports, single site, single sample.")
           # , fluidPage(h2("About"
           #                #, style  = "text-align:center"
           #                )
           #             , p("Background info")
           #
           #             , p("Version 0.5.0.9080")
           #
           #
           #              )## fluidPage ~ END
     #       , includeHTML(file.path("www", "rmd_html", "ShinyHTML_About.html"))
         #  , htmlOutput("html_about") # use with iframe
           )##tabPanel ~ END
}##FUNCTION ~ END

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
