
<!-- README.md is generated from README.Rmd. Please edit that file -->

# polygon

<div data-align="center">

<!-- hex -->

<!-- <img src="./man/figures/logo.png" height = "200px" /> -->

<!-- badges: start -->

<!-- Experimental -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<!-- [![Travis build status](https://travis-ci.org/eokodie/polygon.svg?branch=main)](https://travis-ci.org/eokodie/polygon)  -->

<!-- [![Codecov test coverage](https://codecov.io/gh/eokodie/polygon/branch/master/graph/badge.svg)](https://codecov.io/gh/eokodie/polygon?branch=main) -->

<!-- badges: end -->

<!-- links start -->

<!-- links end -->

</div>

> A WebSocket & RESTful API client for [Polygon](https://polygon.io).

This package is under active development. The API is likely to change
and some features are incomplete.

## Installation

**polygon** is not yet on CRAN. You can install from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("eokodie/polygon", ref = "main")
```

## Exampes

We can download quotes data from the REST API with:

``` r
token = Sys.getenv("polygon_token")
data <- polygon::get_aggregates(
  token,
  ticker = "AAPL",
  multiplier = 15,
  timespan = "minute",
  from = "2020-11-03",
  to = "2020-11-03"
) 
df <- head(data, 20)
df
# # A tibble: 20 x 6
#    volume  open close  high   low time               
#     <dbl> <dbl> <dbl> <dbl> <dbl> <dttm>             
#  1  18873  113.  113.  113.  113. 2020-10-06 22:20:00
#  2  19200  113.  113.  113.  113. 2020-10-06 22:25:00
#  3  48628  113.  113.  113.  113. 2020-10-06 22:30:00
#  4  18053  113.  113.  113.  113. 2020-10-06 22:35:00
#  5  26782  113.  113.  113.  113. 2020-10-06 22:40:00
#  6  35494  113.  113.  113.  113. 2020-10-06 22:45:00
#  7  53465  113.  113.  113.  113. 2020-10-06 22:50:00
#  8  22497  113.  113.  113.  113. 2020-10-06 22:55:00
#  9  27947  113.  113.  113.  113. 2020-10-06 23:00:00
# 10  14125  113.  113.  113.  113. 2020-10-06 23:05:00
```

Which looks like this:

``` r
# remotes::install_github("eokodie/fivethemes", ref = "main")
fivethemes:::plot_candlestick(df, title = "Apple Inc.")
```

<img src="man/figures/candlestick.png" width="100%" />
