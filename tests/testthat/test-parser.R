context("parser")
token <- Sys.getenv("ZC_TOKEN")
skip_if(token == "")

readings <- zc_readings(token = token,
  sn = "z6-00033",
  start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01"))
)

ts <- zc_timeseries(readings)

test_that("zc_timeseries returns errors", {
  expect_error(zc_timeseries(1),
               regexp = "is not TRUE")
})

test_that("zc_timeseries returns correct object", {
  expect_is(ts, "data.frame")
  expect_equal(names(ts),
    c("datetime", "mrid", "rssi", "value", "units", "description", "error"))
})
