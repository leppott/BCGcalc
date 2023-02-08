# Create HTML files for use with Shiny app
# Erik.Leppo@tetratech.com
# 2022-01-11
# 20220923, moved in to the Shiny app
#~~~~~~~~~~~~~~


# Packages
# libary(rmarkdown)

# Files
myFiles <- list.files(path = "inst/shiny-examples/BCGcalc/external/RMD"
                      , pattern = "^ShinyHTML"
                      , full.names = TRUE)

# Loop over files


# Render as HTML
path_shiny_www <- file.path("inst"
                            , "shiny-examples"
                            , "BCGcalc"
                            , "www"
                            , "rmd_html")


for (i in myFiles) {
  # file name w/o extension
  #i_fn <- tools::file_path_sans_ext(basename(i))
  # save to HTML
  rmarkdown::render(input = i
                    , output_dir = path_shiny_www)
}## FOR ~ i

shell.exec(normalizePath(path_shiny_www))
