#' Data of grid system
#'
#' This data contains the grid system used to subsample occurrence data.
#'
#' @format A sf with 1km grid system.
#' @source 1 km grid system of Taiwan, with GRIDID.x for 1 km grid ID and GRIDID.y for 5 km ID.
"grid_1km"

#' Data of environment variables
#'
#' This data contains 21 environment variables used in MaxEnt.
#'
#' @format A list of stacked raster.
#' @source Environment variables download from "A multi-temporal and terrestrial environmental dataset of Taiwan". Includ Bio01, Bio02, Bio04, Bio12, Bio15, Bio16, Aspect, ASR, ELE, ELESD, Slope, BL, BU, FF, FO, FW, MD, UB, WB, WL, DFW.
"env"

#' Data of maxent argument setting
#'
#' This data contains maxent argument used to build SDM
#'
#' @format A vector of characters.
#' @source MaxEnt argumet used.
"maxent_args"

#' Data of layer of Taiwan main island
#'
#' This data contains polygon of Taiwan main island
#'
#' @format A sf polygon.
#' @source Polygon of Taiwan.
"tw_main"
