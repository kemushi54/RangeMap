#' Generate Species Data and Export .geojson Files
#'
#' This function takes species occurrence data in data.frame or data.table format
#' and exports a .geojson file for each species. The .geojson files are saved in
#' the "species_data" directory under the "data_processed" folder as defult.
#'
#' @param sp_data Species occurrence data in data.frame or data.table format.
#' @param species_name Name of the species to be used in the file name.
#' @param coord A vector containing the column names of coordinates in the data.
#'              The default is c("longitude", "latitude").
#' @param crs The EPSG code of coordinate reference system (CRS) of the data, specified as
#'            a numeric vector. The default is 4326.
#' @param path the folder path store the .geojson file.
#'
#' @import sf
#' @import magrittr
#'
#' @return This function generates .geojson files for each species and does not
#' return any value.
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' data <- data.frame(
#'   longitude = c(120.27, 120.15, 121.19),
#'   latitude = c(23.22, 24.10, 23.59),
#'   other_column = c("A", "B", "C")
#' )
#' generate_species_data(sp_data = data, species_name = "Species_A")
#' }
#'
#' @export
generate_species_data <- function(sp_data,
                                  species_name,
                                  coord = c("longitude", "latitude"),
                                  crs_sp = 4326,
                                  path = "data_processed/species_data",
                                  ...){
  # Convert data to simple features (sf) using the specified CRS
  sp_data_sf <- st_as_sf(sp_data, coords = coord, crs = crs_sp)

  # Define the output file path
  output_path <- file.path(path, paste0(species_name, ".geojson"))

  # Export the sf data to a .geojson file
  st_write(sp_data_sf,
           dsn = output_path,
           driver = "GeoJSON",
           delete_dsn = TRUE,
           ...)

  # Print a message indicating the file has been generated
  cat("GeoJSON file for", species_name, "has been generated and saved to", output_path, "\n")

}
