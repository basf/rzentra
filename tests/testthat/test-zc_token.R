context("zc_token")

test_that("zc_token returns error", {
  expect_error(zc_token("xxx", "xxx"))
  expect_error(zc_token("", "xxx"), regexp = "public_key is empty")
  expect_error(zc_token("xxx", ""), regexp = "private_key is empty")
})
