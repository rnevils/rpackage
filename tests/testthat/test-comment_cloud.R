test_that("valid_api_call works with valid key and video", {
  correct_result <- 200

  api_key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"
  video_id <- "QjA5faZF1A8"

  my_result <- valid_api_call_comment(api_key, video_id)

  expect_equal(my_result, correct_result)
})


test_that("valid_api_call works with bad key and video", {
  correct_result <- 400

  bad_api_key <- "AIzaSyA1sCzxpFidfdfsdfBw6SG16MsWPE872_W4XfMRlE"
  video_id <- "QjA5faZF1A8"

  my_result <- valid_api_call_comment(bad_api_key, video_id)

  expect_equal(my_result, correct_result)
})


test_that("valid_api_call works with valid key but bad video", {
  correct_result <- 404

  api_key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"
  bad_video_id <- "QjA5fadfdsfdZF1A8"

  my_result <- valid_api_call_comment(api_key, bad_video_id)

  expect_equal(my_result, correct_result)
})
