#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinydashboard::dashboardPage(
  header = shinydashboard::dashboardHeader(title = "BCGcalc")
  #, sidebar = dashboardSidebar(sb_main("leftsidebarmenu"))
  , sidebar = shinydashboard::dashboardSidebar(sb_main("leftsidebarmenu"))
  , body = dashboardBody(db_main("dbBody"))
) ## dashboardPage ~ END

# https://rstudio.github.io/shinydashboard/get_started.html
