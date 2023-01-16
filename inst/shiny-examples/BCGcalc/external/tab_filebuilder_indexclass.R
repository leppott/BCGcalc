# File Builder Panel, index class

function() {
  sidebarLayout(
    sidebarPanel(h2("Assign Index Class")
            #, useShinyjs()
            
            , p("The process below will assign Index_Class based on the Index_Name.")
            , br()
            , h4("A. Upload a File")
            , p("If no file name showing below repeat 'Import File' in the left sidebar.")
            , p(textOutput("fn_input_display_indexclass"))
            
            , h4("B. User File Column Names")
            , h6("Required Fields")
            , p("If the default values are present they will be auto-populated.")
            # SampleID (really for group_by)
            , uiOutput("UI_indexclass_user_col_indexname")
            , uiOutput("UI_indexclass_user_col_indexclass")
            , uiOutput("UI_indexclass_user_col_sampid")

            , h4("C. Run Operation")
            , p("This button will assign Index_Class based on inputs")
            , shinyjs::disabled(shinyBS::bsButton("b_indexclass_calc"
                                                  , label = "Run Operation"))

            , h4("D. Download Output")
            , p("All input and output files will be available in a single zip file.")
            , shinyjs::disabled(downloadButton("b_indexclass_download"
                                               , "Download Results"))
           
    )## sidebarPanel ~ END
       , mainPanel(
            tabsetPanel(type = "tabs"
                        , tabPanel(title = "IndexClass_About"
                                   ,includeHTML(file.path("www"
                                                          , "rmd_html"
                                          , "ShinyHTML_IndexClass_1About.html"))
                                   )
                            , tabPanel(title = "IndexClass_Output"
                                       ,includeHTML(file.path("www"
                                                              , "rmd_html"
                                          , "ShinyHTML_IndexClass_2Output.html"))
                            )
            )## tabsetPanel ~ END
    )## mainPanel ~ END
  )##sidebarLayout ~ END
  
  
}##FUNCTION ~ END
