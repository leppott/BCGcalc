# File Builder Panel

function() {
  tabPanel("tabpan_filebuilder"
           , h2("File Builder")
           # , fluidPage(h2("About"
           #                #, style  = "text-align:center"
           #                )
           #             , p("Background info")
           #
           #             , p("Version 0.5.0.9080")
           #
           #
           #              )## fluidPage ~ END
            #, includeHTML(file.path("www", "rmd_html", "ShinyHTML_Resources.html"))
			, p("Tools to generate (build) a file for calculation.")
         #  , htmlOutput("html_about") # use with iframe
           )##tabPanel ~ END
}##FUNCTION ~ END

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
