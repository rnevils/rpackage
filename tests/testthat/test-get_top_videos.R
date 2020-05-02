test_that("check that get_region_list works", {
  correct_result <- "Sweden"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  regions <- get_region_list(key)
  my_result <- regions$region[regions$regionId == "SE"]

  expect_equal(my_result, correct_result)
})

test_that("check that region_to_id works", {
  correct_result <- "GB"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  my_result <- region_to_id(key, region = "United Kingdom")

  expect_equal(my_result, correct_result)
})

test_that("check that get_category_list works", {
  correct_result <- "Family"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  cat <- get_category_list(key, region = "IS")
  my_result <- cat$category[cat$categoryId == "37"]

  expect_equal(my_result, correct_result)
})

test_that("check that category_to_id works", {
  correct_result <- "21"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  my_result <- category_to_id(key, region = "GB", category = "Videoblogging")

  expect_equal(my_result, correct_result)
})

test_that("check that validate_category works for valid response", {
  correct_result <- "valid"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  my_result <- validate_category(key, region = "GB", category = "Videoblogging")

  expect_equal(my_result, correct_result)
})

test_that("check that validate_category works for invalid response", {
  correct_result <- "invalid"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  my_result <- validate_category(key, region = "GB", category = "49")

  expect_equal(my_result, correct_result)
})

test_that("check that validate_region works for valid response", {
  correct_result <- "valid"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  my_result <- validate_region(key, region = "Iceland")

  expect_equal(my_result, correct_result)
})

test_that("check that validate_region works for invalid response", {
  correct_result <- "invalid"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  my_result <- validate_region(key, region = "IK")

  expect_equal(my_result, correct_result)
})

test_that("check that get_top_videos works with region", {
  correct_result <- "Iceland"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  videos <- get_top_videos(key, region = "Iceland")
  my_result <- videos$region[1]

  expect_equal(my_result, correct_result)
})

test_that("check that get_top_videos works with category", {
  correct_result <- "Iceland"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  videos <- get_top_videos(key, region = "Iceland", category = "Music")
  my_result <- videos$region[1]

  expect_equal(my_result, correct_result)
})

test_that("check that graph_top_videos_category works with category", {
  correct_result <- "Most Popular YouTube Videos in Sweden by Content Category"

  key <- "AIzaSyA1sCzxpFiBw6SG16MsWPE872_W4XfMRlE"

  graph <- graph_top_videos_category(key, n = 86, region = "Sweden")
  my_result <- graph$labels$title

  expect_equal(my_result, correct_result)
})
