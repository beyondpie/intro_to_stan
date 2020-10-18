/*
 * Camel: Multivariate normal with structured missing data
 * http://www.openbugs.net/Examples/Camel.html
 *
 */
transformed data {
  vector[2] Y[4];
  real Y1[4];  // missing y2
  real Y2[4];  // msising y1

  matrix[2, 2] S;

  S[1, 1] = 1;
  S[1, 2] = 0;
  S[2, 1] = 0;
  S[2, 2] = 1;

  Y[1, 1] = 1.;
  Y[1, 2] = 1.;
  Y[2, 1] = 1.;
  Y[2, 2] = -1.;
  Y[3, 1] = -1.;
  Y[3, 2] = 1.;
  Y[4, 1] = -1.;
  Y[4, 2] = -1.;

  Y1[1] = 2.;
  Y1[2] = 2.;
  Y1[3] = -2.;
  Y1[4] = -2.;

  Y2[1] = 2.;
  Y2[2] = 2.;
  Y2[3] = -2.;
  Y2[4] = -2.;
	vector[2] mu = rep_vector(0.0, 2);
}


parameters {
	// vector[2] mu;
  cov_matrix[2] Sigma;
}

model {
	// mu ~ normal(0, 10);
	// Sigma ~ inv_wishart(3, S);
  for (n in 1:4) {
		Y[n] ~ multi_normal(mu, Sigma);
	}
  Y1 ~ normal(mu[1], sqrt(Sigma[1, 1]));
  Y2 ~ normal(mu[2], sqrt(Sigma[2, 2]));
	// Use Jeffery's prior: p(Sigma) proportiol to |Sigma|^{-3/2}
	target += -1.5 * log(determinant(Sigma));
}

generated quantities {
	real<lower=-1,upper= 1> rho;
  rho = Sigma[1, 2] / sqrt(Sigma[1, 1] * Sigma[2, 2]);

	real y2condy1[4];
	real y1condy2[4];
	real muy2condy1[4];
	real muy1condy2[4];

	for (i in 1:4) {
		muy2condy1[i] = mu[2] + sqrt(Sigma[2,2]) * rho * (Y1[i] - mu[1])/sqrt(Sigma[1,1]);
		y2condy1[i] = normal_rng(muy2condy1[i],
												 sqrt((1-rho*rho) * Sigma[2,2]));
	}

	for (i in 1:4) {
		muy1condy2[i] = mu[1] + sqrt(Sigma[1, 1]) * rho * (Y2[i]- mu[2]) / sqrt(Sigma[2,2]);
		y1condy2[i] = normal_rng(muy1condy2[i],
														 sqrt((1-rho*rho) * Sigma[1,1]));
	}
}
