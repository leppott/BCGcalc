# NHDplus VAA file
# OR and WA
# HUC 17 (Pacific Northwest) then 16 (Great Basin) and 18 (CA)
# Uses VAA file from nhdplusTools but is 220 MB
# File too big for GitHub (max 100 MB).
# fst file format
# reduces to 87 MB
# Erik.Leppo@tetratech.dom
# 2023-05-22
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Packages
library(nhdplusTools)
library(fst)
library(dplyr)

# Get VAA (nhdplusVAA.fst)
nhdplusTools::nhdplusTools_data_dir(tempdir())
nhdplusTools::download_vaa(path = nhdplusTools::get_vaa_path()
                           , force = FALSE
                           , updated_network = FALSE)

# Data
fn_vaa <- get_vaa_path()
df_vaa <- read.fst(fn_vaa)

# Munge
df_vaa_ORWA <- filter(df_vaa, vpuid == "16" | vpuid == "17" | vpuid == "18")

# Resave the file to the Shiny APP with the same name
write.fst(df_vaa_ORWA, fn_vaa)  # 87 MB

# Windows
shell.exec(fn_vaa)

# Copy of Shiny
dn_shiny <- file.path("inst", "shiny-examples", "BCGcalc", "data")
fn_shiny <- file.path(dn_shiny, basename(fn_vaa))
file.copy(fn_vaa, fn_shiny)

# Windows
shell.exec(dn_shiny)