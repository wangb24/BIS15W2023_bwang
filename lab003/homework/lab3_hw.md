---
title: "Lab 3 Homework"
author: "Bode Wang"
date: "2023-01-18"
output:
  html_document:
    theme: spacelab
    toc: no
    keep_md: yes
---

## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the tidyverse

```r
library(tidyverse)
```

## Mammals Sleep
1. For this assignment, we are going to use built-in data on mammal sleep patterns. From which publication are these data taken from? Since the data are built-in you can use the help function in R.

```r
help(msleep)
```

```
## starting httpd help server ... done
```

2. Store these data into a new data frame `sleep`.

```r
sleep <- msleep
head(sleep)
```

```
## # A tibble: 6 × 11
##   name  genus vore  order conse…¹ sleep…² sleep…³ sleep…⁴ awake  brainwt  bodywt
##   <chr> <chr> <chr> <chr> <chr>     <dbl>   <dbl>   <dbl> <dbl>    <dbl>   <dbl>
## 1 Chee… Acin… carni Carn… lc         12.1    NA    NA      11.9 NA        50    
## 2 Owl … Aotus omni  Prim… <NA>       17       1.8  NA       7    0.0155    0.48 
## 3 Moun… Aplo… herbi Rode… nt         14.4     2.4  NA       9.6 NA         1.35 
## 4 Grea… Blar… omni  Sori… lc         14.9     2.3   0.133   9.1  0.00029   0.019
## 5 Cow   Bos   herbi Arti… domest…     4       0.7   0.667  20    0.423   600    
## 6 Thre… Brad… herbi Pilo… <NA>       14.4     2.2   0.767   9.6 NA         3.85 
## # … with abbreviated variable names ¹​conservation, ²​sleep_total, ³​sleep_rem,
## #   ⁴​sleep_cycle
```

3. What are the dimensions of this data frame (variables and observations)? How do you know? Please show the *code* that you used to determine this below.  

```r
dim(sleep)
```

```
## [1] 83 11
```

4. Are there any NAs in the data? How did you determine this? Please show your code.  

```r
colSums(is.na(sleep))
```

```
##         name        genus         vore        order conservation  sleep_total 
##            0            0            7            0           29            0 
##    sleep_rem  sleep_cycle        awake      brainwt       bodywt 
##           22           51            0           27            0
```

5. Show a list of the column names is this data frame.

```r
names(sleep)
```

```
##  [1] "name"         "genus"        "vore"         "order"        "conservation"
##  [6] "sleep_total"  "sleep_rem"    "sleep_cycle"  "awake"        "brainwt"     
## [11] "bodywt"
```

6. How many herbivores are represented in the data?  

```r
table(sleep$vore)['herbi']
```

```
## herbi 
##    32
```

7. We are interested in two groups; small and large mammals. Let's define small as less than or equal to 1kg body weight and large as greater than or equal to 200kg body weight. Make two new dataframes (large and small) based on these parameters.

```r
small <- filter(sleep, bodywt <= 1)
large <- filter(sleep, bodywt >= 200)
```

8. What is the mean weight for both the small and large mammals?

```r
smallMean <- mean(small$bodywt)
largeMean <- mean(large$bodywt)
print(paste("The mean weight for small mammals is", smallMean))
```

```
## [1] "The mean weight for small mammals is 0.259666666666667"
```

```r
print(paste("The mean weight for large mammals is", largeMean))
```

```
## [1] "The mean weight for large mammals is 1747.07085714286"
```

9. Using a similar approach as above, do large or small animals sleep longer on average?  

```r
smallMeanSleep <- mean(small$sleep_total)
largeMeanSleep <- mean(large$sleep_total)
print(paste("The mean sleep time for small mammals is", smallMeanSleep))
```

```
## [1] "The mean sleep time for small mammals is 12.6583333333333"
```

```r
print(paste("The mean sleep time for large mammals is", largeMeanSleep))
```

```
## [1] "The mean sleep time for large mammals is 3.3"
```

```r
if(smallMeanSleep > largeMeanSleep){
  print("Small mammals sleep longer on average")
} else {
  print("Large mammals sleep longer on average")
}
```

```
## [1] "Small mammals sleep longer on average"
```

10.  Which animal is the sleepiest among the entire dataframe?

```r
maxSleepTime <- max(sleep$sleep_total)
sleepiestAnimal <- filter(sleep, sleep_total >= maxSleepTime)
sleepiestAnimal$name
```

```
## [1] "Little brown bat"
```

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.
