# Introduction to STAN


## Install packages `cmdstanr`, `bayesplot`, `posterior` in R.

```{r eval = FALSE}
## install cmdstanr
## See: https://mc-stan.org/cmdstanr/
install.packages("cmdstanr",
                 repos = c("https://mc-stan.org/r-packages/",
                                       getOption("repos")))
## you can also install the developing cmdstan by devtool.
# install.packages("devtools")
# devtools::install_github("stan-dev/cmdstanr")

## install cmdstan using cmdstanr
## you can also add some parameters when install cmdstan
cmdstanr::install_cmdstan()
## you can also directly install cmdstan
## See: https://github.com/stan-dev/cmdstan

## install the other two packages for analysis
install.packages("bayesplot")
install.packages("posterior")

```
