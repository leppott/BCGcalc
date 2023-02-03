# File Builder Panel, index class

function() {
  sidebarLayout(
    sidebarPanel(h2("Assign Index Class")
            #, useShinyjs()
            , h4("A. Upload a File")
            , p("If no file name showing below repeat 'Import File' in the left sidebar.")
            , p(textOutput("fn_input_display_indexclass"))
            
            , h4("B. Define Index Name")
            , uiOutput("UI_indexclass_indexname")
            
            , h4("C. Define Index Class Fields")
            , h6("Required Fields")
            , p("For the Maritime NW BCG model, the input file needs to include elevation and % flowline slope. During calibration of the BCG model, we derived slope from the NHDPlusV2 and elevation from the EPA StreamCat dataset (local catchment scale).")
            # , uiOutput("UI_indexclass_user_col_indexname")
            # , uiOutput("UI_indexclass_user_col_indexclass")
            # for expediency hard code the classification fields
            , uiOutput("UI_indexclass_user_col_elev")
            , uiOutput("UI_indexclass_user_col_slope")
            # SampleID (only for group_by)
            , uiOutput("UI_indexclass_user_col_sampid")

            , h4("D. Run Operation")
            , p("This button will assign Index_Class based on inputs")
            , shinyjs::disabled(shinyBS::bsButton("b_indexclass_calc"
                                                  , label = "Run Operation"))

            , h4("E. Download Output")
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
