BCGcalc-README
================
<Erik.Leppo@tetratech.com>
2018-11-19 09:05:49

<!-- README.md is generated from README.Rmd. Please edit that file -->

    #> Last Update: 2018-11-19 09:05:49

# BCGcalc

Biological Condition Gradient (BCG) calculator. Peform basic functions
needed for metric calculation and model (level) assignments.

## Installation

``` r
# Installing this library (with the vignette)
library(devtools) 
install_github("leppott/BCGcalc", force=TRUE, build_vignettes=TRUE)
```

The vignette (big help file) isn’t created when installing from GitHub
with the basic `install_github` command. If you want the vignette
install with the command above (or download the compressed file from
GitHub and install from that file).

All dependant libraries should install with the install\_github command
but occassionally they do not. If you encounter issues the dependant
libraries can be installed separately with the command below.

``` r
# Choose a CRAN mirror (dowload site) first (can change number)
chooseCRANmirror(ind=21) 
# libraries to be installed
data.packages = c(                  
                  "devtools"        # install helper for non CRAN libraries
                  ,"installr"       # install helper
                  ,"knitr"          # create documents in other formats (e.g., PDF or Word)
                  ,"dplyr"          # summary stats
                  ,"reshape2"       # convert wide to long format
                  ,"rmarkdown"      # a dependency that is sometimes missed.
                  ,"readxl"         # for importing Excel data
                  )
                  
lapply(data.packages,function(x) install.packages(x))
```

Additionally Pandoc is required for creating the reports and (sometimes)
needs to be installed separately. Pandoc is installed with RStudio so if
you have RStudio you already have Pandoc on your computer. Install
directions are included below.

``` r
## pandoc
#install.packages("installr")
library(installr)
install.pandoc()
```

## Purpose

To aid users in data tasks related to the Biological Condition Gradient
for the Pacific Northwest.

## Usage

Everytime R is launched the `BCGcalc` package needs to be loaded.

``` r
# load library and dependant libraries
library("BCGcalc")
```

The default working directory is based on how R was installed but is
typically the user’s ‘MyDocuments’ folder. You can change it through the
menu bar in R (File - Change dir) or RStudio (Session - Set Working
Directory). You can also change it from the command
line.

``` r
# if specify directory use "/" not "\" (as used in Windows) and leave off final "/" (example below).
#myDir.BASE  <- "C:/Users/Erik.Leppo/Documents/ProjectName"
myDir.BASE <- getwd()
setwd(myDir.BASE)
```

## Help

Every function has a help file with a working example. There is also a
vignette with descriptions and examples of all functions in the
`BCGcalc` library.

``` r
# To get help on a function
# library(BCGcalc) # the library must be loaded before accessing help
?BCGcalc
```

To see all available functions in the package use the command below.

``` r
# To get index of help on all functions
# library(BCGcalc) # the library must be loaded before accessing help
help(package="BCGcalc")
```

The vignette file is located in the “doc” directory of the library in
the R install folder. Below is the path to the file on my PC. But it is
much easier to use the code below to call the vignette by name. There is
also be a link to the vignette at the top of the help index for the
package.

“C:\\Programs\\R\\R-3.4.3\\library\\BCGcalc\\doc\\vignette\_BCGcalc.html”

``` r
vignette("vignette_BCGcalc", package="BCGcalc")
```

If the vignette fails to show on your computer. Run the code below to
reinstall the package and specify the creation of the vignette.

``` r
library(devtools)
install_github("leppott/BCGcalc", force=TRUE, build_vignettes=TRUE)
```

## Example

A quick example showing the calculation of metrics on a dataset but
returning only a select few (e.g., the 12 metrics used in the BCG model
for the Pacific NW). This functionality is built into the
`metric.values` function as an optional parameter.

``` r
library(BCGcalc)
library(readxl)
library(reshape2)
library(knitr)
library(BioMonTools)

df.samps.bugs <- read_excel(system.file("./extdata/Data_BCG_PacNW.xlsx"
                                       , package="BCGcalc"))
myDF <- df.samps.bugs

# Columns to keep
myCols <- c("Area_mi2", "SurfaceArea", "Density_m2", "Density_ft2")

# Metrics to Keep
met2keep <- c("ni_total", "nt_total", "nt_BCG_att1i2", "pt_BCG_att1i23"
              , "pi_BCG_att1i23", "pt_BCG_att56", "pi_BCG_att56"
              , "nt_EPT_BCG_att1i23", "pi_NonInsJugaRiss_BCG_att456"
              , "pt_NonIns_BCG_att456", "pi_NonIns_BCG_att456", "nt_EPT")

# Run Function
df.metric.values.bugs <- metric.values(myDF, "bugs", fun.MetricNames=met2keep
                                       , fun.cols2keep=myCols)

# View Results
#View(df.metric.values.bugs)
kable(head(df.metric.values.bugs), caption="Selected metric results")
```

| SAMPLEID                     | AREA\_MI2 | SURFACEAREA | DENSITY\_M2 | DENSITY\_FT2 | SITE\_TYPE | INDEX\_NAME           | ni\_total | nt\_total | nt\_BCG\_att1i2 | pt\_BCG\_att1i23 | pi\_BCG\_att1i23 | pt\_BCG\_att56 | pi\_BCG\_att56 | nt\_EPT\_BCG\_att1i23 | pi\_NonInsJugaRiss\_BCG\_att456 | pt\_NonIns\_BCG\_att456 | pi\_NonIns\_BCG\_att456 | nt\_EPT |
| :--------------------------- | --------: | :---------- | :---------- | :----------- | :--------- | :-------------------- | --------: | --------: | --------------: | ---------------: | ---------------: | -------------: | -------------: | --------------------: | ------------------------------: | ----------------------: | ----------------------: | ------: |
| 01103CSR\_Bug\_2001-08-27\_0 | 44.084184 | NA          | NA          | NA           | lo         | BCG\_PacNW\_v1\_500ct |       589 |        27 |               0 |        0.1111111 |        0.1528014 |      0.2962963 |      0.1494058 |                     2 |                       0.1935484 |               0.3703704 |               0.1935484 |       5 |
| 02087REF\_Bug\_2002-08-22\_0 |  1.791475 | NA          | NA          | NA           | hi         | BCG\_PacNW\_v1\_500ct |       542 |        38 |               4 |        0.4473684 |        0.1512915 |      0.0000000 |      0.0000000 |                    12 |                       0.0202952 |               0.1052632 |               0.6605166 |      18 |
| 03013CSR\_Bug\_2003-07-01\_0 |  9.613734 | 8           | NA          | NA           | hi         | BCG\_PacNW\_v1\_500ct |       507 |        16 |               0 |        0.0625000 |        0.0019724 |      0.0625000 |      0.0197239 |                     1 |                       0.0710059 |               0.3125000 |               0.3313609 |       5 |
| 03053CSR\_Bug\_2003-08-14\_0 |  3.061723 | 8           | NA          | NA           | hi         | BCG\_PacNW\_v1\_500ct |       573 |        36 |               0 |        0.4166667 |        0.3821990 |      0.0000000 |      0.0000000 |                    14 |                       0.0506108 |               0.1388889 |               0.1256545 |      20 |
| 03054CSR\_Bug\_2003-08-18\_0 | 71.249741 | 8           | NA          | NA           | lo         | BCG\_PacNW\_v1\_500ct |       558 |        13 |               1 |        0.2307692 |        0.0179211 |      0.1538462 |      0.7383513 |                     3 |                       0.0448029 |               0.3076923 |               0.0555556 |       6 |
| 06012CSR\_Bug\_2006-09-05\_0 | 82.338353 | 8           | NA          | NA           | hi         | BCG\_PacNW\_v1\_500ct |       545 |        40 |               4 |        0.4500000 |        0.3247706 |      0.0250000 |      0.1761468 |                    12 |                       0.0036697 |               0.0750000 |               0.0091743 |      21 |

Selected metric results
