/*
    likelihood.c
    Dirichlet Mixture, log Likelihood function.
    $Id: likelihood.c,v 1.2 2004/11/18 12:57:19 dmochiha Exp $

*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "feature.h"
#include "gamma.h"
#include "util.h"

double
dm_lik (document *data, double *lambda, double **alpha,
	double *d0, double *alpha0,
	int nmixtures, int nlex)
{
	document *dp;
	int i, j, m;
	double s, z, lik = 0;

	for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
	{
		for (m = 0, z = 0; m < nmixtures; m++)
		{
			s = log(lambda[m])
				+ lgamma(alpha0[m]) - lgamma(alpha0[m] + d0[i]);
			for (j = 0; j < dp->len; j++)
			{
				if (alpha[m][dp->id[j]] > 0)
					s += lgamma(alpha[m][dp->id[j]] + dp->cnt[j])
						- lgamma(alpha[m][dp->id[j]]);
			}
			z = logsumexp(z, s, (m == 0));
		}
		lik += z;
	}

	// fprintf(stderr, "lik = %g\n", lik);
	return lik;
	
}
