#' Turn coordinates of species occurrence to grid centroid, keeping all columns of species occurrence data
#'
#' @param occ_data A data.table of species occurrence data with coordinates.
#' @param coords_arg A vector of variable names of coordinates used in occ_data. Default is c("X", "Y").
#' @param occ_crs EPSG code of occ_data. Default is 4326.
#' @param grid_sf An sf object of small size grid layer.
#' @param grid_id_x Small size grid identifier used in grid_sf. Default is "GRIDID.x".
#' @param grid_id_y Large size grid identifier used in grid_sf. Default is "GRIDID.y".
#' @param grid_crs EPSG code of grid_sf. Default is 3826.
#'
#' @return A data.table including species taxon uuid, grid id, and grid centroid.
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' load(system.file("data", "example_occurrence.RData", package = "RangeMap"))
#' grid_sf <- system.file("data", "grid_1km.RData", package = "RangeMap") %>% load
#' result <- occ2gridCentroid(occ_data = example_occurrence, grid_sf)
#' }
#'
#' @importFrom sf st_transform st_centroid st_coordinates st_join st_as_sf
#' @importFrom data.table setDT
#' @importFrom dplyr select
#'
#' @export
occ2gridCentroid <-
  function(occ_data,
           coords_arg = c("X", "Y"),
           occ_crs = 4326,
           grid_sf,
           grid_id_x = "GRIDID.x",
           grid_id_y = "GRIDID.y",
           grid_crs = 3826) {

    vars <- c(grid_id_x, grid_id_y)

    grid_sf %<>% st_transform(grid_crs) %>%
      dplyr::select(all_of(vars))

    Grid_1k_centroid <-
      cbind(st_set_geometry(grid_sf, NULL),
            st_centroid(grid_sf) %>% st_coordinates) %>%
      setDT %>%
      .[, colnames(.) %in% c(grid_id_x,
                             colnames(st_centroid(grid_sf) %>% st_coordinates)), with = FALSE]

    species_data <-
      st_as_sf(occ_data,
               coords = coords_arg,
               crs = occ_crs) %>%
      st_transform(grid_crs) %>%
      st_join(grid_sf) %>%
      st_set_geometry(., NULL) %>%
      setDT %>%
      unique %>%
      Grid_1k_centroid[., on = grid_id_x]

    return(species_data)
  }
