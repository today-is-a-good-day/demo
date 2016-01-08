library(maptools)
library(ggmap)

# an example of how to plot a region with ggmap
# geography defines regions using polygons (lots of them). In my understanding, 
# the points of these polygons are used to draw the boundaries of countries, municipalities,
# cities etc. 
# read in data
ct <- readShapePoly("metropolitan municipality cpt.shp")
# make df with fortify function
ct.points <- fortify(ct)

# set colours for basemap
library(RColorBrewer)
colors <- brewer.pal(9, "BuGn")

# make basemap
bbox2 <- ggmap::make_bbox(lon = ct.points$long, lat = ct.points$lat, f = 0.5)
mapImage2 <- get_map(location = bbox2,
                     color = "color",
                     source = "google",
                     maptype = "roadmap",
                     zoom = 9)
# plot the boundaries of the municipality of cape town on the basemap
ggmap(mapImage2) +
    geom_polygon(data = ct.points, 
                 aes(x = long, y = lat, group = group), 
                 color = colors[9],
                 fill = colors[6],
                 alpha = 0.5) +
    labs(x = "Longitude",
         y = "Latitude")

# for a quick look up without fancy map underneath
plot(ct, border = "blue", axes = TRUE, las = 1)

# check if lon-lat data lies within ct borders
# toy data set
df <- data.frame(city = c("Paris", "London", "Barcelona", "Cape Town"),
                 long = c(2.294694, -0.116773, 2.154007, 18.480131), 
                 lat = c(48.858093, 51.510357, 41.390205, -33.984347))
# first transform df coordinates in Spatial Points
df_pts <- subset(df, select = c(long, lat))
# second convert long lat data of df into spatial object with same projection as area object
df_pts_sp <- SpatialPoints(df_pts)
# third check which points of df lie in area and return a dataframe
pts_in <- data.frame(over(ct, df_pts_sp, returnList = TRUE))
# select only rows of df stated in pts_in (lying in area)
df_area <- df[pts_in$X0,]

# as you can see, df_area contains only one city, namely Cape Town, which is lying 
# within the Western Cape. 

