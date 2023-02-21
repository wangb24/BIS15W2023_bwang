---
title: "Lab 11 Homework"
author: "Bode W"
date: "2023-02-20"
output:
  html_document:
    theme: spacelab
    toc: no
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above. For any included plots, make sure they are clearly labeled. You are free to use any plot type that you feel best communicates the results of your analysis.  

**In this homework, you should make use of the aesthetics you have learned. It's OK to be flashy!**

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the libraries

```r
library(tidyverse)
library(janitor)
library(here)
library(naniar)
```

## Resources
The idea for this assignment came from [Rebecca Barter's](http://www.rebeccabarter.com/blog/2017-11-17-ggplot2_tutorial/) ggplot tutorial so if you get stuck this is a good place to have a look.  

## Gapminder
For this assignment, we are going to use the dataset [gapminder](https://cran.r-project.org/web/packages/gapminder/index.html). Gapminder includes information about economics, population, and life expectancy from countries all over the world. You will need to install it before use. This is the same data that we will use for midterm 2 so this is good practice.


```r
#install.packages("gapminder")
library("gapminder")
```

## Questions
The questions below are open-ended and have many possible solutions. Your approach should, where appropriate, include numerical summaries and visuals. Be creative; assume you are building an analysis that you would ultimately present to an audience of stakeholders. Feel free to try out different `geoms` if they more clearly present your results.  

**1. Use the function(s) of your choice to get an idea of the overall structure of the data frame, including its dimensions, column names, variable classes, etc. As part of this, determine how NA's are treated in the data.**  


```r
glimpse(gapminder)
```

```
## Rows: 1,704
## Columns: 6
## $ country   <fct> "Afghanistan", "Afghanistan", "Afghanistan", "Afghanistan", …
## $ continent <fct> Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, …
## $ year      <int> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, …
## $ lifeExp   <dbl> 28.801, 30.332, 31.997, 34.020, 36.088, 38.438, 39.854, 40.8…
## $ pop       <int> 8425333, 9240934, 10267083, 11537966, 13079460, 14880372, 12…
## $ gdpPercap <dbl> 779.4453, 820.8530, 853.1007, 836.1971, 739.9811, 786.1134, …
```


```r
miss_var_summary(gapminder)
```

```
## # A tibble: 6 × 3
##   variable  n_miss pct_miss
##   <chr>      <int>    <dbl>
## 1 country        0        0
## 2 continent      0        0
## 3 year           0        0
## 4 lifeExp        0        0
## 5 pop            0        0
## 6 gdpPercap      0        0
```

```r
gapminder %>%
  select(-where(is.factor)) %>%
  summarize_all(list(~ min(.), ~ max(.)))
```

```
## # A tibble: 1 × 8
##   year_min lifeExp_min pop_min gdpPercap_min year_max lifeExp_…¹ pop_max gdpPe…²
##      <int>       <dbl>   <int>         <dbl>    <int>      <dbl>   <int>   <dbl>
## 1     1952        23.6   60011          241.     2007       82.6  1.32e9 113523.
## # … with abbreviated variable names ¹​lifeExp_max, ²​gdpPercap_max
```

**2. Among the interesting variables in gapminder is life expectancy. How has global life expectancy changed between 1952 and 2007?**


```r
gapminder %>%
  group_by(year) %>%
  summarize(mean_life_expectancy = mean(lifeExp)) %>%
  ggplot(aes(x = year, y = mean_life_expectancy)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Global Life Expectancy by Year",
    x = "Year",
    y = "Mean Life Expectancy"
  )
```

![](lab11_hw_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

**3. How do the distributions of life expectancy compare for the years 1952 and 2007?**


```r
gapminder %>%
  filter(year == 1952 | year == 2007) %>%
  mutate(year = as.factor(year)) %>%
  ggplot(aes(x = lifeExp, y = factor(year), fill = year)) +
  geom_boxplot(alpha = 0.4) +
  labs(
    title = "Life Expectancy by Year",
    x = "Life Expectancy",
    y = "Year"
  ) +
  guides(fill = FALSE)
```

```
## Warning: The `<scale>` argument of `guides()` cannot be `FALSE`. Use "none" instead as
## of ggplot2 3.3.4.
```

![](lab11_hw_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

**4. Your answer above doesn't tell the whole story since life expectancy varies by region. Make a summary that shows the min, mean, and max life expectancy by continent for all years represented in the data.**


```r
gapminder %>%
  group_by(continent, year) %>%
  summarize(
    min_lifeExp = min(lifeExp),
    mean_lifeExp = mean(lifeExp),
    max_lifeExp = max(lifeExp),
    .groups = "keep"
  ) %>%
  ggplot() +
  geom_line(aes(x = year, y = mean_lifeExp, color = continent)) +
  geom_point(aes(x = year, y = mean_lifeExp, color = continent)) +
  geom_ribbon(
    aes(
      x = year,
      ymin = min_lifeExp,
      ymax = max_lifeExp,
      fill = continent
    ),
    alpha = 0.17
  ) +
  labs(
    title = "Life Expectancy by Continent",
    x = "Year",
    y = "Life Expectancy"
  )
```

![](lab11_hw_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

**5. How has life expectancy changed between 1952-2007 for each continent?**


```r
stat_ <- gapminder %>%
  group_by(continent, year) %>%
  summarize(
    min_lifeExp = min(lifeExp),
    mean_lifeExp = mean(lifeExp),
    max_lifeExp = max(lifeExp),
    .groups = "keep"
  )

gapminder %>%
  ggplot() +
  geom_jitter(aes(x = year, y = lifeExp, color = continent), alpha = 0.4) +
  geom_line(
    aes(
      x = year,
      y = lifeExp,
      color = continent
    ),
    stat = "summary",
    fun = mean
  ) +
  labs(
    title = "Life Expectancy by Continent",
    x = "Year",
    y = "Life Expectancy"
  )
```

![](lab11_hw_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

**6. We are interested in the relationship between per capita GDP and life expectancy; i.e. does having more money help you live longer?**


```r
gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, color = continent, shape = continent)) +
  geom_point(alpha = 0.5, size = 2) +
  scale_x_log10() +
  scale_y_log10() +
  labs(
    title = "Life Expectancy by GDP",
    x = "GDP per Capita",
    y = "Life Expectancy"
  )
```

![](lab11_hw_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

**7. Which countries have had the largest population growth since 1952?**


```r
result <- gapminder %>%
  select(country, year, pop) %>%
  pivot_wider(
    names_from = year,
    values_from = pop,
    names_prefix = "pop_"
  ) %>%
  mutate(
    pop_growth = pop_2007 - pop_1952
  ) %>%
  select(country, pop_growth) %>%
  arrange(desc(pop_growth))
result %>% head(10)
```

```
## # A tibble: 10 × 2
##    country       pop_growth
##    <fct>              <int>
##  1 China          762419569
##  2 India          738396331
##  3 United States  143586947
##  4 Indonesia      141495000
##  5 Brazil         133408087
##  6 Pakistan       127924057
##  7 Bangladesh     103561480
##  8 Nigeria        101912068
##  9 Mexico          78556574
## 10 Philippines     68638596
```

**8. Use your results from the question above to plot population growth for the top five countries since 1952.**


```r
result %>%
  slice_max(pop_growth, n = 5) %>%
  ggplot(aes(x = reorder(country, pop_growth), y = pop_growth)) +
  geom_col() +
  labs(
    title = "Population Growth by Country",
    subtitle = "Top 5 Countries",
    x = "Country",
    y = "Population Growth"
  ) +
  coord_flip()
```

![](lab11_hw_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

**9. How does per-capita GDP growth compare between these same five countries?**


```r
countries <- result %>%
  slice_max(pop_growth, n = 5) %>%
  pull(country)

gapminder %>%
  filter(country %in% countries) %>%
  select(country, year, gdpPercap) %>%
  pivot_wider(
    names_from = year,
    values_from = gdpPercap,
    names_prefix = "gdpPercap_"
  ) %>%
  mutate(
    gdpPercap_growth = gdpPercap_2007 - gdpPercap_1952
  ) %>%
  select(country, gdpPercap_growth) %>%
  arrange(desc(gdpPercap_growth)) %>%
  ggplot(aes(x = reorder(country, gdpPercap_growth), y = gdpPercap_growth)) +
  geom_col() +
  labs(
    title = "GDP Growth by Country",
    subtitle = "Top 5 Countries",
    x = "Country",
    y = "GDP Growth"
  ) +
  coord_flip()
```

![](lab11_hw_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

<!-- **10. Make one plot of your choice that uses faceting!** -->



## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences. 
