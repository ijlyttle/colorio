
<!-- README.md is generated from README.Rmd. Please edit that file -->

# colorio

<!-- badges: start -->

[![R build
status](https://github.com/ijlyttle/colorio/workflows/R-CMD-check/badge.svg)](https://github.com/ijlyttle/colorio/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of colorio is to provide low-level access to the [**colorio**
Python package](https://github.com/nschloe/colorio), developed by Nico
Schlömer; this package makes conversions between different color spaces
and provides color-distance calculations. It includes some of the
more-recent color spaces, such as
[CAM02-UCS](https://en.wikipedia.org/wiki/CIECAM02),
[CAM16-UCS](https://en.wikipedia.org/wiki/Color_appearance_model#CAM16),
and [Jzazbz](https://doi.org/10.1364/OE.25.015131).

There’s a lot to the colorio Python package; the goal of this README is
to highlight those parts that concern conversion among color spaces, and
distance calculations within a color space.

## Installation

You can install the development version of colorio from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ijlyttle/colorio")
```

Because this package uses the colorio Python package, you may need to
follow a few steps. My recommendations are to:

  - use (or create) a Conda installation.
  - use (or create) a Python environment called `r-reticulate`.
  - install the colorio Python package.

<!-- end list -->

``` r
reticulate::install_miniconda()
reticulate::conda_create("r-reticulate")
colorio::install_colorio()
```

If you use Python virtual environments, or if you use an environment not
named `r-reticulate`, you can use the `method` and `envname` options in
`install_colorio()`.

To confirm everything is working, you can call `check_colorio()`:

``` r
colorio::check_colorio()
#> colorio version: 0.6.3
```

## Example

``` r
library("colorio")
```

In colorio, the basic unit of analysis is the color space. We will call
functions that will create color-space objects; those objects will have
methods we can call to convert to and from the “central” color-space:
XYZ100, the [CIE 1931 XYZ color
space](https://en.wikipedia.org/wiki/CIE_1931_color_space), normalized
to 100.

To convert values from one color space to another, we create each of the
color-space objects - then use the `to_xyz100()` method from one of the
color spaces, then the `from_xyz100()` method from the other.

### Conversion to/from LUV

To help demonstrate, we can use the farver package, which has
capabilities that overlap with this package.

``` r
hex_codes <- c("#112233", "#336699")

farver_xyz100 <- farver::decode_colour(hex_codes, to = "xyz")
farver_xyz100
#>              x         y        z
#> [1,]  1.400521  1.502124  3.34746
#> [2,] 11.864259 12.505267 31.91932
```

The `farver::decode_colour()` function returns a matrix with a color in
each row, and each column named for a dimension. We can convert this to
LUV coordinates:

``` r
farver_luv <- farver::convert_colour(farver_xyz100, from = "xyz", to = "luv")
farver_luv
#>             l          u         v
#> [1,] 12.62155  -5.406472 -11.55451
#> [2,] 42.00815 -20.248606 -47.55476
```

Again, we get a matrix with a color in each row.

We can make the analogous calculations using colorio; the first step is
to create an instance of the LUV color space:

``` r
LUV <- colorio$CIELUV()
```

This color space (as do all colorio color spaces) has a `from_xyz100()`
method. Becuase Python is row-based and R is column-based, we have to
use the transpose function, `t()`:

``` r
colorio_luv <- LUV$from_xyz100(t(farver_xyz100))
t(colorio_luv)
#>          [,1]       [,2]      [,3]
#> [1,] 12.62155  -5.406472 -11.55451
#> [2,] 42.00815 -20.248608 -47.55476
```

We get essentially the same result; we can use the `to_xyz100()` method
to go back:

``` r
colorio_xyz100 <- LUV$to_xyz100(colorio_luv)
t(colorio_xyz100)
#>           [,1]      [,2]     [,3]
#> [1,]  1.400521  1.502124  3.34746
#> [2,] 11.864259 12.505267 31.91932
```

We can use the [**waldo**](https://waldo.r-lib.org/) package to compare
the sets of LUV coordinates:

``` r
waldo::compare(farver_luv, t(colorio_luv))
#> `dimnames(x)` is a list
#> `dimnames(y)` is absent
#> 
#> `x`: 12.6215546 42.0081466 -5.4064720 -20.2486056 -11.5545113 -47.5547572
#> `y`: 12.6215540 42.0081456 -5.4064723 -20.2486079 -11.5545117 -47.5547584
```

We see that colorio does not return dimension-names (we knew that), and
that numerical differences are on the order of `1.e-6`. Given that a
visible difference is on the order of `1.0`, we are not concerned with
differences in the sixth decimal place.

Instead, we are encouraged that we can get the “same” answer using two
different implementations.

### Conversion to other colorspaces

The reason I find the colorio Python package so compelling is the wide
range of color spaces it offers, including the CAM02-UCS color space,
and its successor CAM16-UCS. You may remember the CAM02-UCS color space
was used by Stéfan van der Walt and Nathaniel Smith to [design the
viridis palette](https://www.youtube.com/watch?v=xAoljeRJ3lU).

To create a CAM16UCS color space (as well as for any of the CAM02 and
CAM16 family), we have to supply some additional options. These options
are contained in a helper function `cam_options()`, which can be used in
conjunction with `do.call()`:

``` r
CAM16UCS <- do.call(colorio$CAM16UCS, cam_options())
```

To get the coordinates for these colors in the CAM16-UCS color space,
use its `from_xyz100()` method:

``` r
colorio_cam16ucs <- CAM16UCS$from_xyz100(colorio_xyz100)
t(colorio_cam16ucs)
#>          [,1]      [,2]      [,3]
#> [1,] 15.49649 -3.623903 -10.94256
#> [2,] 43.95556 -6.195777 -20.92419
```

### Color-difference calculation

If the colorspace is Cartesian (not polar), you can get a useful
distance-calculation using the `colorio$delta()` function.

Keep in mind that this calculates the sum-of-squares of differences
between two color spaces. If you want the Euclidean distance, take the
square root.

``` r
# expect a couple of zeroes
colorio$delta(colorio_cam16ucs, colorio_cam16ucs)
#> [1] 0 0

# expect a single non-zero number.
colorio$delta(
  colorio_cam16ucs[, 1, drop = FALSE], 
  colorio_cam16ucs[, 2, drop = FALSE]
)
#> [1] 916.1662
```

There is nothing stopping you from providing non-Cartesian coordinates,
other than your vigilance.

## Other resources

  - R package [farver](https://farver.data-imaginist.com/), by Thomas
    Lin Pedersen
  - R package [colorspace](http://hclwizard.org/r-colorspace/), by Achim
    Zeileis et al.
  - Python package
    [colorspacious](https://github.com/njsmith/colorspacious), by
    Nathaniel Smith
