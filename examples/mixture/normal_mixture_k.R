library(cmdstanr)
library(bayesplot)
library(posterior)

## set CPU numbers
options(mc.cores = 3)

## set cmdstan package position.
set_cmdstan_path(path = paste(Sys.getenv("HOME"),
  "softwares",
  "cmdstan-2.23.0",
  sep = "/"
))

## load model
mixture_model <- cmdstan_model("normal_mixture_k_simu_data.stan",
  compile = TRUE
)

## generate simulation data.
N <- 1200
N1 <- 400
N2 <- 400
musig <- 10.0
alpha <- c(1.0, 1.0, 1.0)
sigma <- c(1.0, 1.0, 1.0)

sim_sampler <- mixture_model$sample(
  data = list(
    K = 3,
    N = N,
    N1 = N1,
    N2 = N2,
    y = rep(1, N),
    musig = musig,
    alpha = alpha,
    sigma = sigma
  ),
  seed = 355113,
  chains = 1,
  iter_sampling = 1,
  parallel_chains = getOption("mc.cores", 1),
  show_message = TRUE,
  init = list(
    list(
      theta = c(N1 / N, N2 / N, 1 - N1 / N - N2 / N),
      mu = c(-5.0, 0.0, 5)
      ## sigma = c(0.5, 1, 1)
    )
  ),
  fixed_param = TRUE
)

sim_draws <- sim_sampler$draws()
## dimnames(sim_draws)$variable[1:10]

gy <- c(sim_draws[1, 1, grep("gy", dimnames(sim_draws)$variable)])
hist(gy, breaks = 50)

## sampling
sim_sampler <- mixture_model$sample(
  data = list(
    K = 3,
    N = N,
    N1 = N1,
    N2 = N2,
    y = gy,
    musig = musig,
    alpha = alpha,
    sigma = sigma
  ),
  seed = 355113,
  chains = 4,
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
  show_message = TRUE
)

## sim_sampler$cmdstan_diagnose()
ey <- sim_sampler$draws()

## posterior draws
color_scheme_set("brewer-Spectral")
## bayesplot::mcmc_combo(ey,
##   regex_pars = c("mu"), widths = c(1, 3),
##   combo = c("dens_overlay", "trace"))

bayesplot::mcmc_combo(ey[, , grep("mu", dimnames(ey)$variable)],
  widths = c(1, 3),
  combo = c("dens_overlay", "trace"))

bayesplot::mcmc_combo(ey[, , grep("theta", dimnames(ey)$variable)],
  widths = c(1, 3),
  combo = c("dens_overlay", "trace"))

## bayesplot::mcmc_combo(ey[, , grep("sigma", dimnames(ey)$variable)],
##   widths = c(1, 3),
##   combo = c("dens_overlay", "trace"))
