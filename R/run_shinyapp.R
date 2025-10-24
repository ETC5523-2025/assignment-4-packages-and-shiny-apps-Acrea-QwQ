#' @export
run_shinyapp <- function() {
  app_dir <- system.file("eda-app", package = "GoldinGroundOz")
  shiny::runApp(app_dir, display.mode = "normal")
}
