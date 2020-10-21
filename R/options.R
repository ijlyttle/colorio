#' CAM color space options
#'
#' The CAM02 and CAM16 families of color spaces use a set of parameters
#' to establish a particular color space.
#'
#' I have no feel for how to use anything other than the defaults.
#'
#' @param c `numeric` impact of surroundings
#' @param Y_b `numeric` relative luminance of the background
#' @param L_A `numeric` absolute luminance of  the adapting field
#' @param ... other elements added to the options list
#'
#' @return `list`
#' @examples
#' if (FALSE) {
#'   # not run because it requires Python
#'   cam16 <- do.call(colorio$CAM16, cam_options())
#' }
#' @export
#'
cam_options <- function(c = 0.69, Y_b = 20, L_A = 64 / pi / 5, ...) {
  list(c = c, Y_b = Y_b, L_A = L_A, ...)
}
