#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dashboardPage(
  header = dashboardHeader(title = "BCGcalc")
  #, sidebar = dashboardSidebar(sb_main("leftsidebarmenu"))
  , sidebar = dashboardSidebar(db_main_sb("leftsidebarmenu"))
  , body = dashboardBody(db_main_body("dbBody"))
  , footer = dashboardFooter(left = "v1.3.5.9009"
                             , right = "https://github.com/leppott/BCGcalc")
) ## dashboardPage ~ END

# https://rstudio.github.io/shinydashboard/get_started.html
