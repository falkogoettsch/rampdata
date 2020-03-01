test_that("project path for just stage", {
  pp <- project_path(list(stage = "input", location = "uganda"))
  expect_equal(pp, "countries/uganda")
})
