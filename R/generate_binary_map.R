#' Generate Binary Maps for Species Using MaxEnt Thresholds
#'
#' This function generates 11 binary maps for a species using different thresholds
#' provided by MaxEnt. The resulting plot includes binary maps for each threshold.
#'
#' @param model_dir The directory containing MaxEnt modeling results. Default is "models".
#' @param predicted_dir The directory containing continuous predicted values. Default is "results/gis/prediction_avg".
#' @param species_list A vector of name of the species, used as folder names for models and binary maps generated.
#' @param file_path The optional file path to save the generated plot. No file will be saved if not provided.
#'
#' @return A list of ggplot objects, each containing a plot with 11 binary maps for different thresholds.
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' species_list <- c("Species_A", "Species_B")
#' generate_binary_map(model_dir = "models", predicted_dir = "results/gis/prediction_avg", species_list)
#' }
#'
#' @importFrom ggplot2 ggplot geom_raster geom_sf scale_fill_manual coord_sf facet_wrap labs theme_bw ggsave aes
#' @importFrom data.table melt %like%
#'
#' @export
generate_binary_map <- function(model_dir = "models",
                                predicted_dir = "results/gis/prediction_avg",
                                species_list,
                                file_path = NULL) {
  lapply(species_list, function(sp){

  # Generate binary table using model2binary_tb function
  binary_tb <- model2binary_tb(model_dir = model_dir,
                               predicted_dir = predicted_dir,
                               species_name = sp)

  # Melt binary table for ggplot
  binary_tb_melt <-
    binary_tb %>%
    data.table::melt(id = c("x", "y"),
                     measures = 4:14) %>%
    .[variable != "layer"] %>%
    .[, abbr := abbreviate(variable)]

  # Generate ggplot object for the binary maps
  p <- ggplot() +
    geom_raster(data = binary_tb_melt,
                aes(x = x, y = y, fill = as.factor(value))) +
    geom_sf(data = tw_main,
            color = "#878787", fill = NA, size = .25) +
    scale_fill_manual(breaks = c("0", "1"),
                      values = c("white","#942010"),
                      labels = c("Absence", "Presence")) +
    coord_sf(xlim = c(100000, 400000),
             ylim = c(2400000, 2850000)) +
    facet_wrap(~ abbr, ncol = 6) +
    labs(title = sp) +
    theme_bw() +
    theme(axis.title = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          legend.position = "none")

  # Save plot if file_path is provided
  if (!is.null(file_path)) {
    ggsave(sprintf("%s_maxent.png", sp),
           path = file_path,
           width = 12, height = 7, dpi = 300)

    cat(sprintf("Plot save at %s\n", file_path))
  }

  return(p)
  })
}
