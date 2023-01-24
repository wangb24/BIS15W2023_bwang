### 1. Load the bison data.

    library(tidyverse)

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0      ✔ purrr   1.0.0 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.2.1      ✔ stringr 1.5.0 
    ## ✔ readr   2.1.3      ✔ forcats 0.5.2 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

    bison <- read_csv("data/bison.csv")

    ## Rows: 8325 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (3): data_code, animal_code, animal_sex
    ## dbl (5): rec_year, rec_month, rec_day, animal_weight, animal_yob
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    bison$animal_sex <- as.factor(bison$animal_sex)

### 2. What are the dimesions and structure of the data?

    dim(bison)

    ## [1] 8325    8

### 3. We are only interested in code, sex, weight, year of birth. Restrict the data to these variables and store the dataframe as a new object.

    names(bison)

    ## [1] "data_code"     "rec_year"      "rec_month"     "rec_day"      
    ## [5] "animal_code"   "animal_sex"    "animal_weight" "animal_yob"

    bison_interest <- bison %>% select(animal_code, animal_sex, animal_weight, animal_yob)
    head(bison_interest)

    ## # A tibble: 6 × 4
    ##   animal_code animal_sex animal_weight animal_yob
    ##   <chr>       <fct>              <dbl>      <dbl>
    ## 1 813         F                    890       1981
    ## 2 834         F                   1074       1983
    ## 3 B-301       F                   1060       1983
    ## 4 B-402       F                    989       1984
    ## 5 B-403       F                   1062       1984
    ## 6 B-502       F                    978       1985

### 4. Pull out the animals born between 1980-1990.

    bison_interest_btwn8090 <- bison_interest %>% filter(animal_yob >= 1980 & animal_yob <= 1990)
    head(bison_interest_btwn8090)

    ## # A tibble: 6 × 4
    ##   animal_code animal_sex animal_weight animal_yob
    ##   <chr>       <fct>              <dbl>      <dbl>
    ## 1 813         F                    890       1981
    ## 2 834         F                   1074       1983
    ## 3 B-301       F                   1060       1983
    ## 4 B-402       F                    989       1984
    ## 5 B-403       F                   1062       1984
    ## 6 B-502       F                    978       1985

    dim(bison_interest_btwn8090)

    ## [1] 435   4

### 5. How many male and female bison are represented between 1980-1990?

    table(bison_interest_btwn8090$animal_sex)

    ## 
    ##   F   M 
    ## 414  21

### 6. Between 1980-1990, were males or females larger on average?

    anyNA(bison_interest_btwn8090$animal_weight)

    ## [1] FALSE

    bison_interest_btwn8090[bison_interest_btwn8090$animal_sex=="M", ]$animal_weight %>% mean

    ## [1] 1543.333

    bison_interest_btwn8090[bison_interest_btwn8090$animal_sex=="F", ]$animal_weight %>% mean

    ## [1] 1017.314
