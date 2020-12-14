
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rzentra

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/rzentra)](https://CRAN.R-project.org/package=rzentra)
[![R build
status](https://github.com/basf/rzentra/workflows/R-CMD-check/badge.svg)](https://github.com/basf/rzentra/actions)
[![codecov](https://codecov.io/gh/basf/rzentra/branch/master/graph/badge.svg?token=DJ6PVJQLRZ)](https://codecov.io/gh/basf/rzentra)
<!-- badges: end -->

An R client for [Zentracloud
API](https://zentracloud.com/api/v1/guide#APIGuidelines).

## Installation

## Example

``` r
library("rzentra")
```

### Authentcation

To work with the API you first need to authenticate. The `zc_token()`
function authenticates you with your username and password and returns a
`token` that can be used in subsequent API-calls.

The `username` & `password` are by default read from environmental
variables `ZC_USERNAME` and `ZC_PASSWORD`, but you can provide them also
in every function call using the `username=` and `password=` arguments.

``` r
token <- zc_token(username = "yourname", password = "yourpassword")$token
```

### Querying data

#### Device settings

Querying the settings of a device can be done with `zc_settings`

``` r
zc_settings(token = token, 
  sn = "z6-00033", 
  start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01"))
  )
```

#### Device statuses

Querying the settings of a device can be done with `zc_statuses`

``` r
zc_statuses(token = token, 
  sn = "z6-00033", 
  start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01"))
  )
```

#### Device readings

``` r
zc_readings(token = token, 
  sn = "z6-00033", 
  start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01"))
  )
```

### Parsing data

Readings can be parsed into a long time-series table with
`zc_timeseries()`

``` r
head(
  zc_timeseries(readings)
)
```
