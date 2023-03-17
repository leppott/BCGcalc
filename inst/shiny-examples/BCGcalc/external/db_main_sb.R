#Sidebar----

# tabs
# sourced in global.R
# ref in db_main_body.R
# menu in db_main_sb.R

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
                 , icon = icon("toolbox")
                 #, tabName = "tab_filebuilder"
                 , menuSubItem("Taxa Translate and Attribute Assignment"
                               , tabName = "tab_filebuilder_taxatrans"
                               , icon = icon("language")
                               )
                 , menuSubItem("Assign BCG Index Name and Class"
                               , tabName = "tab_filebuilder_indexclass"
                               , icon = icon("address-book")
                               )
                 , menuSubItem("Merge Files"
                               , tabName = "tab_filebuilder_mergefiles"
                               , icon = icon("code-merge")
                               )
                 )## menuItem ~ File Builder
      , menuItem(text = "Calculation"
                 , icon = icon("gears")
                 , tabName = "tab_calc"
                 , menuSubItem("BCG Models"
                               , tabName = "tab_calc_bcg"
                               , icon = icon("award"))
                 , menuSubItem("Thermal Preference Metrics"
                               , tabName = "tab_calc_thermalmetrics"
                               , icon = icon("temperature-empty"))
                 , menuSubItem("Fuzzy set temperature model"
                               , tabName = "tab_calc_thermalfuzzy"
                               , icon = icon("square-check"))
                 , menuSubItem("MTTI"
                               , tabName = "tab_calc_mtti"
                               , icon = icon("microscope"))
                 , menuSubItem("BioDiversity Index"
                               , tabName = "tab_calc_biodivind"
                               , icon = icon("flask"))
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
      , menuItem(text = "Map"
                 , tabName = "tab_map"
                 , icon = icon("map"))## menuItem ~ Map
      , menuItem(text = "Reports"
                 , icon = icon("clipboard-check")
                 , menuSubItem("Single Site, Single Sample"
                               , tabName = "tab_rep_ss_ss"
                               , icon = icon("pen")
                               )
                 , menuSubItem("Single Site, Multiple Samples"
                               , tabName = "tab_rep_ss_ms"
                               , icon = icon("pen-ruler")
                               )
                 , menuSubItem("Muliple Sites"
                               , tabName = "tab_rep_ms"
                               , icon = icon("pen-to-square"))
                 )## menuItem ~ Reports ~ END
      , menuItem(text = "Relevant Resources"
                 , tabName = "tab_resources"
                 , icon = icon("book"))
    )## sidebarMenu ~ END
  )## dashboardSidebar ~ END
}## FUNCTION ~ END
