# Example Workflow using the RangeMap Package

# Install the RangeMap package from a local tar.gz file.
# Replace "path/to/RangeMap_0.1.0.tar.gz" with the actual path to your tar.gz file.
# install.packages("path/to/RangeMap_0.1.0.tar.gz")


# Load the RangeMap package and its dependency packages.
library(RangeMap)
load_dependency_packages()


# Initialize the project structure.
# This creates the necessary folders for the project.
project_init()


# Load the required data for the workflow.
load_required_data()


# Prepare a list of species names.
# These names should match the species names used in the occurrence data and will be used
# as identifiers for the subsequent workflow steps.
sp_list <- c("麻雀", "白尾鴝")


# Load the occurrence data for the specified species.
# The data should be data.table format.
load(system.file("data", "example_occurrence.RData", package = "RangeMap"))


# Generate species data in GeoJSON format for each species.
# This step exports the species data for further processing.
lapply(sp_list, function(sp) {

  sp_data <- example_occurrence %>% dplyr::filter(name_c == sp)
  generate_species_data(sp_data = sp_data,
                        species_name = sp)
}
)


# Construct Species Distribution Models (SDM) using MaxEnt for each species.
# This step generates MaxEnt models and the average predicted habitat suitability values.
# The average predicted habitat suitability values saved in "results/gis/prediction_avg" in default.
maxent_models <-
  lapply(sp_list, function(sp)
    construct_sdm(species_name = sp,
                  data_dir = "data_processed/species_data",
                  env = env,
                  maxent_args = maxent_args,
                  result_dir = "results/gis/prediction_avg"))


# Generate binary maps based on MaxEnt predictions.
# This step converts continuous predicted values to binary values using thresholds MaxEnt provides.
# Export a PNG file with 11 plots for each species.
generate_binary_map(species_list = sp_list,
                    file_path = "results/plots/binary_map")


# Export binary maps selected by experts for review.
# Export PNG files for each species to assess if modifications to the range are needed.
threshold_table <-
  data.frame(species = sp_list,
             threshold_maxent = c("Fcv10Ct", "MtpCt"))

generate_range_map_layer(species_list = sp_list,
                         r = 20,
                         threshold_table = threshold_table,
                         output_dir_png = "results/plots/range_map_ori/")


# projection
future_predict <-
  lapply(seq_along(maxent_models), function(m)
    lapply(seq_along(maxent_models[[m]]), function(r)
      predict(maxent_model[[m]], future_env)) %>%
      do.call(stack, .)
  )

# Generate final range maps.
# Export PNG files for the final range map product.
range_map <- lapply(sp_list, function(sp) {
  # import range map layer
  sp_range_map <- st_read(sprintf("results/gis/range_map_modified/%s.geojson", sp))
  # generate map in ggplot format
  generate_species_range_map(species_name = sp,
                             range_map = sp_range_map)
  # save ggplot as PNG
  ggsave(sprintf("%s.png", sp),
         path = "results/plots/range_map_modified",
         width = 7, height = 9, dpi = 300)
})
