#' Using Maxent to construct Species Distribution Model (SDM)
#'
#' This function using MaxEnt to constructs a Species Distribution Model (SDM) for a given species
#' based on species occurrence data in a .geojson file. It performs MaxEnt modeling
#' and exports prediction results. The SDM is built for multiple replicates (default r is 20),
#' and prediction averages are calculated.
#'
#' @param species_name The name of the species using in data file, also for SDM folder.
#' @param data_dir The path to the directory containing species occurrence data in .geojson format.
#' @param n_cl The number of clusters for parallel processing (default is 10).
#' @param model_dir The path to the directory store species model, default is "models".
#' @param result_dir The path to the directory to store average predicted raster file, default is "results/gis/prediction_avg".
#'
#' @return The function constructs the SDM and returns the model as list. It also saves
#' prediction results in the "results/gis/prediction_avg" directory as default.
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' construct_sdm("Example_Species", path = "data_processed/species_data", n_cl = 5)
#' }
#'
#' @importFrom sf st_read st_drop_geometry st_coordinates
#' @importFrom data.table setDT
#' @importFrom dismo maxent
#' @importFrom raster calc stack
#' @import rJava
#' @import doParallel
#' @import foreach
#' @importFrom tidyr drop_na
#' @importFrom magrittr %>%
#' @importFrom parallel makeCluster clusterExport clusterEvalQ stopCluster
#'
#' @export
construct_sdm <- function(species_name,
                          data_dir = "data_processed/species_data",
                          n_cl = 10,
                          r = 20,
                          model_dir = "models",
                          env,
                          maxent_args,
                          result_dir = "results/gis/prediction_avg",
                          ...){

  # prepare species data for MaxEnt
  species_data_sf <-
    st_read(file.path(data_dir, paste0(species_name, ".geojson")))

  species_data <-
    cbind(st_drop_geometry(species_data_sf),
          st_coordinates(species_data_sf)) %>%
    occ2gridCentroid(occ_data = .,
                     coords_arg = c("X", "Y"),
                     occ_crs = 4326,
                     grid_sf = grid_1km,
                     grid_id_x = "GRIDID.x",
                     grid_id_y = "GRIDID.y",
                     grid_crs = 3826) %>%
    drop_na(GRIDID.x, GRIDID.y)

  if ( "Issue" %in% names(species_data)) {

    species_data <-
      species_data %>%
      dplyr::filter(is.na(Issue)) %>%
      setDT

  } else {

    species_data <-
      species_data %>%
      setDT
  }

  # Construct SDM
  cl <- makeCluster(n_cl)
  registerDoParallel(cl)

  tryCatch({
    species_models <-
      # Export necessary variables to the workers
      foreach(i = 1:r, .packages = c("data.table", "magrittr", "dismo", "rJava", "raster")) %dopar% {
        # subsample of species data by 5km grids (GRIDID.y)
        # create folder
        path_sdm <- sprintf("%s/%s/%02d", model_dir, species_name, i)

        if (!dir.exists(path_sdm)) {
          dir.create(path_sdm, recursive = TRUE)
        }

        sp_data <-
          species_data %>%
          .[, .SD[sample(.N ,(min(.N, 1)))], by = GRIDID.y] %>%
          .[, list(X, Y)] %>%
          as.matrix %>%
          na.omit()

        # run MaxEnt
        SDM <-
          maxent(env[[1]], sp_data,
                 path = path_sdm,
                 args = maxent_args,
                 silent = TRUE)

        # export prediction value
        SDM.stack <-
          lapply(1:length(SDM@models),
                 function(j)
                   predict(env[[1]], SDM@models[[j]])) %>%
          stack()

        saveRDS(SDM.stack, sprintf("%s/model_predict_stack.rds", path_sdm))

        return(SDM)
      }

    # export prediction raster file
    if (!dir.exists(result_dir)) {
      dir.create(result_dir, recursive = TRUE)
    }

    prediction <-
      foreach(i = 1:20, .combine = stack, .packages = "raster") %dopar% {
        path_sdm <- sprintf("models/%s/%02d", species_name, i)

        prediction <- readRDS(sprintf("%s/model_predict_stack.rds", path_sdm)) %>%
          calc(fun = mean)
      }

    prediction_avg <-
      prediction %>% calc(fun = mean)

    saveRDS(prediction_avg,
            sprintf("%s/%s.rds", result_dir, species_name))

    return(species_models)

  }, finally = {
    # Stop the cluster when done
    stopCluster(cl)
  })

}
