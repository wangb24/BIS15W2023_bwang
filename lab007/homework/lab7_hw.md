---
title: "Lab 7 Homework"
author: "Bode W"
date: "2023-02-05"
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
library(tidyverse)
library(janitor)
library(skimr)
library(naniar)
library(dplyr)
```

## Data
**1. For this homework, we will use two different data sets. Please load `amniota` and `amphibio`.**  

`amniota` data:  
Myhrvold N, Baldridge E, Chan B, Sivam D, Freeman DL, Ernest SKM (2015). “An amniote life-history
database to perform comparative analyses with birds, mammals, and reptiles.” _Ecology_, *96*, 3109.
doi: 10.1890/15-0846.1 (URL: https://doi.org/10.1890/15-0846.1).

```r
amniota <- read_csv("./data/amniota.csv")
```

```
## Rows: 21322 Columns: 36
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (6): class, order, family, genus, species, common_name
## dbl (30): subspecies, female_maturity_d, litter_or_clutch_size_n, litters_or...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

`amphibio` data:  
Oliveira BF, São-Pedro VA, Santos-Barrera G, Penone C, Costa GC (2017). “AmphiBIO, a global database
for amphibian ecological traits.” _Scientific Data_, *4*, 170123. doi: 10.1038/sdata.2017.123 (URL:
https://doi.org/10.1038/sdata.2017.123).

```r
amphibio <- read_csv("./data/amphibio.csv")
```

```
## Rows: 6776 Columns: 38
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (6): id, Order, Family, Genus, Species, OBS
## dbl (31): Fos, Ter, Aqu, Arb, Leaves, Flowers, Seeds, Arthro, Vert, Diu, Noc...
## lgl  (1): Fruits
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## Questions  
**2. Do some exploratory analysis of the `amniota` data set. Use the function(s) of your choice. Try to get an idea of how NA's are represented in the data.**  

```r
head(amniota)
```

```
## # A tibble: 6 × 36
##   class order       family genus species subsp…¹ commo…² femal…³ litte…⁴ litte…⁵
##   <chr> <chr>       <chr>  <chr> <chr>     <dbl> <chr>     <dbl>   <dbl>   <dbl>
## 1 Aves  Accipitrif… Accip… Acci… albogu…    -999 Pied G…   -999  -999       -999
## 2 Aves  Accipitrif… Accip… Acci… badius     -999 Shikra     363.    3.25       1
## 3 Aves  Accipitrif… Accip… Acci… bicolor    -999 Bicolo…   -999     2.7     -999
## 4 Aves  Accipitrif… Accip… Acci… brachy…    -999 New Br…   -999  -999       -999
## 5 Aves  Accipitrif… Accip… Acci… brevip…    -999 Levant…    363.    4          1
## 6 Aves  Accipitrif… Accip… Acci… castan…    -999 Chestn…   -999  -999       -999
## # … with 26 more variables: adult_body_mass_g <dbl>, maximum_longevity_y <dbl>,
## #   gestation_d <dbl>, weaning_d <dbl>, birth_or_hatching_weight_g <dbl>,
## #   weaning_weight_g <dbl>, egg_mass_g <dbl>, incubation_d <dbl>,
## #   fledging_age_d <dbl>, longevity_y <dbl>, male_maturity_d <dbl>,
## #   inter_litter_or_interbirth_interval_y <dbl>, female_body_mass_g <dbl>,
## #   male_body_mass_g <dbl>, no_sex_body_mass_g <dbl>, egg_width_mm <dbl>,
## #   egg_length_mm <dbl>, fledging_mass_g <dbl>, adult_svl_cm <dbl>, …
```

```r
glimpse(amniota)
```

```
## Rows: 21,322
## Columns: 36
## $ class                                 <chr> "Aves", "Aves", "Aves", "Aves", …
## $ order                                 <chr> "Accipitriformes", "Accipitrifor…
## $ family                                <chr> "Accipitridae", "Accipitridae", …
## $ genus                                 <chr> "Accipiter", "Accipiter", "Accip…
## $ species                               <chr> "albogularis", "badius", "bicolo…
## $ subspecies                            <dbl> -999, -999, -999, -999, -999, -9…
## $ common_name                           <chr> "Pied Goshawk", "Shikra", "Bicol…
## $ female_maturity_d                     <dbl> -999.000, 363.468, -999.000, -99…
## $ litter_or_clutch_size_n               <dbl> -999.000, 3.250, 2.700, -999.000…
## $ litters_or_clutches_per_y             <dbl> -999, 1, -999, -999, 1, -999, -9…
## $ adult_body_mass_g                     <dbl> 251.500, 140.000, 345.000, 142.0…
## $ maximum_longevity_y                   <dbl> -999.00000, -999.00000, -999.000…
## $ gestation_d                           <dbl> -999, -999, -999, -999, -999, -9…
## $ weaning_d                             <dbl> -999, -999, -999, -999, -999, -9…
## $ birth_or_hatching_weight_g            <dbl> -999, -999, -999, -999, -999, -9…
## $ weaning_weight_g                      <dbl> -999, -999, -999, -999, -999, -9…
## $ egg_mass_g                            <dbl> -999.00, 21.00, 32.00, -999.00, …
## $ incubation_d                          <dbl> -999.00, 30.00, -999.00, -999.00…
## $ fledging_age_d                        <dbl> -999.00, 32.00, -999.00, -999.00…
## $ longevity_y                           <dbl> -999.00000, -999.00000, -999.000…
## $ male_maturity_d                       <dbl> -999, -999, -999, -999, -999, -9…
## $ inter_litter_or_interbirth_interval_y <dbl> -999, -999, -999, -999, -999, -9…
## $ female_body_mass_g                    <dbl> 352.500, 168.500, 390.000, -999.…
## $ male_body_mass_g                      <dbl> 223.000, 125.000, 212.000, 142.0…
## $ no_sex_body_mass_g                    <dbl> -999.0, 123.0, -999.0, -999.0, -…
## $ egg_width_mm                          <dbl> -999, -999, -999, -999, -999, -9…
## $ egg_length_mm                         <dbl> -999, -999, -999, -999, -999, -9…
## $ fledging_mass_g                       <dbl> -999, -999, -999, -999, -999, -9…
## $ adult_svl_cm                          <dbl> -999.00, 30.00, 39.50, -999.00, …
## $ male_svl_cm                           <dbl> -999, -999, -999, -999, -999, -9…
## $ female_svl_cm                         <dbl> -999, -999, -999, -999, -999, -9…
## $ birth_or_hatching_svl_cm              <dbl> -999, -999, -999, -999, -999, -9…
## $ female_svl_at_maturity_cm             <dbl> -999, -999, -999, -999, -999, -9…
## $ female_body_mass_at_maturity_g        <dbl> -999, -999, -999, -999, -999, -9…
## $ no_sex_svl_cm                         <dbl> -999, -999, -999, -999, -999, -9…
## $ no_sex_maturity_d                     <dbl> -999, -999, -999, -999, -999, -9…
```

**3. Do some exploratory analysis of the `amphibio` data set. Use the function(s) of your choice. Try to get an idea of how NA's are represented in the data.**  

```r
head(amphibio)
```

```
## # A tibble: 6 × 38
##   id     Order Family Genus Species   Fos   Ter   Aqu   Arb Leaves Flowers Seeds
##   <chr>  <chr> <chr>  <chr> <chr>   <dbl> <dbl> <dbl> <dbl>  <dbl>   <dbl> <dbl>
## 1 Anf00… Anura Allop… Allo… Alloph…    NA     1     1     1     NA      NA    NA
## 2 Anf00… Anura Alyti… Alyt… Alytes…    NA     1     1     1     NA      NA    NA
## 3 Anf00… Anura Alyti… Alyt… Alytes…    NA     1     1     1     NA      NA    NA
## 4 Anf00… Anura Alyti… Alyt… Alytes…    NA     1     1     1     NA      NA    NA
## 5 Anf00… Anura Alyti… Alyt… Alytes…    NA     1    NA     1     NA      NA    NA
## 6 Anf00… Anura Alyti… Alyt… Alytes…     1     1     1     1     NA      NA    NA
## # … with 26 more variables: Fruits <lgl>, Arthro <dbl>, Vert <dbl>, Diu <dbl>,
## #   Noc <dbl>, Crepu <dbl>, Wet_warm <dbl>, Wet_cold <dbl>, Dry_warm <dbl>,
## #   Dry_cold <dbl>, Body_mass_g <dbl>, Age_at_maturity_min_y <dbl>,
## #   Age_at_maturity_max_y <dbl>, Body_size_mm <dbl>,
## #   Size_at_maturity_min_mm <dbl>, Size_at_maturity_max_mm <dbl>,
## #   Longevity_max_y <dbl>, Litter_size_min_n <dbl>, Litter_size_max_n <dbl>,
## #   Reproductive_output_y <dbl>, Offspring_size_min_mm <dbl>, …
```

```r
glimpse(amphibio)
```

```
## Rows: 6,776
## Columns: 38
## $ id                      <chr> "Anf0001", "Anf0002", "Anf0003", "Anf0004", "A…
## $ Order                   <chr> "Anura", "Anura", "Anura", "Anura", "Anura", "…
## $ Family                  <chr> "Allophrynidae", "Alytidae", "Alytidae", "Alyt…
## $ Genus                   <chr> "Allophryne", "Alytes", "Alytes", "Alytes", "A…
## $ Species                 <chr> "Allophryne ruthveni", "Alytes cisternasii", "…
## $ Fos                     <dbl> NA, NA, NA, NA, NA, 1, 1, 1, 1, 1, 1, 1, 1, NA…
## $ Ter                     <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
## $ Aqu                     <dbl> 1, 1, 1, 1, NA, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
## $ Arb                     <dbl> 1, 1, 1, 1, 1, 1, NA, NA, NA, NA, NA, NA, NA, …
## $ Leaves                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ Flowers                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ Seeds                   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ Fruits                  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ Arthro                  <dbl> 1, 1, 1, NA, 1, 1, 1, 1, 1, NA, 1, 1, NA, NA, …
## $ Vert                    <dbl> NA, NA, NA, NA, NA, NA, 1, NA, NA, NA, 1, 1, N…
## $ Diu                     <dbl> 1, NA, NA, NA, NA, NA, 1, 1, 1, NA, 1, 1, NA, …
## $ Noc                     <dbl> 1, 1, 1, NA, 1, 1, 1, 1, 1, NA, 1, 1, 1, NA, N…
## $ Crepu                   <dbl> 1, NA, NA, NA, NA, 1, NA, NA, NA, NA, NA, NA, …
## $ Wet_warm                <dbl> NA, NA, NA, NA, 1, 1, NA, NA, NA, NA, 1, NA, N…
## $ Wet_cold                <dbl> 1, NA, NA, NA, NA, NA, 1, NA, NA, NA, NA, NA, …
## $ Dry_warm                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ Dry_cold                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ Body_mass_g             <dbl> 31.00, 6.10, NA, NA, 2.31, 13.40, 21.80, NA, N…
## $ Age_at_maturity_min_y   <dbl> NA, 2.0, 2.0, NA, 3.0, 2.0, 3.0, NA, NA, NA, 4…
## $ Age_at_maturity_max_y   <dbl> NA, 2.0, 2.0, NA, 3.0, 3.0, 5.0, NA, NA, NA, 4…
## $ Body_size_mm            <dbl> 31.0, 50.0, 55.0, NA, 40.0, 55.0, 80.0, 60.0, …
## $ Size_at_maturity_min_mm <dbl> NA, 27, NA, NA, NA, 35, NA, NA, NA, NA, NA, NA…
## $ Size_at_maturity_max_mm <dbl> NA, 36.0, NA, NA, NA, 40.5, NA, NA, NA, NA, NA…
## $ Longevity_max_y         <dbl> NA, 6, NA, NA, NA, 7, 9, NA, NA, NA, NA, NA, N…
## $ Litter_size_min_n       <dbl> 300, 60, 40, NA, 7, 53, 300, 1500, 1000, NA, 2…
## $ Litter_size_max_n       <dbl> 300, 180, 40, NA, 20, 171, 1500, 1500, 1000, N…
## $ Reproductive_output_y   <dbl> 1, 4, 1, 4, 1, 4, 6, 1, 1, 1, 1, 1, 1, 1, NA, …
## $ Offspring_size_min_mm   <dbl> NA, 2.6, NA, NA, 5.4, 2.6, 1.5, NA, 1.5, NA, 1…
## $ Offspring_size_max_mm   <dbl> NA, 3.5, NA, NA, 7.0, 5.0, 2.0, NA, 1.5, NA, 1…
## $ Dir                     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, N…
## $ Lar                     <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, N…
## $ Viv                     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, N…
## $ OBS                     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
```

**4. How many total NA's are in each data set? Do these values make sense? Are NA's represented by values?**   

`amniota`  

```r
## for some reason, the code below raises the following error:
### Error in `na_if()`:
### ! Can't convert `y` <double> to match type of `x` <spec_tbl_df>.
# amniota_tidy <- amniota %>%
#   na_if(-999) %>%
#   janitor::clean_names()

## so, I'm going to use the following code instead:
amniota_tidy <- amniota %>% clean_names()
amniota_tidy[amniota_tidy == -999] <- NA
head(amniota_tidy)
```

```
## # A tibble: 6 × 36
##   class order       family genus species subsp…¹ commo…² femal…³ litte…⁴ litte…⁵
##   <chr> <chr>       <chr>  <chr> <chr>     <dbl> <chr>     <dbl>   <dbl>   <dbl>
## 1 Aves  Accipitrif… Accip… Acci… albogu…      NA Pied G…     NA    NA         NA
## 2 Aves  Accipitrif… Accip… Acci… badius       NA Shikra     363.    3.25       1
## 3 Aves  Accipitrif… Accip… Acci… bicolor      NA Bicolo…     NA     2.7       NA
## 4 Aves  Accipitrif… Accip… Acci… brachy…      NA New Br…     NA    NA         NA
## 5 Aves  Accipitrif… Accip… Acci… brevip…      NA Levant…    363.    4          1
## 6 Aves  Accipitrif… Accip… Acci… castan…      NA Chestn…     NA    NA         NA
## # … with 26 more variables: adult_body_mass_g <dbl>, maximum_longevity_y <dbl>,
## #   gestation_d <dbl>, weaning_d <dbl>, birth_or_hatching_weight_g <dbl>,
## #   weaning_weight_g <dbl>, egg_mass_g <dbl>, incubation_d <dbl>,
## #   fledging_age_d <dbl>, longevity_y <dbl>, male_maturity_d <dbl>,
## #   inter_litter_or_interbirth_interval_y <dbl>, female_body_mass_g <dbl>,
## #   male_body_mass_g <dbl>, no_sex_body_mass_g <dbl>, egg_width_mm <dbl>,
## #   egg_length_mm <dbl>, fledging_mass_g <dbl>, adult_svl_cm <dbl>, …
```

```r
miss_var_summary(amniota_tidy)
```

```
## # A tibble: 36 × 3
##    variable                       n_miss pct_miss
##    <chr>                           <int>    <dbl>
##  1 subspecies                      21322    100  
##  2 female_body_mass_at_maturity_g  21318    100. 
##  3 female_svl_at_maturity_cm       21120     99.1
##  4 fledging_mass_g                 21111     99.0
##  5 male_svl_cm                     21040     98.7
##  6 no_sex_maturity_d               20860     97.8
##  7 egg_width_mm                    20727     97.2
##  8 egg_length_mm                   20702     97.1
##  9 weaning_weight_g                20258     95.0
## 10 female_svl_cm                   20242     94.9
## # … with 26 more rows
```

```r
## another workaround
amniota_tidy_2 <- amniota %>%
  mutate(across(where(is.numeric), ~ na_if(., -999))) %>%
  mutate(across(where(is.character), ~ na_if(., "-999"))) %>%
  clean_names()
head(amniota_tidy_2)
```

```
## # A tibble: 6 × 36
##   class order       family genus species subsp…¹ commo…² femal…³ litte…⁴ litte…⁵
##   <chr> <chr>       <chr>  <chr> <chr>     <dbl> <chr>     <dbl>   <dbl>   <dbl>
## 1 Aves  Accipitrif… Accip… Acci… albogu…      NA Pied G…     NA    NA         NA
## 2 Aves  Accipitrif… Accip… Acci… badius       NA Shikra     363.    3.25       1
## 3 Aves  Accipitrif… Accip… Acci… bicolor      NA Bicolo…     NA     2.7       NA
## 4 Aves  Accipitrif… Accip… Acci… brachy…      NA New Br…     NA    NA         NA
## 5 Aves  Accipitrif… Accip… Acci… brevip…      NA Levant…    363.    4          1
## 6 Aves  Accipitrif… Accip… Acci… castan…      NA Chestn…     NA    NA         NA
## # … with 26 more variables: adult_body_mass_g <dbl>, maximum_longevity_y <dbl>,
## #   gestation_d <dbl>, weaning_d <dbl>, birth_or_hatching_weight_g <dbl>,
## #   weaning_weight_g <dbl>, egg_mass_g <dbl>, incubation_d <dbl>,
## #   fledging_age_d <dbl>, longevity_y <dbl>, male_maturity_d <dbl>,
## #   inter_litter_or_interbirth_interval_y <dbl>, female_body_mass_g <dbl>,
## #   male_body_mass_g <dbl>, no_sex_body_mass_g <dbl>, egg_width_mm <dbl>,
## #   egg_length_mm <dbl>, fledging_mass_g <dbl>, adult_svl_cm <dbl>, …
```

```r
miss_var_summary(amniota_tidy_2)
```

```
## # A tibble: 36 × 3
##    variable                       n_miss pct_miss
##    <chr>                           <int>    <dbl>
##  1 subspecies                      21322    100  
##  2 female_body_mass_at_maturity_g  21318    100. 
##  3 female_svl_at_maturity_cm       21120     99.1
##  4 fledging_mass_g                 21111     99.0
##  5 male_svl_cm                     21040     98.7
##  6 no_sex_maturity_d               20860     97.8
##  7 egg_width_mm                    20727     97.2
##  8 egg_length_mm                   20702     97.1
##  9 weaning_weight_g                20258     95.0
## 10 female_svl_cm                   20242     94.9
## # … with 26 more rows
```


```r
## the above two methods should produce the same results, howvever, they don't
identical(amniota_tidy, amniota_tidy_2)
```

```
## [1] FALSE
```

`amphibio`  

```r
amphibio_tidy <- amphibio %>% clean_names()
miss_var_summary(amphibio_tidy)
```

```
## # A tibble: 38 × 3
##    variable n_miss pct_miss
##    <chr>     <int>    <dbl>
##  1 fruits     6774    100. 
##  2 flowers    6772     99.9
##  3 seeds      6772     99.9
##  4 leaves     6752     99.6
##  5 dry_cold   6735     99.4
##  6 vert       6657     98.2
##  7 obs        6651     98.2
##  8 wet_cold   6625     97.8
##  9 crepu      6608     97.5
## 10 dry_warm   6572     97.0
## # … with 28 more rows
```

**5. Make any necessary replacements in the data such that all NA's appear as "NA".**   

```r
head(amniota_tidy)
```

```
## # A tibble: 6 × 36
##   class order       family genus species subsp…¹ commo…² femal…³ litte…⁴ litte…⁵
##   <chr> <chr>       <chr>  <chr> <chr>     <dbl> <chr>     <dbl>   <dbl>   <dbl>
## 1 Aves  Accipitrif… Accip… Acci… albogu…      NA Pied G…     NA    NA         NA
## 2 Aves  Accipitrif… Accip… Acci… badius       NA Shikra     363.    3.25       1
## 3 Aves  Accipitrif… Accip… Acci… bicolor      NA Bicolo…     NA     2.7       NA
## 4 Aves  Accipitrif… Accip… Acci… brachy…      NA New Br…     NA    NA         NA
## 5 Aves  Accipitrif… Accip… Acci… brevip…      NA Levant…    363.    4          1
## 6 Aves  Accipitrif… Accip… Acci… castan…      NA Chestn…     NA    NA         NA
## # … with 26 more variables: adult_body_mass_g <dbl>, maximum_longevity_y <dbl>,
## #   gestation_d <dbl>, weaning_d <dbl>, birth_or_hatching_weight_g <dbl>,
## #   weaning_weight_g <dbl>, egg_mass_g <dbl>, incubation_d <dbl>,
## #   fledging_age_d <dbl>, longevity_y <dbl>, male_maturity_d <dbl>,
## #   inter_litter_or_interbirth_interval_y <dbl>, female_body_mass_g <dbl>,
## #   male_body_mass_g <dbl>, no_sex_body_mass_g <dbl>, egg_width_mm <dbl>,
## #   egg_length_mm <dbl>, fledging_mass_g <dbl>, adult_svl_cm <dbl>, …
```

```r
head(amphibio_tidy)
```

```
## # A tibble: 6 × 38
##   id     order family genus species   fos   ter   aqu   arb leaves flowers seeds
##   <chr>  <chr> <chr>  <chr> <chr>   <dbl> <dbl> <dbl> <dbl>  <dbl>   <dbl> <dbl>
## 1 Anf00… Anura Allop… Allo… Alloph…    NA     1     1     1     NA      NA    NA
## 2 Anf00… Anura Alyti… Alyt… Alytes…    NA     1     1     1     NA      NA    NA
## 3 Anf00… Anura Alyti… Alyt… Alytes…    NA     1     1     1     NA      NA    NA
## 4 Anf00… Anura Alyti… Alyt… Alytes…    NA     1     1     1     NA      NA    NA
## 5 Anf00… Anura Alyti… Alyt… Alytes…    NA     1    NA     1     NA      NA    NA
## 6 Anf00… Anura Alyti… Alyt… Alytes…     1     1     1     1     NA      NA    NA
## # … with 26 more variables: fruits <lgl>, arthro <dbl>, vert <dbl>, diu <dbl>,
## #   noc <dbl>, crepu <dbl>, wet_warm <dbl>, wet_cold <dbl>, dry_warm <dbl>,
## #   dry_cold <dbl>, body_mass_g <dbl>, age_at_maturity_min_y <dbl>,
## #   age_at_maturity_max_y <dbl>, body_size_mm <dbl>,
## #   size_at_maturity_min_mm <dbl>, size_at_maturity_max_mm <dbl>,
## #   longevity_max_y <dbl>, litter_size_min_n <dbl>, litter_size_max_n <dbl>,
## #   reproductive_output_y <dbl>, offspring_size_min_mm <dbl>, …
```

**6. Use the package `naniar` to produce a summary, including percentages, of missing data in each column for the `amniota` data.**  

```r
miss_var_summary(amniota_tidy)
```

```
## # A tibble: 36 × 3
##    variable                       n_miss pct_miss
##    <chr>                           <int>    <dbl>
##  1 subspecies                      21322    100  
##  2 female_body_mass_at_maturity_g  21318    100. 
##  3 female_svl_at_maturity_cm       21120     99.1
##  4 fledging_mass_g                 21111     99.0
##  5 male_svl_cm                     21040     98.7
##  6 no_sex_maturity_d               20860     97.8
##  7 egg_width_mm                    20727     97.2
##  8 egg_length_mm                   20702     97.1
##  9 weaning_weight_g                20258     95.0
## 10 female_svl_cm                   20242     94.9
## # … with 26 more rows
```

**7. Use the package `naniar` to produce a summary, including percentages, of missing data in each column for the `amphibio` data.**

```r
miss_var_summary(amphibio_tidy)
```

```
## # A tibble: 38 × 3
##    variable n_miss pct_miss
##    <chr>     <int>    <dbl>
##  1 fruits     6774    100. 
##  2 flowers    6772     99.9
##  3 seeds      6772     99.9
##  4 leaves     6752     99.6
##  5 dry_cold   6735     99.4
##  6 vert       6657     98.2
##  7 obs        6651     98.2
##  8 wet_cold   6625     97.8
##  9 crepu      6608     97.5
## 10 dry_warm   6572     97.0
## # … with 28 more rows
```

**8. For the `amniota` data, calculate the number of NAs in the `egg_mass_g` column sorted by taxonomic class; i.e. how many NA's are present in the `egg_mass_g` column in birds, mammals, and reptiles? Does this results make sense biologically? How do these results affect your interpretation of NA's?**  

```r
amniota_tidy %>%
  group_by(class) %>%
  summarise(
    na_count = sum(is.na(egg_mass_g)),
    total_count = n(),
    na_percent = sum(is.na(egg_mass_g)) / n() * 100
  )
```

```
## # A tibble: 3 × 4
##   class    na_count total_count na_percent
##   <chr>       <int>       <int>      <dbl>
## 1 Aves         4914        9802       50.1
## 2 Mammalia     4953        4953      100  
## 3 Reptilia     6040        6567       92.0
```

**9. The `amphibio` data have variables that classify species as fossorial (burrowing), terrestrial, aquatic, or arboreal. Calculate the number of NA's in each of these variables. Do you think that the authors intend us to think that there are NA's in these columns or could they represent something else? Explain.**

```r
names(amphibio_tidy)
```

```
##  [1] "id"                      "order"                  
##  [3] "family"                  "genus"                  
##  [5] "species"                 "fos"                    
##  [7] "ter"                     "aqu"                    
##  [9] "arb"                     "leaves"                 
## [11] "flowers"                 "seeds"                  
## [13] "fruits"                  "arthro"                 
## [15] "vert"                    "diu"                    
## [17] "noc"                     "crepu"                  
## [19] "wet_warm"                "wet_cold"               
## [21] "dry_warm"                "dry_cold"               
## [23] "body_mass_g"             "age_at_maturity_min_y"  
## [25] "age_at_maturity_max_y"   "body_size_mm"           
## [27] "size_at_maturity_min_mm" "size_at_maturity_max_mm"
## [29] "longevity_max_y"         "litter_size_min_n"      
## [31] "litter_size_max_n"       "reproductive_output_y"  
## [33] "offspring_size_min_mm"   "offspring_size_max_mm"  
## [35] "dir"                     "lar"                    
## [37] "viv"                     "obs"
```

```r
amphibio_tidy %>%
  group_by(fos, ter, aqu, arb) %>%
  summarise(
    count = n(),
    na_count = sum(is.na(fos) & is.na(ter) & is.na(aqu) & is.na(arb))
  ) %>%
  arrange(-count)
```

```
## `summarise()` has grouped output by 'fos', 'ter', 'aqu'. You can override using
## the `.groups` argument.
```

```
## # A tibble: 15 × 6
## # Groups:   fos, ter, aqu [8]
##      fos   ter   aqu   arb count na_count
##    <dbl> <dbl> <dbl> <dbl> <int>    <int>
##  1    NA     1     1    NA  1997        0
##  2    NA     1     1     1  1165        0
##  3    NA     1    NA    NA  1039        0
##  4    NA     1    NA     1   846        0
##  5     1     1     1    NA   534        0
##  6    NA    NA    NA    NA   483      483
##  7    NA    NA    NA     1   310        0
##  8    NA    NA     1    NA   116        0
##  9    NA    NA     1     1    97        0
## 10     1     1    NA    NA    82        0
## 11     1    NA     1    NA    56        0
## 12     1    NA    NA    NA    40        0
## 13     1     1    NA     1     8        0
## 14     1    NA    NA     1     2        0
## 15     1     1     1     1     1        0
```

**10. Now that we know how NA's are represented in the `amniota` data, how would you load the data such that the values which represent NA's are automatically converted?**

```r
amniota_ <- read_csv("./data/amniota.csv", na = c("-999"))
```

```
## Warning: One or more parsing issues, call `problems()` on your data frame for details,
## e.g.:
##   dat <- vroom(...)
##   problems(dat)
```

```
## Rows: 21322 Columns: 36
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (6): class, order, family, genus, species, common_name
## dbl (28): female_maturity_d, litter_or_clutch_size_n, litters_or_clutches_pe...
## lgl  (2): subspecies, female_body_mass_at_maturity_g
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
problems(amniota_)
```

```
## # A tibble: 4 × 5
##     row   col expected           actual file 
##   <int> <int> <chr>              <chr>  <chr>
## 1 10410    34 1/0/T/F/TRUE/FALSE 194000 ""   
## 2 10411    34 1/0/T/F/TRUE/FALSE 194000 ""   
## 3 12601    34 1/0/T/F/TRUE/FALSE 100    ""   
## 4 12646    34 1/0/T/F/TRUE/FALSE 30     ""
```

```r
head(amniota_[, 34], n=3)  # female_body_mass_at_maturity_g was lgl, should be dbl
```

```
## # A tibble: 3 × 1
##   female_body_mass_at_maturity_g
##   <lgl>                         
## 1 NA                            
## 2 NA                            
## 3 NA
```

```r
amniota_ <- read.csv("./data/amniota.csv", na = c("-999")) %>%
  mutate_if(is.logical, as.numeric)
glimpse(amniota_)
```

```
## Rows: 21,322
## Columns: 36
## $ class                                 <chr> "Aves", "Aves", "Aves", "Aves", …
## $ order                                 <chr> "Accipitriformes", "Accipitrifor…
## $ family                                <chr> "Accipitridae", "Accipitridae", …
## $ genus                                 <chr> "Accipiter", "Accipiter", "Accip…
## $ species                               <chr> "albogularis", "badius", "bicolo…
## $ subspecies                            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ common_name                           <chr> "Pied Goshawk", "Shikra", "Bicol…
## $ female_maturity_d                     <dbl> NA, 363.468, NA, NA, 363.468, NA…
## $ litter_or_clutch_size_n               <dbl> NA, 3.250, 2.700, NA, 4.000, NA,…
## $ litters_or_clutches_per_y             <dbl> NA, 1, NA, NA, 1, NA, NA, 1, NA,…
## $ adult_body_mass_g                     <dbl> 251.500, 140.000, 345.000, 142.0…
## $ maximum_longevity_y                   <dbl> NA, NA, NA, NA, NA, NA, NA, 19.9…
## $ gestation_d                           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ weaning_d                             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ birth_or_hatching_weight_g            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ weaning_weight_g                      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ egg_mass_g                            <dbl> NA, 21.00, 32.00, NA, 21.85, NA,…
## $ incubation_d                          <dbl> NA, 30.00, NA, NA, 32.50, NA, NA…
## $ fledging_age_d                        <dbl> NA, 32.00, NA, NA, 42.50, NA, NA…
## $ longevity_y                           <dbl> NA, NA, NA, NA, NA, NA, NA, 12.5…
## $ male_maturity_d                       <dbl> NA, NA, NA, NA, NA, NA, NA, 365,…
## $ inter_litter_or_interbirth_interval_y <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ female_body_mass_g                    <dbl> 352.500, 168.500, 390.000, NA, 2…
## $ male_body_mass_g                      <dbl> 223.000, 125.000, 212.000, 142.0…
## $ no_sex_body_mass_g                    <dbl> NA, 123.0, NA, NA, NA, NA, NA, 1…
## $ egg_width_mm                          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ egg_length_mm                         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ fledging_mass_g                       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ adult_svl_cm                          <dbl> NA, 30.00, 39.50, NA, 33.50, NA,…
## $ male_svl_cm                           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ female_svl_cm                         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ birth_or_hatching_svl_cm              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ female_svl_at_maturity_cm             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ female_body_mass_at_maturity_g        <int> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ no_sex_svl_cm                         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
## $ no_sex_maturity_d                     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
```

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.  
