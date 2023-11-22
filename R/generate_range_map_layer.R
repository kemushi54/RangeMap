#' Generate Range Map in .geojson Format Using Thresholds Select by Expert
#'
#' This function generates species range map file in .geojson format for multiple species
#' using thresholds provided by an expert. The thresholds are based on MaxEnt modeling
#' results. The resulting range maps are saved in the specified output directory.
#'
#' @param species_list A character vector of species names for which range maps are generated.
#' @param r The number of replicates used in MaxEnt modeling (default is 20).
#' @param threshold_table A data.table containing expert-selected thresholds for each species.
#' @param model_dir The directory containing MaxEnt modeling results (default is "models").
#' @param predict_dir The directory containing prediction averages (default is "results/gis/prediction_avg").
#' @param output_dir_gis The directory where the range maps in .geojson format will be saved
#'                   (default is "results/gis/range_map_ori").
#' @param output_dir_png The directory where the range maps in .png format will be saved
#'                   (default is NULL).
#'
#' @return This function generates range maps and does not return any value.
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' species_list <- c("Species_A", "Species_B")
#' threshold_table <- fread("path/to/threshold_table.csv") %>% select(species, threshold_maxent)
#' generate_range_map_layer(species_list, r = 20, threshold_table)
#' }
#'
#' @importFrom data.table fread setDT melt
#' @importFrom raster calc rasterToPolygons
#' @importFrom sf st_as_sf st_set_crs st_write
#' @importFrom dplyr left_join
#'
#' @export
generate_range_map_layer <- function(species_list,
                                     r = 20,
                                     threshold_table,
                                     model_dir = "models",
                                     predict_dir = "results/gis/prediction_avg",
                                     output_dir_gis = "results/gis/range_map_ori",
                                     output_dir_png = NULL,
                                     ...){

  # get threshold value of each threshold generate by MaxEnt
  threshold_value <-
    lapply(species_list, function(sp){
      lapply(1:r, function(r)
        fread(sprintf("%s/%s/%02d/maxentResults.csv",
                      model_dir, sp, r))
      ) %>%
        do.call(rbind, .) %>%
        .[, colnames(.) %like% "Cloglog threshold", with = FALSE] %>%
        .[, lapply(.SD, mean, na.rm = TRUE)] %>%
        .[, species := sp]

    }) %>%
    do.call(rbind, .) %>%
    data.table::melt(id = "species",
                     measure = patterns("Cloglog threshold"),
                     variable.name = "threshold",
                     value.name = "value") %>%
    setDT %>%
    .[, threshold_maxent := abbreviate(threshold)]


  # get threshold value selected by expert for each species and export range map for each species (.geojson)
  threshold_use <-
    dplyr::left_join(threshold_table, threshold_value) %>%
    setDT

  binary_value <-
    lapply(species_list,  function(sp){

      threshold_value_selected <- threshold_use[species == sp, value]

      range_map <-
        readRDS(sprintf("%s/%s.rds", predict_dir, sp)) %>%
        calc(fun = function(x)ifelse(x >= threshold_value_selected, 1, 0)) %>%
        rasterToPolygons() %>%
        st_as_sf() %>%
        st_set_crs(3826)

      st_write(range_map,
               sprintf("%s/%s.geojson", output_dir_gis, sp),
               delete_dsn = TRUE)

      if (!is.null(output_dir_png)) {

        range_map_ori <-
          range_map %>%
          dplyr::filter(layer == 1)

        p1 <- ggplot() +
          geom_sf(data = tw_main,
                  color = "#878787", fill = NA, size = .25) +
          geom_sf(data = range_map_ori, fill = "#942010", col = NA) +
          coord_sf(xlim = c(100000, 400000),
                   ylim = c(2400000, 2850000)) +
          labs(title = sp) +
          theme_bw() +
          theme(axis.title = element_blank(),
                axis.text = element_blank(),
                axis.ticks = element_blank(),
                legend.position = "none")

        ggsave(sprintf("%s_range_ori.png", sp),
               plot = p1,
               path = output_dir_png,
               width = 7, height = 9, dpi = 300)
      }
    }

    )
}
