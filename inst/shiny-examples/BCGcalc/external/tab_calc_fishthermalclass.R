# Fish Thermal Class Panel


# About Panel

function() {
  tabPanel("tabpan_fishthermalclass"
           , h2("Calculate Fish Thermal Class")
           
           , includeHTML(file.path("www"
                                   , "rmd_html"
                                   , "ShinyHTML_Calc_FishThermalClass_1About.html"))
           
  )##tabPanel ~ END
}##FUNCTION ~ END

