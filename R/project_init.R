#' Create the project directory structure
#'
#' This function creates the project folder structure described in the documentation.
#'
#' @param base_dir The base directory where the project structure should be created.
#'                 The default is the current working directory.
#'
#' @return The function creates the project structure and does not return any value.
#'
#' @examples
#' \dontrun{
#' # To create the project structure in the current working directory:
#' project_init()
#'
#' # To create the project structure in a specific directory:
#' project_init("/path/to/your/directory")
#'
#' # The directory structure will be created in the specified directory.
#' }
#'
#' @export
project_init <- function(base_dir = getwd()) {
  # Define the folder structure
  folders <- c(
    "data_processed",
    "data_processed/species_data",
    "data_raw",
    "models",
    "results",
    "results/plots",
    "results/plots/occurrence_map",
    "results/plots/binary_map",
    "results/plots/range_map_ori",
    "results/plots/range_map_modified",
    "results/tables",
    "results/gis",
    "results/gis/range_map_ori",
    "results/gis/range_map_modified",
    "scripts"
  )

  # Create the folders in the specified base directory
  for (folder in folders) {
    dir.create(file.path(base_dir, folder), showWarnings = FALSE, recursive = TRUE)
  }

}
