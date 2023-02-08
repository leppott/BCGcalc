# BCGcalc - File Builder - Data Files
# Erik.Leppo@tetratech.com
# 2023-02-07 
#
# Replicate Shiny app code, server.R, as a stand-alone script
#
# Copy test files to temp directory so example scripts work
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Directory
dn_examples <- file.path("inst", "extdata", "examples")
# dn_examples <- system.file(file.path("extdata", "examples")
#                            , package = "BCGcalc")

# Files
files_from <- list.files(dn_examples, full.names = TRUE)
# don't use recursive here or lose directory structure
files_to <- file.path(tempdir(), "examples")

# Create Folders ----
dir.create(file.path(tempdir(), "examples"))

# Copy Files -----
file.copy(files_from
          , files_to
          , recursive = TRUE
          , copy.mode = TRUE
          , overwrite = TRUE)

# Open ----
shell.exec(files_to)
