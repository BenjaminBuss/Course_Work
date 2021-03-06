
# Benjamin Buss
# Started December 5th 2019
# Stats 4200 Final
# "Count all the trees on campus!"
# Big Data Buzzword Approach

# Import needed packages
library(countcolors) 
# Introductory Documentation: https://cran.r-project.org/web/packages/countcolors/vignettes/Introduction.html
# Indepth Documentation:      https://cran.r-project.org/web/packages/countcolors/countcolors.pdf
library(imager)


# Load in image in three different formats
jpg_image <- jpeg::readJPEG("B:/Downloads/cropped_image.jpg")
load_image <- colordistance::loadImage("B:/Downloads/cropped_image.jpg")
image_two <- imager::load.image("B:/Downloads/cropped_image.jpg")
# https://www.rdocumentation.org/packages/colordistance/versions/1.1.0/topics/loadImage

# Plot pixel distribution(decrease n to increase speed)
colordistance::plotPixels(load_image, lower=c(0.8, 0.8, 0.8), upper=c(1, 1, 1), n = 50000)
# https://www.rdocumentation.org/packages/colordistance/versions/1.1.0/topics/plotPixels

# Calculate k-means of image(including background colors)
kmeans_clusters <- colordistance::getKMeanColors("B:/Downloads/cropped_image.jpg", n = 3, plotting = FALSE)
# https://www.rdocumentation.org/packages/colordistance/versions/1.1.0/topics/getKMeanColors

# Calculate k-means of image(discluding background colors)
kmeans_clusters <- colordistance::getKMeanColors("B:/Downloads/cropped_image.jpg", n = 3, plotting = FALSE, 
                                                 lower =c(0.8, 0.8, 0.8), upper = c(1, 1, 1))

# Extract and display k-means
colordistance::extractClusters(kmeans_clusters)
# https://www.rdocumentation.org/packages/colordistance/versions/1.1.0/topics/extractClusters

# Set center of sphere based on k-means(see third row of previous command)
center_spherical <- c(0.16, 0.20, 0.17) 
row_one_sphere <- c(.32, .33, .30)
row_two_sphere <- c(.48, .48, .46)

# Find all the pixels within a 10% color radius of GREEN
campus_spherical <- countcolors::sphericalRange(jpg_image, center = center_spherical, radius = 0.1, 
                                                color.pixels = FALSE, plotting = FALSE)
non_one_sphere <- countcolors::sphericalRange(jpg_image, center = row_one_sphere, radius = 0.1, 
                                              color.pixels = FALSE, plotting = FALSE)
non_two_sphere <- countcolors::sphericalRange(jpg_image, center = row_two_sphere, radius = 0.1, 
                                              color.pixels = FALSE, plotting = FALSE)

# Color all green pixels in range magenta(just for visualization)
countcolors::changePixelColor(jpg_image, campus_spherical$pixel.idx, target.color = "magenta")

# Color all NOT green pixel white, return to the color_changed variable
    # Parking lots and roads
roads_changed <- countcolors::changePixelColor(jpg_image, non_one_sphere$pixel.idx, target.color = "white", return.img = TRUE)
    # Buildings
buildings_changed <- countcolors::changePixelColor(jpg_image, non_two_sphere$pixel.idx, target.color = "white", return.img = TRUE)


# Get percentage of campus that is green
campus_spherical$img.fraction
    # .2022722 is green(ish)

# Get percentage of campus that is roads
non_one_sphere$img.fraction
    # .2699302 is road(ish)

# Get percentage of campus that is buildings
non_two_sphere$img.fraction
    # .1260938 is buildings(ish)

    # .4017038 is white


# Convert filtered image into cimg(so I can use imager package on it)
color_cimg <- as.cimg(color_changed)
    # Main downside is it rotates the image

plot(color_cimg)

autocrop(color_cimg)

unrotated <- imrotate(color_cimg, 270)

plot(unrotated)

cs_lot <- bucketfill(unrotated, x = 2050, y = 1070, color = "red", sigma = .10) #<- I guess
plot(cs_lot)

cs_lot <- bucketfill(unrotated, x = 1760, y = 450, color = "red", sigma = .10) #<- I guess
plot(cs_lot)

cs_lot <- bucketfill(unrotated, x = 1400, y = 490, color = "red", sigma = .10) #<- I guess
plot(cs_lot)

test_point <- draw_circle(unrotated, 1400, 490, 5, color = "purple", opacity = 1, filled = TRUE)
plot(test_point)

# Create a chessboard of rectangles
# test <- draw_rect(unrotated, 500, 500, 1000, 1000, color = "red", opacity = 1)
test <- draw_rect(image_two, 500, 500, 1000, 1000, color = "red", opacity = 1)
test <- draw_rect(test, 1000, 1000, 1500, 1500, color = "red", opacity = 1)
test <- draw_rect(test, 1500, 1500, 2000, 2000, color = "red", opacity = 1)
test <- draw_rect(test, 0, 0, 500, 500, color = "red", opacity = 1)
test <- draw_rect(test, 0, 1500, 500, 1000, color = "red", opacity = 1)
test <- draw_rect(test, 500, 2000, 1000, 1500, color = "red", opacity = 1)
test <- draw_rect(test, 1000, 500, 1500, 0, color = "red", opacity = 1)
test <- draw_rect(test, 1500, 1000, 2000, 500, color = "red", opacity = 1)
test <- draw_rect(test, 2000, 500, 2500, 0, color = "red", opacity = 1)
test <- draw_rect(test, 2000, 1500, 2500, 1000, color = "red", opacity = 1)
test <- draw_rect(test, 2500, 1000, 2800, 500, color = "red", opacity = 1)
test <- draw_rect(test, 2500, 2000, 2800, 1500, color = "red", opacity = 1)
plot(test)

# norway.spherical$img.fraction


# edge_two <- cannyEdges(color_cimg)
# 
# circ_two <- hough_circle(edge_two, 10)
# plot(circ_two)






library(ForestTools)
library(raster)

raster_test <- raster("B:/Downloads/cropped_image.jpg")

data("raster_test")

lim <- function(x){x * 0.05 + 0.3 }

ttops <- vwf(CHM = raster_test, winFun = lim, minHeight = 2)

plot(raster_test, xlab = "", ylab = "", xaxt ='n', yaxt = 'n')

plot(ttops, col = "blue", pch = 20, cex = 0.5, add = TRUE)        
