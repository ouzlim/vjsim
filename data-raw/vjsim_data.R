## code to prepare `vjsim_data` dataset goes here

require(tidyverse)
require(progress)

gravity_const <- 9.81
external_load <- c(0, 0.2, 0.4, 0.6, 0.8)
time_step <- 0.001


parameters <- expand_grid(
  mass = seq(90, 50, -10),
  push_off_distance = c(0.3, 0.4, 0.5),
  max_force_rel = c(35, 40, 45, 50),
  max_velocity = c(2, 3, 4, 5, 6, 7),
  decline_rate = c(1.1, 0.8, 0.5),
  peak_location = c(-0.04, -0.08),
  time_to_max_activation = c(0.4, 0.3, 0.2, 0.1)
)

parameters <- parameters %>%
  mutate(
    max_force = max_force_rel * mass,
    weight = mass * gravity_const,
    force_percentage_init = fgen_get_force_percentage(
      current_distance = 0,
      push_off_distance = push_off_distance,
      decline_rate = decline_rate,
      peak_location = peak_location
    ),
    potential_force_init = max_force * force_percentage_init,
    initial_activation = weight / potential_force_init
  )

parameters_len <- nrow(parameters)

vjsim_data <- list()

# pb <- progress::progress_bar$new(
#  total = parameters_len,
#  format = "(:spin) [:bar] :percent eta: :eta"
# )
# pb$tick(0)

# --------------------------------
# Loop
for (i in seq(1, parameters_len)) {
  # pb$tick()

  # -------------------------------
  # Force Generator characteristics
  mass <- parameters$mass[i]
  weight <- mass * gravity_const
  push_off_distance <- parameters$push_off_distance[i]
  max_force <- parameters$max_force[i]
  max_velocity <- parameters$max_velocity[i]
  decline_rate <- parameters$decline_rate[i]
  peak_location <- parameters$peak_location[i]
  time_to_max_activation <- parameters$time_to_max_activation[i]

  # Message
  message(paste(
    "Subject: ", i, " of ", parameters_len,
    ", mass=", mass, ", push-off distance=", push_off_distance,
    ", max_force=", max_force, ", max_velocity=", max_velocity,
    ", decline_rate=", decline_rate, ", peak_location=", peak_location,
    ", time_to_max_activation=", time_to_max_activation,
    sep = ""
  ))


  # Hypothetical using Samozino model
  optimal_profile <- get_samozino_optimal_profile(
    F0 = max_force,
    V0 = max_velocity,
    bodyweight = mass,
    push_off_distance = push_off_distance,
    gravity_const = gravity_const
  )

  # Fgen parameters
  force_generator <- c(
    list(
      bodyweight = mass,
      push_off_distance = push_off_distance,
      max_force = max_force,
      max_velocity = max_velocity,
      decline_rate = decline_rate,
      peak_location = peak_location,
      time_to_max_activation = time_to_max_activation
    ),
    unlist(optimal_profile)
  )

  # --------------------------------
  # Bodyweight jump
  bodyweight_jump <- vj_simulate(
    mass = mass,
    weight = weight,
    push_off_distance = push_off_distance,
    gravity_const = gravity_const,
    time_step = time_step,
    save_trace = FALSE,
    max_force = max_force,
    max_velocity = max_velocity,
    decline_rate = decline_rate,
    peak_location = peak_location,
    time_to_max_activation = time_to_max_activation
  )

  bodyweight_jump <- bodyweight_jump$summary[, -c(1, 2, 3, 4, 5, 7, 8)]

  # ------------------------
  # Jump probe to see which brings more increase
  bodyweight_jump_force <- vj_simulate(
    mass = mass,
    weight = weight,
    push_off_distance = push_off_distance,
    gravity_const = gravity_const,
    time_step = time_step,
    save_trace = FALSE,
    max_force = max_force * 1.1, # The change
    max_velocity = max_velocity,
    decline_rate = decline_rate,
    peak_location = peak_location,
    time_to_max_activation = time_to_max_activation
  )
  bodyweight_jump_force <- bodyweight_jump_force$summary

  bodyweight_jump_velocity <- vj_simulate(
    mass = mass,
    weight = weight,
    push_off_distance = push_off_distance,
    gravity_const = gravity_const,
    time_step = time_step,
    save_trace = FALSE,
    max_force = max_force,
    max_velocity = max_velocity * 1.1, # The change
    decline_rate = decline_rate,
    peak_location = peak_location,
    time_to_max_activation = time_to_max_activation
  )
  bodyweight_jump_velocity <- bodyweight_jump_velocity$summary

  bodyweight_jump_activation <- vj_simulate(
    mass = mass,
    weight = weight,
    push_off_distance = push_off_distance,
    gravity_const = gravity_const,
    time_step = time_step,
    save_trace = FALSE,
    max_force = max_force,
    max_velocity = max_velocity,
    decline_rate = decline_rate,
    peak_location = peak_location,
    time_to_max_activation = time_to_max_activation / 1.1 # The change
  )
  bodyweight_jump_activation <- bodyweight_jump_activation$summary

  # Probing summary
  probe_bodyweight_jump <- list(
    # Max Force improved
    force_height = bodyweight_jump_force$height,
    force_height_diff = bodyweight_jump_force$height - bodyweight_jump$height,
    force_height_ratio = bodyweight_jump_force$height / bodyweight_jump$height,

    # Max Velocity improved
    velocity_height = bodyweight_jump_velocity$height,
    velocity_height_diff = bodyweight_jump_velocity$height - bodyweight_jump$height,
    velocity_height_ratio = bodyweight_jump_velocity$height / bodyweight_jump$height,

    # Time to max activation
    activation_height = bodyweight_jump_activation$height,
    activation_height_diff = bodyweight_jump_activation$height - bodyweight_jump$height,
    activation_height_ratio = bodyweight_jump_activation$height / bodyweight_jump$height,

    # Ratios and differences
    velocity_to_force_height_diff = (bodyweight_jump_velocity$height - bodyweight_jump$height) - (bodyweight_jump_force$height - bodyweight_jump$height),
    velocity_to_force_height_ratio = (bodyweight_jump_velocity$height - bodyweight_jump$height) / (bodyweight_jump_force$height - bodyweight_jump$height),
    velocity_to_activation_height_diff = (bodyweight_jump_velocity$height - bodyweight_jump$height) - (bodyweight_jump_activation$height - bodyweight_jump$height),
    velocity_to_activation_height_ratio = (bodyweight_jump_velocity$height - bodyweight_jump$height) / (bodyweight_jump_activation$height - bodyweight_jump$height),

    force_to_velocity_height_diff = (bodyweight_jump_force$height - bodyweight_jump$height) - (bodyweight_jump_velocity$height - bodyweight_jump$height),
    force_to_velocity_height_ratio = (bodyweight_jump_force$height - bodyweight_jump$height) / (bodyweight_jump_velocity$height - bodyweight_jump$height),
    force_to_activation_height_diff = (bodyweight_jump_force$height - bodyweight_jump$height) - (bodyweight_jump_activation$height - bodyweight_jump$height),
    force_to_activation_height_ratio = (bodyweight_jump_force$height - bodyweight_jump$height) / (bodyweight_jump_activation$height - bodyweight_jump$height),

    activation_to_velocity_height_diff = (bodyweight_jump_activation$height - bodyweight_jump$height) - (bodyweight_jump_velocity$height - bodyweight_jump$height),
    activation_to_velocity_height_ratio = (bodyweight_jump_activation$height - bodyweight_jump$height) / (bodyweight_jump_velocity$height - bodyweight_jump$height),
    activation_to_force_height_diff = (bodyweight_jump_activation$height - bodyweight_jump$height) - (bodyweight_jump_force$height - bodyweight_jump$height),
    activation_to_force_height_ratio = (bodyweight_jump_activation$height - bodyweight_jump$height) / (bodyweight_jump_force$height - bodyweight_jump$height)
  )

  # ------------------------
  # Bosco Index
  double_bodyweight_jump <- vj_simulate(
    mass = mass * 2,
    weight = weight * 2,
    push_off_distance = push_off_distance,
    gravity_const = gravity_const,
    time_step = time_step,
    save_trace = FALSE,
    max_force = max_force,
    max_velocity = max_velocity,
    decline_rate = decline_rate,
    peak_location = peak_location,
    time_to_max_activation = time_to_max_activation
  )

  bosco <- list(
    height_2BW = double_bodyweight_jump$summary$height,
    index = double_bodyweight_jump$summary$height / bodyweight_jump$height * 100
  )

  # -------------------------
  # Profile
  jump_profile_data <- vj_profile(
    mass = mass,
    external_load = external_load * mass,
    push_off_distance = push_off_distance,
    gravity_const = gravity_const,
    time_step = time_step,
    max_force = max_force,
    max_velocity = max_velocity,
    decline_rate = decline_rate,
    peak_location = peak_location,
    time_to_max_activation = time_to_max_activation
  )

  jump_profile <- get_all_profiles(jump_profile_data)
  jump_profile <- as.list(unlist(jump_profile$list))

  # ------------------------
  # Load~Peak Force profiel
  LPF_profile_model <- lm(peak_GRF ~ mass, jump_profile_data)
  LPF_profile <- list(
    slope = coef(LPF_profile_model)[[2]],
    slope_rel = coef(LPF_profile_model)[[2]] / mass
  )


  # -------------------------
  # Samozino
  samozino_profile <- get_all_samozino_profiles(jump_profile_data)
  samozino_profile <- as.list(unlist(samozino_profile$list))

  # ------------------------
  # Simple profile
  simple_profile <- get_simple_profile(jump_profile_data)

  # -------------------------
  # Save results
  vjsim_data[[i]] <- list(
    force_generator = force_generator,
    bodyweight_jump = as.list(bodyweight_jump),
    probe_bodyweight_jump = probe_bodyweight_jump,
    bosco = bosco,
    jump_profile,
    LPF_profile = LPF_profile,
    samozino_profile,
    simple_profile = simple_profile
  )
}

vjsim_data <- as.data.frame(do.call(rbind, lapply(vjsim_data, unlist)))
usethis::use_data(vjsim_data, overwrite = TRUE)
