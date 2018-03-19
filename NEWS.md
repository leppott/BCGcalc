BCGcalc-NEWS
================
<Erik.Leppo@tetratech.com>
2018-03-18 21:16:35

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->

    #> Last Update: 2018-03-18 21:16:35

# Future Possibile Features (Wish List)

  - Add excluded taxa flag to samples based on levels of taxonomy. Will
    not be completely accurate. Will have many false positives and false
    negatives. That is, if there are only organisms at the higher level
    in a sample it will fail. And if there are no organisms of the
    target group it will pass.
    
      - Pass, Fail on each. And overall flag
      - Chiro (tribe and family)
      - Oligo
      - trombidiformes

  - Flags, would prefer to have flags attached to final Level
    assignments.

  - Hi/Lo models.
    
      - ~~parameter to run “correct” model or all models for each
        site.~~
      - Have a field for site type. So can override gradient.

  - ~~Report - QC, use DataExplorer.~~

  - ~~Table of metrics for each model with DataExplorer report.~~

  - Include a master taxa list.
    
      - Match data input and add information (phylo and auteco)
      - Ability to report back unmatched

  - Generate SiteType from data (gradient for PacNW)

  - Update For loop in BCG.Level.Assignment to apply function (similar
    to BCG.Level.Membership).

# Version History

## v1.0.0.9001

2018-03-18

  - Metric.values
      - Fix non-clumpy metrics.
      - Remove extra data frames for dominance metrics. Slight speed
        improvement. Issue \#5.
  - Fix version numbers in NEWS.
  - Updated ReadMe with only the relevant packages. Issue \#4.

## v1.0.0.0000

2018-03-18

  - Only metric value issues left to resolve with test data set. Rest of
    the calculations are ok.

## v0.1.0.9019

2018-03-18

  - Rules.xlsx
      - Fill in missing cells.
  - metric.values.R
      - Update FFG abbreviations to match example data.
      - Dominant N and special Dominant N metrics.
      - Define pipe as referncing dplyr. Slows down the functions but
        keeps dplyr from needing to be loaded.
  - SiteType values to lowercase.
      - metric.values.R
      - BCG.Metric.Membership.R
      - BCG.Level.Membership.R
      - BCG.Level.Assignment.R
  - Consistent terminology; don’t mix “.”, " “, and”*“. Use”*“.
      - METRIC\_NAMES
      - METRIC\_VALUES
      - SITE\_TYPE (and change from REGION)
      - RULE\_TYPE
      - NUMERIC\_RULES
      - LIFE\_CYCLE
      - LONG\_LIVED
      - THERMAL\_INDICATOR
      - NAME\_WIDE
  - Rebuild PacNW master taxa list with changes.
      - Consistent names (columns and categories).
  - Example PacNW data.
      - Consistent names (columns).
  - QC Checks
  - Update Vignette.
  - All functions and examples seem to be generating the proper outputs.
    When QC only a few metrics are off. But enough that no final results
    are correct (that is, all levels, site types, and samples are
    affected but the remaning QC issues). Non-Insect and modified
    dominant 2 metrics are the 4 that have issues.

## v0.1.0.9018

2018-03-17

  - BCG.Level.Membership.R
      - Correct function to consider preceeding levels when assigning
        membership scores.

## v0.1.0.9017

2018-03-16

  - metric.values.R
      - Added Thermal Indicator (TI) metrics.
  - Updates to PacNW bug data and rules files (xlsx).

## v0.1.0.9016

2018-03-16

  - metric.values.R
      - Update pt\_BCG\_att1i2 and 1i23 metrics (numerator not capturing
        “i” taxa).
  - Update Rules.xlsx

## v0.1.0.9015

2018-03-16

  - Vignette didn’t update in previous version.

## v0.1.0.9014

2018-03-15

  - Tweak “data.R”. Not complete\!
      - Added example save code for master taxa list.
  - Update BCG.Metric.Membership.
      - Add some error checking.
      - Colnames to upper case.
  - Updated Rules.xlsx
      - Percent metrics convered to 0-1 values to match metric.values
        calculations.
      - Fixed Index Name for some records.
  - metric.values.R
      - Updated examples, details, and description.
  - Update BCGcalc Vignette.
  - Update Readme.
  - Update BCG.Level.Membership

## v0.1.0.9013

2018-03-14

  - Added PacNW benthic master taxa list to data.
  - Created “data.R”. Not complete\!

## v0.1.0.9012

2018-03-08

  - Update PacNW example data to use TRUE/FALSE for Excluded and
    NonTarget fields.
  - Updated metric.values
      - Moved common data munging to earlier in function so applies to
        all communities.
      - Enabled NonTarget exclusion. NonTarget column now required.

## v0.1.0.9011

2018-03-08

  - Completed lingering edits for “Tier” to “Level”.
  - Completed BCG.Level.Membership function.

## v0.1.0.9010

2018-03-07

  - Remove “Tier” wording in package and rename some functions to better
    reflect usage.
  - Include example code for saving results for each function.
  - Change Region to SiteType in code and example data files.

## v0.1.0.9009

2018-03-05

  - Dom02 special metric placeholder.
  - Update Rule table for Level assignments.
  - BCG.Levels function.
  - Fixed error in sequencing in BCG.Membership function.

## v0.1.0.9008

2018-03-05

  - Add last of the PacNW specific metrics to metric.values.
  - Added Vignette.

## v0.1.0.9007

2018-03-05

  - Check clean up.
  - Convert data imports from development folder to pacakge folder with
    system.file.
  - Add data for rarify function.

## v0.1.0.9006

2018-03-04

  - BCG.Tiers function.

## v0.1.0.9005

2018-03-04

  - Add BCG.Membership function. Return is in long format.
      - Not QCed but has some known issues.

## v0.1.0.9004

2018-03-03

  - Add subtitles, date, author to YAML header to NEWS and README.
  - Add “flags” Excel file to raw-data for QC checks. Used in qc.checks
    function (new).
  - Added 4 new ni metrics to metric values to be used for QC checks
    (flags).
  - qc.checks.R (incomplete but works).
  - Add BCGcalc.R to describe the package.
  - Update documentation headers in R files.

## v0.1.0.9003

2018-02-20

  - metric.values.R, benthos
      - Added BCG attribute metrics.
      - Added outlining for readability in code.
      - More metrics and clean up of file.
      - Prepare example data for metric calculation.
      - Added na.rm=TRUE to n\_distinct and sum in summarise.

## v0.1.0.9002

2018-02-16

  - Add parts without any modification from `MBSStools` package.
      - rarify function
      - metric.values function
      - included data folder and files
      - added Excel file to extdata with metric naming explanation

## v0.1.0.9001

2018-02-16

  - Updated files for package.
      - Readme, NEWS, DESCRIPTION
      - Not complete.

## v0.1.0

2018-02-16

  - Created GitHub repository
