data {
	int<lower=1> K;
	int<lower=1> N;
	real y[N];
	int N1;
	int N2;
}

parameters {
	simplex[K] theta;
	ordered[K] mu;
	// vector[K] mu;
	vector<lower = 0>[K] sigma;
}


model {
	mu ~ normal(0, 10);
	real ym[K];
	for (n in 1 : N) {
		for ( k in 1:K) {
			ym[k] = log(theta[k]) + normal_lpdf(y[n] | mu[k], sigma[k]);
		}
		target += log_sum_exp(ym);
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

