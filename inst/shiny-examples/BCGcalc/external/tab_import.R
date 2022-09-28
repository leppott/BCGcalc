# Import Page

function() {
  tabPanel("1. Import Data"
    # SideBar ####
    , sidebarLayout(
        sidebarPanel(
          # 0. Progress
          #, tags$hr()
          h4("1. Load File")
          , p("Only comma-separated or tab-separated files.")
          , h5("Select file parameters")
          #, checkboxInput('header', 'Header', TRUE)
          , radioButtons("sep", "Separator",
                         c(Comma = ",",
                          # Semicolon = ";",
                           Tab = "\t"),
                         ',')
          , fileInput("fn_input"
                      , label = "Choose file to upload"
                      , multiple = FALSE
                      , accept = c("text/csv"
                                   , "text/comma-separated-values"
                                   , "text/tab-separated-values"
                                   , "text/plain"
                                   , ".csv"
                                   , ".tsv"
                                   , ".txt")
                      )##fileInput~END
          , tags$hr()
          , p("The 'separator' allows the user to upload different file formats
            (e.g., csv, tsv, or txt).")
        , p("Files for all operations will be uploaded through this interface.")
          , p(paste0("File uploads are limited to a maximum of "
                     , mb_limit
                     , " MB in size."))

        )##sidebarPanel~END
      # Main Panel ####
      , mainPanel(
           p("A table is shown below after data is loaded.")
          , DT::dataTableOutput("df_import_DT")
      )##mainPanel~END

    )##sidebarLayout~END
  )##tabPanel ~ END
}## FUNCTION ~ END
