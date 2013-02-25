/*
    likelihood.c
    Dirichlet Mixtures, log Likelihood and perplexity functions.
    $Id: likelihood.c,v 1.4 2006/01/13 13:02:42 dmochiha Exp $

*/
#include <math.h>
#include "likelihood.h"
#include "feature.h"
#include "gamma.h"
#include "util.h"

double
dm_ppl (document *data, double *lambda, double *s, double **mu,
	double *d0, int nmixtures, int nlex)
{
	document *dp;
	int i, n = 0;
	for (dp = data; (dp->len) != -1; dp++)
		for (i = 0; i < dp->len; i++)
			n += dp->cnt[i];
	return exp(- dm_lik(data, lambda, s, mu,
			    d0, nmixtures, nlex) / (double)n);
}

double
dm_lik (document *data, double *lambda, double *s, double **mu,
	double *d0, int nmixtures, int nlex)
{
	document *dp;
	int i, j, m;
	double l, z, lik = 0;

	for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
	{
		for (m = 0, z = 0; m < nmixtures; m++)
		{
			if (lambda[m] == 0)
				continue;
			l = log(lambda[m])
				+ lgamma(s[m]) - lgamma(s[m] + d0[i]);
			for (j = 0; j < dp->len; j++) {
				if (mu[m][dp->id[j]] > 0)
					l += lgamma(s[m]*mu[m][dp->id[j]] + dp->cnt[j])
						- lgamma(s[m]*mu[m][dp->id[j]]);
			}
			z = logsumexp(z, l, (m == 0));
		}
		lik += z;
	}
	return lik;

}


