#' @title run Shiny Example
#'
#' @description Launches Shiny app for BCGcalc package.
#'
#' @details The Shiny app based on the R package BCGcalc is included in
#' the R package. This function launches that app.
#'
#' The Shiny app is online at:
#' https://tetratech-wtr-wne.shinyapps.io/BCGcalc
#'
#' @param shinyappname Shiny appplication name, default = BCGcalc
#'
#' @examples
#' \dontrun{
#' # Run Function (full EMVL version, default)
#' runShiny()
#'
#' }
#
#' @export
runShiny <- function(shinyappname = "BCGcalc"){##FUNCTION.START
  #
  appDir <- system.file("shiny-examples"
                        , shinyappname
                        , package = "BCGcalc")
  #
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `BCGcalc`."
         , call. = FALSE)
  }
  #
  shiny::runApp(appDir, display.mode = "normal")
  #
}##FUNCTION.END
