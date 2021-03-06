% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{get_mean_force_over_distance}
\alias{get_mean_force_over_distance}
\title{Get Mean Force over Distance}
\usage{
get_mean_force_over_distance(
  mass,
  weight = mass * 9.81,
  take_off_velocity,
  push_off_distance
)
}
\arguments{
\item{mass}{Numeric vector}

\item{weight}{Numeric vector. Default \code{mass} * 9.81}

\item{take_off_velocity}{Numeric vector}

\item{push_off_distance}{Numeric vector}
}
\value{
Numeric vector
}
\description{
Function \code{get_mean_force_over_distance} calculates mean force over push-off distance using work equation
}
\examples{
get_mean_force_over_distance(100, 100 * 9.81, 4, 0.4)
}
