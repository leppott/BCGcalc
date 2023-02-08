# filebuilder, merge files Panel
#
# 2nd version
# https://community.rstudio.com/t/how-can-you-make-a-merge-of-two-reactive-datas-in-which-the-user-can-select-the-columns-through-which-to-make-the-merge-that-is-the-user-selects-who-is-by-x-and-by-y/30345/2

function() {
  sidebarLayout(
    sidebarPanel(
      h2("Merge Sample and Site Files")
      , p("This process will merge two CSV files.")
      , p("File 1 is the primary file. All rows in the primary file will be carried through into the ouput file.")
      , p("File 2 is the secondary file. Only rows that match with the common identifier in the primary file will be carried through into the output file.")
      , br()
      
      , h4("A. Upload files.")
      # file input
      , fileInput("fn_input_mf1"
                  , label = "Import Primary File"
                  , multiple = FALSE
                  , accept = c("text/csv"
                               , "text/comma-separated-values"
                               , "text/tab-separated-values"
                               , "text/plain"
                               , ".csv")
                  )
      , fileInput("fn_input_mf2"
                  , label = "Import Secondary File"
                  , multiple = FALSE
                  , accept = c("text/csv"
                               , "text/comma-separated-values"
                               , "text/tab-separated-values"
                               , "text/plain"
                               , ".csv")
                  )
      
      , h4("B. Select common identifier column for the merge.")
      , uiOutput("UI_mergefiles_f1_col_merge")
      , uiOutput("UI_mergefiles_f2_col_merge")
      
      , h4("C. Run Operation")
      , p("This button will merge the two files based on inputs")
      , shinyjs::disabled(shinyBS::bsButton("b_mergefiles_calc"
                                            , label = "Run Operation"))
      
      , h4("D. Download Output")
      , p("All input and output files will be available in a single zip file.")
      , shinyjs::disabled(downloadButton("b_download_mergefiles"
                                         , "Download Results"))
      
      #, p(textOutput("fn_input_display"))
    )## sidebarPanel
    , mainPanel(
      tabsetPanel(type = "tabs"
                  , id = "MF_mp_tsp"
                  , tabPanel(title = "About"
                             , includeHTML(file.path("www"
                                                     , "rmd_html"
                                                     , "ShinyHTML_MergeFiles_1About.html")))
                  , tabPanel(title = "Output"
                             , includeHTML(file.path("www"
                                                     , "rmd_html"
                                                     , "ShinyHTML_MergeFiles_2Output.html")))
                  , tabPanel(title = "File 1"
                             , h4("File 1 (Primary)")
                             , DT::dataTableOutput("df_import_mf1_DT")
                             , value = "tab_MF_1")
                  , tabPanel(title = "File 2"
                             , h4("File 2 (Secondary)")
                             , DT::dataTableOutput("df_import_mf2_DT")
                             , value = "tab_MF_2"
                             )
                  # , tabPanel(title = "Merged File"
                  #            , h4("Merged File")
                  #            , tableOutput(outputId = "df_mf_merge_DT")
                  #            , value = "tab_MF_merge"
                  #            )
                  
                  # , tabPanel(title = "Calc_MTTI_Input"
                  #            ,includeHTML(file.path("www"
                  #                                   , "rmd_html"
                  #                                   , "ShinyHTML_Calc_MTTI_2Input.html"))
                  # )
                  # , tabPanel(title = "Calc_MTTI_Output"
                  #            ,includeHTML(file.path("www"
                  #                                   , "rmd_html"
                  #                                   , "ShinyHTML_Calc_MTTI_3Output.html"))
                  # )
      )## tabsetPanel ~ END
      
    )## mainPanel ~ END
  )##sidebarLayout ~ END  
}##FUNCTION ~ END

# output$UI_about = renderUI({
#   p("About stuff here.")
# })
