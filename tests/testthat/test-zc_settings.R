context("zc_settings")

token <- Sys.getenv("ZC_TOKEN")
test_that("zc_settings returns errors", {
  expect_error(zc_settings(token = "aaa", sn = "z6-00033"),
               regexp = "Invalid token.")
  skip_if(token == "")
  expect_error(zc_settings(token = token, sn = "aaa"),
               regexp = "Zentracloud API request failed")
})


skip_if(token == "")
settings <- zc_settings(token = token,
                        sn = "z6-00033",
                        start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01"))
)

test_that("zc_settings works as expected", {
  expect_is(settings, "list")
  expect_true(
    all(names(settings) %in% c("device", "get_settings_ver", "created")))
})
