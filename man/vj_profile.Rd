% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/profiles.R
\name{vj_profile}
\alias{vj_profile}
\title{Vertical Jump Profile}
\usage{
vj_profile(external_load = c(-40, -20, 0, 20, 40, 60, 80, 100), mass = 75, ...)
}
\arguments{
\item{external_load}{Numeric vector. Default is  \code{c(-40, -20, 0, 20, 40, 60, 80)}}

\item{mass}{Numeric value. Represents bodyweight}

\item{...}{Parameters forwarded to \code{\link{vj_simulate}}}
}
\value{
Data frame. Returns the data frame from \code{\link{vj_simulate}} with extra two columns:
    \code{bodyweigh}t and \code{external_load}
}
\description{
\code{vj_profile} generates vertical jump profile by loading the vertical jump with \code{external_load}
}
\examples{
vj_profile_data <- vj_profile(mass = 75)

plot(x = vj_profile_data$mass, y = vj_profile_data$height)
plot(x = vj_profile_data$mean_GRF_over_distance, y = vj_profile_data$mean_velocity)
}
