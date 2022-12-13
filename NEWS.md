BCGcalc-NEWS
================
<Erik.Leppo@tetratech.com>
2022-12-13 17:09:04

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->

    #> Last Update: 2022-12-13 17:09:04

# BCGcalc 2.0.0.9009 (2022-12-13)

- refactor: Update filebuilder tab in Shiny app
  - Use “user file” less often
  - Change summary default to TRUE
  - Modified output files to include “*taxatrans*”
  - Renamed RESULTS to MERGED in output file
  - Add link to Taxa Translate Official files on GitHub
  - Fix non-match output

# BCGcalc 2.0.0.9008 (2022-12-13)

- refactor: Change BCG.ContLevelText status from x/y tie to x.5, Issue
  \#64

# BCGcalc 2.0.0.9007 (2022-12-12)

- feature: Add taxa translator tab and functionality to Shiny

# BCGcalc 2.0.0.9006 (2022-11-29)

- feature: Add new function to calculate BCG Status
  - Uses continuous value to get Integer or PlusMinus text

# BCGcalc 2.0.0.9005 (2022-11-18)

- refactor: Additional Shiny outputs
  - 6metflags; flag metrics, values, thresholds
  - 3metrules; rules table
- refactor: Update Shiny text for additional outputs

# BCGcalc 2.0.0.9004 (2022-11-18)

- refactor: Update Shiny app text for slim to BCG file name for BCG
  output
- refactor: Change order and names of columns in BCG.Level.Assignment
  output
  - Memb.Total to Membership_Total
  - Memb.QC to Membership_Total_QC
  - Lev.1.Memb to Primary_Membership
  - Lev.1.Name to Primary_BCG_Level
  - Lev.2.Memb to Secondary_Membership
  - Lev.2.Name to Secondary_BCG_Level
  - Lev.Memb.Diff to Membership_Diff
  - Lev.Memb.close to Membership_Close
  - Lev.Prop.Num to Continuous_BCG_Level
  - Lev.Prop.Nar to BCG_Status

# BCGcalc 2.0.0.9003 (2022-11-17)

- refactor: Change Shiny output 2metval_slim.csv to 2metval_BCG.csv

# BCGcalc 2.0.0.9002 (2022-11-17)

- fix: Update Rules.xlsx for non-ASCII characters

# BCGcalc 2.0.0.9001 (2022-11-16)

- breaking change: Site_Type and Index_Region to INDEX_CLASS, Issue \#63
  - Deprecate in functions (allow for ‘…’) and shiny
    - BCG.Level.Membership
    - BCG.Metric.Membership
    - Include warning for old code
- refactor: Update reference Excel files for updated field, Issue \#63
  - Rules.xlsx
  - MetricFlags.xlsx

# BCGcalc 1.3.5.9018 (2022-11-16)

- refactor: Shiny, change menu item name

# BCGcalc 1.3.5.9017 (2022-11-11)

- fix: Shiny app ‘slim’ output, Issue \#62

# BCGcalc 1.3.5.9016 (2022-11-03)

- fix: Shiny app, markExcl, EXCLUDED to EXCLUDE

# BCGcalc 1.3.5.9015 (2022-11-01)

- update: Change name of PacNW model, Issue \#61
  - Rules.xlsx
  - MetricFlags.xlsx
  - Example files (file name, data, sheet names)
  - Update examples in functions
  - Vignettes

# BCGcalc 1.3.5.9014 (2022-10-21)

- update: Update BCG style temperature model thresholds
  - Rules.xlsx

# BCGcalc 1.3.5.9013 (2022-10-14)

- refactor: Upgrades to Shiny app

# BCGcalc 1.3.5.9012 (2022-10-14)

- refactor: Upgrades to Shiny app

# BCGcalc 1.3.5.9011 (2022-10-13)

- refactor: Upgrades to Shiny app
  - Rework tab order and names
  - Update About
  - Other

# BCGcalc 1.3.5.9010 (2022-10-11)

- refactor: Upgrades to Shiny app
  - Added summary report
  - Added packages needed for report
  - Minor edits to main menu
  - Minor edits to About
- update: Add ‘Therm_ORWA_Bugs500ct’ model to Excel files

# BCGcalc 1.3.5.9009 (2022-10-11)

- refactor: Upgrades to Shiny app
  - Mark Excluded taxa
  - Minor updates
  - Added footer to app with shinydashboardPlus
    - Added package to DESCRIPTION
  - Update About
  - Add placeholder tabs for future updates

# BCGcalc 1.3.5.9008 (2022-09-30)

- refactor: Upgrades to Shiny app
  - Second version of results/metval with only those for the model
  - Ensure result files removed from previous imports

# BCGcalc 1.3.5.9007 (2022-09-29)

- refactor: Upgrades to Shiny app

# BCGcalc 1.3.5.9006 (2022-09-28)

- docs: Update examples for missing columns in sample data for all
  functions
- fix: Update MetricFlags.xlsx for one flag

# BCGcalc 1.3.5.9005 (2022-09-28)

- docs: Update packages in DESCRIPTION and global.R in Shiny app

# BCGcalc 1.3.5.9004 (2022-09-28)

- feat: Redesign shiny app
- docs: Add packages needed by Shiny app to DESCRIPTION

# BCGcalc 1.3.5.9003 (2022-09-23)

- style: Perform updates from lintr and goodpractice
- fix: Update Font Awesome icons, some were deprecated
- fix: Shiny About links update so open in new tab

# BCGcalc 1.3.5.9002 (2022-08-19)

- docs: Update format of NEWS

# BCGcalc 1.3.5.9001 (2022-08-18)

- feature: Add Shiny app skeleton and function to run it, Issue \#58

# BCGcalc 1.3.5 (2022-08-18)

- refactor: Bump version number.

# BCGcalc 1.3.4.9047 (2022-03-31)

- fix: Update MetricFlags.xlsx for BCG_MariNW_Bugs500ct models

# BCGcalc 1.3.4.9046 (2022-02-14)

- fix: Update MetricFlags.xlsx for BCG_MariNW_Bugs500ct models

# BCGcalc 1.3.4.9045 (2022-02-14)

- fix: Update MetricFlags.xlsx for BCG_MariNW_Bugs500ct models

# BCGcalc 1.3.4.9044 (2022-02-14)

- fix: Update MetricFlags.xlsx for BCG_MariNW_Bugs500ct models

# BCGcalc 1.3.4.9043 (2022-02-14)

- fix: Update MetricFlags.xlsx for BCG_MariNW_Bugs500ct models

# BCGcalc 1.3.4.9042 (2022-02-14)

- refactor: Update metric.values()
  - Failed when rules table included more than 1 region and metrics
    uneven

# BCGcalc 1.3.4.9041 (2022-02-11)

- refactor: Update MetricFlags.xlsx for BCG_MariNW_Bugs500ct models

# BCGcalc 1.3.4.9040 (2022-02-11)

- refactor: Update MetricFlags.xlsx for BCG_MariNW_Bugs500ct models

# BCGcalc 1.3.4.9039 (2022-02-11)

- refactor: Update MetricFlags.xlsx for BCG_MariNW_Bugs500ct models
- tests: Add tests for flags and metric names

# BCGcalc 1.3.4.9038 (2021-12-03)

- refactor: Update BCG.Level.Membership() for new median rule type,
  Issue \#55
- refactor: Update Rules.xlsx to handle new median rule type, Issue \#55

# BCGcalc 1.3.4.9037 (2021-12-02)

- refactor: Update MetricFlags.xlsx
  - Match metric names to BioMonTools::metric.values()
  - Add BioMonTools_MetNam column for future test (some not metrics)
  - Change symbols from = to ==
  - Write test to check for Flag symbols
- fix: One entry in Rules.xlsx was “\[” instead of “\>=”.

# BCGcalc 1.3.4.9036 (2021-12-01)

- fix: BCG.Level.Membership fails test
  - Missing EXC_RULE in merge statement
- refactor: Update “Notes” to “Note_Rules” in Rules.xlsx
- tests: Update test for revised sheet name in Rules.xlsx

# BCGcalc 1.3.4.9035 (2021-12-01)

- fix: Renamed master branch to main
- docs: Move wishlist from NEWS to GitHub Issue \#56
- refactor: Updated Rules.xlsx for PacNW BCG, Issue \#55
- refactor: Updated Flags.xlsx for PacNW BCG, Issue \#55
- tests: Add test for floating point error
  - Rules.xlsx
  - Flags.xlsx
- docs: Update example for additional required columns in
  BioMonTools::metric.values()
  - BCG.Metric.Membership()
  - BCG.Level.Membership()

# BCGcalc 1.3.4.9034 (2021-08-09)

- feat: Update BCG.Level.Membership() to account for special conditions
  - Use Index_Name and Site_Type to allow for individual model
    exceptions to the typical rules for level membership
- feat: Update Rules.xlsx for exceptions in level membership in
  BCG.Level.Membership()

# BCGcalc 1.3.4.9033 (2021-08-06)

- fix: Update BCG.Metric.Membership() to use \<= and \>= when checking
  for values below and above limits rather than \< and \> due to rules
  in CT BCG using 0 as a lower AND upper limit

# BCGcalc 1.3.4.9032 (2021-08-04)

- fix: Update Rules.xlsx for CT BCG model, Issue \#48
  - Removed double entries for fish01, fish02, and fish03 SiteType

# BCGcalc 1.3.4.9031 (2021-08-04)

- fix: Update Rules.xlsx for CT BCG model, Issue \#48
  - Removed double entries for bug01 SiteType

# BCGcalc 1.3.4.9030 (2021-08-04)

- refactor: Update BCG.Metric.Membership() for lower and upper bounds
  - Per CT Access db (2013-08-09) use \<= and \>= instead of \< and \>
- style: Wrap some lines more than 80 characters, BCG.Level.Assignment()

# BCGcalc 1.3.4.9029 (2021-08-03)

- fix: Update BCG.Metric.Membership() for calculating membership for
  more than one Site_Type at a time, Issue \#53
  - Allows for NA for metrics not common to all included Site Types

# BCGcalc 1.3.4.9028 (2021-07-30)

- refactor: Update Rules.xlsx for CT BCG benthos
  - pi_BCG_att5 to pi_BCG_att5extra

# BCGcalc 1.3.4.9027 (2021-07-30)

- refactor: Update BCG.Level.Membership with stop message if unable to
  merge data frames

# BCGcalc 1.3.4.9026 (2021-07-30)

- refactor: Update Rules.xlsx to match BioMonTools::metric.values()
  - rename brook trout wild

# BCGcalc 1.3.4.9025 (2021-07-29)

- refactor: Update Rules.xlsx to match BioMonTools::metric.values()
  - Add “BCG” to BCG attribute metric names

# BCGcalc 1.3.4.9024 (2021-07-28)

- refactor: Update BCG.Level.Assignment()
  - Add column name inputs and defaults
  - Update code to use inputs
  - Add tempdir() to save example
  - Update example to not have warning for BioMonTools::metric.values()
  - Apply fixes for changes in dplyr
- refactor: Update BCG.Level.Membership()
  - Add column name inputs and defaults
  - Update code to use inputs
  - Add tempdir() to save example
  - Add QC in function to retain only the input columns
  - Update example to not have warning for BioMonTools::metric.values()
  - Apply fixes for changes in dplyr
- refactor: Update BCG.Metric.Membership()
  - Add column name inputs and defaults
  - Update code to use inputs
  - Add tempdir() to save example
  - Update example to not have warning for BioMonTools::metric.values()
  - Apply fixes for changes in dplyr
- style: Trim lines to 80 characters (partial)
  - BCG.Level.Assignment()
  - BCG.Level.Membership()
  - BCG.Metric.Membership()
- style: Update function examples to use “\_” instead of “.” in object
  names
  - BCG.Level.Assignment()
  - BCG.Level.Membership()
  - BCG.Metric.Membership()
- style: Update function examples to use foo::fun() instead of
  library(foo)
  - BCG.Level.Assignment()
  - BCG.Level.Membership()
  - BCG.Metric.Membership()

# BCGcalc 1.3.4.9023 (2021-07-23)

- refactor: Update Rules.xlsx, Issue \#48
  - Change Index_Name, Site_Type, and Index_Region

# BCGcalc 1.3.4.9022 (2021-07-01)

- docs: Update DESCRIPTION remotes to proper url
- refactor: Update `metric.membership()` example to use updated
  Rules.xlsx, Issue \#48
- refactor: Update Rules.xlsx file, Issue \#48
- refactor: Update `level.membership()` example to use updated
  Rules.xlsx, Issue \#48
- refactor: Update `level.assignment()` example to use updated
  Rules.xlsx, Issue \#48

# BCGcalc 1.3.4.9021 (2021-07-01)

- refactor: Merge pull request with updated rules, Issue \#52

# BCGcalc 1.3.4.9020 (2021-06-22)

- refactor: Update model rules, Rules.xlsx, Issue \#48

# BCGcalc 1.3.4.9019 (2021-04-04)

- docs: Add sticker to README

# BCGcalc 1.3.4.9018 (2021-04-04)

- feature: Add sticker
  - Create with hexSticker

# BCGcalc 1.3.4.9017 (2021-04-04)

- style: Fix devtools::spell_check() issues
  - NEWS
  - README
  - vignette_BCGcalc.Rmd
- refactor: README
  - Update example, change devtools::install_github to
    remotes::install_github
  - Rebuild README

# BCGcalc 1.3.4.9016 (2021-01-18)

- docs: Remove date from DESCRIPTION
- tests: Add tests
  - metric_membership
  - level_membership
  - level_assignment
- feature: Create metrics_values dataset to use in tests
- docs: Document metrics_values dataset
- refactor: Replace undesirable function, library
  - ProcessData_TaxaMaster_Ben_BCG_PacNW

# BCGcalc 1.3.4.9015 (2020-12-27)

- test: set up test folder

# BCGcalc 1.3.4.9014 (2020-12-27)

- ci: Add GitHub Action test coverage
- ci: Add GitHub Action pkgdown
- docs: ReadMe, add codecov badge
- docs: ReadMe, add lifecycle badge
- docs: ReadMe, add codefactor badge
- docs: Remove docs folder from main branch for pkgdown
- docs: Redirect GitHub repo for pkgdown to gh-pages branch

# BCGcalc 1.3.4.9013 (2020-12-27)

- ci: Add GitHub Actions, continuous integration
- ci: Remove TravisCI
- docs: ReadMe, remove TravisCI badge
- docs: ReadMe, Add GitHub Actions CMD check badge

# BCGcalc 1.3.4.9012 (2019-11-07)

- Add pkgdown website.
  - Need to fix vignettes/BCGcalc_Map.Rmd.
    - INFRAORDER missing.

# BCGcalc 1.3.4.9011 (2019-06-26)

- Build Check fixes.
  - Move “View” in example to “do not run”.
    - BCG.Level.Assignment
    - BCG.Level.Membership
    - BCG.Metric.Membership
  - Column names of TaxaMaster_Ben_BCG_PacNW
    - Data.R
  - Depends on R \>= 2.10
    - DESCRIPTION
  - Add .github to .Rbuildignore
  - Remove unused data (data folder and data.R)
    - taxa_fish
    - taxa_bugs_family
    - taxa_bugs_genus

# BCGcalc 1.3.4.9010 (2019-05-17)

- Update for R v3.6.0, Issue \#46
  - README
    - Add extra line for devtools::install_github to work properly
- Added badges to README
- Map Vignette
  - Update title.

# BCGcalc 1.3.4.9009 (2019-04-18)

- BCG.Level.Assignment
  - Proportional BCG final scores, Issue \#43.
    - Add “tie” to narrative.

# BCGcalc 1.3.4.9008 (2019-04-17)

- BCG.Level.Assignment
  - Proportional BCG final scores, Issue \#43
    - Turn on features from v1.3.4.9004.
    - Add proportional narrative (+/-).

# BCGcalc 1.3.4.9007 (2019-04-17)

- extdata.xlsx
  - ni_total, Hi, to 450 from 400.
    - Matches file in BioMonTools package.

# BCGcalc 1.3.4.9006 (2019-04-17)

- Remove format Hoboware file from extdata folder.
  - From another package under development.

# BCGcalc 1.3.4.9005 (2019-03-15)

- MetricFlags.xlsx
  - Percent metrics to 0-100. Issues \#45.
  - Add field Index_Region
- Data_BCG_PacNW.xlsx
  - Add fields: Issue \#33.
    - Index_Region
    - LongLived
    - NoteWorthy
    - FFG2
    - TolVal2
- Rules.xlsx
  - Add field Index_Region Issue \#33.
  - Update percent metrics to 0-100. Issue \#45.
- Vignette, modify for Site_Type to Index_Region
  - BCGcalc_Map.RMD
  - vignette_BCGcalc.RMD
    - Add “Site_Type”” to columns to keep
- Modify example for Site_Type to Index_Region Issue \#33.
  - BCG.Level.Assignment.R
  - BCG.Level.Membership.R
  - BCG.Metric.Membership.R

# BCGcalc 1.3.4.9004 (2018-11-26)

- Proportional Level Assignment. Issue \#43.
  - Needs more polish for different conditions.
  - Assign all to NA.

# BCGcalc 1.3.4.9003 (2018-11-26)

- Last update not complete before uploaded.

# BCGcalc 1.3.4.9002 (2018-11-26)

- Move qc.checks to BioMonTools package. Issue \#44
  - Remove qc.checks.R
  - Update Vignette.
- Update read_excel with guess_max=10^6 for bio data file.

# BCGcalc 1.3.4.9001 (2018-11-26)

- Add proportional Level Assignment. Issue \#43.
  - BCG.Level.Assignment

# BCGcalc 1.3.4 (2018-11-21)

- Update release version with Remote”s”” fix.

# BCGcalc 1.3.3.9005 (2018-11-21)

- BioMonTools dependency not installing.
  - Move Remote up in listing in DESCRIPTION.
  - Renamed Remote to Remotes.

# BCGcalc 1.3.3.9004 (2018-11-21)

- Add BioMonTools to Imports so will auto install.
  - Had removed at some point since don’t use the functions in any
    BCGcalc functions.

# BCGcalc 1.3.3.9003 (2018-11-20)

- Update SuperFamily Tipuloidea
  - /extdata/Data_BCG_PacNW.xlsx
  - /extdata/TaxaMaster_Bug_BCG_PacNW_v1.xlsx

# BCGcalc 1.3.3.9002 (2018-11-19)

- /extdata/Data_BCG_PacNW.xlsx
  - Update Exclude column after QC with BioMonTools::markExcluded
    - Change 6 FALSE to TRUE
    - Change 1 TRUE to FALSE

# BCGcalc 1.3.3.9001 (2018-11-19)

- Update ReadMe for BioMonTools::metric.values. Issue \#41.

# BCGcalc 1.3.3 (2018-11-19)

- Update version have changes related to moving functions to the
  BioMonTools package.

# BCGcalc 1.3.2.9012 (2018-11-19)

- metric.values, move to another package, Issue \#40
  - Moved to separate package. \_
    <https://github.com/leppott/BioMonTools>
    - BioMonTools is for bioassessment and biomonitoring.
    - ContDataQC should stay focused on continuous data.  
  - Vignette
    - Updated each section with metric.values
    - BCGcalc_Map.rmd
    - vignette_BCGcalc.rmd
  - R/data.R
    - Keep example data since specific to BCG project
  - Remove
    - R/metric.values.R
  - Update function examples.
    - Add library(BioMonTools)
    - qc.checks.R
    - BCG.Metric.Membership.R
    - BCG.Level.Membership.R
    - BCG.Level.Assignment.R
- Update map colors, Issue \#35.
- BCG.Metric.Membership.R
  - Update details.
- BCG.Level.Assignment.R
  - Add don’t run to simple example for write.csv.

# BCGcalc 1.3.2.9011 (2018-11-15)

- rarify, move to another package, Issue \#40
  - Moved to separate package.  
    \_ <https://github.com/leppott/BioMonTools>
    - BioMonTools is for bioassessment and biomonitoring.
    - BCGcalc should stay focused on BCG models.
  - DESCRIPTION
    - Add Remote: leppott/BioMonTools
    - Remove Jon van Sickles as contributor since removed rarify
      function.
  - Vignette
    - rarify section updated.
  - R/data.R
    - Remove reference to data_bio2rarify
  - Remove
    - R/rarify.R
    - data-raw/ProcessData_rarify.R
    - data-raw/ 3 data files
    - data/data_bio2rarify.rda

# BCGcalc 1.3.2.9010 (2018-11-07)

- Metric calculations, additional metrics.
  - metric.values.R
    - nt_Ephemerellidae
    - nt_Heptageniidae
    - nt_Nemouridae
    - nt_Perlidae
    - nt_Rhyacophila
    - nt_Tipulidae
  - MetricNames.xlsx
- Fix error with habit metric names.
  - metric.values.R
  - MetricNames.xlsx

# BCGcalc 1.3.2.9009 (2018-10-23)

- Metric calculation;
  - x_HBI. Issue \#37
    - calculation use TOLVAL\>=0 rather than TOLVAL\>0 in denominator.
  - Consistent naming. Issue \#38
    - habit_clmbrs to habit_climb
    - habit_clngrs to habit_cling
    - habit_swmmrs to habit_swim

# BCGcalc 1.3.2.9008 (2018-10-22)

- Metric calculation;
  - Tolerance metrics
    - nt_tv_intol
    - nt_tv_toler
    - pt_tv_intol
    - pt_tv_toler
    - Added lower and upper limits for intol and toler

# BCGcalc 1.3.2.9007 (2018-10-22)

- Metric calculation;
  - pi_Colesen
    - Change is.na(FAMILY) from FALSE to TRUE.

# BCGcalc 1.3.2.9006 (2018-10-22)

- Metric calculation;
  - pi_Hydro
    - Equal sign missing in equation (“=” instead of “==”).

# BCGcalc 1.3.2.9005 (2018-10-22)

- Metric calculation;
  - pi_Tanyp
    - Misspelled Tanypodinae

# BCGcalc 1.3.2.9004 (2018-10-22)

- Metric calculations;
  - x_HBI
    - Remove negative sign. Issue \#37
  - x_Shan_e, x_Shan_2, x_Shan_10
    - Fix equation. Not properly calculating proportions.
    - Drop use of x_Shan_Num. Use x_Shan_e then convert for other log
      bases.
  - x_D
    - Fix equation.

# BCGcalc 1.3.2.9003 (2018-10-22)

- Fix metric calculation; na.rm=TRUE for sum. Issue \#37
  - x_HBI \_ If had any NA values for TolVal the final value was NA.
    - Added na.rm=TRUE to sum function for numerator.
    - Denominator already included na.rm=TRUE.
  - x_D
    - No effect as no records should be NA for count
  - dominant calculation intermediate columns
    - No effect as no records should be NA for count
  - ni_total
    - No effect as no records should be NA for count
  - All fish metrics (with “sum”)

# BCGcalc 1.3.2.9002 (2018-10-12)

- Add 8 additional metrics to metric.values
  - MS DEQ, MBISQ 2015 \_ pi_Hydro
    - nt_NonIns
    - pt_NonIns
    - pi_Tanyp
    - pt_tv_intol
    - pt_tv_toler  
    - pi_Colesens
    - pi_COC2Chi

# BCGcalc 1.3.2.9001 (2018-10-12)

- Mapping Vignette. Issue \#34.
  - DESCRIPTION
    - Add ggplot2 to Suggests
  - extdata\_BCG_PacNW.xlsx
    - Add Latitude, Longitude, and COMID
  - Create Vignette for mapping

# BCGcalc 1.3.2 (2018-10-11)

- Release version.

# BCGcalc 1.3.1.9001 (2018-10-11)

- Master Taxa List
  - Turbellaria BCG Attribute.
    - Change from “x” to “4” to match its synonym Trepaxonemata.

# BCGcalc 1.3.1 (2018-10-10)

- Release version.

# BCGcalc 1.3.0.9001 (2018-10-10)

- Rules.xlsx
  - Fix typos in “Numeric_Rules” field.
    - No impact on calculations.

# BCGcalc 1.3.0 (2018-10-09)

- Release version.

# BCGcalc 1.2.2.9033 (2018-10-09)

- Update Vignette.
  - Rarify section to 600.

# BCGcalc 1.2.2.9032 (2018-10-09)

- Update Vignette.
  - Fix a few typos.

# BCGcalc 1.2.2.9031 (2018-10-09)

- Update Rules.xlsx.
  - 300 count model edits.

# BCGcalc 1.2.2.9030 (2018-10-09)

- Vignette updates.

# BCGcalc 1.2.2.9029 (2018-10-05)

- Updated rarify data; data_bio2rarify
  - Replace fully qualified 500 count data with 3 column 600 count.
  - Update data.R entry.
  - Update rarify function example.
  - Update vignette example.

# BCGcalc 1.2.2.9028 (2018-10-05)

- Updated docs.
  - extdata/ExampleDataFile.xlsx
  - docs/BCGcalc_README_20180919.pdf

# BCGcalc 1.2.2.9027 (2018-10-05)

- Updated Rules.xlsx file in extdata.

# BCGcalc 1.2.2.9026 (2018-09-28)

- Finish updates to Vignette.

# BCGcalc 1.2.2.9025 (2018-09-28)

- Level.Assignment. Issue \#11
  - Update example so don’t calculate metrics twice.

# BCGcalc 1.2.2.9024 (2018-09-28)

- Vignette updates (incomplete).
- Metric.Membership. Issue \#11
  - Non numeric extra columns caused errors. Fixed.

# BCGcalc 1.2.2.9023 (2018-09-27)

- extdata
  - TaxaMaster_Bug_BCG_PacNW_v1.xlsx; rename worksheet to match previous
    version.
- data-raw
  - Remove data_bio2rarify.txt
  - Recreate TaxaMaster_Ben_BCG_PacNW using revised XLSX file.
  - Update 500count.tsv thermal column name.
- data.R
  - Update entries for TaxaMaster_Ben_BCG_PacNW and data_bio2rarify
- Vignette
  - Start on updates.

# BCGcalc 1.2.2.9022 (2018-09-27)

- Update Data_BCG_PacNW.xlsx. Issue \#32
  - Remove unnecessary worksheets.
  - Rename single remaining worksheet.
  - Update phylogenetic columns.
  - Rearrange columns into required and optional.
- Add master taxa list file to external docs.
- Add thermal indicators file to external docs.

# BCGcalc 1.2.2.9021 (2018-09-27)

- update ReadMe. Issue \#31

# BCGcalc 1.2.2.9020 (2018-09-27)

- Ensure reshape2 package references are consistent. Issue \#30
  - Ensure functions use reshape2::melt (or dcast)
  - Ensure examples (and vignette) use library(reshape) and melt or
    dcast.

# BCGcalc 1.2.2.9019 (2018-09-26)

- File formats. Issue \#28
  - Add statement about file formats to Vignette.

# BCGcalc 1.2.2.9018 (2018-09-26)

- rarify data. Issue \#19
  - Use USGS 500 to 300 count data instead of MS 200 count.
  - Change raw data process script.
  - Replace data_bio2rarify.
  - Modify rarify example.
  - Modified rarify example in Vignette.

# BCGcalc 1.2.2.9017 (2018-09-26)

- BCG PacNW primer. Issue \#29
  - BCGcalc_README_20180918.pdf to so shows up in package help.
- MetricFlags.xlsx
  - Last line, Index_Name updated for 300 count model.

# BCGcalc 1.2.2.9016 (2018-09-26)

- Example “write” statements as “dontrun”. Issue \#27
  - BCG.Level.Assignment; also moved write statement to end
  - BCG.Level.Membership
  - BCG.Metric.Membership
  - metric.values; included write and DataExplorer
  - qc.checks; no write statement.
  - rarify; Changed from commented out to donotrun
  - Vignette; leave “as is”. Write statements all commented out.
- BCG.Level.Assignment
  - Change write.table(tsv) to write.csv. Issue \#28

# BCGcalc 1.2.2.9015 (2018-09-26)

- extdata.xlsx. Issue \#26
  - Added NOTES worksheet.
  - Added MetricMetadata from MetricNames.xlsx.
  - Added NOTES worksheet to MetricNames.xlsx.
  - Renamed worksheet “BCG_PacNW_2018” to “BCG_PacNW_v1_500ct”.
  - Renamed Index_Name from “BCG_PacNW_2018” to “BCG_PacNW_v1_500ct”.
  - Added worksheet “BCG_PacNW_v1_300ct”.
- Revised code references to Rules.xlsx (worksheet and Index_Name).
  Mostly examples.
- extdata\_BCG_PacNW.xlsx
  - Renamed Index_Name from “BCG_PacNW_2018” to “BCG_PacNW_v1_500ct”.
- extdata.xlsx
  - Renamed Index_Name from “BCG_PacNW_2018” to “BCG_PacNW_v1_500ct”.
  - Added Index_Name “BCG_PacNW_v1_300ct”. Adjust some flags based on
    500 vs. 300 count.

# BCGcalc 1.2.2.9014 (2018-09-25)

- qc.checks. Issue \#25.
  - Update Description.
  - Add View for imported checks file.
  - Vignette. Change section title from QC Checks to Flags.
  - Update Level Assignment example in Vignette with real data and
    append flags.

# BCGcalc 1.2.2.9013 (2018-09-25)

- Function rarify. Issue \#19
  - Remove keywords.

# BCGcalc 1.2.2.9012 (2018-09-25)

- Function rafify. Issue \#19
  - Fix typo in @param mySeed. Remove extra period.

# BCGcalc 1.2.2.9011 (2018-09-20)

- Metric Names metadata Issue \#18
  - Update extdata.xlsx
  - Add PDF version to docs.

# BCGcalc 1.2.2.9010 (2018-09-20)

- More Indiana files. Issue \#24
  - extdata\_IN_BCG_Bugs_20170203.xlsm
  - extdata\_Metrics_Bugs_IN.xlsx

# BCGcalc 1.2.2.9009 (2018-09-20)

- Remove Indiana references. Issue \#24.
  - Delete extdata Indiana file (Data_BCG_Indiana.xlsx).
  - Delete data-raw Indiana database (BCG_Model_Calc (IN 20170301).mdb.
    Already excluded from package build.
  - Delete example in metric.values function.

# BCGcalc 1.2.2.9008 (2018-09-12)

- DESCRIPTION
  - Add date.
  - Add Jen Stamp as contributor
- Citation still gives error but is more complete now. Issue \#23

# BCGcalc 1.2.2.9007 (2018-09-07)

- metric.values
  - Fixed included metrics (fun.MetricNames)

# BCGcalc 1.2.2.9006 (2018-09-07)

- metric.values
  - Added QC check for NonTarget==FALSE.  
  - Give a warning if have zero FALSE values.

# BCGcalc 1.2.2.9005 (2018-09-07)

- metric.values
  - Added QC check for Exclude==TRUE.  
  - Give a warning if have zero TRUE values.

# BCGcalc 1.2.2.9004 (2018-09-05)

- Update Vignette.
  - Add data munging example. Issue \#14
  - Update metric.values section for required fields. Issue \#13.
  - Added section demonstrating saving only select metrics. Issue \#15
- Update text in metric.values.

# BCGcalc 1.2.2.9003 (2018-09-04)

- metric.values. Issue \#16
  - Added QC worksheet to extdata\_BCG_PacNW.xlsx

# BCGcalc 1.2.2.9002 (2018-08-28)

- metric.values. Issue \#13
  - Add required fields (columns) to help file.
  - Add QC check in function. Prompt user to continue or stop.

# BCGcalc 1.2.2.9001 (2018-08-15)

- metric.values
  - Added metric Percent Baetis tricaudatus complex + Simuliidae
    individuals (pi_SimBtri). Issue \#16.

# BCGcalc 1.2.2 (2018-06-14)

- New release version.

# BCGcalc 1.2.1.9001 (2018-06-14)

- qc.checks.R
  - Modification to use metric names as lower case. Issue \#12.
  - Example table; useNA=“ifany”.

# BCGcalc 1.2.1 (2018-06-13)

- New release version.

# BCGcalc 1.2.0.9001 (2018-06-13)

- BCG.Level.Assignment.R
  - Membership QC (sum===1) add “round” 8 to avoid too many samples
    being flagged as “FAIL”.
  - Example changes:
  - Changed terminology from PASS/FAIL to NA/flag in flag fields.
  - Changed “NumFlagFAIL” to “NumFlags”.
  - Reordered columns so “NumFlags” is before the flag fields.

# BCGcalc 1.2.0 (2018-06-13)

- Release version for Pacific Northwest BCG workgroup with updated
  model.

# BCGcalc 1.1.0.9010 (2018-06-13)

- BCG.Level.Assignment.R
  - Example code to match up with qc.checks output.
  - Includes export to file.
- qc.checks.R
  - Remove example modifying column names.

# BCGcalc 1.1.0.9009 (2018-06-13)

- BCG.Level.Membership.R
  - Added “round” to 8 places when determining level membership.
  - Floating point error resulted in the occassional value of 1.1E-16
    when the previous level was “1”.
  - This resulted in the sample getting a split level assignment, e.g.,
    3:4 when it was 100% 3.

# BCGcalc 1.1.0.9008 (2018-06-13)

- metric.values.R
  - Add additional metrics
  - nt; BCG_att; 1i, 1m, 3
  - pt; BCG_att; 1i, 1m, 3
  - pi; BCG_att; 1i, 1m, 2, 3
  - thermal indicator metrics
  - modify grepl to == because COLD was matching COLD and COLD_COOL.
    Only want exact match.

# BCGcalc 1.1.0.9007 (2018-06-12)

- Update Rules.xlsx.
  - Level 3 (Hi and Lo), pi_BCG_att56 changed to pt_BCG_att1i23.
  - Change involved both direction and thresholds.

# BCGcalc 1.1.0.9006 (2018-06-12)

- Update metric.values.
  - Add “cols2keep” to allow for extra fields in output.
  - Need extra fields for qc.checks
- Update qc.checks.
  - Update example with cols2keep from metric.values example.

# BCGcalc 1.1.0.9005 (2018-06-11)

- Update bio data to be used for the model; Issue \#7
  - Collapse mites to Order.

# BCGcalc 1.1.0.9004 (2018-06-08)

- Update extdata/Rules.xlsx; Issue \#7

# BCGcalc 1.1.0.9003 (2018-06-08)

- metric.values dd nt, pi, and pt metrics; Issue \#7
  - NonIns_BCG_attr456
  - NonInsJugaRiss_BCG_attr456

# BCGcalc 1.1.0.9002 (2018-06-08)

- QC Flags, Add pi_dom02. Issue \#7
- Update format of NEWS.
- metric.values, row_number to dplyr::row_number for dominant metrics.

# BCGcalc 1.1.0.9001 (2018-06-08)

- metric.values, Issue \#7
  - Update metrics from NonClump to NoJugaRiss.

# BCGcalc 1.1.0.0000 (2018-03-19)

- Release new and fully QCed version.

# BCGcalc 1.0.0.9002 (2018-03-19)

- Metric.values
  - Fix metrics with *not equal* functions.
  - Ensure use is.na(x)==TRUE rather than x==NA
  - When have more than one condition for a data column need to be in
    the same statement.
  - Better define clumpy taxa for 2 metrics.
- BCG.Level.Membership
  - Fixed combination of rules by level. Missed a column and was getting
    duplicates for alt rules that changed the outcome.
- BCG.Level.Assignment
  - Replace For loop with apply.
  - Add special conditions for ties (2 levels with 0.5) and primary
    level is 1 (no 2nd level).

# BCGcalc 1.0.0.9001 (2018-03-18)

- Metric.values
  - Fix non-clumpy metrics.
  - Remove extra data frames for dominance metrics. Slight speed
    improvement. Issue \#5.
- Fix version numbers in NEWS.
- Updated ReadMe with only the relevant packages. Issue \#4.

# BCGcalc 1.0.0.0000 (2018-03-18)

- Only metric value issues left to resolve with test data set. Rest of
  the calculations are ok.

# BCGcalc 0.1.0.9019 (2018-03-18)

- Rules.xlsx
  - Fill in missing cells.
- metric.values.R
  - Update FFG abbreviations to match example data.
  - Dominant N and special Dominant N metrics.
  - Define pipe as referencing dplyr. Slows down the functions but keeps
    dplyr from needing to be loaded.
- SiteType values to lowercase.
  - metric.values.R
  - BCG.Metric.Membership.R
  - BCG.Level.Membership.R
  - BCG.Level.Assignment.R
- Consistent terminology; don’t mix “.”, ” “, and”*“. Use”*”.
  - METRIC_NAMES
  - METRIC_VALUES
  - SITE_TYPE (and change from REGION)
  - RULE_TYPE
  - NUMERIC_RULES
  - LIFE_CYCLE
  - LONG_LIVED
  - THERMAL_INDICATOR
  - NAME_WIDE
- Rebuild PacNW master taxa list with changes.
  - Consistent names (columns and categories).
- Example PacNW data.
  - Consistent names (columns).
- QC Checks
- Update Vignette.
- All functions and examples seem to be generating the proper outputs.
  When QC only a few metrics are off. But enough that no final results
  are correct (that is, all levels, site types, and samples are affected
  but the remaining QC issues). Non-Insect and modified dominant 2
  metrics are the 4 that have issues.

# BCGcalc 0.1.0.9018 (2018-03-17)

- BCG.Level.Membership.R
  - Correct function to consider preceding levels when assigning
    membership scores.

# BCGcalc 0.1.0.9017 (2018-03-16)

- metric.values.R
  - Added Thermal Indicator (TI) metrics.
- Updates to PacNW bug data and rules files (xlsx).

# BCGcalc 0.1.0.9016 (2018-03-16)

- metric.values.R
  - Update pt_BCG_att1i2 and 1i23 metrics (numerator not capturing “i”
    taxa).
- Update Rules.xlsx

# BCGcalc 0.1.0.9015 (2018-03-16)

- Vignette didn’t update in previous version.

# BCGcalc 0.1.0.9014 (2018-03-15)

- Tweak “data.R”. Not complete!
  - Added example save code for master taxa list.
- Update BCG.Metric.Membership.
  - Add some error checking.
  - Colnames to upper case.
- Updated Rules.xlsx
  - Percent metrics converted to 0-1 values to match metric.values
    calculations.
  - Fixed Index Name for some records.
- metric.values.R
  - Updated examples, details, and description.
- Update BCGcalc Vignette.
- Update Readme.
- Update BCG.Level.Membership

# BCGcalc 0.1.0.9013 (2018-03-14)

- Added PacNW benthic master taxa list to data.
- Created “data.R”. Not complete!

# BCGcalc 0.1.0.9012 (2018-03-08)

- Update PacNW example data to use TRUE/FALSE for Excluded and NonTarget
  fields.
- Updated metric.values
  - Moved common data munging to earlier in function so applies to all
    communities.
  - Enabled NonTarget exclusion. NonTarget column now required.

# BCGcalc 0.1.0.9011 (2018-03-08)

- Completed lingering edits for “Tier” to “Level”.
- Completed BCG.Level.Membership function.

# BCGcalc 0.1.0.9010 (2018-03-07)

- Remove “Tier” wording in package and rename some functions to better
  reflect usage.
- Include example code for saving results for each function.
- Change Region to SiteType in code and example data files.

# BCGcalc 0.1.0.9009 (2018-03-05)

- Dom02 special metric placeholder.
- Update Rule table for Level assignments.
- BCG.Levels function.
- Fixed error in sequencing in BCG.Membership function.

# BCGcalc 0.1.0.9008 (2018-03-05)

- Add last of the PacNW specific metrics to metric.values.
- Added Vignette.

# BCGcalc 0.1.0.9007 (2018-03-05)

- Check clean up.
- Convert data imports from development folder to pacakge folder with
  system.file.
- Add data for rarify function.

# BCGcalc 0.1.0.9006 (2018-03-04)

- BCG.Tiers function.

# BCGcalc 0.1.0.9005 (2018-03-04)

- Add BCG.Membership function. Return is in long format.
  - Not QCed but has some known issues.

# BCGcalc 0.1.0.9004 (2018-03-03)

- Add subtitles, date, author to YAML header to NEWS and README.
- Add “flags” Excel file to raw-data for QC checks. Used in qc.checks
  function (new).
- Added 4 new ni metrics to metric values to be used for QC checks
  (flags).
- qc.checks.R (incomplete but works).
- Add BCGcalc.R to describe the package.
- Update documentation headers in R files.

# BCGcalc 0.1.0.9003 (2018-02-20)

- metric.values.R, benthos
  - Added BCG attribute metrics.
  - Added outlining for readability in code.
  - More metrics and clean up of file.
  - Prepare example data for metric calculation.
  - Added na.rm=TRUE to n_distinct and sum in summarise.

## Changes in Version 0.1.0.9002 (2018-02-16)

- Add parts without any modification from `MBSStools` package.
  - rarify function
  - metric.values function
  - included data folder and files
  - added Excel file to extdata with metric naming explanation

# BCGcalc 0.1.0.9001 (2018-02-16)

- Updated files for package.
  - Readme, NEWS, DESCRIPTION
  - Not complete.

# BCGcalc 0.1.0 (2018-02-16)

- Created GitHub repository
