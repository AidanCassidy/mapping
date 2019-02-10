install.packages("leaflet")
install.packages("ggmap")
install.packages("ggmap2")
install.packages("maptools")
install.packages("rgeos")
install.packages("devtools")
install.packages("gpclib")
install.packages("mapdata")

install.packages("tidyverse")
install.packages("rgdal")
library(leaflet)
library(ggmap)
library(dplyr)
library(rgdal)
library(rgeos)
library(readr)
library(Rtools)
require(Rtools, lib.loc = "C:/Rtools", quietly = FALSE,
        warn.conflicts = TRUE,
        character.only = FALSE)

setup_rtools(cache = TRUE, debug = FALSE)
library(devtools)
find_rtools()
df2 <- data.frame(
  address = c("G413EY, UK",  "G2 8LU, UK"), stringsAsFactors = FALSE)
df2 = mutate_geocode(df2, address, output = "more", source = "dsk")
df2

names(providers)[1:5]

SG_SIMD_2016 = readOGR("C:/Users/acassidy/Desktop/SG/statistics/shapes", "SG_SIMD_2016")
class(SG_SIMD_2016)
head(SG_SIMD_2016, 1)
SG_SIMD_2016 = spTransform(SG_SIMD_2016, CRS("+proj=longlat +ellps=GRS80"))
SIMD16_Glasgow = subset(SG_SIMD_2016, LAName == "Glasgow City")
head(SIMD16_Glasgow, 1)
class(SIMD16_Glasgow$Quintile)
bins <- c(0, 1, 2, 3, 4, 5)
pal <- colorBin("YlOrRd", domain = SIMD16_Glasgow$Quintile, bins = bins)
labels <- sprintf(
  "<strong>%s</strong><br/>%g SIMD 2016 rank</sup>",
  SIMD16_Glasgow$DataZone, SIMD16_Glasgow$Rank) 
%>% lapply(htmltools::HTML)

map3 = leaflet(options = leafletOptions(minZoom = 10, dragging = TRUE))  %>% 
addProviderTiles("CartoDB") %>%
addPolygons(data=SIMD16_Glasgow, fillColor = ~pal(Quintile),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
 highlight = highlightOptions(
   weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels, 
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))%>%
 addLegend(pal = pal, values = SIMD16_Glasgow$Quintile, opacity = 0.7, title = "title",
    position = "bottomright") %>%
addMarkers(lng = df2$lon, lat = df2$lat, popup = df2$locality) %>%
setView(lng = -4.263574, lat = 55.85745, zoom = 12)
map3

SG_SIMD_2016 = readOGR("C:/Users/acassidy/Desktop/SG/statistics/shapes", "SG_SIMD_2016")
SG_SIMD_2016s = spTransform(SG_SIMD_2016, CRS("+proj=longlat +ellps=GRS80"))
getwd()
SIMDgeo = read_csv("SIMDgeo.csv")
SIMDgeo = subset(SIMDgeo, select=c(DZ, URclass:SPCname))
colnames(DZ) <- "DataZone"
colnames(SIMDgeo)[colnames(SIMDgeo)=="DZ"] = "DataZone"
names(SIMDgeo)
SG_SIMD_2016s = merge(SG_SIMD_2016s, SIMDgeo, by = "DataZone")
names(SG_SIMD_2016s)
SIMD16_LM = subset(SG_SIMD_2016s, MMWname == "Buckhaven, Methil and Wemyss Villages Ward" | MMWname == "Leven, Kennoway and Largo Ward")
head(SIMD16_LM, 1)

labels2 <- sprintf(
  "<strong>%s</strong><br/>%g SIMD 2016 rank</sup>",
  SIMD16_LM$MMWname, SIMD16_LM$DataZone, SIMD16_LM$Rank
) %>% lapply(htmltools::HTML)

map4 = leaflet(options = leafletOptions(minZoom = 10, dragging = TRUE))  %>% 
addProviderTiles("CartoDB") %>%
addPolygons(data=SIMD16_LM, fillColor = ~pal(Quintile),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
 highlight = highlightOptions(
   weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels2, 
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))%>%
 addLegend(pal = pal, values = SIMD16_LM$Quintile, opacity = 0.7, title = "title",
    position = "bottomright")
# %>% addMarkers(lng = df2$lon, lat = df2$lat, popup = df2$locality) %>%
#setView(lng = -4.263574, lat = 55.85745, zoom = 12)
map4









