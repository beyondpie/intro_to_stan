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
## Examples

Examples are provided under the directory `examples`. 
- You can directly use the `stan_examples.Rmd` file to scan the examples.

- You can enter the different directories under `examples` to run or modify both
  the R and STAN scripts by yourself. 

## Diagnosis
During sampling, it's very common that STAN will provide some issues and
warnings. We can treat this as a feature in STAN, which could help us to debug
not only our codes, but also our model. Here I list some materials for
reference. 

### Explanations for STAN's Warnings

- [Brief Guide to Stan's Warnings](https://mc-stan.org/misc/warnings.html)

### Reparameterization in hierarchical Bayesian model.

- [Hamiltonian Monte Carlo for Hierarchical
  Models](https://arxiv.org/abs/1312.0906)
  
- [Diagnosing Biased Inference with Divergences](https://mc-stan.org/users/documentation/case-studies/divergences_and_bias.html)

### Mixture models in STAN

- [Identifying Bayesian Mixture Models](https://mc-stan.org/users/documentation/case-studies/identifying_mixture_models.html)

