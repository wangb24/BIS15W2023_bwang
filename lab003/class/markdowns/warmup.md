## Warm-up

1.  Build a vector that includes the following height measurements for
    five plants: plant 1 30.7, plant 2 37.6, plant 3 28.4, plant 4 NA,
    plant 5 33.2

<!-- -->

    height <- c(30.7, 37.6, 28.4, NA, 33.2)
    height

    ## [1] 30.7 37.6 28.4   NA 33.2

1.  Build another vector that includes the following mass measurements:
    plant 1 4, plant 2 5.2, plant 3 3.7, plant 4 NA, plant 5 4.6

<!-- -->

    mass <- c(4, 5.2, 3.7, NA, 4.6)
    mass

    ## [1] 4.0 5.2 3.7  NA 4.6

1.  Assemble these vectors into a labeled data matrix with two columns

<!-- -->

    plant_data <- cbind(height, mass)
    colnames(plant_data) <- c("height", "mass")
    rownames(plant_data) <- c("Plant 1", "Plant 2", "Plant 3", "Plant 4", "Plant 5" )
    plant_data

    ##         height mass
    ## Plant 1   30.7  4.0
    ## Plant 2   37.6  5.2
    ## Plant 3   28.4  3.7
    ## Plant 4     NA   NA
    ## Plant 5   33.2  4.6

1.  Calculate the mean for height and mass and add them to the data
    matrix

<!-- -->

    mean_data <- colMeans(plant_data, na.rm = TRUE)
    mean_data

    ## height   mass 
    ## 32.475  4.375

    plant_data <- rbind(plant_data, mean_data)
    rownames(plant_data)[6] <- "Mean"
    plant_data

    ##         height  mass
    ## Plant 1 30.700 4.000
    ## Plant 2 37.600 5.200
    ## Plant 3 28.400 3.700
    ## Plant 4     NA    NA
    ## Plant 5 33.200 4.600
    ## Mean    32.475 4.375
