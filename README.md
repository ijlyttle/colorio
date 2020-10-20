
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

Because this package uses the colorio Python package, you need to
install it in a place that reticulate can find it. The way I recommend
is to use a Conda installation.

If you do not already have one, you can create one:

``` r
reticulate::install_miniconda()
```

Then, you need to create (or use) a Conda environment; I recommend you
use an environment called `r-reticulate`:

``` r
reticulate::conda_create('r-reticulate')
```

Finally, you can install the colorio Python package:

``` r
colorio::install_colorio()
```

To confirm everything is working, you can call `check_colorio()`:

``` r
colorio::check_colorio()
#> colorio version: 0.6.3
```

## Example

``` r
library("colorio")
## basic example code
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
