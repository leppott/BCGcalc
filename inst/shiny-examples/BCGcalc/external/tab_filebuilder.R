# File Builder Panel

function() {
  mainPanel(
        tabsetPanel(type = "tabs"
                    , tabPanel("File Builder, About"
                               #,includeHTML(file.path("www", "rmd_html", "ShinyHTML_Calc_BCG.html"))
                               )
                    , tabPanel("File Builder, 2"
                               , p("info here"))
                    , tabPanel("File Builder, 3"
                               , p("info here"))
                    )## tabsetPanel ~ END
      
    )## mainPanel ~ END
}##FUNCTION ~ END
