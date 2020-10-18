data {
	int<lower=1> K;
	int<lower=1> N;
	real y[N];
	int N1;
	int N2;
	real<lower=0> musig;
	vector<lower=0>[K] alpha;
	vector<lower=0>[K] sigma;
}

transformed data {}

parameters {
	simplex[K] theta;
	ordered[K] mu;
	// vector[K] mu;
	// vector<lower = 0>[K] sigma;
}


model {
	// theta ~ dirichlet(alpha);
	mu ~ normal(0, musig);
	// sigma ~ lognormal(0, 2);
	vector[K] log_theta = log(theta);
	for (n in 1 : N) {
		vector[K] lps = log_theta;
		for ( k in 1:K) {
			lps[k] += normal_lpdf(y[n] | mu[k], sigma[k]);
		}
		target += log_sum_exp(lps);
	}
}

generated quantities {
	vector[N] gy;
	for (i in 1:N1) {
		gy[i] = normal_rng(mu[1], sigma[1]);
	}
	for (i in (N1+1): (N1 + N2)) {
		gy[i] = normal_rng(mu[2], sigma[2]);
	}
	for(i in (N1+N2+1):N) {
		gy[i] = normal_rng(mu[3], sigma[3]);
	}
}

