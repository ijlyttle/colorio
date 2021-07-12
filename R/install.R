#' Install colorio Python package
#'
#' This function wraps installation functions from [reticulate][reticulate::reticulate] to install the Python package
#' **colorio**.
#'
#' This package uses the [reticulate][reticulate::reticulate] package
#' to make an interface with the [colorio](https://github.com/nschloe/colorio)
#' Python package. To promote consistency in usage of **reticulate** among
#' different R packages, it is
#' [recommended](https://rstudio.github.io/reticulate/articles/package.html#installing-python-dependencies)
#' to use a common Python environment, called `"r-reticulate"`.
#'
#' Depending on your setup, you can create this environment using
#' [reticulate::conda_create()] or [reticulate::virtualenv_create()],
#' as described in this
#' [reticulate article](https://rstudio.github.io/reticulate/articles/python_packages.html#conda-installation).
#'
#' @param method `character`, indicates to use `"conda"` or `"virtualenv"`
#' @param envname `character`, name of environment into which to install
#' @param ... other arguments sent to [reticulate::conda_install()] or
#'    [reticulate::virtualenv_install()]
#'
#' @return Invisible `NULL`, called for side effects
#'
#' @examples
#' if (FALSE) {
#'   # not run because it requires Python
#'   install_colorio()
#' }
#' @export
#'
install_colorio <- function(method = c("conda", "virtualenv"),
                            envname = "r-reticulate",
                            ...) {

  # validate stage, method arguments
  method <- match.arg(method)

  packages <- c("meshzoo", "colorio")

  if (identical(method, "conda")) {
    pip <- TRUE
    message("Package not available on conda-forge, setting pip to TRUE")
  }

  # call installer
  if (identical(method, "conda")) {
    # install numpy, matplotlib using conda
    reticulate::conda_install(
      envname = envname,
      packages = c("numpy", "matplotlib"),
      pip = FALSE,
      ...
    )
    # install actual packages using pip
    reticulate::conda_install(
      envname = envname,
      packages = packages,
      pip = pip,
      ...
    )
  }

  if (identical(method, "virtualenv")) {
    reticulate::virtualenv_install(
      packages = packages,
      envname = envname,
      ...
    )
  }

  invisible(NULL)
}

#' Check the colorio installation
#'
#' To install colorio into a Python environment, use [install_colorio()].
#'
#' @param quiet `logical`, if `TRUE`, suppresses message upon successful check
#'
#' @return invisible `NULL`, called for side-effects
#' @seealso [reticulate::py_config()], [install_colorio()], [colorio_version()]
#' @examples
#' if (FALSE) {
#'   # not run because it requires Python
#'   check_colorio()
#' }
#' @export
#'
check_colorio <- function(quiet = FALSE) {
  if (!quiet) {
    message(paste("colorio version:", colorio_version()))
  }
}

#' Installed version of colorio
#'
#' @return `character` version
#' @examples
#' if (interactive()) {
#'   colorio_version()
#' }
#'
#' @export
#'
colorio_version <- function() {
  pkg_resources <- reticulate::import("pkg_resources")
  pkg_resources$get_distribution('colorio')$version
}
