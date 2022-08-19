# Help Panel

function() {
  tabPanel("Help"
           , fluidPage(h2("BCGcalc Shiny App Help"
                          #, style  = "text-align:center"
                          )
                       , p("This Shiny app helps the user calculate
                           BCG metric and site/sample scores.")
                       , br()
                       , p("0. Combine (Aggregate) files (if necessary).")
                       , p("1. Import files.")
                       , p("2. Define columns.")
                       , p("3. Calculate.")
                       , p("4. Download data.")
                        )## fluidPage ~ END
           # , includeHTML(file.path("external", "Help.html"))
           )##tabPanel ~ END
}##FUNCTION ~ END
