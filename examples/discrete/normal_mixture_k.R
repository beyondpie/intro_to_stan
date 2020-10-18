library(cmdstanr)
library(bayesplot)
library(posterior)

## set CPU numbers
options(mc.cores = 2)

## set cmdstan package position.
set_cmdstan_path(path = paste(Sys.getenv("HOME"),
  "softwares",
  "cmdstan-2.23.0",
  sep = "/"
))

## load model
sim_model <- cmdstan_model("normal_mixture_k_simu_data.stan",
  compile = TRUE
)

## generate simulation data.
N <- 1000
N1 <- 400
N2 <- 300

sim_sampler <- sim_model$sample(
  data = list(
    K = 3,
    N = N,
    N1 = N1,
    N2 = N2,
    y = rep(1, N)
  ),
  seed = 355113,
  chains = 1,
  iter_sampling = 1,
  parallel_chains = getOption("mc.cores", 1),
  show_message = TRUE,
  init = list(
    list(
      theta = c(0.4, 0.3, 0.3),
      mu = c(-4.0, 0.0, 4),
      sigma = c(1.0, 0.5, 2.0)
    )
  ),
  ## output_dir = "./",
  fixed_param = TRUE
)

sim_draws <- sim_sampler$draws()
## dimnames(sim_draws)$variable[1:10]

gy <- c(sim_draws[1, 1, 10: dim(sim_draws)[3]])
## hist(gy, breaks = 50)

## sampling
sim_sampler <- sim_model$sample(
  data = list(
    K = 3,
    N = N,
    N1 = N1,
    N2 = N2,
    y = gy
  ),
  seed = 355113,
  chains = 1,
  iter_sampling = 1000,
  fixed_param = FALSE,
  ## init = list(
  ##   list(
  ##     theta = c(0.4, 0.3, 0.3),
  ##     mu = c(-4.0, 0.0, 4),
  ##     sigma = c(10, 10, 10)
  ##   ),
  ##   list(
  ##     theta = c(0.2, 0.3, 0.5),
  ##     mu = c(-10.0, 0.0, 10),
  ##     sigma = c(10.0, 10, 10.0)
  ##   )
  ## ),
  parallel_chains = getOption("mc.cores", 1),
  ## output_dir = "./",
  show_message = TRUE,
  ## adapt_delta = 0.9
)

ey <- sim_sampler$draws()
## posterior draws

bayesplot::mcmc_combo(ey,
  regex_pars = c("mu"), widths = c(1, 3),
  combo = c("dens_overlay", "trace"),
  gg_theme = legend_none())

