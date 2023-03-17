# Help Panel

function() {
  tabPanel("Map"
           , fluidPage(h2("Map"
                          #, style  = "text-align:center"
                          )
                       , p("Placeholder for map")
                       
                        )## fluidPage ~ END
           # , includeHTML(file.path("external", "Help.html"))
           )##tabPanel ~ END
}##FUNCTION ~ END
