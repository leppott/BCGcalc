# BioDiversity Index Panel

function() {
  tabPanel("tabpan_calc_biodivind"
           
           , includeHTML(file.path("www", "rmd_html", "ShinyHTML_Calc_BioDivInd.html"))
         
           )##tabPanel ~ END
}##FUNCTION ~ END

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
