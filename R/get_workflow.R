#' Save the example workflow R code to another location
#'
#' This function copies the example workflow R code from the package to a specified destination path.
#'
#' @param file_path The destination path where you want to copy the example code. The default is "scripts"
#' @param file_name The file name of script saved. The default is "workflow.R"
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' get_workflow(file_path = "scripts")
#' }
#'
#' @export
get_workflow <- function(file_path = "scripts",
                         file_name = "workflow.R") {
  file.copy(from = system.file("examples", "example_workflow.R", package = "RangeMap"),
            to = file.path(file_path, file_name))
}
