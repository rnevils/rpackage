test_that("valid_api_call works with valid API key", {
  correct_result <- 200
  api_key <- "AIzaSyBjorH1zc5D9qpWHpQ7q-leDqS-bfadX3U"
  my_result <- valid_api_call(api_key)
  expect_equal(my_result, correct_result)
})

test_that("valid_api_call doesn't work with bad API key", {
  correct_result <- 400
  bad_api_key <- "badbad8207181910apikey"
  my_result <- valid_api_call(bad_api_key)
  expect_equal(my_result, correct_result)
})


