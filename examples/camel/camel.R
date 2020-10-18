library(cmdstanr)
library(bayesplot)
library(posterior)

color_scheme_set("brewer-Spectral")
set_cmdstan_path(path = paste(Sys.getenv("HOME"),
  "softwares",
  "cmdstan-2.23.0", sep = "/"))

## load camel2 model
camel_mdl <- cmdstan_model("camel2.stan",
  compile = TRUE)

camel_sampler <- camel_mdl$sample(data = NULL,
  seed = 355113,
  parallel_chains = 4,
  show_message = TRUE,
  ## increase adapt delta, default is 0.80
  adapt_delta = 0.85,
  iter_sampling = 1000
  ## output_dir = "./"
)

camel_draws <- camel_sampler$draws()

## show variable names
## dimnames(camel_draws)$variable

## diagnose
## camel_sampler$cmdstan_diagnose()

## view rho
bayesplot::mcmc_combo(camel_draws,
  pars = c("rho"), widths = c(1, 3),
  combo = c("dens_overlay", "trace")
 )

## View imputations of the missing data
bayesplot::mcmc_combo(camel_draws,
  regex_pars = c("y2condy1"), widths = c(1, 3),
  combo = c("dens_overlay", "trace"))

