
<!-- README.md is generated from README.Rmd. Please edit that file -->

# anomalyrecipes

<!-- badges: start -->
<!-- badges: end -->

Anomaly recipes provides `{recipes}` step functions for anomaly
detection.

Right now the package contains one step function: `step_isofor` (short
for isolation forest). This is an implementation of the isolation forest
algorithm from the R `{solitude}` package.

This is a work in progress (and mostly a pet project at this point), but
if you have a chance to try it out, please let me know how it goes.

## Installation

You can install the development version of anomalyrecipes from github:

``` r
devtools::install_github("kevin-m-kent/anomalyrecipes")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(anomalyrecipes)
#> Loading required package: recipes
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> 
#> Attaching package: 'recipes'
#> The following object is masked from 'package:stats':
#> 
#>     step
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
