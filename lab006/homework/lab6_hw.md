---
title: "Lab 6 Homework"
author: "Bode W"
date: "2023-02-02"
output:
    html_document: 
        theme: spacelab
        keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the libraries

```r
# install.packages(c("tidyverse", "janitor", "skimr"), repos = "http://cran.us.r-project.org")
library(tidyverse)
library(janitor)
library(skimr)
```

For this assignment we are going to work with a large data set from the [United Nations Food and Agriculture Organization](http://www.fao.org/about/en/) on world fisheries. These data are pretty wild, so we need to do some cleaning. First, load the data.  

Load the data `FAO_1950to2012_111914.csv` as a new object titled `fisheries`.

```r
fisheries <- readr::read_csv(file = "data/FAO_1950to2012_111914.csv")
```

```
## Rows: 17692 Columns: 71
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (69): Country, Common name, ISSCAAP taxonomic group, ASFIS species#, ASF...
## dbl  (2): ISSCAAP group#, FAO major fishing area
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

1. Do an exploratory analysis of the data (your choice). What are the names of the variables, what are the dimensions, are there any NA's, what are the classes of the variables?  

```r
names(fisheries)
```

```
##  [1] "Country"                 "Common name"            
##  [3] "ISSCAAP group#"          "ISSCAAP taxonomic group"
##  [5] "ASFIS species#"          "ASFIS species name"     
##  [7] "FAO major fishing area"  "Measure"                
##  [9] "1950"                    "1951"                   
## [11] "1952"                    "1953"                   
## [13] "1954"                    "1955"                   
## [15] "1956"                    "1957"                   
## [17] "1958"                    "1959"                   
## [19] "1960"                    "1961"                   
## [21] "1962"                    "1963"                   
## [23] "1964"                    "1965"                   
## [25] "1966"                    "1967"                   
## [27] "1968"                    "1969"                   
## [29] "1970"                    "1971"                   
## [31] "1972"                    "1973"                   
## [33] "1974"                    "1975"                   
## [35] "1976"                    "1977"                   
## [37] "1978"                    "1979"                   
## [39] "1980"                    "1981"                   
## [41] "1982"                    "1983"                   
## [43] "1984"                    "1985"                   
## [45] "1986"                    "1987"                   
## [47] "1988"                    "1989"                   
## [49] "1990"                    "1991"                   
## [51] "1992"                    "1993"                   
## [53] "1994"                    "1995"                   
## [55] "1996"                    "1997"                   
## [57] "1998"                    "1999"                   
## [59] "2000"                    "2001"                   
## [61] "2002"                    "2003"                   
## [63] "2004"                    "2005"                   
## [65] "2006"                    "2007"                   
## [67] "2008"                    "2009"                   
## [69] "2010"                    "2011"                   
## [71] "2012"
```

```r
dim(fisheries)
```

```
## [1] 17692    71
```

```r
anyNA(fisheries)
```

```
## [1] TRUE
```

```r
str(fisheries)
```

```
## spc_tbl_ [17,692 × 71] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Country                : chr [1:17692] "Albania" "Albania" "Albania" "Albania" ...
##  $ Common name            : chr [1:17692] "Angelsharks, sand devils nei" "Atlantic bonito" "Barracudas nei" "Blue and red shrimp" ...
##  $ ISSCAAP group#         : num [1:17692] 38 36 37 45 32 37 33 45 38 57 ...
##  $ ISSCAAP taxonomic group: chr [1:17692] "Sharks, rays, chimaeras" "Tunas, bonitos, billfishes" "Miscellaneous pelagic fishes" "Shrimps, prawns" ...
##  $ ASFIS species#         : chr [1:17692] "10903XXXXX" "1750100101" "17710001XX" "2280203101" ...
##  $ ASFIS species name     : chr [1:17692] "Squatinidae" "Sarda sarda" "Sphyraena spp" "Aristeus antennatus" ...
##  $ FAO major fishing area : num [1:17692] 37 37 37 37 37 37 37 37 37 37 ...
##  $ Measure                : chr [1:17692] "Quantity (tonnes)" "Quantity (tonnes)" "Quantity (tonnes)" "Quantity (tonnes)" ...
##  $ 1950                   : chr [1:17692] NA NA NA NA ...
##  $ 1951                   : chr [1:17692] NA NA NA NA ...
##  $ 1952                   : chr [1:17692] NA NA NA NA ...
##  $ 1953                   : chr [1:17692] NA NA NA NA ...
##  $ 1954                   : chr [1:17692] NA NA NA NA ...
##  $ 1955                   : chr [1:17692] NA NA NA NA ...
##  $ 1956                   : chr [1:17692] NA NA NA NA ...
##  $ 1957                   : chr [1:17692] NA NA NA NA ...
##  $ 1958                   : chr [1:17692] NA NA NA NA ...
##  $ 1959                   : chr [1:17692] NA NA NA NA ...
##  $ 1960                   : chr [1:17692] NA NA NA NA ...
##  $ 1961                   : chr [1:17692] NA NA NA NA ...
##  $ 1962                   : chr [1:17692] NA NA NA NA ...
##  $ 1963                   : chr [1:17692] NA NA NA NA ...
##  $ 1964                   : chr [1:17692] NA NA NA NA ...
##  $ 1965                   : chr [1:17692] NA NA NA NA ...
##  $ 1966                   : chr [1:17692] NA NA NA NA ...
##  $ 1967                   : chr [1:17692] NA NA NA NA ...
##  $ 1968                   : chr [1:17692] NA NA NA NA ...
##  $ 1969                   : chr [1:17692] NA NA NA NA ...
##  $ 1970                   : chr [1:17692] NA NA NA NA ...
##  $ 1971                   : chr [1:17692] NA NA NA NA ...
##  $ 1972                   : chr [1:17692] NA NA NA NA ...
##  $ 1973                   : chr [1:17692] NA NA NA NA ...
##  $ 1974                   : chr [1:17692] NA NA NA NA ...
##  $ 1975                   : chr [1:17692] NA NA NA NA ...
##  $ 1976                   : chr [1:17692] NA NA NA NA ...
##  $ 1977                   : chr [1:17692] NA NA NA NA ...
##  $ 1978                   : chr [1:17692] NA NA NA NA ...
##  $ 1979                   : chr [1:17692] NA NA NA NA ...
##  $ 1980                   : chr [1:17692] NA NA NA NA ...
##  $ 1981                   : chr [1:17692] NA NA NA NA ...
##  $ 1982                   : chr [1:17692] NA NA NA NA ...
##  $ 1983                   : chr [1:17692] NA NA NA NA ...
##  $ 1984                   : chr [1:17692] NA NA NA NA ...
##  $ 1985                   : chr [1:17692] NA NA NA NA ...
##  $ 1986                   : chr [1:17692] NA NA NA NA ...
##  $ 1987                   : chr [1:17692] NA NA NA NA ...
##  $ 1988                   : chr [1:17692] NA NA NA NA ...
##  $ 1989                   : chr [1:17692] NA NA NA NA ...
##  $ 1990                   : chr [1:17692] NA NA NA NA ...
##  $ 1991                   : chr [1:17692] NA NA NA NA ...
##  $ 1992                   : chr [1:17692] NA NA NA NA ...
##  $ 1993                   : chr [1:17692] NA NA NA NA ...
##  $ 1994                   : chr [1:17692] NA NA NA NA ...
##  $ 1995                   : chr [1:17692] "0 0" "1" NA "0 0" ...
##  $ 1996                   : chr [1:17692] "53" "2" NA "3" ...
##  $ 1997                   : chr [1:17692] "20" "0 0" NA "0 0" ...
##  $ 1998                   : chr [1:17692] "31" "12" NA NA ...
##  $ 1999                   : chr [1:17692] "30" "30" NA NA ...
##  $ 2000                   : chr [1:17692] "30" "25" "2" NA ...
##  $ 2001                   : chr [1:17692] "16" "30" NA NA ...
##  $ 2002                   : chr [1:17692] "79" "24" NA "34" ...
##  $ 2003                   : chr [1:17692] "1" "4" NA "22" ...
##  $ 2004                   : chr [1:17692] "4" "2" "2" "15" ...
##  $ 2005                   : chr [1:17692] "68" "23" "4" "12" ...
##  $ 2006                   : chr [1:17692] "55" "30" "7" "18" ...
##  $ 2007                   : chr [1:17692] "12" "19" NA NA ...
##  $ 2008                   : chr [1:17692] "23" "27" NA NA ...
##  $ 2009                   : chr [1:17692] "14" "21" NA NA ...
##  $ 2010                   : chr [1:17692] "78" "23" "7" NA ...
##  $ 2011                   : chr [1:17692] "12" "12" NA NA ...
##  $ 2012                   : chr [1:17692] "5" "5" NA NA ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Country = col_character(),
##   ..   `Common name` = col_character(),
##   ..   `ISSCAAP group#` = col_double(),
##   ..   `ISSCAAP taxonomic group` = col_character(),
##   ..   `ASFIS species#` = col_character(),
##   ..   `ASFIS species name` = col_character(),
##   ..   `FAO major fishing area` = col_double(),
##   ..   Measure = col_character(),
##   ..   `1950` = col_character(),
##   ..   `1951` = col_character(),
##   ..   `1952` = col_character(),
##   ..   `1953` = col_character(),
##   ..   `1954` = col_character(),
##   ..   `1955` = col_character(),
##   ..   `1956` = col_character(),
##   ..   `1957` = col_character(),
##   ..   `1958` = col_character(),
##   ..   `1959` = col_character(),
##   ..   `1960` = col_character(),
##   ..   `1961` = col_character(),
##   ..   `1962` = col_character(),
##   ..   `1963` = col_character(),
##   ..   `1964` = col_character(),
##   ..   `1965` = col_character(),
##   ..   `1966` = col_character(),
##   ..   `1967` = col_character(),
##   ..   `1968` = col_character(),
##   ..   `1969` = col_character(),
##   ..   `1970` = col_character(),
##   ..   `1971` = col_character(),
##   ..   `1972` = col_character(),
##   ..   `1973` = col_character(),
##   ..   `1974` = col_character(),
##   ..   `1975` = col_character(),
##   ..   `1976` = col_character(),
##   ..   `1977` = col_character(),
##   ..   `1978` = col_character(),
##   ..   `1979` = col_character(),
##   ..   `1980` = col_character(),
##   ..   `1981` = col_character(),
##   ..   `1982` = col_character(),
##   ..   `1983` = col_character(),
##   ..   `1984` = col_character(),
##   ..   `1985` = col_character(),
##   ..   `1986` = col_character(),
##   ..   `1987` = col_character(),
##   ..   `1988` = col_character(),
##   ..   `1989` = col_character(),
##   ..   `1990` = col_character(),
##   ..   `1991` = col_character(),
##   ..   `1992` = col_character(),
##   ..   `1993` = col_character(),
##   ..   `1994` = col_character(),
##   ..   `1995` = col_character(),
##   ..   `1996` = col_character(),
##   ..   `1997` = col_character(),
##   ..   `1998` = col_character(),
##   ..   `1999` = col_character(),
##   ..   `2000` = col_character(),
##   ..   `2001` = col_character(),
##   ..   `2002` = col_character(),
##   ..   `2003` = col_character(),
##   ..   `2004` = col_character(),
##   ..   `2005` = col_character(),
##   ..   `2006` = col_character(),
##   ..   `2007` = col_character(),
##   ..   `2008` = col_character(),
##   ..   `2009` = col_character(),
##   ..   `2010` = col_character(),
##   ..   `2011` = col_character(),
##   ..   `2012` = col_character()
##   .. )
##  - attr(*, "problems")=<externalptr>
```

2. Use `janitor` to rename the columns and make them easier to use. As part of this cleaning step, change `country`, `isscaap_group_number`, `asfis_species_number`, and `fao_major_fishing_area` to data class factor. 

```r
fisheries <- janitor::clean_names(fisheries)
names(fisheries)
```

```
##  [1] "country"                 "common_name"            
##  [3] "isscaap_group_number"    "isscaap_taxonomic_group"
##  [5] "asfis_species_number"    "asfis_species_name"     
##  [7] "fao_major_fishing_area"  "measure"                
##  [9] "x1950"                   "x1951"                  
## [11] "x1952"                   "x1953"                  
## [13] "x1954"                   "x1955"                  
## [15] "x1956"                   "x1957"                  
## [17] "x1958"                   "x1959"                  
## [19] "x1960"                   "x1961"                  
## [21] "x1962"                   "x1963"                  
## [23] "x1964"                   "x1965"                  
## [25] "x1966"                   "x1967"                  
## [27] "x1968"                   "x1969"                  
## [29] "x1970"                   "x1971"                  
## [31] "x1972"                   "x1973"                  
## [33] "x1974"                   "x1975"                  
## [35] "x1976"                   "x1977"                  
## [37] "x1978"                   "x1979"                  
## [39] "x1980"                   "x1981"                  
## [41] "x1982"                   "x1983"                  
## [43] "x1984"                   "x1985"                  
## [45] "x1986"                   "x1987"                  
## [47] "x1988"                   "x1989"                  
## [49] "x1990"                   "x1991"                  
## [51] "x1992"                   "x1993"                  
## [53] "x1994"                   "x1995"                  
## [55] "x1996"                   "x1997"                  
## [57] "x1998"                   "x1999"                  
## [59] "x2000"                   "x2001"                  
## [61] "x2002"                   "x2003"                  
## [63] "x2004"                   "x2005"                  
## [65] "x2006"                   "x2007"                  
## [67] "x2008"                   "x2009"                  
## [69] "x2010"                   "x2011"                  
## [71] "x2012"
```


```r
fisheries <- fisheries %>%
    mutate(
        country = as.factor(country),
        isscaap_group_number = as.factor(isscaap_group_number),
        asfis_species_number = as.factor(asfis_species_number),
        fao_major_fishing_area = as.factor(fao_major_fishing_area)
    )
str(fisheries)
```

```
## tibble [17,692 × 71] (S3: tbl_df/tbl/data.frame)
##  $ country                : Factor w/ 204 levels "Albania","Algeria",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ common_name            : chr [1:17692] "Angelsharks, sand devils nei" "Atlantic bonito" "Barracudas nei" "Blue and red shrimp" ...
##  $ isscaap_group_number   : Factor w/ 30 levels "11","12","21",..: 14 12 13 19 8 13 9 19 14 26 ...
##  $ isscaap_taxonomic_group: chr [1:17692] "Sharks, rays, chimaeras" "Tunas, bonitos, billfishes" "Miscellaneous pelagic fishes" "Shrimps, prawns" ...
##  $ asfis_species_number   : Factor w/ 1553 levels "1020100101","1020100201",..: 92 970 1068 1256 398 581 817 1228 27 1499 ...
##  $ asfis_species_name     : chr [1:17692] "Squatinidae" "Sarda sarda" "Sphyraena spp" "Aristeus antennatus" ...
##  $ fao_major_fishing_area : Factor w/ 19 levels "18","21","27",..: 6 6 6 6 6 6 6 6 6 6 ...
##  $ measure                : chr [1:17692] "Quantity (tonnes)" "Quantity (tonnes)" "Quantity (tonnes)" "Quantity (tonnes)" ...
##  $ x1950                  : chr [1:17692] NA NA NA NA ...
##  $ x1951                  : chr [1:17692] NA NA NA NA ...
##  $ x1952                  : chr [1:17692] NA NA NA NA ...
##  $ x1953                  : chr [1:17692] NA NA NA NA ...
##  $ x1954                  : chr [1:17692] NA NA NA NA ...
##  $ x1955                  : chr [1:17692] NA NA NA NA ...
##  $ x1956                  : chr [1:17692] NA NA NA NA ...
##  $ x1957                  : chr [1:17692] NA NA NA NA ...
##  $ x1958                  : chr [1:17692] NA NA NA NA ...
##  $ x1959                  : chr [1:17692] NA NA NA NA ...
##  $ x1960                  : chr [1:17692] NA NA NA NA ...
##  $ x1961                  : chr [1:17692] NA NA NA NA ...
##  $ x1962                  : chr [1:17692] NA NA NA NA ...
##  $ x1963                  : chr [1:17692] NA NA NA NA ...
##  $ x1964                  : chr [1:17692] NA NA NA NA ...
##  $ x1965                  : chr [1:17692] NA NA NA NA ...
##  $ x1966                  : chr [1:17692] NA NA NA NA ...
##  $ x1967                  : chr [1:17692] NA NA NA NA ...
##  $ x1968                  : chr [1:17692] NA NA NA NA ...
##  $ x1969                  : chr [1:17692] NA NA NA NA ...
##  $ x1970                  : chr [1:17692] NA NA NA NA ...
##  $ x1971                  : chr [1:17692] NA NA NA NA ...
##  $ x1972                  : chr [1:17692] NA NA NA NA ...
##  $ x1973                  : chr [1:17692] NA NA NA NA ...
##  $ x1974                  : chr [1:17692] NA NA NA NA ...
##  $ x1975                  : chr [1:17692] NA NA NA NA ...
##  $ x1976                  : chr [1:17692] NA NA NA NA ...
##  $ x1977                  : chr [1:17692] NA NA NA NA ...
##  $ x1978                  : chr [1:17692] NA NA NA NA ...
##  $ x1979                  : chr [1:17692] NA NA NA NA ...
##  $ x1980                  : chr [1:17692] NA NA NA NA ...
##  $ x1981                  : chr [1:17692] NA NA NA NA ...
##  $ x1982                  : chr [1:17692] NA NA NA NA ...
##  $ x1983                  : chr [1:17692] NA NA NA NA ...
##  $ x1984                  : chr [1:17692] NA NA NA NA ...
##  $ x1985                  : chr [1:17692] NA NA NA NA ...
##  $ x1986                  : chr [1:17692] NA NA NA NA ...
##  $ x1987                  : chr [1:17692] NA NA NA NA ...
##  $ x1988                  : chr [1:17692] NA NA NA NA ...
##  $ x1989                  : chr [1:17692] NA NA NA NA ...
##  $ x1990                  : chr [1:17692] NA NA NA NA ...
##  $ x1991                  : chr [1:17692] NA NA NA NA ...
##  $ x1992                  : chr [1:17692] NA NA NA NA ...
##  $ x1993                  : chr [1:17692] NA NA NA NA ...
##  $ x1994                  : chr [1:17692] NA NA NA NA ...
##  $ x1995                  : chr [1:17692] "0 0" "1" NA "0 0" ...
##  $ x1996                  : chr [1:17692] "53" "2" NA "3" ...
##  $ x1997                  : chr [1:17692] "20" "0 0" NA "0 0" ...
##  $ x1998                  : chr [1:17692] "31" "12" NA NA ...
##  $ x1999                  : chr [1:17692] "30" "30" NA NA ...
##  $ x2000                  : chr [1:17692] "30" "25" "2" NA ...
##  $ x2001                  : chr [1:17692] "16" "30" NA NA ...
##  $ x2002                  : chr [1:17692] "79" "24" NA "34" ...
##  $ x2003                  : chr [1:17692] "1" "4" NA "22" ...
##  $ x2004                  : chr [1:17692] "4" "2" "2" "15" ...
##  $ x2005                  : chr [1:17692] "68" "23" "4" "12" ...
##  $ x2006                  : chr [1:17692] "55" "30" "7" "18" ...
##  $ x2007                  : chr [1:17692] "12" "19" NA NA ...
##  $ x2008                  : chr [1:17692] "23" "27" NA NA ...
##  $ x2009                  : chr [1:17692] "14" "21" NA NA ...
##  $ x2010                  : chr [1:17692] "78" "23" "7" NA ...
##  $ x2011                  : chr [1:17692] "12" "12" NA NA ...
##  $ x2012                  : chr [1:17692] "5" "5" NA NA ...
```


We need to deal with the years because they are being treated as characters and start with an X. We also have the problem that the column names that are years actually represent data. We haven't discussed tidy data yet, so here is some help. You should run this ugly chunk to transform the data for the rest of the homework. It will only work if you have used janitor to rename the variables in question 2!

```r
fisheries_tidy <- fisheries %>%  # nolint # nolint
    pivot_longer(
        -c(
            country,
            common_name,
            isscaap_group_number,
            isscaap_taxonomic_group,
            asfis_species_number,
            asfis_species_name,
            fao_major_fishing_area,
            measure
        ),
        names_to = "year",
        values_to = "catch",
        values_drop_na = TRUE
    ) %>%
    mutate(year = as.numeric(str_replace(year, 'x', ''))) %>% 
    mutate(catch = str_replace(catch, c(' F'), replacement = '')) %>% 
    mutate(catch = str_replace(catch, c('...'), replacement = '')) %>% 
    mutate(catch = str_replace(catch, c('-'), replacement = '')) %>% 
    mutate(catch = str_replace(catch, c('0 0'), replacement = ''))

fisheries_tidy$catch <- as.numeric(fisheries_tidy$catch)
glimpse(fisheries_tidy)
```

```
## Rows: 376,771
## Columns: 10
## $ country                 <fct> "Albania", "Albania", "Albania", "Albania", "A…
## $ common_name             <chr> "Angelsharks, sand devils nei", "Angelsharks, …
## $ isscaap_group_number    <fct> 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38…
## $ isscaap_taxonomic_group <chr> "Sharks, rays, chimaeras", "Sharks, rays, chim…
## $ asfis_species_number    <fct> 10903XXXXX, 10903XXXXX, 10903XXXXX, 10903XXXXX…
## $ asfis_species_name      <chr> "Squatinidae", "Squatinidae", "Squatinidae", "…
## $ fao_major_fishing_area  <fct> 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37…
## $ measure                 <chr> "Quantity (tonnes)", "Quantity (tonnes)", "Qua…
## $ year                    <dbl> 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002…
## $ catch                   <dbl> NA, 53, 20, 31, 30, 30, 16, 79, 1, 4, 68, 55, …
```

3. How many countries are represented in the data? Provide a count and list their names.

```r
n_distinct(fisheries_tidy$country)
```

```
## [1] 203
```


```r
fisheries_tidy %>%
    group_by(country) %>%
    summarize(n = n()) %>%
    arrange(desc(n))
```

```
## # A tibble: 203 × 2
##    country                      n
##    <fct>                    <int>
##  1 United States of America 18080
##  2 Spain                    17482
##  3 Japan                    15429
##  4 Portugal                 11570
##  5 Korea, Republic of       10824
##  6 France                   10639
##  7 Taiwan Province of China  9927
##  8 Indonesia                 9274
##  9 Australia                 8183
## 10 Un. Sov. Soc. Rep.        7084
## # … with 193 more rows
```

4. Refocus the data only to include country, isscaap_taxonomic_group, asfis_species_name, asfis_species_number, year, catch.

```r
fisheries_focus <- fisheries_tidy %>%
    select(
        country,
        isscaap_taxonomic_group,
        asfis_species_name,
        asfis_species_number,
        year,
        catch
    )
glimpse(fisheries_focus)
```

```
## Rows: 376,771
## Columns: 6
## $ country                 <fct> "Albania", "Albania", "Albania", "Albania", "A…
## $ isscaap_taxonomic_group <chr> "Sharks, rays, chimaeras", "Sharks, rays, chim…
## $ asfis_species_name      <chr> "Squatinidae", "Squatinidae", "Squatinidae", "…
## $ asfis_species_number    <fct> 10903XXXXX, 10903XXXXX, 10903XXXXX, 10903XXXXX…
## $ year                    <dbl> 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002…
## $ catch                   <dbl> NA, 53, 20, 31, 30, 30, 16, 79, 1, 4, 68, 55, …
```

5. Based on the asfis_species_number, how many distinct fish species were caught as part of these data?

```r
n_distinct(fisheries_focus$asfis_species_number)
```

```
## [1] 1551
```

6. Which country had the largest overall catch in the year 2000?

```r
fisheries_focus %>%
    filter(year == 2000) %>%
    group_by(country) %>%
    summarize(`total catch in 2000` = sum(catch)) %>%
    arrange(desc(`total catch in 2000`))
```

```
## # A tibble: 193 × 2
##    country                `total catch in 2000`
##    <fct>                                  <dbl>
##  1 Bangladesh                              1499
##  2 Aruba                                    163
##  3 Iraq                                      89
##  4 TimorLeste                                89
##  5 Sudan (former)                            70
##  6 Montserrat                                33
##  7 Suriname                                  26
##  8 French Guiana                              7
##  9 Bosnia and Herzegovina                     5
## 10 Pitcairn Islands                           5
## # … with 183 more rows
```

7. Which country caught the most sardines (_Sardina pilchardus_) between the years 1990-2000?

```r
fisheries_focus %>%
    filter(
        asfis_species_name == "Sardina pilchardus",
        year >= 1990,
        year <= 2000
    ) %>%
    group_by(country) %>%
    summarize(`total catch of sardines` = sum(catch, na.rm = TRUE)) %>%
    arrange(desc(`total catch of sardines`))
```

```
## # A tibble: 37 × 2
##    country               `total catch of sardines`
##    <fct>                                     <dbl>
##  1 Morocco                                    7470
##  2 Spain                                      3507
##  3 Russian Federation                         1639
##  4 Ukraine                                    1030
##  5 France                                      966
##  6 Portugal                                    818
##  7 Greece                                      528
##  8 Italy                                       507
##  9 Serbia and Montenegro                       478
## 10 Denmark                                     477
## # … with 27 more rows
```

8. Which five countries caught the most cephalopods between 2008-2012?

```r
fisheries_focus %>%
    filter(
        asfis_species_name == "Cephalopoda",
        year >= 2008,
        year <= 2012
    ) %>%
    group_by(country) %>%
    summarize(`total catch of cephalopods` = sum(catch, na.rm = TRUE)) %>%
    arrange(desc(`total catch of cephalopods`)) %>%
    head(5)
```

```
## # A tibble: 5 × 2
##   country `total catch of cephalopods`
##   <fct>                          <dbl>
## 1 India                            570
## 2 China                            257
## 3 Spain                            198
## 4 Algeria                          162
## 5 France                           101
```

9. Which species had the highest catch total between 2008-2012? (hint: Osteichthyes is not a species)

```r
fisheries_focus %>%
    filter(
        asfis_species_name != "Osteichthyes",
        year >= 2008, 
        year <= 2012
    ) %>%
    group_by(asfis_species_name) %>%
    summarize(`total catch of species` = sum(catch, na.rm = TRUE)) %>%
    arrange(desc(`total catch of species`)) %>%
    head(5)
```

```
## # A tibble: 5 × 2
##   asfis_species_name    `total catch of species`
##   <chr>                                    <dbl>
## 1 Theragra chalcogramma                    41075
## 2 Engraulis ringens                        35523
## 3 Katsuwonus pelamis                       32153
## 4 Trichiurus lepturus                      30400
## 5 Clupea harengus                          28527
```

10. Use the data to do at least one analysis of your choice.

`each country's top species caught between 2007-2012`


```r
fisheries_focus %>%
    filter(
        year >= 2007, 
        year <= 2012
    ) %>%
    group_by(country, asfis_species_name) %>%
    summarize(`total catch of species` = sum(catch, na.rm = TRUE)) %>%
    arrange(country, desc(`total catch of species`)) %>%
    group_by(country) %>%
    slice(1)
```

```
## `summarise()` has grouped output by 'country'. You can override using the
## `.groups` argument.
```

```
## # A tibble: 199 × 3
## # Groups:   country [199]
##    country             asfis_species_name   `total catch of species`
##    <fct>               <chr>                                   <dbl>
##  1 Albania             Scomber spp                               405
##  2 Algeria             Nephrops norvegicus                       324
##  3 American Samoa      Makaira nigricans                         339
##  4 Angola              Schedophilus pemarco                      370
##  5 Anguilla            Strombus spp                              142
##  6 Antigua and Barbuda Ostraciidae                               390
##  7 Argentina           Merluccius hubbsi                        4213
##  8 Aruba               Osteichthyes                              290
##  9 Australia           Sepiidae, Sepiolidae                      692
## 10 Bahamas             Carangidae                                359
## # … with 189 more rows
```

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.   
