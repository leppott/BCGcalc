BCGcalc-NEWS
================
<Erik.Leppo@tetratech.com>
2021-12-02 12:38:22

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->

    #> Last Update: 2021-12-02 12:38:22

# Version History

## Changes in Version 1.3.4.9037 (2021-12-02)

-   refactor: Update MetricFlags.xlsx
    -   Match metric names to BioMonTools::metric.values()
    -   Add BioMonTools\_MetNam column for future test (some not
        metrics)
    -   Change symbols from = to ==
    -   Write test to check for Flag symbols
-   fix: One entry in Rules.xlsx was “\[” instead of “&gt;=”.

## Changes in Version 1.3.4.9036 (2021-12-01)

-   fix: BCG.Level.Membership fails test
    -   Missing EXC\_RULE in merge statement
-   refactor: Update “Notes” to “Note\_Rules” in Rules.xlsx
-   tests: Update test for revised sheet name in Rules.xlsx

## Changes in Version 1.3.4.9035 (2021-12-01)

-   fix: Renamed master branch to main
-   docs: Move wishlist from NEWS to GitHub Issue \#56
-   refactor: Updated Rules.xlsx for PacNW BCG, Issue \#55
-   refactor: Updated Flags.xlsx for PacNW BCG, Issue \#55
-   tests: Add test for floating point error
    -   Rules.xlsx
    -   Flags.xlsx
-   docs: Update example for additional required columns in
    BioMonTools::metric.values()
    -   BCG.Metric.Membership()
    -   BCG.Level.Membership()

## Changes in Version 1.3.4.9034 (2021-08-09)

-   feat: Update BCG.Level.Membership() to account for special
    conditions
    -   Use Index\_Name and Site\_Type to allow for individual model
        exceptions to the typical rules for level membership
-   feat: Update Rules.xlsx for exceptions in level membership in
    BCG.Level.Membership()

## Changes in Version 1.3.4.9033 (2021-08-06)

-   fix: Update BCG.Metric.Membership() to use &lt;= and &gt;= when
    checking for values below and above limits rather than &lt; and &gt;
    due to rules in CT BCG using 0 as a lower AND upper limit

## Changes in Version 1.3.4.9032 (2021-08-04)

-   fix: Update Rules.xlsx for CT BCG model, Issue \#48
    -   Removed double entries for fish01, fish02, and fish03 SiteType

## Changes in Version 1.3.4.9031 (2021-08-04)

-   fix: Update Rules.xlsx for CT BCG model, Issue \#48
    -   Removed double entries for bug01 SiteType

## Changes in Version 1.3.4.9030 (2021-08-04)

-   refactor: Update BCG.Metric.Membership() for lower and upper bounds
    -   Per CT Access db (2013-08-09) use &lt;= and &gt;= instead of
        &lt; and &gt;
-   style: Wrap some lines more than 80 characters,
    BCG.Level.Assignment()

## Changes in Version 1.3.4.9029 (2021-08-03)

-   fix: Update BCG.Metric.Membership() for calculating membership for
    more than one Site\_Type at a time, Issue \#53
    -   Allows for NA for metrics not common to all included Site Types

## Changes in Version 1.3.4.9028 (2021-07-30)

-   refactor: Update Rules.xlsx for CT BCG benthos
    -   pi\_BCG\_att5 to pi\_BCG\_att5extra

## Changes in Version 1.3.4.9027 (2021-07-30)

-   refactor: Update BCG.Level.Membership with stop message if unable to
    merge data frames

## Changes in Version 1.3.4.9026 (2021-07-30)

-   refactor: Update Rules.xlsx to match BioMonTools::metric.values()
    -   rename brook trout wild

## Changes in Version 1.3.4.9025 (2021-07-29)

-   refactor: Update Rules.xlsx to match BioMonTools::metric.values()
    -   Add “BCG” to BCG attribute metric names

## Changes in Version 1.3.4.9024 (2021-07-28)

-   refactor: Update BCG.Level.Assignment()
    -   Add column name inputs and defaults
    -   Update code to use inputs
    -   Add tempdir() to save example
    -   Update example to not have warning for
        BioMonTools::metric.values()
    -   Apply fixes for changes in dplyr
-   refactor: Update BCG.Level.Membership()
    -   Add column name inputs and defaults
    -   Update code to use inputs
    -   Add tempdir() to save example
    -   Add QC in function to retain only the input columns
    -   Update example to not have warning for
        BioMonTools::metric.values()
    -   Apply fixes for changes in dplyr
-   refactor: Update BCG.Metric.Membership()
    -   Add column name inputs and defaults
    -   Update code to use inputs
    -   Add tempdir() to save example
    -   Update example to not have warning for
        BioMonTools::metric.values()
    -   Apply fixes for changes in dplyr
-   style: Trim lines to 80 characters (partial)
    -   BCG.Level.Assignment()
    -   BCG.Level.Membership()
    -   BCG.Metric.Membership()
-   style: Update function examples to use "\_" instead of “.” in object
    names
    -   BCG.Level.Assignment()
    -   BCG.Level.Membership()
    -   BCG.Metric.Membership()
-   style: Update function examples to use foo::fun() instead of
    library(foo)
    -   BCG.Level.Assignment()
    -   BCG.Level.Membership()
    -   BCG.Metric.Membership()

## Changes in Version 1.3.4.9023 (2021-07-23)

-   refactor: Update Rules.xlsx, Issue \#48
    -   Change Index\_Name, Site\_Type, and Index\_Region

## Changes in Version 1.3.4.9022 (2021-07-01)

-   docs: Update DESCRIPTION remotes to proper url
-   refactor: Update `metric.membership()` example to use updated
    Rules.xlsx, Issue \#48
-   refactor: Update Rules.xlsx file, Issue \#48
-   refactor: Update `level.membership()` example to use updated
    Rules.xlsx, Issue \#48
-   refactor: Update `level.assignment()` example to use updated
    Rules.xlsx, Issue \#48

## Changes in Version 1.3.4.9021 (2021-07-01)

-   refactor: Merge pull request with updated rules, Issue \#52

## Changes in Version 1.3.4.9020 (2021-06-22)

-   refactor: Update model rules, Rules.xlsx, Issue \#48

## Changes in Version 1.3.4.9019 (2021-04-04)

-   docs: Add sticker to README

## Changes in Version 1.3.4.9018 (2021-04-04)

-   feature: Add sticker
    -   Create with hexSticker

## Changes in Version 1.3.4.9017 (2021-04-04)

-   style: Fix devtools::spell\_check() issues
    -   NEWS
    -   README
    -   vignette\_BCGcalc.Rmd
-   refactor: README
    -   Update example, change devtools::install\_github to
        remotes::install\_github
    -   Rebuild README

## Changes in Version 1.3.4.9016 (2021-01-18)

-   docs: Remove date from DESCRIPTION
-   tests: Add tests
    -   metric\_membership
    -   level\_membership
    -   level\_assignment
-   feature: Create metrics\_values dataset to use in tests
-   docs: Document metrics\_values dataset
-   refactor: Replace undesirable function, library
    -   ProcessData\_TaxaMaster\_Ben\_BCG\_PacNW

## Changes in Version 1.3.4.9015 (2020-12-27)

-   test: set up test folder

## Changes in Version 1.3.4.9014 (2020-12-27)

-   ci: Add GitHub Action test coverage
-   ci: Add GitHub Action pkgdown
-   docs: ReadMe, add codecov badge
-   docs: ReadMe, add lifecycle badge
-   docs: ReadMe, add codefactor badge
-   docs: Remove docs folder from main branch for pkgdown
-   docs: Redirect GitHub repo for pkgdown to gh-pages branch

## Changes in Version 1.3.4.9013 (2020-12-27)

-   ci: Add GitHub Actions, continuous integration
-   ci: Remove TravisCI
-   docs: ReadMe, remove TravisCI badge
-   docs: ReadMe, Add GitHub Actions CMD check badge

## Changes in Version 1.3.4.9012 (2019-11-07)

-   Add pkgdown website.
    -   Need to fix vignettes/BCGcalc\_Map.Rmd.
        -   INFRAORDER missing.

## Changes in Version 1.3.4.9011 (2019-06-26)

-   Build Check fixes.
    -   Move “View” in example to “do not run”.
        -   BCG.Level.Assignment
        -   BCG.Level.Membership
        -   BCG.Metric.Membership
    -   Column names of TaxaMaster\_Ben\_BCG\_PacNW
        -   Data.R
    -   Depends on R &gt;= 2.10
        -   DESCRIPTION
    -   Add .github to .Rbuildignore
    -   Remove unused data (data folder and data.R)
        -   taxa\_fish
        -   taxa\_bugs\_family
        -   taxa\_bugs\_genus

## Changes in Version 1.3.4.9010 (2019-05-17)

-   Update for R v3.6.0, Issue \#46
    -   README
        -   Add extra line for devtools::install\_github to work
            properly
-   Added badges to README
-   Map Vignette
    -   Update title.

## Changes in Version 1.3.4.9009 (2019-04-18)

-   BCG.Level.Assignment
    -   Proportional BCG final scores, Issue \#43.
        -   Add “tie” to narrative.

## Changes in Version 1.3.4.9008 (2019-04-17)

-   BCG.Level.Assignment
    -   Proportional BCG final scores, Issue \#43
        -   Turn on features from v1.3.4.9004.
        -   Add proportional narrative (+/-).

## Changes in Version 1.3.4.9007 (2019-04-17)

-   extdata.xlsx
    -   ni\_total, Hi, to 450 from 400.
        -   Matches file in BioMonTools package.

## Changes in Version 1.3.4.9006 (2019-04-17)

-   Remove format Hoboware file from extdata folder.
    -   From another package under development.

## Changes in Version 1.3.4.9005 (2019-03-15)

-   MetricFlags.xlsx
    -   Percent metrics to 0-100. Issues \#45.
    -   Add field Index\_Region
-   Data\_BCG\_PacNW.xlsx
    -   Add fields: Issue \#33.
        -   Index\_Region
        -   LongLived
        -   NoteWorthy
        -   FFG2
        -   TolVal2
-   Rules.xlsx
    -   Add field Index\_Region Issue \#33.
    -   Update percent metrics to 0-100. Issue \#45.
-   Vignette, modify for Site\_Type to Index\_Region
    -   BCGcalc\_Map.RMD
    -   vignette\_BCGcalc.RMD
        -   Add “Site\_Type”" to columns to keep
-   Modify example for Site\_Type to Index\_Region Issue \#33.
    -   BCG.Level.Assignment.R
    -   BCG.Level.Membership.R
    -   BCG.Metric.Membership.R

## Changes in Version 1.3.4.9004 (2018-11-26)

-   Proportional Level Assignment. Issue \#43.
    -   Needs more polish for different conditions.
    -   Assign all to NA.

## Changes in Version 1.3.4.9003 (2018-11-26)

-   Last update not complete before uploaded.

## Changes in Version 1.3.4.9002 (2018-11-26)

-   Move qc.checks to BioMonTools package. Issue \#44
    -   Remove qc.checks.R
    -   Update Vignette.
-   Update read\_excel with guess\_max=10^6 for bio data file.

## Changes in Version 1.3.4.9001 (2018-11-26)

-   Add proportional Level Assignment. Issue \#43.
    -   BCG.Level.Assignment

## Changes in Version 1.3.4 (2018-11-21)

-   Update release version with Remote“s”" fix.

## Changes in Version 1.3.3.9005 (2018-11-21)

-   BioMonTools dependency not installing.
    -   Move Remote up in listing in DESCRIPTION.
    -   Renamed Remote to Remotes.

## Changes in Version 1.3.3.9004 (2018-11-21)

-   Add BioMonTools to Imports so will auto install.
    -   Had removed at some point since don’t use the functions in any
        BCGcalc functions.

## Changes in Version 1.3.3.9003 (2018-11-20)

-   Update SuperFamily Tipuloidea
    -   /extdata/Data\_BCG\_PacNW.xlsx
    -   /extdata/TaxaMaster\_Bug\_BCG\_PacNW\_v1.xlsx

## Changes in Version 1.3.3.9002 (2018-11-19)

-   /extdata/Data\_BCG\_PacNW.xlsx
    -   Update Exclude column after QC with BioMonTools::markExcluded
        -   Change 6 FALSE to TRUE
        -   Change 1 TRUE to FALSE

## Changes in Version 1.3.3.9001 (2018-11-19)

-   Update ReadMe for BioMonTools::metric.values. Issue \#41.

## Changes in Version 1.3.3 (2018-11-19)

-   Update version have changes related to moving functions to the
    BioMonTools package.

## Changes in Version 1.3.2.9012 (2018-11-19)

-   metric.values, move to another package, Issue \#40
    -   Moved to separate package. \_
        <https://github.com/leppott/BioMonTools>
        -   BioMonTools is for bioassessment and biomonitoring.
        -   ContDataQC should stay focused on continuous data.  
    -   Vignette
        -   Updated each section with metric.values
        -   BCGcalc\_Map.rmd
        -   vignette\_BCGcalc.rmd
    -   R/data.R
        -   Keep example data since specific to BCG project
    -   Remove
        -   R/metric.values.R
    -   Update function examples.
        -   Add library(BioMonTools)
        -   qc.checks.R
        -   BCG.Metric.Membership.R
        -   BCG.Level.Membership.R
        -   BCG.Level.Assignment.R
-   Update map colors, Issue \#35.
-   BCG.Metric.Membership.R
    -   Update details.
-   BCG.Level.Assignment.R
    -   Add don’t run to simple example for write.csv.

## Changes in Version 1.3.2.9011 (2018-11-15)

-   rarify, move to another package, Issue \#40
    -   Moved to separate package.  
        \_ <https://github.com/leppott/BioMonTools>
        -   BioMonTools is for bioassessment and biomonitoring.
        -   BCGcalc should stay focused on BCG models.
    -   DESCRIPTION
        -   Add Remote: leppott/BioMonTools
        -   Remove Jon van Sickles as contributor since removed rarify
            function.
    -   Vignette
        -   rarify section updated.
    -   R/data.R
        -   Remove reference to data\_bio2rarify
    -   Remove
        -   R/rarify.R
        -   data-raw/ProcessData\_rarify.R
        -   data-raw/ 3 data files
        -   data/data\_bio2rarify.rda

## Changes in Version 1.3.2.9010 (2018-11-07)

-   Metric calculations, additional metrics.
    -   metric.values.R
        -   nt\_Ephemerellidae
        -   nt\_Heptageniidae
        -   nt\_Nemouridae
        -   nt\_Perlidae
        -   nt\_Rhyacophila
        -   nt\_Tipulidae
    -   MetricNames.xlsx
-   Fix error with habit metric names.
    -   metric.values.R
    -   MetricNames.xlsx

## Changes in Version 1.3.2.9009 (2018-10-23)

-   Metric calculation;
    -   x\_HBI. Issue \#37
        -   calculation use TOLVAL&gt;=0 rather than TOLVAL&gt;0 in
            denominator.
    -   Consistent naming. Issue \#38
        -   habit\_clmbrs to habit\_climb
        -   habit\_clngrs to habit\_cling
        -   habit\_swmmrs to habit\_swim

## Changes in Version 1.3.2.9008 (2018-10-22)

-   Metric calculation;
    -   Tolerance metrics
        -   nt\_tv\_intol
        -   nt\_tv\_toler
        -   pt\_tv\_intol
        -   pt\_tv\_toler
        -   Added lower and upper limits for intol and toler

## Changes in Version 1.3.2.9007 (2018-10-22)

-   Metric calculation;
    -   pi\_Colesen
        -   Change is.na(FAMILY) from FALSE to TRUE.

## Changes in Version 1.3.2.9006 (2018-10-22)

-   Metric calculation;
    -   pi\_Hydro
        -   Equal sign missing in equation (“=” instead of “==”).

## Changes in Version 1.3.2.9005 (2018-10-22)

-   Metric calculation;
    -   pi\_Tanyp
        -   Misspelled Tanypodinae

## Changes in Version 1.3.2.9004 (2018-10-22)

-   Metric calculations;
    -   x\_HBI
        -   Remove negative sign. Issue \#37
    -   x\_Shan\_e, x\_Shan\_2, x\_Shan\_10
        -   Fix equation. Not properly calculating proportions.
        -   Drop use of x\_Shan\_Num. Use x\_Shan\_e then convert for
            other log bases.
    -   x\_D
        -   Fix equation.

## Changes in Version 1.3.2.9003 (2018-10-22)

-   Fix metric calculation; na.rm=TRUE for sum. Issue \#37
    -   x\_HBI \_ If had any NA values for TolVal the final value was
        NA.
        -   Added na.rm=TRUE to sum function for numerator.
        -   Denominator already included na.rm=TRUE.
    -   x\_D
        -   No effect as no records should be NA for count
    -   dominant calculation intermediate columns
        -   No effect as no records should be NA for count
    -   ni\_total
        -   No effect as no records should be NA for count
    -   All fish metrics (with “sum”)

## Changes in Version 1.3.2.9002 (2018-10-12)

-   Add 8 additional metrics to metric.values
    -   MS DEQ, MBISQ 2015 \_ pi\_Hydro
        -   nt\_NonIns
        -   pt\_NonIns
        -   pi\_Tanyp
        -   pt\_tv\_intol
        -   pt\_tv\_toler  
        -   pi\_Colesens
        -   pi\_COC2Chi

## Changes in Version 1.3.2.9001 (2018-10-12)

-   Mapping Vignette. Issue \#34.
    -   DESCRIPTION
        -   Add ggplot2 to Suggests
    -   extdata\_BCG\_PacNW.xlsx
        -   Add Latitude, Longitude, and COMID
    -   Create Vignette for mapping

## Changes in Version 1.3.2 (2018-10-11)

-   Release version.

## Changes in Version 1.3.1.9001 (2018-10-11)

-   Master Taxa List
    -   Turbellaria BCG Attribute.
        -   Change from “x” to “4” to match its synonym Trepaxonemata.

## Changes in Version 1.3.1 (2018-10-10)

-   Release version.

## Changes in Version 1.3.0.9001 (2018-10-10)

-   Rules.xlsx
    -   Fix typos in “Numeric\_Rules” field.
        -   No impact on calculations.

## Changes in Version 1.3.0 (2018-10-09)

-   Release version.

## Changes in Version 1.2.2.9033 (2018-10-09)

-   Update Vignette.
    -   Rarify section to 600.

## Changes in Version 1.2.2.9032 (2018-10-09)

-   Update Vignette.
    -   Fix a few typos.

## Changes in Version 1.2.2.9031 (2018-10-09)

-   Update Rules.xlsx.
    -   300 count model edits.

## Changes in Version 1.2.2.9030 (2018-10-09)

-   Vignette updates.

## Changes in Version 1.2.2.9029 (2018-10-05)

-   Updated rarify data; data\_bio2rarify
    -   Replace fully qualified 500 count data with 3 column 600 count.
    -   Update data.R entry.
    -   Update rarify function example.
    -   Update vignette example.

## Changes in Version 1.2.2.9028 (2018-10-05)

-   Updated docs.
    -   extdata/ExampleDataFile.xlsx
    -   docs/BCGcalc\_README\_20180919.pdf

## Changes in Version 1.2.2.9027 (2018-10-05)

-   Updated Rules.xlsx file in extdata.

## Changes in Version 1.2.2.9026 (2018-09-28)

-   Finish updates to Vignette.

## Changes in Version 1.2.2.9025 (2018-09-28)

-   Level.Assignment. Issue \#11
    -   Update example so don’t calculate metrics twice.

## Changes in Version 1.2.2.9024 (2018-09-28)

-   Vignette updates (incomplete).
-   Metric.Membership. Issue \#11
    -   Non numeric extra columns caused errors. Fixed.

## Changes in Version 1.2.2.9023 (2018-09-27)

-   extdata
    -   TaxaMaster\_Bug\_BCG\_PacNW\_v1.xlsx; rename worksheet to match
        previous version.
-   data-raw
    -   Remove data\_bio2rarify.txt
    -   Recreate TaxaMaster\_Ben\_BCG\_PacNW using revised XLSX file.
    -   Update 500count.tsv thermal column name.
-   data.R
    -   Update entries for TaxaMaster\_Ben\_BCG\_PacNW and
        data\_bio2rarify
-   Vignette
    -   Start on updates.

## Changes in Version 1.2.2.9022 (2018-09-27)

-   Update Data\_BCG\_PacNW.xlsx. Issue \#32
    -   Remove unnecessary worksheets.
    -   Rename single remaining worksheet.
    -   Update phylogenetic columns.
    -   Rearrange columns into required and optional.
-   Add master taxa list file to external docs.
-   Add thermal indicators file to external docs.

## Changes in Version 1.2.2.9021 (2018-09-27)

-   update ReadMe. Issue \#31

## Changes in Version 1.2.2.9020 (2018-09-27)

-   Ensure reshape2 package references are consistent. Issue \#30
    -   Ensure functions use reshape2::melt (or dcast)
    -   Ensure examples (and vignette) use library(reshape) and melt or
        dcast.

## Changes in Version 1.2.2.9019 (2018-09-26)

-   File formats. Issue \#28
    -   Add statement about file formats to Vignette.

## Changes in Version 1.2.2.9018 (2018-09-26)

-   rarify data. Issue \#19
    -   Use USGS 500 to 300 count data instead of MS 200 count.
    -   Change raw data process script.
    -   Replace data\_bio2rarify.
    -   Modify rarify example.
    -   Modified rarify example in Vignette.

## Changes in Version 1.2.2.9017 (2018-09-26)

-   BCG PacNW primer. Issue \#29
    -   BCGcalc\_README\_20180918.pdf to so shows up in package help.
-   MetricFlags.xlsx
    -   Last line, Index\_Name updated for 300 count model.

## Changes in Version 1.2.2.9016 (2018-09-26)

-   Example “write” statements as “dontrun”. Issue \#27
    -   BCG.Level.Assignment; also moved write statement to end
    -   BCG.Level.Membership
    -   BCG.Metric.Membership
    -   metric.values; included write and DataExplorer
    -   qc.checks; no write statement.
    -   rarify; Changed from commented out to donotrun
    -   Vignette; leave “as is”. Write statements all commented out.
-   BCG.Level.Assignment
    -   Change write.table(tsv) to write.csv. Issue \#28

## Changes in Version 1.2.2.9015 (2018-09-26)

-   extdata.xlsx. Issue \#26
    -   Added NOTES worksheet.
    -   Added MetricMetadata from MetricNames.xlsx.
    -   Added NOTES worksheet to MetricNames.xlsx.
    -   Renamed worksheet “BCG\_PacNW\_2018” to “BCG\_PacNW\_v1\_500ct”.
    -   Renamed Index\_Name from “BCG\_PacNW\_2018” to
        “BCG\_PacNW\_v1\_500ct”.
    -   Added worksheet “BCG\_PacNW\_v1\_300ct”.
-   Revised code references to Rules.xlsx (worksheet and Index\_Name).
    Mostly examples.
-   extdata\_BCG\_PacNW.xlsx
    -   Renamed Index\_Name from “BCG\_PacNW\_2018” to
        “BCG\_PacNW\_v1\_500ct”.
-   extdata.xlsx
    -   Renamed Index\_Name from “BCG\_PacNW\_2018” to
        “BCG\_PacNW\_v1\_500ct”.
    -   Added Index\_Name “BCG\_PacNW\_v1\_300ct”. Adjust some flags
        based on 500 vs. 300 count.

## Changes in Version 1.2.2.9014 (2018-09-25)

-   qc.checks. Issue \#25.
    -   Update Description.
    -   Add View for imported checks file.
    -   Vignette. Change section title from QC Checks to Flags.
    -   Update Level Assignment example in Vignette with real data and
        append flags.

## Changes in Version 1.2.2.9013 (2018-09-25)

-   Function rarify. Issue \#19
    -   Remove keywords.

## Changes in Version 1.2.2.9012 (2018-09-25)

-   Function rafify. Issue \#19
    -   Fix typo in @param mySeed. Remove extra period.

## Changes in Version 1.2.2.9011 (2018-09-20)

-   Metric Names metadata Issue \#18
    -   Update extdata.xlsx
    -   Add PDF version to docs.

## Changes in Version 1.2.2.9010 (2018-09-20)

-   More Indiana files. Issue \#24
    -   extdata\_IN\_BCG\_Bugs\_20170203.xlsm
    -   extdata\_Metrics\_Bugs\_IN.xlsx

## Changes in Version 1.2.2.9009 (2018-09-20)

-   Remove Indiana references. Issue \#24.
    -   Delete extdata Indiana file (Data\_BCG\_Indiana.xlsx).
    -   Delete data-raw Indiana database (BCG\_Model\_Calc (IN
        20170301).mdb. Already excluded from package build.
    -   Delete example in metric.values function.

## Changes in Version 1.2.2.9008 (2018-09-12)

-   DESCRIPTION
    -   Add date.
    -   Add Jen Stamp as contributor
-   Citation still gives error but is more complete now. Issue \#23

## Changes in Version 1.2.2.9007 (2018-09-07)

-   metric.values
    -   Fixed included metrics (fun.MetricNames)

## Changes in Version 1.2.2.9006 (2018-09-07)

-   metric.values
    -   Added QC check for NonTarget==FALSE.  
    -   Give a warning if have zero FALSE values.

## Changes in Version 1.2.2.9005 (2018-09-07)

-   metric.values
    -   Added QC check for Exclude==TRUE.  
    -   Give a warning if have zero TRUE values.

## Changes in Version 1.2.2.9004 (2018-09-05)

-   Update Vignette.
    -   Add data munging example. Issue \#14
    -   Update metric.values section for required fields. Issue \#13.
    -   Added section demonstrating saving only select metrics. Issue
        \#15
-   Update text in metric.values.

## Changes in Version 1.2.2.9003 (2018-09-04)

-   metric.values. Issue \#16
    -   Added QC worksheet to extdata\_BCG\_PacNW.xlsx

## Changes in Version 1.2.2.9002 (2018-08-28)

-   metric.values. Issue \#13
    -   Add required fields (columns) to help file.
    -   Add QC check in function. Prompt user to continue or stop.

## Changes in Version 1.2.2.9001 (2018-08-15)

-   metric.values
    -   Added metric Percent Baetis tricaudatus complex + Simuliidae
        individuals (pi\_SimBtri). Issue \#16.

## Changes in Version 1.2.2 (2018-06-14)

-   New release version.

## Changes in Version 1.2.1.9001 (2018-06-14)

-   qc.checks.R
    -   Modification to use metric names as lower case. Issue \#12.
    -   Example table; useNA=“ifany”.

## Changes in Version 1.2.1 (2018-06-13)

-   New release version.

## Changes in Version 1.2.0.9001 (2018-06-13)

-   BCG.Level.Assignment.R
    -   Membership QC (sum===1) add “round” 8 to avoid too many samples
        being flagged as “FAIL”.
    -   Example changes:
    -   Changed terminology from PASS/FAIL to NA/flag in flag fields.
    -   Changed “NumFlagFAIL” to “NumFlags”.
    -   Reordered columns so “NumFlags” is before the flag fields.

## Changes in Version 1.2.0 (2018-06-13)

-   Release version for Pacific Northwest BCG workgroup with updated
    model.

## Changes in Version 1.1.0.9010 (2018-06-13)

-   BCG.Level.Assignment.R
    -   Example code to match up with qc.checks output.
    -   Includes export to file.
-   qc.checks.R
    -   Remove example modifying column names.

## Changes in Version 1.1.0.9009 (2018-06-13)

-   BCG.Level.Membership.R
    -   Added “round” to 8 places when determining level membership.
    -   Floating point error resulted in the occassional value of
        1.1E-16 when the previous level was “1”.
    -   This resulted in the sample getting a split level assignment,
        e.g., 3:4 when it was 100% 3.

## Changes in Version 1.1.0.9008 (2018-06-13)

-   metric.values.R
    -   Add additional metrics
    -   nt; BCG\_att; 1i, 1m, 3
    -   pt; BCG\_att; 1i, 1m, 3
    -   pi; BCG\_att; 1i, 1m, 2, 3
    -   thermal indicator metrics
    -   modify grepl to == because COLD was matching COLD and
        COLD\_COOL. Only want exact match.

## Changes in Version 1.1.0.9007 (2018-06-12)

-   Update Rules.xlsx.
    -   Level 3 (Hi and Lo), pi\_BCG\_att56 changed to pt\_BCG\_att1i23.
    -   Change involved both direction and thresholds.

## Changes in Version 1.1.0.9006 (2018-06-12)

-   Update metric.values.
    -   Add “cols2keep” to allow for extra fields in output.
    -   Need extra fields for qc.checks
-   Update qc.checks.
    -   Update example with cols2keep from metric.values example.

## Changes in Version 1.1.0.9005 (2018-06-11)

-   Update bio data to be used for the model; Issue \#7
    -   Collapse mites to Order.

## Changes in Version 1.1.0.9004 (2018-06-08)

-   Update extdata/Rules.xlsx; Issue \#7

## Changes in Version 1.1.0.9003 (2018-06-08)

-   metric.values dd nt, pi, and pt metrics; Issue \#7
    -   NonIns\_BCG\_attr456
    -   NonInsJugaRiss\_BCG\_attr456

## Changes in Version 1.1.0.9002 (2018-06-08)

-   QC Flags, Add pi\_dom02. Issue \#7
-   Update format of NEWS.
-   metric.values, row\_number to dplyr::row\_number for dominant
    metrics.

## Changes in Version 1.1.0.9001 (2018-06-08)

-   metric.values, Issue \#7
    -   Update metrics from NonClump to NoJugaRiss.

## Changes in Version 1.1.0.0000 (2018-03-19)

-   Release new and fully QCed version.

## Changes in Version 1.0.0.9002 (2018-03-19)

-   Metric.values
    -   Fix metrics with *not equal* functions.
    -   Ensure use is.na(x)==TRUE rather than x==NA
    -   When have more than one condition for a data column need to be
        in the same statement.
    -   Better define clumpy taxa for 2 metrics.
-   BCG.Level.Membership
    -   Fixed combination of rules by level. Missed a column and was
        getting duplicates for alt rules that changed the outcome.
-   BCG.Level.Assignment
    -   Replace For loop with apply.
    -   Add special conditions for ties (2 levels with 0.5) and primary
        level is 1 (no 2nd level).

## Changes in Version 1.0.0.9001 (2018-03-18)

-   Metric.values
    -   Fix non-clumpy metrics.
    -   Remove extra data frames for dominance metrics. Slight speed
        improvement. Issue \#5.
-   Fix version numbers in NEWS.
-   Updated ReadMe with only the relevant packages. Issue \#4.

## Changes in Version 1.0.0.0000 (2018-03-18)

-   Only metric value issues left to resolve with test data set. Rest of
    the calculations are ok.

## Changes in Version 0.1.0.9019 (2018-03-18)

-   Rules.xlsx
    -   Fill in missing cells.
-   metric.values.R
    -   Update FFG abbreviations to match example data.
    -   Dominant N and special Dominant N metrics.
    -   Define pipe as referencing dplyr. Slows down the functions but
        keeps dplyr from needing to be loaded.
-   SiteType values to lowercase.
    -   metric.values.R
    -   BCG.Metric.Membership.R
    -   BCG.Level.Membership.R
    -   BCG.Level.Assignment.R
-   Consistent terminology; don’t mix “.”, " “, and”*“. Use”*".
    -   METRIC\_NAMES
    -   METRIC\_VALUES
    -   SITE\_TYPE (and change from REGION)
    -   RULE\_TYPE
    -   NUMERIC\_RULES
    -   LIFE\_CYCLE
    -   LONG\_LIVED
    -   THERMAL\_INDICATOR
    -   NAME\_WIDE
-   Rebuild PacNW master taxa list with changes.
    -   Consistent names (columns and categories).
-   Example PacNW data.
    -   Consistent names (columns).
-   QC Checks
-   Update Vignette.
-   All functions and examples seem to be generating the proper outputs.
    When QC only a few metrics are off. But enough that no final results
    are correct (that is, all levels, site types, and samples are
    affected but the remaining QC issues). Non-Insect and modified
    dominant 2 metrics are the 4 that have issues.

## Changes in Version 0.1.0.9018 (2018-03-17)

-   BCG.Level.Membership.R
    -   Correct function to consider preceding levels when assigning
        membership scores.

## Changes in Version 0.1.0.9017 (2018-03-16)

-   metric.values.R
    -   Added Thermal Indicator (TI) metrics.
-   Updates to PacNW bug data and rules files (xlsx).

## Changes in Version 0.1.0.9016 (2018-03-16)

-   metric.values.R
    -   Update pt\_BCG\_att1i2 and 1i23 metrics (numerator not capturing
        “i” taxa).
-   Update Rules.xlsx

## Changes in Version 0.1.0.9015 (2018-03-16)

-   Vignette didn’t update in previous version.

## Changes in Version 0.1.0.9014 (2018-03-15)

-   Tweak “data.R”. Not complete!
    -   Added example save code for master taxa list.
-   Update BCG.Metric.Membership.
    -   Add some error checking.
    -   Colnames to upper case.
-   Updated Rules.xlsx
    -   Percent metrics converted to 0-1 values to match metric.values
        calculations.
    -   Fixed Index Name for some records.
-   metric.values.R
    -   Updated examples, details, and description.
-   Update BCGcalc Vignette.
-   Update Readme.
-   Update BCG.Level.Membership

## Changes in Version 0.1.0.9013 (2018-03-14)

-   Added PacNW benthic master taxa list to data.
-   Created “data.R”. Not complete!

## Changes in Version 0.1.0.9012 (2018-03-08)

-   Update PacNW example data to use TRUE/FALSE for Excluded and
    NonTarget fields.
-   Updated metric.values
    -   Moved common data munging to earlier in function so applies to
        all communities.
    -   Enabled NonTarget exclusion. NonTarget column now required.

## Changes in Version 0.1.0.9011 (2018-03-08)

-   Completed lingering edits for “Tier” to “Level”.
-   Completed BCG.Level.Membership function.

## Changes in Version 0.1.0.9010 (2018-03-07)

-   Remove “Tier” wording in package and rename some functions to better
    reflect usage.
-   Include example code for saving results for each function.
-   Change Region to SiteType in code and example data files.

## Changes in Version 0.1.0.9009 (2018-03-05)

-   Dom02 special metric placeholder.
-   Update Rule table for Level assignments.
-   BCG.Levels function.
-   Fixed error in sequencing in BCG.Membership function.

## Changes in Version 0.1.0.9008 (2018-03-05)

-   Add last of the PacNW specific metrics to metric.values.
-   Added Vignette.

## Changes in Version 0.1.0.9007 (2018-03-05)

-   Check clean up.
-   Convert data imports from development folder to pacakge folder with
    system.file.
-   Add data for rarify function.

## Changes in Version 0.1.0.9006 (2018-03-04)

-   BCG.Tiers function.

## Changes in Version 0.1.0.9005 (2018-03-04)

-   Add BCG.Membership function. Return is in long format.
    -   Not QCed but has some known issues.

## Changes in Version 0.1.0.9004 (2018-03-03)

-   Add subtitles, date, author to YAML header to NEWS and README.
-   Add “flags” Excel file to raw-data for QC checks. Used in qc.checks
    function (new).
-   Added 4 new ni metrics to metric values to be used for QC checks
    (flags).
-   qc.checks.R (incomplete but works).
-   Add BCGcalc.R to describe the package.
-   Update documentation headers in R files.

## Changes in Version 0.1.0.9003 (2018-02-20)

-   metric.values.R, benthos
    -   Added BCG attribute metrics.
    -   Added outlining for readability in code.
    -   More metrics and clean up of file.
    -   Prepare example data for metric calculation.
    -   Added na.rm=TRUE to n\_distinct and sum in summarise.

## Changes in Version 0.1.0.9002 (2018-02-16)

-   Add parts without any modification from `MBSStools` package.
    -   rarify function
    -   metric.values function
    -   included data folder and files
    -   added Excel file to extdata with metric naming explanation

## Changes in Version 0.1.0.9001 (2018-02-16)

-   Updated files for package.
    -   Readme, NEWS, DESCRIPTION
    -   Not complete.

## Changes in Version 0.1.0 (2018-02-16)

-   Created GitHub repository
