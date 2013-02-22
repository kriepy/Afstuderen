/*
    learn.c
    Dirichlet Mixture of unigrams, parameter estimation.
    $Id: learn.c,v 1.3 2004/11/24 14:58:37 dmochiha Exp $

*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "learn.h"
#include "loo.h"
#include "likelihood.h"
#include "feature.h"
#include "gamma.h"
#include "dmatrix.h"
#include "util.h"

void
dm_learn (document *data, double *lambda, double **alpha,
	  int nmixtures, int nlex, int emmax, double epsilon)
{
	document *dp;
	double *alpha0, *d0, *f, **p;
	double lik, plik = 0;
	double z;
	int i, j, n, m, t;
	int start, elapsed;

	/* randomize a seed */
	srand(time(NULL));

	/* initialize lambda */
	for (i = 0; i < nmixtures; i++)
		lambda[i] = RANDOM + 0.5;
	for (i = 0, z = 0; i < nmixtures; i++)
		z += lambda[i];
	for (i = 0; i < nmixtures; i++)
		lambda[i] = lambda[i] / z;
	qsort(lambda, nmixtures, sizeof(double), // sort lambda initially
	      (int (*)(const void *, const void *))doublecmp);

	/* count data length, allocate p */
	for (dp = data, n = 0; (dp->len) != -1; dp++, n++)
		;
	if ((p = dmatrix(nmixtures, n)) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate p.\n");
		return;
	}
	/* allocate d0, and cache */
	if ((d0 = (double *)calloc(n, sizeof(double))) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate d0.\n");
		return;
	}
	for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
	{
		for (j = 0, z = 0; j < dp->len; j++)
			z += dp->cnt[j];
		d0[i] = z;
	}
	/* allocate alpha0 */
	if ((alpha0 = (double *)calloc(nmixtures, sizeof(double))) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate alpha0.\n");
		return;
	}

	/* initialize alpha by a mean */
	if ((f = (double *)calloc(nlex, sizeof(double))) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate f.\n");
		return;
	}
	for (dp = data, n = 0; (dp->len) != -1; dp++, n++)
	{
		for (j = 0; j < dp->len; j++)
			f[dp->id[j]] += dp->cnt[j];
	}
	for (m = 0; m < nmixtures; m++)
		for (i = 0; i < nlex; i++)
			alpha[m][i] = f[i] / n;
	
	printf("number of documents   = %d\n", n);
	printf("number of words       = %d\n", nlex);
	printf("number of mixtures    = %d\n", nmixtures);
	printf("convergence criterion = %.6g %%\n", epsilon * 100);

	start = myclock();
	for (t = 0; t < emmax; t++)
	{
		printf("iteration %d/%2d..\t", t + 1, emmax); fflush(stdout);
		/*
		 * E step
		 *
		 */

		/* calculate alpha0 */
		for (m = 0; m < nmixtures; m++)
		{
			for (i = 0, z = 0; i < nlex; i++)
				z += alpha[m][i];
			alpha0[m] = z;
		}

		/* main */
		for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
		{
			for (m = 0; m < nmixtures; m++)
			{
				for (j = 0, z = 0; j < dp->len; j++) {
					if (alpha[m][dp->id[j]] > 0) // only of possibility
						z += lgamma(alpha[m][dp->id[j]] + dp->cnt[j])
							- lgamma(alpha[m][dp->id[j]]);
				}
				p[m][i] = log(lambda[m])
					+ lgamma(alpha0[m]) - lgamma(alpha0[m] + d0[i])
					+ z;
			}
			/* normalize, and exp */
			for (m = 0, z = 0; m < nmixtures; m++)
				z = logsumexp(z, p[m][i], (m == 0));
			for (m = 0; m < nmixtures; m++)
				p[m][i] = exp(p[m][i] - z);
		}

		/*
		 * M step
		 *
		 */

		/* MLE lambda */
		for (m = 0; m < nmixtures; m++)
			lambda[m] = 0;
		for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
		{
			for (m = 0; m < nmixtures; m++)
				lambda[m] += p[m][i];
		}
		/* normalize */
		for (m = 0, z = 0; m < nmixtures; m++)
			z += lambda[m];
		for (m = 0; m < nmixtures; m++)
			lambda[m] /= z;

		/* maximize alpha */
		loo_maximize_alpha (alpha, p, data, d0,
				    nmixtures, nlex, epsilon);

		/* converged? */
		lik = dm_lik(data, lambda, alpha, d0, alpha0, nmixtures, nlex);
		elapsed = myclock() - start;
		printf("-L(D) = %.2f\t", - lik);
		fflush(stdout);
		if ((t > 1) && (fabs((lik - plik) / lik) < epsilon)) {
			printf("\nconverged. [%s]\n", rtime(elapsed));
			free_dmatrix(p, nmixtures);
			free(alpha0);
			free(d0);
			free(f);
			return;
		}
		plik = lik;
		/*
		 * ETA
		 *
		 */
		printf("ETA:%s (%d sec/step)\r",
		       rtime(elapsed * ((double) emmax / (t + 1) - 1)),
		       (int)((double) elapsed / (t + 1) + 0.5));
	}
	printf("\nmaximum iteration reached. exiting..\n");
	
	free_dmatrix(p, nmixtures);
	free(alpha0);
	free(d0);
	free(f);
	return;
	
}

