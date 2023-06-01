# Copy RMD template from package to shiny for use on server
# Erik.Leppo@tetratech.com
# 2022-10-13
#~~~~~~~~~~~~~~

# Shiny on the server can't access RMD from package
# copy to the Shiny file structure

fn_rmd <- "Results_Summary.Rmd"

rmd_orig <- file.path("inst", "rmd", fn_rmd)

rmd_shiny <- file.path("inst", "shiny-examples", "BCGcalc", "external", fn_rmd)

file.copy(rmd_orig, rmd_shiny, overwrite = TRUE)

# And copy to R package dir for quick testing without rebuilding package

rmd_r <- file.copy(system.file(package = "BCGcalc", "rmd"), fn_rmd)

file.copy(rmd_orig, rmd_shiny, overwrite = TRUE)
