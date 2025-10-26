#' Launch the GoldinGroundOz Shiny Application
#'
#' This function launches the interactive Shiny app included in the
#' **GoldinGroundOz** package. The app provides an interactive visualization
#' of Australia's simulated detached house prices, household disposable income,
#' and average capital gain rate changes over time.
#'
#' @details
#' The function locates the Shiny app directory within the package and runs it
#' using \code{shiny::runApp()}. The app will open in your default web browser
#' or the RStudio Viewer pane.
#'
#' @return
#' This function launches the app and does not return a value.
#'
#' @examples
#' \dontrun{
#' # Launch the interactive Shiny app
#' run_shinyapp()
#' }
#'
#' @export
run_shinyapp <- function() {
  app_dir <- system.file("shiny", package = "GoldinGroundOz")
  shiny::runApp(app_dir, display.mode = "normal")
}
