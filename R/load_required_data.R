#' Load required data for the RangeMap package
#'
#' This function loads essential data files required for the RangeMap package.
#'
#' @examples
#' \dontrun{
#' # Load data files when loading the RangeMap package
#' load_required_data()
#' }
#'
#' @export
load_required_data <- function() {
  data_file <- system.file("data", "grid_1km.RData", package = "RangeMap")
  load(data_file)

  data_file <- system.file("data", "env.RData", package = "RangeMap")
  load(data_file)

  data_file <- system.file("data", "maxent_args.RData", package = "RangeMap")
  load(data_file)

  data_file <- system.file("data", "tw_main.RData", package = "RangeMap")
  load(data_file)
}
