# reference: https://rstudio.github.io/reticulate/articles/package.html

#' colorio object
#'
#' Uses the reticulate framework to access the colorio API.
#'
#' The color Python package is exposed through the `colorio` object.
#'
#' In this package, use the `$` operator wherever you see the `.` operator
#' used in Python.
#'
#' @export colorio
#'
colorio <- NULL

on_colorio_load <- function() {

  check_colorio(quiet = TRUE)

  # leave this here in case we ever need to check the version of reticulate
  #
  # version_reticulate <- utils::packageVersion("reticulate")

}

on_colorio_error <- function(e) {
  message("Error importing colorio python package")
  message("Please try using install_colorio() to install")
  message("")
  message("Output from reticulate::py_config():")
  print(reticulate::py_config())

  NULL
}

.onLoad <- function(libname, pkgname) {

  reticulate::configure_environment(pkgname)

  colorio <<-
    reticulate::import(
      "colorio",
      delay_load = list(
        on_load = on_colorio_load,
        on_error = on_colorio_error
      )
    )
}
