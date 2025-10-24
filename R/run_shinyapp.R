#' @export
run_shinyapp <- function() {
  app_dir <- system.file("shiny", package = "GoldinGroundOz")
  shiny::runApp(app_dir, display.mode = "normal")
}
