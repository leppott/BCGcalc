# File Builder Panel, index class parameters

function() {
  sidebarLayout(
    sidebarPanel(h2("Generate Index Class Parameters")
            #, useShinyjs()
            , h4("A. Upload a File")
            , p("If no file name showing below repeat 'Import File' in the left sidebar.")
            , p(textOutput("fn_input_display_indexclassparam"))
            
            , h4("B. Define Index Name")
            , uiOutput("UI_indexclassparam_indexname")
            #, p("Only the Maritime NW BCG model is included for now.")
            
            , h4("C. Define Index Class Fields")
            , h6("Required Fields")
            , p("For the Maritime NW BCG model, the input file needs to include latitude and longitude.")
            , p("Reach slope (0-100) from the NHDPlusV2 and elevation (m) from the EPA StreamCat dataset (local catchment scale).")
            # Only PacNW for now so hard code (short on hours)
            # text box for all names of input DF.  
            # Default to Latitude and Longitude
            # Need SampID ???

            # SampleID (only for group_by)
            , uiOutput("UI_indexclassparam_user_col_sampid")

            , h4("D. Run Operation")
            , p("This button will generate the index class parameters based on the above inputs")
            , shinyjs::disabled(shinyBS::bsButton("b_calc_indexclassparam"
                                                  , label = "Run Operation"))

            , h4("E. Download Output")
            , p("All input and output files will be available in a single zip file.")
            , shinyjs::disabled(downloadButton("b_indexclassparam_download"
                                               , "Download Results"))
           
    )## sidebarPanel ~ END
       , mainPanel(
            tabsetPanel(type = "tabs"
                        , tabPanel(title = "IndexClassParam_About"
                                   ,includeHTML(file.path("www"
                                                          , "rmd_html"
                                          , "ShinyHTML_IndexClassParam_1About.html"))
                                   )
                            , tabPanel(title = "IndexClassParam_Output"
                                       ,includeHTML(file.path("www"
                                                              , "rmd_html"
                                          , "ShinyHTML_IndexClassParam_2Output.html"))
                            )
            )## tabsetPanel ~ END
    )## mainPanel ~ END
  )##sidebarLayout ~ END
  
  
}##FUNCTION ~ END
