# mtti Panel

function() {
  tabPanel("tabpan_calc_mtti"
           
           , includeHTML(file.path("www", "rmd_html", "ShinyHTML_Calc_MTTI.html"))
         
           )##tabPanel ~ END
}##FUNCTION ~ END

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
