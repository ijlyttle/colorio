test_that("colorio_version() works", {

  expect_type(colorio_version(), "character")

})

test_that("check_colorio() works", {

  expect_message(check_colorio(quiet = FALSE), "^colorio version:")
  expect_silent(check_colorio(quiet = TRUE))

})
