
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vjsim <img src="man/figures/vjsim-logo.png" align="right" width="200" />

<!-- badges: start -->

<!-- badges: end -->

`vjsim` is R package that simulates vertical jump with the aim of
teaching basic biomechanical principles, FV profiling, and exploring
assumptions of FV optimization models.

## Installation

You can install the development version from
[GitHub](https://github.com/mladenjovanovic/vjsim) with:

``` r
# install.packages("devtools")
devtools::install_github("mladenjovanovic/vjsim")

require(vjsim)
```

## Usage

Please read accompanying vignettes for examples and usage of the `vjsim`
package

### [Introduction](https://mladenjovanovic.github.io/vjsim/articles/introduction-vjsim.html)

This vignette discusses the basic mechanical representation of the
vertical jump system. Please read this to understand the overall setup.
Access it by clicking the above link or running the following code:

``` r
vignette("introduction-vjsim")
```

### [Simulation](https://mladenjovanovic.github.io/vjsim/articles/simulation-vjsim.html)

This vignette continues the
[Introduction](https://mladenjovanovic.github.io/vjsim/articles/introduction-vjsim.html)
vignette and expands on the topic of simulation and how vertical jump is
simulated. Access it by clicking the above link or running the following
code:

``` r
vignette("simulation-vjsim")
```

### [Profiling](https://mladenjovanovic.github.io/vjsim/articles/profiling-vjsim.html)

Once you understand how the
[Simulation](https://mladenjovanovic.github.io/vjsim/articles/simulation-vjsim.html)
works, we can start playing with profiling. Force-Velocity (FV),
Load-Velocity (LV), and other profiles are discussed, as well as the
idea of “optimal” FV profile. Access it by clicking the above link or
running the following code:

``` r
vignette("profiling-vjsim")
```

### [Exploring](https://mladenjovanovic.github.io/vjsim/articles/exploring-vjsim.html)

In this vignette we are going to explore various assumptions of the
model, “optimal” FV profiles and some other interesting questions.
Access it by clicking the above link or running the following code:

``` r
vignette("exploring-vjsim")
```

## [Shiny App](https://athletess.shinyapps.io/shiny-simulator/)

To run the Shiny app, use the following code, or by clicking on the
above link (this will take you to the *shinyapps.io*)

``` r
# install.packages(c("shiny", "plotly", "DT"))
run_simulator()
```

(App is in ongoing development; Instructional Video will be added)
