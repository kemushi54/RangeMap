#' Generate Species Range Map Plot
#'
#' This function generates a ggplot for a species range map using specified style.
#'
#' @param range_map The spatial data frame for the species range map.
#' @param species_name The name of the species.
#'
#' @return A ggplot object representing the species range map.
#'
#' @examples
#' \dontrun{
#' sp <- "Species_A"
#' sp_range_map <- st_read("path/to/species_range_map.geojson")
#' generate_species_range_map(species_name = sp, range_map = sp_range_map)
#' ggsave(sprintf("%s.png", sp),
#'        path = "results/plots/range_map_modified",
#'        width = 7, height = 9, dpi = 300)
#' }
#'
#' @importFrom ggplot2 ggplot geom_sf coord_sf labs theme_bw theme element_blank
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
#' @export
generate_species_range_map <- function(range_map, species_name) {

  sp_map <- range_map %>% dplyr::filter(layer == 1)

  p <- ggplot() +
    geom_sf(data = tw_main,
            color = "#878787", fill = NA, size = 0.25) +
    geom_sf(data = sp_map, fill = "#942010", col = NA) +
    coord_sf(xlim = c(100000, 400000),
             ylim = c(2400000, 2850000)) +
    labs(title = species_name) +
    theme_bw() +
    theme(axis.title = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          legend.position = "none")

  return(p)
}
