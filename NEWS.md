BCGcalc-NEWS
================
<Erik.Leppo@tetratech.com>
2018-03-08 11:52:10

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->

    #> Last Update: 2018-03-08 11:52:11

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
      - Will need to report back unmatched

  - Generate SiteType from data (gradient for PacNW)

# Version History

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
