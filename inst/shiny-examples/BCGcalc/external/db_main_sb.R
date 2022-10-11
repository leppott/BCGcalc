#Sidebar----
#sb_main <- function(id) {
function(id) {
  dashboardSidebar(
    width = 275
    , HTML("&nbsp;&nbsp;<font size=5><b>Steps</b></font>")
    #Steps, do *not* need to be done sequentially----
    , sidebarMenu(id = id
      , menuItem(text = "About"
               , tabName = "tab_about"
               , icon = icon("house")
               )## menuItem ~ About ~ END
      , menuItem(text = "Import Files"
                 , tabName = "tab_import"
                 , icon = icon("file-arrow-up")
                 , startExpanded = TRUE)
      , menuItem(text = "File Builder"
                 , tabName = "tab_munge"
                 , icon = icon("toolbox")
                 )
      , menuItem(text = "Calculation"
                 , icon = icon("gears")
                 , tabName = "tab_calc"
                 , menuSubItem("BCG Models"
                               , tabName = "tab_calcbcg"
                               , icon = icon("award"))
                 , menuSubItem("Thermal Preference Metrics"
                               , tabName = "tab_calcbcg"
                               , icon = icon("temperature-empty"))
                 , menuSubItem("BMI BCG-style temperature model"
                               , tabName = "tab_bcg_metmemb"
                               , icon = icon("temperature-full"))
                 )## menuItem ~ BCG
      # , menuItem(text = "Temperature"
      #            , icon = icon("temperature-full") #
      #            , menuSubItem("Thermal Stats"
      #                          , tabName = "tab_about"
      #                          , icon = icon("square-check"))
      #            , menuSubItem("Growing Degree Days"
      #                          , tabName = "seedling"
      #                          , icon = icon("microscope"))
      #            , menuSubItem("Thermal Classification"
      #                          , tabName = "tab_about"
      #                          , icon = icon("clone"))
      #            )## menuItem ~ Data Preparation ~ END
      # , menuItem(text = "Hydrology"
      #            , icon = icon("water") #
      #            , menuSubItem("IHA"
      #                          , tabName = "tab_about"
      #                          , icon = icon("map"))
      #            , menuSubItem("Flashiness"
      #                          , tabName = "tab_about"
      #                          , icon = icon("calculator"))
      #            )## menuItem ~ Analysis ~ END
      , menuItem(text = "Reports"
                 , icon = icon("clipboard-check")
                 , menuSubItem("Single Site"
                               , tabName = "tab_X"
                               , icon = icon("pen")
                               )
                 , menuSubItem("Muliple Sites"
                               , tabName = "tab_Y"
                               , icon = icon("pen-ruler")
                               )
                 , menuSubItem("Continuous Sensor Metadata"
                               , tabName = "tools"
                               , icon = icon("pen-to-square"))
                 )## menuItem ~ Reports ~ END
    )## sidebarMenu ~ END
  )## dashboardSidebar ~ END
}## FUNCTION ~ END
