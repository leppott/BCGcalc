# Main

function(id) {

    tabItems(
      tabItem(tabName = "tab_about", tab_code_about())
      , tabItem(tabName = "tab_import", tab_code_import())
      , tabItem(tabName = "tab_filebuilder", tab_code_filebuilder())
      , tabItem(tabName = "tab_taxatrans", tab_code_taxatrans())
      , tabItem(tabName = "tab_assignindexclass", tab_code_assignindexclass())
      , tabItem(tabName = "tab_calc_bcg", tab_code_calc_bcg())
      , tabItem(tabName = "tab_calc_metrics", tab_code_calc_metrics())
      , tabItem(tabName = "tab_calc_model_thermal", tab_code_calc_model_thermal())
      , tabItem(tabName = "tab_calc_mtti", tab_code_calc_mtti())
      , tabItem(tabName = "tab_calc_biodivind", tab_code_calc_biodivind())
      , tabItem(tabName = "tab_rep_ss_ss", tab_code_rep_ss_ss())
      , tabItem(tabName = "tab_rep_ss_ms", tab_code_rep_ss_ms())
      , tabItem(tabName = "tab_rep_ms", tab_code_rep_ms())
      , tabItem(tabName = "tab_resources", tab_code_resources())
    )## tabItems

}## FUNCTION ~ END


# body <- dashboardBody(
#   tabItems(
#     tabItem(tabName = "tab_about", h2("About"))
#     , tabItem(tabName = "tab_import", h2("Import"))
#   )## tabItems
# )## dashboardBody ~ END
