# Process Files, Create Zip Files, Example Scripts and Data, Shiny App
# Erik.Leppo@tetratech.com
# 2023-02-08
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set Working Directory for each file so don't get extra directory structure
# in the zip file
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Create zip file for each procedure and an overall
wd_orig <- getwd()
dn_input <- normalizePath(file.path("inst", "extdata", "examples"))
dn_save <- normalizePath(file.path("inst"
                                   , "shiny-examples"
                                   , "BCGcalc"
                                   , "www"
                                   , "links"))

# 0, All ----
fn_zip <- "examples_all.zip"
wd_zip <- normalizePath(dn_input)
setwd(wd_zip)
path_4zip <- wd_zip
fn_4zip <- list.files(full.names = TRUE)
utils::zip(file.path(dn_save, fn_zip), fn_4zip)

# # 1, Calc, BCG----
# fn_zip <- "examples_all.zip"
# 
# # 2, Calc, BobBioDiv----
# fn_zip <- "examples_all.zip"
# 
# # 3, Calc, Fuzzy Therm----
# fn_zip <- "examples_all.zip"
# 
# # 4, File Builder, Assign Index Class----
# fn_zip <- "examples_all.zip"
# 
# # 5, File Builder, Merge Files----
# fn_zip <- "examples_all.zip"
# 
# # 6, File Builder, Taxa Translate----
# fn_zip <- "examples_all.zip"

# Return Working Directory
setwd(wd_orig)

