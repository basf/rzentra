context("zc_statuses")

token <- Sys.getenv("ZC_TOKEN")
test_that("zc_statuses returns errors", {
  expect_error(zc_statuses(token = "aaa", sn = "z6-00033"),
               regexp = "Invalid token.")
  skip_if(token == "")
  expect_error(zc_statuses(token = token, sn = "aaa"),
               regexp = "Missing query string parameter.")
})


skip_if(token == "")
statuses <- zc_statuses(token = token,
                        sn = "z6-00033",
                        start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01"))
)

test_that("zc_statuses works as expected", {
  expect_is(statuses, "list")
  expect_true(
    all(names(statuses) %in% c("device", "get_status_ver", "created")))
})
