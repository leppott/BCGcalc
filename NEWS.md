BCGcalc-NEWS
================
<Erik.Leppo@tetratech.com>
2024-02-27 12:12:52.808604

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->

    #> Last Update: 2024-02-27 12:12:52.880878

# BCGcalc 2.0.0.9140 (2024-02-27)

- feature: Add new template for new metrics, models, and rules
- fix: Update package documenation per roxygen2

# BCGcalc 2.0.0.9139 (2024-02-06)

- refactor: Shiny app file builder generate class parameters, Issue \#89
  - Add shinyalert for more than 500 records
  - `nhdplustools` and `StreamCatTools` timeout issues with too many
    records
- fix: Shiny app calculation of BioMonTools::metric.scores,
  leppott/BioMonTools#103
  - Affected BDI calculation, checked and no other instances
- fix: Update package documenation per roxygen2 (since 7.0.0)

# BCGcalc 2.0.0.9138 (2024-02-01)

- fix: Shiny app fuzzy model not working, change community reference
  - Also fixed thermal metrics for status message

# BCGcalc 2.0.0.9137 (2024-02-01)

- fix: Update naming scheme for BCG calculation in Shiny app, Issue \#87
  - Add “\_” prefix to Results.

# BCGcalc 2.0.0.9136 (2024-02-01)

- fix: Update naming scheme for BCG calculation in Shiny app, Issue \#87
- refactor: Update text on BCG calculation pop up in Shiny app, Issue
  \#88

# BCGcalc 2.0.0.9135 (2024-01-11)

- refactor: Update NM BCG, drop percent max ffg from L2 and L4 per
  documentation

# BCGcalc 2.0.0.9134 (2024-01-11)

- refactor: Update NM BCG Index_Name and Index_Class in Rules.xlsx

# BCGcalc 2.0.0.9133 (2024-01-09)

- fix: Add shiny::validate(msg) back to shiny alert for when no file
  uploaded
  - Avoid the app crashing by preventing rest of code from running
- refactor: update shiny alert message for upload to account for file
  upload not complete
- fix: Update order of conditional formatting for nt_ti_stenocold

# BCGcalc 2.0.0.9132 (2024-01-08)

- fix: Remove testing line in Report server code
  - Caused ShinyApps.io to crash trying to open Excel

# BCGcalc 2.0.0.9131 (2024-01-08)

- refactor: Update Report
  - Add conditional formatting for summary worksheet for data columns
    - MTTI
    - Thermal Metrics
  - Add error checking if thermal metrics not present

# BCGcalc 2.0.0.9130 (2024-01-02)

- docs: Add tag to roxygen chunk to allow for table in
  `BCG.Level.Membership`
- refactor: Update `BCG.Level.Membership` for new exception rules (NM
  bugs)
  - Added routines for Exception Rules Small2 and Small3
- refactor: Update Rules.xlsx (NM bugs)

# BCGcalc 2.0.0.9129 (2023-12-21)

- refactor: Modify Shiny single report
  - Properly filter for singe station for every worksheet
  - Modify freeze panes for summary wide
- refactor: Calculation community buttons to default to NA
  - calc_BCG
  - calc_thermalfuzzy
  - calc_thermalmetrics

# BCGcalc 2.0.0.9128 (2023-12-20)

- refactor: Modify Shiny single report
  - Add taxatrans table
  - Verify sorting of tables by user selections
  - Add summary color thresholds
  - Color summary color thresholds
  - Set column widths
  - update formulas on NOTES

# BCGcalc 2.0.0.9127 (2023-12-19)

- refactor: Modify Shiny single report
  - Zip file download

# BCGcalc 2.0.0.9126 (2023-12-07)

- fix: Update app BCG calculation for cases where have no flags

# BCGcalc 2.0.0.9125 (2023-12-06)

- fix: Update MN fish metric names (trout) to be more specific

# BCGcalc 2.0.0.9124 (2023-12-06)

- tests: Update tests for name changes in 2.0.0.9004
- fix: Update metric name in Rules.xlsx to match BioMonTools
  - pi_Trout to pi_trout

# BCGcalc 2.0.0.9123 (2023-12-01)

- fix: Modify taxatrans hack for noteworthy to only trigger if present

# BCGcalc 2.0.0.9122 (2023-12-01)

- refactor: BCG calculation user column select to lower case
  - elev_m
  - pslope_nhd
- refactor: Rename BCG calculation flag output (previously model
  experience)

# BCGcalc 2.0.0.9121 (2023-11-30)

- feature: Add ecoregion L3 to generate index class parameters

# BCGcalc 2.0.0.9120 (2023-11-30)

- refactor: Modify QC check on BCG model experience to BCG calculate
  - Change text on pop-up
  - Modify structure of output file
  - Add checks for slope and elevation
- refactor: Result files remove leading “\_”

# BCGcalc 2.0.0.9119 (2023-11-29)

- fix: Modify QC check on BCG model experience to BCG calculate
  - total flags

# BCGcalc 2.0.0.9118 (2023-11-29)

- refactor: Modify QC check on BCG model experience to BCG calculate

# BCGcalc 2.0.0.9117 (2023-11-29)

- feature: Add QC check on BCG model experience to BCG calculate
- fix: Comment out all other instances of validate(msg) to avoid
  potential issues

# BCGcalc 2.0.0.9116 (2023-11-28)

- fix: File builder taxa translate remove validate statement from pop up
  - Was causing the server to pause and not continue

# BCGcalc 2.0.0.9115 (2023-11-21)

- feature: Add pop-up for taxa translate with mismatch taxa

# BCGcalc 2.0.0.9114 (2023-11-21)

- refactor: Modify output file names
  - Shorten names by dropping user input file name
- style: Add package names to a functions, Global.R
  - write_disk was missing httr:: prefix

# BCGcalc 2.0.0.9113 (2023-11-20)

- refactor: Add MN BCG Fish rules, Rules.xlsx

# BCGcalc 2.0.0.9112 (2023-11-13)

- feature: Added single site report
  - Formatting incomplete but function working in Shiny

# BCGcalc 2.0.0.9111 (2023-11-06)

- fix: Change order of operations to allow multiple uses of single
  import
  - For example, taxa translate now generates only the current results
- refactor: Create helper functions for re-used code
  - clean_results
  - copy_import_file

# BCGcalc 2.0.0.9110 (2023-11-04)

- fix: Create workaround for Generate Class Param
  - If reused an output as input duplicate fields are created
  - Then crashes when tries to join results
  - Rename existing fields as \_OLD

# BCGcalc 2.0.0.9109 (2023-11-04)

- fix: Updates TaxaTranslate file output (names and folders)

# BCGcalc 2.0.0.9108 (2023-11-03)

- refactor: Updates to Shiny interface

# BCGcalc 2.0.0.9107 (2023-11-03)

- refactor: Implement result folder changes
- refactor: Add subfolder for user import file
- refactor: Implement changes for new source files in taxa translator
- refactor: Implement file name changes

# BCGcalc 2.0.0.9106 (2023-10-31)

- refactor: Implement result file name changes using global
  abbreviations

# BCGcalc 2.0.0.9105 (2023-10-31)

- refactor: Remove toner lite base layer from Shiny maps
  - no longer supporter after 2023-10-31
- refactor: Sidebar menu updates
  - Label calculations as ‘Draft’ (non-BCG)
  - Tweak ‘Taxa Translate’ language
- refactor: Update Shiny map clustering options
- refactor: Reports to only multi and single
- refactor: Add result file and folder abbreviations to global

# BCGcalc 2.0.0.9104 (2023-10-27)

- feature: Add report to Shiny
  - Still under construction
- refactor: Update Shiny import to remove empty directories as well as
  files
  - Change from `file.remove` to `unlink`
- docs: Add openxlsx to DESCRIPTION for report creation in Shiny

# BCGcalc 2.0.0.9103 (2023-10-20)

- fix: Shiny, taxatrans_late_0filesversion.csv, swap 2 columns

# BCGcalc 2.0.0.9102 (2023-10-17)

- refactor: Leaflet map Fuzzy Thermal changes
  - Create multiple TIEs for legend so don’t count as NA
    - TIE_A_B same as TIE_B_A
  - Remove Continuous_Thermal as a required field
    - Was used for size but size no longer being used

# BCGcalc 2.0.0.9101 (2023-10-03)

- refactor: For leaflet map change to addCircleMarkers
  - Replaced addCircles

# BCGcalc 2.0.0.9100 (2023-10-02)

- fix: Change leaflet map proxy to redraw legend
  - Prevents thermal metric legends from having multiple on screen
- refactor: Add “DRAFT” to BDI

# BCGcalc 2.0.0.9099 (2023-09-29)

- refactor: Remove base layers too large to use
  - NorWeST
  - NHD+ catchment
  - NDD+ flowlines
- fix: Change Fuzzy Thermal legend
  - Move first ties up 1 slot each
  - Change legend colors
- refactor: Change jitter on map from jitter function to custom
  - jitter didn’t always work with large data sets

# BCGcalc 2.0.0.9098 (2023-09-28)

- feat: Update Shiny map
  - Add Imagery as baselayer to Shiny map
  - Add legend title variable to Shiny map legend
  - Add jitter to map plot to avoid overlap of multiple samples per
    location
  - Change legend and colors
    - BDI
    - BCG
    - MTTI
    - Thermal Metrics

# BCGcalc 2.0.0.9097 (2023-09-27)

- refactor: Add download links to KMZ files
- refactor: Update map legends coding, Issue \#67

# BCGcalc 2.0.0.9096 (2023-09-26)

- feature: Add KMZ downloads to Shiny app
  - NorWeST_ORWA
  - PNMR_BCGclasses
- feature: Updated maps in Shiny, Issue \#67

# BCGcalc 2.0.0.9095 (2023-09-07)

- feat: Add example script for MTTI

# BCGcalc 2.0.0.9094 (2023-09-07)

- feat: Add example data for MTTI to external folder

# BCGcalc 2.0.0.9093 (2023-08-29)

- feat: Add maps for each index, Issue \#67

# BCGcalc 2.0.0.9092 (2023-08-25)

- fix: BDI, if no Index_Class was not adding proper variable name, Issue
  \#66
  - Caused samples to not be scored

# BCGcalc 2.0.0.9091 (2023-08-25)

- fix: Typo on “Covert OTU” on MTTI and BDI shiny tabs
- refactor: Adjust Excl taxa triggers and QC in code, Issue \#66

# BCGcalc 2.0.0.9090 (2023-08-24)

- fix: Removed browser() statement from QC of last update, Issue \#84

# BCGcalc 2.0.0.9089 (2023-08-24)

- feature: Automate Index Name and Class for fuzzy set calculation,
  Issue \#84
  - Shiny

# BCGcalc 2.0.0.9088 (2023-08-17)

- feature: Add BDI calculation to Shiny, Issue \#66
  - COMPLETE
- refactor: Shiny required fields type for TRUE/FALSE changed text to
  logical

# BCGcalc 2.0.0.9087 (2023-07-13)

- refactor: Update MN BCG (bugs) in Rules.xlsx, Issue \#82

# BCGcalc 2.0.0.9086 (2023-07-12)

- refactor: Add MN BCG (bugs) to Rules.xlsx, Issue \#82

# BCGcalc 2.0.0.9085 (2023-07-11)

- refactor: Updates to BDI calculation, Issue \#66
  - INCOMPLETE, completed in 2.0.0.988

# BCGcalc 2.0.0.9084 (2023-06-19)

- fix: Update complex number import code (BCG_ATTR), Issue \#77
  - Should work in all cases and not cause issues with other fields
- feature: Enable BDI calculation in Shiny app, Issue \#66
  - PARTIAL

# BCGcalc 2.0.0.9083 (2023-06-13)

- refactor: Modify code for import and merge files, Issue \#77
  - Only specify BCG_ATTR column
  - Undoes some edits in v2.0.0.9081
- fix: Adjust import function to allow for user selection of tab or
  comma
  - Comma was hard coded even though gave user the choice of separators

# BCGcalc 2.0.0.9082 (2023-06-12)

- refactor: Updates to Shiny map, Issue \#67
  - INCOMPLETE
- refactor: Change taxa translator to no default

# BCGcalc 2.0.0.9081 (2023-06-08)

- fix: Modify code for complex number (BCG_ATTR), Issue \#77
  - Other logical fields could cause issues with older import method

# BCGcalc 2.0.0.9080 (2023-06-08)

- fix: Change links to files in Shiny from “" to”/”
- refactor: Update Index Class Parameter, Issue \#73
- refactor: Update to text for Fuzzy Set Input File, Issue \#70

# BCGcalc 2.0.0.9079 (2023-06-07)

- refactor: Update Index Class Parameter, Issue \#73

# BCGcalc 2.0.0.9079 (2023-06-07)

- refactor: Update Shiny Fuzzy Set

# BCGcalc 2.0.0.9078 (2023-06-07)

- feature: Add upset plot to MTTI results report
- docs: Add `ComplexUpset` to DESCRIPTION Suggests and Shiny global

# BCGcalc 2.0.0.9077 (2023-06-06)

- refactor: Update Shiny MTTI, Issue \#74
  - Onscreen text
  - Example files
- style: Move MTTI model file location

# BCGcalc 2.0.0.9076 (2023-06-06)

- fix: MetricFlags.xlsx ‘pctSLOPE’ to ‘pslope_nhd’
  - Align with index class assignment
  - Add PRECIP8110CAT for BCG_MariNW_Bugs500ct (all classes)
- refactor: Add more StreamCat variables to get index parameters, Issue
  \#75
  - PRECIP8110CAT
  - ICI
  - IWI

# BCGcalc 2.0.0.9075 (2023-06-06)

fix: Update MTTI routine for user SampleID, Issue \#74 + One instance
was hard-coded

# BCGcalc 2.0.0.9074 (2023-06-06)

refactor: Update MTTI output, Issue \#74

# BCGcalc 2.0.0.9073 (2023-06-06)

style: Code coverage updates

# BCGcalc 2.0.0.9072 (2023-06-05)

- refactor: Change order of columns for Fuzzy Thermal, Issue \#70
  - modtherm_5levassign.csv

# BCGcalc 2.0.0.9071 (2023-06-05)

- fix: Update overlapping Fuzzy Thermal CheckNames in MetricFlags.xlsx,
  Issue \#72

# BCGcalc 2.0.0.9070 (2023-06-05)

- refactor: Add columns and classifications to Fuzzy Thermal model,
  Issue \#70

# BCGcalc 2.0.0.9069 (2023-06-05)

- fix: MetricFlags.xlsx ‘pcSLOPE’ to ‘pctSLOPE’ (typo)
- fix: MetricFlags.xlsx ‘DrArea_mi2’ to ‘WSAREASQKM’ (and values)

# BCGcalc 2.0.0.9068 (2023-06-05)

- fix: Remove `browser` call in fuzzy thermal model

# BCGcalc 2.0.0.9067 (2023-06-05)

- refactor: Additional flags for fuzzy thermal model

# BCGcalc 2.0.0.9066 (2023-06-02)

- refactor: Updates to fuzzy thermal model output

# BCGcalc 2.0.0.9065 (2023-06-02)

- fix: BCG.Level.Membership account for less than 5 rules, Issue \#68
- fix: Update examples so don’t get duplicate columns kept in output
  - Can cause successive examples to fail
  - BCG.Metric.Membership
  - BCG.Level.Membership

# BCGcalc 2.0.0.9064 (2023-06-01)

- refactor: Error checking for missing variables, Shiny
  - Fuzzy Thermal Model
  - Index Class Param, Issue \#42

# BCGcalc 2.0.0.9063 (2023-06-01)

- refactor: Update Index Class Param onscreen help in Shiny, Issue \#42

# BCGcalc 2.0.0.9062 (2023-06-01)

- refactor: Shiny get Index Class Params, Issue \#42
  - Allow for user defined column
    - Default is NAD83 North America, EPSG = 4269
  - Trim output

# BCGcalc 2.0.0.9061 (2023-05-26)

- refactor: Update Shiny MTTI calculation and flags calculation and
  output

# BCGcalc 2.0.0.9060 (2023-05-26)

- refactor: Update Shiny MTTI calculation to include flags
- style: Modify some lines based on lintr suggestions
  - Add nolint to Shiny library calls

# BCGcalc 2.0.0.9059 (2023-05-23)

- fix: Update Shiny app import to better handle BCG_ATTR (complex)
  - Added exception for only integer values

# BCGcalc 2.0.0.9058 (2023-05-23)

- fix: Ensure all Shiny buttons use same terminology
  - b_calc_x
  - b_download_x

# BCGcalc 2.0.0.9057 (2023-05-23)

- fix: Update names of assign indec class buttons
  - calc and download
- style: Modify outlining in server.R
- refactor: Modify Shiny Generate Index Class Param
  - Add column names to match Shiny Assign Index Class
    - Allows user to upload file with no modifications

# BCGcalc 2.0.0.9056 (2023-05-23)

- docs: Update DESCRIPTION R \>= 2.1 to \>= 3.5.0 due to code dependency
  - Loading of MTTI model file in Shiny app
- refactor: Add data-raw Process Data script for nhdplusTools vaa file
  - Only VPUID 16, 17, and 18 for use with OR and WA.
  - Add fst package to Suggests in DESCRIPTION
  - Unable to upload full file to GitHub

# BCGcalc 2.0.0.9055 (2023-05-19)

- refactor: Shiny index class parameter generation, Issue \#42
- docs: Add packages used in Shiny app to DESCRTION Suggests
  - StreamCatTools
  - nhdplusTools

# BCGcalc 2.0.0.9054 (2023-05-19)

- fix: Shiny index class parameter generation, Issue \#42
- refactor: Shiny MTTI change language
  - ‘Pacific Northwest’ to ‘Oregon/Washington’
- fix: Change utils::zip to zip::zip in Shiny
  - Not working locally or on ShinyApps.io
- docs: Add zips to DESCRIPTION Suggests

# BCGcalc 2.0.0.9053 (2023-05-17)

- refactor: Update Shiny MTTI calculation (was placeholder)

# BCGcalc 2.0.0.9052 (2023-05-16)

- feat: Add Shiny tab for generating index class parameters, Issue \#42
  - Placeholder only

# BCGcalc 2.0.0.9051 (2023-03-20)

- refactor: Add map column select and base map, Issue \#67
  - Not complete

# BCGcalc 2.0.0.9050 (2023-03-17)

- feat: Add placeholder for map, Issue \#67

# BCGcalc 2.0.0.9049 (2023-03-17)

- fix: Remove example file link in fuzzy thermal about page
  - No fuzzy thermal examples
- feat: Add fuzzy thermal calculation and associated pages to Shiny,
  Issue \#65

# BCGcalc 2.0.0.9048 (2023-03-17)

- refactor: Add link for example scripts to fuzzy thermal about page

# BCGcalc 2.0.0.9047 (2023-02-10)

- docs: Update `BCG.Level.Assignment` example code
- refactor: Update example script (BCG calc)

# BCGcalc 2.0.0.9046 (2023-02-08)

- refactor: Create ‘process’ file in data-raw for creating zip file of
  examples for Shiny app (‘www’)
- refactor: Update example scripts
- refactor: Add link to download example zip file in Shiny app

# BCGcalc 2.0.0.9045 (2023-02-08)

- refactor: Create Shiny Merge Files Output tab

# BCGcalc 2.0.0.9044 (2023-02-08)

- refactor: Update Shiny output tabs

# BCGcalc 2.0.0.9043 (2023-02-07)

- refactor: Update taxa translate 0fileversion output
  - Shiny, server.R
  - example code, taxa translate

# BCGcalc 2.0.0.9042 (2023-02-07)

- feature: Add example scripts and data for Shiny File Builder functions
  - Taxa Translate
  - Assign Index_Class
  - Merge Files
- feature: Add Fuzzy Thermal narrative to Shiny operation

# BCGcalc 2.0.0.9041 (2023-02-03)

- refactor: Update Shiny onscreen text, inputs BCG calc
- refactor: Update Shiny onscreen text, inputs thermal metrics

# BCGcalc 2.0.0.9040 (2023-02-03)

- refactor: Update Shiny onscreen text, thermal preference metrics
  - Add metadata file to calculation thermal metrics results

# BCGcalc 2.0.0.9039 (2023-02-03)

- refactor: Update Shiny onscreen text, BCG calc

# BCGcalc 2.0.0.9038 (2023-02-03)

- docs: Update readme install section with quick code
- refactor: Update Shiny onscreen text, Assign Index_Class

# BCGcalc 2.0.0.9037 (2023-02-03)

- refactor: Update Shiny onscreen text, Merge Files

# BCGcalc 2.0.0.9036 (2023-02-03)

- refactor: Change Shiny merge files order (x and y)
  - Samples should be the main file (x) and keep all records and info

# BCGcalc 2.0.0.9035 (2023-02-02)

- refactor: Update Shiny app text

# BCGcalc 2.0.0.9034 (2023-02-02)

- refactor: Update Shiny to include change in BioMonTools package

# BCGcalc 2.0.0.9033 (2023-02-02)

- fix: Update file import routine
  - Account for multiple permutations of BCG_Attr
  - Add “” to na.strings

# BCGcalc 2.0.0.9032 (2023-01-31)

- fix: Adjust QC routine in Shiny app assign index class

# BCGcalc 2.0.0.9031 (2023-01-31)

- refactor: Finish updates to Shiny app merge files tab

# BCGcalc 2.0.0.9030 (2023-01-30)

- refactor: Add error checking for Index_Class in Shiny

# BCGcalc 2.0.0.9029 (2023-01-27)

- docs: Add Shiny link to README
- refactor: Layout changes to taxa translate section of Shiny app

# BCGcalc 2.0.0.9028 (2023-01-27)

- refactor: Add Shiny merge files tab placeholder
  - proof of concept, not complete

# BCGcalc 2.0.0.9027 (2023-01-24)

- refactor: Update onscreen text for Shiny assign index class

# BCGcalc 2.0.0.9026 (2023-01-23)

- refactor: Remove uneeded QC steps in Shiny assign_indexclass routine

# BCGcalc 2.0.0.9025 (2023-01-20)

- refactor: Add excluded taxa subroutine to thermal metrics in Shiny

# BCGcalc 2.0.0.9024 (2023-01-20)

- refactor: BioMonTools MetricNames.xlsx from GitHub instead of package
  in Shiny

# BCGcalc 2.0.0.9023 (2023-01-20)

- refactor: Add taxa translate unique crosswalk to output of
  taxatranslate in Shiny

# BCGcalc 2.0.0.9022 (2023-01-19)

- fix: Modify code in Shiny for `assign_indexclass` so won’t fail if
  field not provided.

# BCGcalc 2.0.0.9021 (2023-01-19)

- feature: Add thermal metric calculation to Shiny app

# BCGcalc 2.0.0.9020 (2023-01-16)

- feature: Add assign index class to Shiny
- refactor: Update Shiny tabs to not include numbered steps (all were
  step 2)
- fix: Update shiny taxa translate to combine duplicate taxa by default

# BCGcalc 2.0.0.9019 (2023-01-02)

- refactor: Update Shiny taxa trans to drop translator columns if have
  an attributes table

# BCGcalc 2.0.0.9018 (2023-01-02)

- refactor: Update Shiny taxa trans to use default names
  - SampleID, TaxaID, and N_Taxa

# BCGcalc 2.0.0.9017 (2022-12-23)

- refactor: Update Shiny taxa trans to include filenames in MERGED
  output

# BCGcalc 2.0.0.9016 (2022-12-23)

- refactor: Update Shiny, split file builder in to taxa trans and assign
  index class

# BCGcalc 2.0.0.9015 (2022-12-23)

- refactor: Update Shiny app MTTI tab

# BCGcalc 2.0.0.9014 (2022-12-20)

- refactor: Update Shiny app for taxaid_drop parameter in
  `BioMonTools::taxa_translate`

# BCGcalc 2.0.0.9013 (2022-12-15)

- refactor: Sort columns and order output of taxa translator

# BCGcalc 2.0.0.9012 (2022-12-15)

- feature: Add INDEX_NAME and INDEX_CLASS as input parameters to
  `BCG.Level.Assignment`

# BCGcalc 2.0.0.9011 (2022-12-15)

- refactor: Shiny app, filebuilder
  - save version of files in download
  - reorganize the required fields requested of user
  - change some text on screen

# BCGcalc 2.0.0.9010 (2022-12-14)

- refactor: Shiny app, filebuilder
  - Ensure consistency of BCGcalc and BioMonTools columns names (all
    caps)
  - Add about and output tabs to taxa translator
  - Update for consistency pick list file names in file and in code
  - Update routine for translating then adding attributes
    - Leave some projects with one file but add ability for two files
      (PacNW)

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
