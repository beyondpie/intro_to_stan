library(cmdstanr)
library(bayesplot)
library(posterior)

set_cmdstan_path(path = paste(Sys.getenv("HOME"),
  "softwares",
  "cmdstan-2.23.0", sep = "/"))
camel_mdl <- cmdstan_model("camel2.stan",
  compile = TRUE)

camel_mcmc <- camel_mdl$sample(data = NULL,
  seed = 355113,
  parallel_chains = 4,
  show_message = TRUE,
  output_dir = "./")

camel_draws <- camel_mcmc$draws()
dimnames(camel_draws)$variable

bayesplot::mcmc_combo(camel_draws[, c(1, 2), ],
  pars = c("rho"), widths = c(1, 3),
  combo = c("dens_overlay", "trace"),
  n_warmup = 100,
  gg_theme = legend_none())

## view trace for rho
plot(camel_draws[, 1, 'rho'])
lines(camel_draws[, 1, 'rho'])

## View imputations of the missing data
bayesplot::mcmc_combo(camel_draws[, c(1, 2), ],
  regex_pars = c("y2condy1"), widths = c(1, 3),
  combo = c("dens_overlay", "trace"),
  n_warmup = 100,
  gg_theme = legend_none())

## View trace of mu
bayesplot::mcmc_combo(camel_draws[, c(1, 2), ],
  regex_pars = c("mu"), widths = c(1, 3),
  combo = c("dens_overlay", "trace"),
  gg_theme = legend_none())
