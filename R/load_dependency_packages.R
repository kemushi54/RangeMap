#' Load dependency packages when loading the package
#' @import tidyr
#' @import dplyr
#' @import parallel
#' @import dismo
#' @import rJava
#' @import data.table
#' @import magrittr
#' @import sf
#' @import ggplot2
#' @import raster
#' @import rgdal
#' @import foreach
#' @import doParallel
#'
#' @export
load_dependency_packages <- function() {
  # Load required packages when loading the package
  library(tidyr)
  library(dplyr)
  library(parallel)
  library(dismo)
  library(rJava)
  library(data.table)
  library(magrittr)
  library(sf)
  library(ggplot2)
  library(raster)
  library(rgdal)
  library(foreach)
  library(doParallel)
}
