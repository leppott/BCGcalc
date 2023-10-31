# Main

# tabs
# sourced in global.R
# ref in db_main_body.R
# menu in db_main_sb.R

function(id) {

    tabItems(
      tabItem(tabName = "tab_about"
              , tab_code_about())
      , tabItem(tabName = "tab_import"
                , tab_code_import())
      , tabItem(tabName = "tab_filebuilder"
                , tab_code_filebuilder())
      , tabItem(tabName = "tab_filebuilder_taxatrans"
                , tab_code_filebuilder_taxatrans())
      , tabItem(tabName = "tab_filebuilder_indexclass"
                , tab_code_filebuilder_indexclass())
      , tabItem(tabName = "tab_filebuilder_indexclassparam"
                , tab_code_filebuilder_indexclassparam())
      , tabItem(tabName = "tab_filebuilder_mergefiles"
                , tab_code_filebuilder_mergefiles())
      , tabItem(tabName = "tab_calc_bcg"
                , tab_code_calc_bcg())
      , tabItem(tabName = "tab_calc_thermalmetrics"
                , tab_code_calc_thermalmetrics())
      , tabItem(tabName = "tab_calc_thermalfuzzy"
                , tab_code_calc_thermalfuzzy())
      , tabItem(tabName = "tab_calc_mtti"
                , tab_code_calc_mtti())
      , tabItem(tabName = "tab_calc_bdi"
                , tab_code_calc_bdi())
      , tabItem(tabName = "tab_map"
                , tab_code_map())
      , tabItem(tabName = "tab_rep_single"
                , tab_code_rep_single())
      , tabItem(tabName = "tab_rep_multi"
                , tab_code_rep_multi())
      , tabItem(tabName = "tab_resources"
                , tab_code_resources())
    )## tabItems

}## FUNCTION ~ END


# body <- dashboardBody(
#   tabItems(
#     tabItem(tabName = "tab_about", h2("About"))
#     , tabItem(tabName = "tab_import", h2("Import"))
#   )## tabItems
# )## dashboardBody ~ END
