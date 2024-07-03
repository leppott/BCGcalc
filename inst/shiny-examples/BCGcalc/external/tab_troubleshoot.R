# Troubleshooting Panel

function() {
  tabPanel("tabpan_troubleshoot"
           , h2("Troubleshooting")
            , includeHTML(file.path("www", "rmd_html", "ShinyHTML_Troubleshoot.html"))
           )##tabPanel ~ END
}##FUNCTION ~ END

