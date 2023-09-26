# Transform GIS Data
# Eco3_ORWA
# Erik.Leppo@tetratech.com
# 2023-09-25
#~~~~~~~~~~~~~~~~~~~~~~~~
# Hard Drive space low so keep raw data on external drive
#~~~~~~~~~~~~~~~~~~~~~~~~
# Save GIS shapefile as RDA
# saves space and should load quicker
#~~~~~~~~~~~~~~~~~~~~~~~~
# Data files using same projection as map in Shiny where using the data
# NAD83, North America
#~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Prep----
#wd <- getwd() # assume is package directory
# library(usethis)
# library(sf) # replace rgdal
# library(ggplot2)

# 1. Get data and process----
fn_shp <- file.path("G:", "BCG", "GIS", "data")
ogr_shp <- sf::st_read(dsn = fn_shp, layer = "Eco3_ORWA_clip")
fort_shp <- ggplot2::fortify(ogr_shp)
# 0.99 MB

# 2. Save as RDA for use in package----
data_GIS_eco3_orwa <- fort_shp
usethis::use_data(data_GIS_eco3_orwa, overwrite = TRUE)
# 0.377 MB
