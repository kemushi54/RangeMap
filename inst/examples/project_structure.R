#' Project Folder Structure
#'
#' This package follows the following project folder structure as default:
#'
#' - "data_processed": Processed data files.
#' - "data_raw": Raw data files.
#' - "models": Model-related files.
#' - "results": Results and outputs.
#'   - "plots": Plot files.
#'     - "binary_map": 11 Binary map plots.
#'     - "range_map_ori": Original range map plots.
#'     - "range_map_modified": Modified range map plots.
#'   - "tables": Data tables and related files.
#'   - "gis": GIS-related files.
#'     - "range_map_ori": Original range map GIS files.
#'     - "range_map_modified": Range map GIS files modified by expert.
#' - "scripts": Project scripts.
#'
#' This folder structure is created when the project is initialized. Users can use
#' the \code{\link{project_init}} function provided by this package to set up
#' the project structure in their working directory.
#'
#' @examples
#' \dontrun{
#' # Access directories within the package structure
#' data_processed_dir <- system.file("data_processed", package = "RangeMap")
#' data_raw_dir <- system.file("data_raw", package = "RangeMap")
#' models_dir <- system.file("models", package = "RangeMap")
#' results_dir <- system.file("results", package = "RangeMap")
#' plots_dir <- system.file("results/plots", package = "RangeMap")
#' binary_map_dir <- system.file("results/plots/binary_map", package = "RangeMap")
#' range_map_ori_dir <- system.file("results/plots/range_map_ori", package = "RangeMap")
#' range_map_modified_dir <- system.file("results/plots/range_map_modified", package = "RangeMap")
#' tables_dir <- system.file("results/tables", package = "RangeMap")
#' gis_dir <- system.file("results/gis", package = "RangeMap")
#' range_map_ori_gis_dir <- system.file("results/gis/range_map_ori", package = "RangeMap")
#' range_map_modified_gis_dir <- system.file("results/gis/range_map_modified", package = "RangeMap")
#'
#' # Use these directories in your package functions
#'
#' }
#'
#' @seealso
#' \code{\link{project_init}}: Function to create the project structure.
#'
#' @export
NULL
