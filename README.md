BCGcalc-README
================
<Erik.Leppo@tetratech.com>
2019-05-17 10:21:52

<!-- README.md is generated from README.Rmd. Please edit that file -->

    #> Last Update: 2019-05-17 10:21:52

# BCGcalc

Biological Condition Gradient (BCG) calculator. Peform basic functions
needed for metric calculation and model (level)
assignments.

## Badges

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/leppott/BCGcalc/graphs/commit-activity)
[![GitHub
license](https://img.shields.io/github/license/leppott/BCGcalc.svg)](https://github.com/leppott/BCGcalc/blob/master/LICENSE)
[![Travis-CI Build
Status](https://travis-ci.org/leppott/BCGcalc.svg?branch=master)](https://travis-ci.org/leppott/BCGcalc)
[![GitHub
issues](https://img.shields.io/github/issues/leppott/BCGcalc.svg)](https://GitHub.com/leppott/BCGcalc/issues/)

[![GitHub
release](https://img.shields.io/github/release/leppott/BCGcalc.svg)](https://GitHub.com/leppott/BCGcalc/releases/)
[![Github all
releases](https://img.shields.io/github/downloads/leppott/BCGcalc/total.svg)](https://GitHub.com/leppott/BCGcalc/releases/)

## Installation

``` r
# Installing this library (with the vignette)
library(devtools) 
Sys.setenv("TAR" = "internal")  # needed for R v3.6.0 or higher
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
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1341 / R1341C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1429 / R1429C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1431 / R1431C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1487 / R1487C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1505 / R1505C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1527 / R1527C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1546 / R1546C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1581 / R1581C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1594 / R1594C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1610 / R1610C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1624 / R1624C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1650 / R1650C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1660 / R1660C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1668 / R1668C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1705 / R1705C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1721 / R1721C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1743 / R1743C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1777 / R1777C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1852 / R1852C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q1929 / R1929C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2011 / R2011C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2025 / R2025C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2035 / R2035C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2062 / R2062C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2080 / R2080C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2102 / R2102C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2124 / R2124C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2201 / R2201C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2263 / R2263C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2271 / R2271C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2280 / R2280C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2288 / R2288C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2308 / R2308C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2311 / R2311C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2316 / R2316C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2358 / R2358C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2383 / R2383C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2393 / R2393C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2410 / R2410C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2428 / R2428C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2440 / R2440C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2463 / R2463C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2489 / R2489C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2531 / R2531C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2533 / R2533C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2561 / R2561C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2580 / R2580C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2617 / R2617C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2664 / R2664C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2672 / R2672C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2727 / R2727C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2751 / R2751C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2752 / R2752C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2776 / R2776C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2815 / R2815C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2863 / R2863C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q2870 / R2870C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3048 / R3048C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3110 / R3110C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3126 / R3126C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3134 / R3134C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3150 / R3150C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3175 / R3175C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3184 / R3184C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3195 / R3195C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3214 / R3214C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3236 / R3236C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3285 / R3285C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3301 / R3301C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3320 / R3320C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3331 / R3331C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3344 / R3344C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3355 / R3355C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3365 / R3365C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3381 / R3381C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3398 / R3398C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3407 / R3407C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3446 / R3446C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3538 / R3538C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3552 / R3552C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3572 / R3572C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3607 / R3607C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3657 / R3657C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3714 / R3714C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3730 / R3730C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3763 / R3763C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3780 / R3780C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3791 / R3791C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3805 / R3805C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3820 / R3820C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3895 / R3895C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3949 / R3949C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3965 / R3965C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q3981 / R3981C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4001 / R4001C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4014 / R4014C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4030 / R4030C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4044 / R4044C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4064 / R4064C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4107 / R4107C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4155 / R4155C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4176 / R4176C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4193 / R4193C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4197 / R4197C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4198 / R4198C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4201 / R4201C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4260 / R4260C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4261 / R4261C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4321 / R4321C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4336 / R4336C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4360 / R4360C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4381 / R4381C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4502 / R4502C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4553 / R4553C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4602 / R4602C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4665 / R4665C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4685 / R4685C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4875 / R4875C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4897 / R4897C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4920 / R4920C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4932 / R4932C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4955 / R4955C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q4958 / R4958C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5082 / R5082C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5103 / R5103C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5117 / R5117C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5175 / R5175C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5313 / R5313C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5331 / R5331C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5427 / R5427C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5463 / R5463C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5482 / R5482C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5489 / R5489C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5528 / R5528C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5547 / R5547C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5568 / R5568C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5571 / R5571C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5577 / R5577C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5585 / R5585C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5611 / R5611C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5647 / R5647C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5663 / R5663C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5677 / R5677C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5740 / R5740C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5872 / R5872C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5883 / R5883C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5911 / R5911C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q5981 / R5981C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6003 / R6003C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6018 / R6018C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6042 / R6042C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6066 / R6066C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6083 / R6083C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6090 / R6090C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6103 / R6103C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6138 / R6138C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6156 / R6156C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6167 / R6167C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6194 / R6194C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6206 / R6206C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6229 / R6229C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6248 / R6248C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6255 / R6255C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6268 / R6268C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6272 / R6272C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6287 / R6287C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6296 / R6296C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6300 / R6300C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6309 / R6309C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6372 / R6372C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6380 / R6380C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6442 / R6442C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6453 / R6453C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6460 / R6460C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6513 / R6513C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6529 / R6529C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6537 / R6537C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6550 / R6550C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6565 / R6565C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6583 / R6583C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6585 / R6585C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6597 / R6597C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6617 / R6617C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6627 / R6627C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6634 / R6634C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6648 / R6648C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6655 / R6655C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6687 / R6687C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6691 / R6691C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6707 / R6707C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6722 / R6722C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6754 / R6754C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6769 / R6769C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6772 / R6772C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6774 / R6774C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6788 / R6788C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6807 / R6807C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6808 / R6808C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6825 / R6825C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6827 / R6827C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6856 / R6856C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6859 / R6859C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6862 / R6862C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6879 / R6879C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6882 / R6882C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6982 / R6982C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q6997 / R6997C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7011 / R7011C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7023 / R7023C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7025 / R7025C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7028 / R7028C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7042 / R7042C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7044 / R7044C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7046 / R7046C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7062 / R7062C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7076 / R7076C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7097 / R7097C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7100 / R7100C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7110 / R7110C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7127 / R7127C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7142 / R7142C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7157 / R7157C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7278 / R7278C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7296 / R7296C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7300 / R7300C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7315 / R7315C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7320 / R7320C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7372 / R7372C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7394 / R7394C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7407 / R7407C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7420 / R7420C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7422 / R7422C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7438 / R7438C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7441 / R7441C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7457 / R7457C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7461 / R7461C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7549 / R7549C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7588 / R7588C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7626 / R7626C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7674 / R7674C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7686 / R7686C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7726 / R7726C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7741 / R7741C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7799 / R7799C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7806 / R7806C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7807 / R7807C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7809 / R7809C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7813 / R7813C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7816 / R7816C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q7818 / R7818C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8031 / R8031C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8135 / R8135C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8146 / R8146C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8172 / R8172C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8173 / R8173C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8200 / R8200C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8202 / R8202C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8205 / R8205C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8211 / R8211C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8213 / R8213C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8215 / R8215C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8217 / R8217C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8219 / R8219C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8230 / R8230C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8256 / R8256C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8342 / R8342C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8388 / R8388C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8470 / R8470C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8477 / R8477C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8479 / R8479C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8481 / R8481C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8495 / R8495C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8506 / R8506C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8560 / R8560C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8605 / R8605C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8668 / R8668C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8723 / R8723C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8750 / R8750C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8781 / R8781C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8803 / R8803C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8828 / R8828C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8851 / R8851C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8875 / R8875C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8880 / R8880C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8882 / R8882C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8885 / R8885C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8890 / R8890C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8932 / R8932C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8947 / R8947C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8979 / R8979C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8981 / R8981C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8983 / R8983C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8985 / R8985C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8987 / R8987C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8989 / R8989C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q8992 / R8992C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9000 / R9000C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9001 / R9001C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9037 / R9037C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9039 / R9039C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9041 / R9041C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9093 / R9093C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9124 / R9124C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9140 / R9140C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9146 / R9146C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9160 / R9160C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9171 / R9171C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9174 / R9174C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9220 / R9220C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9263 / R9263C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9289 / R9289C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9291 / R9291C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9312 / R9312C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9337 / R9337C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9339 / R9339C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9346 / R9346C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9416 / R9416C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9424 / R9424C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9440 / R9440C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9460 / R9460C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9463 / R9463C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9487 / R9487C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9494 / R9494C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9507 / R9507C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9518 / R9518C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9530 / R9530C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9559 / R9559C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9622 / R9622C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9635 / R9635C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9653 / R9653C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9679 / R9679C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9686 / R9686C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9729 / R9729C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9802 / R9802C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9826 / R9826C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9840 / R9840C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9877 / R9877C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9897 / R9897C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9923 / R9923C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q9932 / R9932C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10021 / R10021C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10046 / R10046C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10075 / R10075C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10098 / R10098C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10124 / R10124C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10145 / R10145C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10165 / R10165C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10181 / R10181C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10194 / R10194C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10209 / R10209C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10252 / R10252C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10271 / R10271C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10283 / R10283C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10321 / R10321C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10349 / R10349C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10372 / R10372C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10457 / R10457C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10465 / R10465C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10479 / R10479C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10487 / R10487C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10516 / R10516C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10539 / R10539C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10618 / R10618C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10747 / R10747C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10792 / R10792C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10876 / R10876C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q10979 / R10979C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11020 / R11020C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11042 / R11042C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11069 / R11069C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11079 / R11079C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11156 / R11156C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11178 / R11178C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11186 / R11186C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11237 / R11237C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11257 / R11257C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11292 / R11292C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11363 / R11363C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11455 / R11455C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11554 / R11554C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11555 / R11555C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11609 / R11609C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11634 / R11634C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11668 / R11668C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11760 / R11760C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11797 / R11797C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11829 / R11829C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11890 / R11890C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11905 / R11905C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11953 / R11953C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11967 / R11967C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q11971 / R11971C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12026 / R12026C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12100 / R12100C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12139 / R12139C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12173 / R12173C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12198 / R12198C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12206 / R12206C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12254 / R12254C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12268 / R12268C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12330 / R12330C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12337 / R12337C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12364 / R12364C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12416 / R12416C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12491 / R12491C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12505 / R12505C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12527 / R12527C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12541 / R12541C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12563 / R12563C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12627 / R12627C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12634 / R12634C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12640 / R12640C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12654 / R12654C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12674 / R12674C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12682 / R12682C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12706 / R12706C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12719 / R12719C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12748 / R12748C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12758 / R12758C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12777 / R12777C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12811 / R12811C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12818 / R12818C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12863 / R12863C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12889 / R12889C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q12982 / R12982C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13004 / R13004C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13043 / R13043C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13066 / R13066C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13097 / R13097C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13120 / R13120C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13141 / R13141C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13142 / R13142C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13151 / R13151C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13169 / R13169C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13178 / R13178C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13204 / R13204C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13213 / R13213C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13230 / R13230C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13231 / R13231C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13269 / R13269C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13276 / R13276C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13347 / R13347C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13447 / R13447C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13474 / R13474C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13496 / R13496C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13504 / R13504C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13514 / R13514C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13542 / R13542C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13629 / R13629C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13657 / R13657C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13679 / R13679C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13695 / R13695C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13727 / R13727C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13752 / R13752C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13765 / R13765C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13766 / R13766C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13775 / R13775C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13806 / R13806C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13826 / R13826C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13833 / R13833C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13848 / R13848C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13877 / R13877C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13904 / R13904C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13922 / R13922C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13933 / R13933C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13972 / R13972C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q13997 / R13997C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14021 / R14021C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14022 / R14022C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14033 / R14033C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14086 / R14086C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14114 / R14114C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14137 / R14137C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14181 / R14181C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14216 / R14216C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14236 / R14236C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14255 / R14255C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14287 / R14287C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14313 / R14313C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14336 / R14336C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14366 / R14366C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14391 / R14391C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14442 / R14442C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14473 / R14473C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14510 / R14510C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14531 / R14531C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14549 / R14549C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14570 / R14570C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14595 / R14595C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14612 / R14612C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14640 / R14640C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14708 / R14708C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14737 / R14737C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14795 / R14795C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14821 / R14821C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14844 / R14844C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14850 / R14850C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14876 / R14876C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14905 / R14905C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q14934 / R14934C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15018 / R15018C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15042 / R15042C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15070 / R15070C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15082 / R15082C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15122 / R15122C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15128 / R15128C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15147 / R15147C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15176 / R15176C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15223 / R15223C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15227 / R15227C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15238 / R15238C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15270 / R15270C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15329 / R15329C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15406 / R15406C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15416 / R15416C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15432 / R15432C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15467 / R15467C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15474 / R15474C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15491 / R15491C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15501 / R15501C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15512 / R15512C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15526 / R15526C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15555 / R15555C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15601 / R15601C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15628 / R15628C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15687 / R15687C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15727 / R15727C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15742 / R15742C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15856 / R15856C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15882 / R15882C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15909 / R15909C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15941 / R15941C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15964 / R15964C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q15972 / R15972C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16001 / R16001C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16015 / R16015C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16025 / R16025C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16053 / R16053C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16103 / R16103C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16488 / R16488C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16489 / R16489C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16544 / R16544C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16566 / R16566C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16586 / R16586C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16700 / R16700C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16783 / R16783C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16805 / R16805C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16849 / R16849C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q16956 / R16956C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17028 / R17028C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17058 / R17058C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17131 / R17131C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17144 / R17144C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17193 / R17193C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17215 / R17215C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17267 / R17267C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17312 / R17312C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17330 / R17330C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17358 / R17358C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17387 / R17387C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17415 / R17415C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17439 / R17439C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17461 / R17461C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17493 / R17493C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17508 / R17508C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17544 / R17544C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17595 / R17595C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17627 / R17627C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17652 / R17652C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17675 / R17675C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17730 / R17730C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17790 / R17790C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17835 / R17835C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17855 / R17855C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17865 / R17865C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17910 / R17910C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q17961 / R17961C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18020 / R18020C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18040 / R18040C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18145 / R18145C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18200 / R18200C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18230 / R18230C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18261 / R18261C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18277 / R18277C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18295 / R18295C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18313 / R18313C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18328 / R18328C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18361 / R18361C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18373 / R18373C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18393 / R18393C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18418 / R18418C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18433 / R18433C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18463 / R18463C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18477 / R18477C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18481 / R18481C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18495 / R18495C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18508 / R18508C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18514 / R18514C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18521 / R18521C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18540 / R18540C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18547 / R18547C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18548 / R18548C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18559 / R18559C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18584 / R18584C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18663 / R18663C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18748 / R18748C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18754 / R18754C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18794 / R18794C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18825 / R18825C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18846 / R18846C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18870 / R18870C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18894 / R18894C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18920 / R18920C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18946 / R18946C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q18971 / R18971C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19009 / R19009C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19017 / R19017C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19054 / R19054C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19093 / R19093C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19108 / R19108C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19134 / R19134C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19163 / R19163C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19188 / R19188C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19266 / R19266C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19291 / R19291C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19308 / R19308C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19332 / R19332C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19355 / R19355C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19366 / R19366C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19379 / R19379C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19389 / R19389C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19399 / R19399C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19424 / R19424C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19450 / R19450C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19474 / R19474C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19494 / R19494C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19517 / R19517C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19541 / R19541C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19555 / R19555C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19571 / R19571C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19602 / R19602C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19611 / R19611C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19636 / R19636C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19677 / R19677C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19687 / R19687C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19714 / R19714C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19755 / R19755C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19773 / R19773C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19834 / R19834C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19858 / R19858C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19883 / R19883C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19905 / R19905C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19924 / R19924C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19949 / R19949C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19975 / R19975C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q19994 / R19994C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20004 / R20004C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20022 / R20022C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20046 / R20046C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20063 / R20063C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20072 / R20072C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20085 / R20085C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20117 / R20117C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20140 / R20140C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20165 / R20165C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20183 / R20183C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20192 / R20192C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20210 / R20210C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20220 / R20220C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20248 / R20248C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20275 / R20275C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20302 / R20302C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20318 / R20318C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20327 / R20327C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20343 / R20343C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20365 / R20365C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20376 / R20376C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20385 / R20385C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20401 / R20401C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20410 / R20410C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20426 / R20426C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20435 / R20435C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20456 / R20456C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20477 / R20477C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20501 / R20501C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20515 / R20515C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20535 / R20535C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20572 / R20572C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20614 / R20614C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20625 / R20625C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20652 / R20652C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20677 / R20677C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20699 / R20699C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20743 / R20743C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20786 / R20786C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20814 / R20814C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20839 / R20839C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20863 / R20863C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20891 / R20891C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20939 / R20939C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q20987 / R20987C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21005 / R21005C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21019 / R21019C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21025 / R21025C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21036 / R21036C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21085 / R21085C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21105 / R21105C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21133 / R21133C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21140 / R21140C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21164 / R21164C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21196 / R21196C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21219 / R21219C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21265 / R21265C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21288 / R21288C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21336 / R21336C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21433 / R21433C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21476 / R21476C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21485 / R21485C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21501 / R21501C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21511 / R21511C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21530 / R21530C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21531 / R21531C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21541 / R21541C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21584 / R21584C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21603 / R21603C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21632 / R21632C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21643 / R21643C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21660 / R21660C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21668 / R21668C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21714 / R21714C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21744 / R21744C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21747 / R21747C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21753 / R21753C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21768 / R21768C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21780 / R21780C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21803 / R21803C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21824 / R21824C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21840 / R21840C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21860 / R21860C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21877 / R21877C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21929 / R21929C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21967 / R21967C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21984 / R21984C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q21991 / R21991C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22013 / R22013C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22035 / R22035C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22056 / R22056C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22076 / R22076C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22094 / R22094C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22118 / R22118C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22144 / R22144C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22168 / R22168C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22191 / R22191C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22204 / R22204C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22230 / R22230C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22253 / R22253C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22269 / R22269C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22317 / R22317C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22335 / R22335C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22378 / R22378C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22387 / R22387C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22417 / R22417C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22422 / R22422C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22442 / R22442C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22447 / R22447C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22469 / R22469C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22494 / R22494C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22502 / R22502C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22551 / R22551C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22564 / R22564C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22575 / R22575C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22581 / R22581C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22593 / R22593C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22618 / R22618C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22638 / R22638C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22651 / R22651C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22659 / R22659C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22679 / R22679C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22718 / R22718C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22850 / R22850C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22865 / R22865C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22896 / R22896C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22915 / R22915C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22936 / R22936C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22958 / R22958C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22970 / R22970C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22982 / R22982C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q22992 / R22992C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23001 / R23001C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23013 / R23013C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23036 / R23036C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23076 / R23076C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23123 / R23123C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23164 / R23164C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23206 / R23206C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23256 / R23256C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23276 / R23276C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23405 / R23405C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23421 / R23421C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23439 / R23439C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23456 / R23456C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23524 / R23524C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23542 / R23542C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23582 / R23582C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23617 / R23617C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23656 / R23656C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23676 / R23676C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23741 / R23741C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23768 / R23768C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23806 / R23806C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23822 / R23822C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23856 / R23856C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23875 / R23875C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23895 / R23895C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23898 / R23898C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23916 / R23916C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23923 / R23923C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23926 / R23926C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23930 / R23930C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23939 / R23939C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23948 / R23948C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23954 / R23954C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q23962 / R23962C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24066 / R24066C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24091 / R24091C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24112 / R24112C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24131 / R24131C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24177 / R24177C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24263 / R24263C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24285 / R24285C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24294 / R24294C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24313 / R24313C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24350 / R24350C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24377 / R24377C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24406 / R24406C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24544 / R24544C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24581 / R24581C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24640 / R24640C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24714 / R24714C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24722 / R24722C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24750 / R24750C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24865 / R24865C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24946 / R24946C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q24975 / R24975C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q25085 / R25085C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q25239 / R25239C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q25248 / R25248C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q25297 / R25297C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q25350 / R25350C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q25351 / R25351C17: got 'Tipuloidea'
#> Warning in read_fun(path = enc2native(normalizePath(path)), sheet_i =
#> sheet, : Expecting logical in Q26447 / R26447C17: got 'Tipuloidea'
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

| SAMPLEID                     | AREA\_MI2 | SURFACEAREA | DENSITY\_M2 | DENSITY\_FT2 | INDEX\_REGION | INDEX\_NAME           | ni\_total | nt\_total | nt\_BCG\_att1i2 | pt\_BCG\_att1i23 | pi\_BCG\_att1i23 | pt\_BCG\_att56 | pi\_BCG\_att56 | nt\_EPT\_BCG\_att1i23 | pi\_NonInsJugaRiss\_BCG\_att456 | pt\_NonIns\_BCG\_att456 | pi\_NonIns\_BCG\_att456 | nt\_EPT |
| :--------------------------- | --------: | :---------- | :---------- | :----------- | :------------ | :-------------------- | --------: | --------: | --------------: | ---------------: | ---------------: | -------------: | -------------: | --------------------: | ------------------------------: | ----------------------: | ----------------------: | ------: |
| 01103CSR\_Bug\_2001-08-27\_0 | 44.084184 | NA          | NA          | NA           | lo            | BCG\_PacNW\_v1\_500ct |       589 |        27 |               0 |         11.11111 |       15.2801358 |       29.62963 |      14.940577 |                     2 |                      19.3548387 |                37.03704 |              19.3548387 |       5 |
| 02087REF\_Bug\_2002-08-22\_0 |  1.791475 | NA          | NA          | NA           | hi            | BCG\_PacNW\_v1\_500ct |       542 |        38 |               4 |         44.73684 |       15.1291513 |        0.00000 |       0.000000 |                    12 |                       2.0295203 |                10.52632 |              66.0516605 |      18 |
| 03013CSR\_Bug\_2003-07-01\_0 |  9.613734 | 8           | NA          | NA           | hi            | BCG\_PacNW\_v1\_500ct |       507 |        16 |               0 |          6.25000 |        0.1972387 |        6.25000 |       1.972387 |                     1 |                       7.1005917 |                31.25000 |              33.1360947 |       5 |
| 03053CSR\_Bug\_2003-08-14\_0 |  3.061723 | 8           | NA          | NA           | hi            | BCG\_PacNW\_v1\_500ct |       573 |        36 |               0 |         41.66667 |       38.2198953 |        0.00000 |       0.000000 |                    14 |                       5.0610820 |                13.88889 |              12.5654450 |      20 |
| 03054CSR\_Bug\_2003-08-18\_0 | 71.249741 | 8           | NA          | NA           | lo            | BCG\_PacNW\_v1\_500ct |       558 |        13 |               1 |         23.07692 |        1.7921147 |       15.38462 |      73.835125 |                     3 |                       4.4802867 |                30.76923 |               5.5555556 |       6 |
| 06012CSR\_Bug\_2006-09-05\_0 | 82.338353 | 8           | NA          | NA           | hi            | BCG\_PacNW\_v1\_500ct |       545 |        40 |               4 |         45.00000 |       32.4770642 |        2.50000 |      17.614679 |                    12 |                       0.3669725 |                 7.50000 |               0.9174312 |      21 |

Selected metric results
