library(tidyverse)
library(sf)
library(rnaturalearth)

world_sf <- ne_countries(returnclass = "sf")
coordinates <- st_coordinates(world_sf)

world_boundaries <- tibble(
  longitude = coordinates[, "X"],
  latitude = coordinates[, "Y"],
  polygon_group = str_c(
    coordinates[, "L3"],
    coordinates[, "L2"],
    coordinates[, "L1"],
    sep = "-"
  ),
  name_long = world_sf$name_long[coordinates[, "L3"]]
)

write_csv(world_boundaries, "data/world_boundaries.csv")
