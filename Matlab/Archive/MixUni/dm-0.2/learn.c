/*
    learn.c
    hierarchically smoothed Dirichlet Mixtures, parameter estimation.
    Reversing EM version.
    $Id: learn.c,v 1.13 2006/02/02 16:53:48 dmochiha Exp $

*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "learn.h"
#include "newton.h"
#include "likelihood.h"
#include "feature.h"
#include "dmatrix.h"
#include "random.h"
#include "gamma.h"
#include "util.h"
#include "writer.h"

void
dm_learn (document *data, double *lambda, double **alpha,
	  int nmixtures, int nlex, int emmax, int remmax, double epsilon)
{
	document *dp;
	double *d0, *f, **p;
	double *s, **mu, **eps, *beta;
	double aimv, z, t1, t2;
	double ppl, sppl, pplp = 0, spplp = 0;
	int i, j, m, n, t, v;
	int start, elapsed, step, steps = 0;

	/* initialize seed */
	srand(time(NULL));

	/* initialize lambda */
	for (i = 0; i < nmixtures; i++)
		lambda[i] = 1.0 / (double)nmixtures;

	/* count data length, allocate p */
	for (dp = data, n = 0; (dp->len) != -1; dp++, n++)
		;
	if ((p = dmatrix(n, nmixtures)) == NULL) {
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

	/* allocate eps */
	if ((eps = dmatrix(nmixtures,nlex)) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate eps.\n");
		return;
	}
	/* allocate beta, and initialize */
	if ((beta = (double *)calloc(nlex, sizeof(double))) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate beta.\n");
		return;
	}
	for (v = 0; v < nlex; v++)
		beta[v] = INITIAL_PCOUNT;

	/* allocate s, mu */
	if ((s = (double *)calloc(nmixtures, sizeof(double))) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate s.\n");
		return;
	}
	if ((mu = dmatrix(nmixtures, nlex)) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate mu.\n");
		return;
	}
	/* initialize s, mu */
	for (m = 0; m < nmixtures; m++)
		s[m] = INITIAL_PCOUNT * nlex;
	if ((f = (double *)calloc(nlex, sizeof(double))) == NULL) {
		fprintf(stderr, "dm_learn:: can't allocate f.\n");
		return;
	}
	for (dp = data, z = 0; (dp->len) != -1; dp++)
	{
		for (j = 0; j < dp->len; j++)
		{
			f[dp->id[j]] += dp->cnt[j];
			z += dp->cnt[j];
		}
	}
	for (i = 0; i < nlex; i++)
		f[i] /= z;
	for (m = 0; m < nmixtures; m++)
		dirrand(mu[m], f, nlex, INITIAL_PCOUNT * nlex * 100);
	for (m = 0; m < nmixtures; m++) {
		for (v = 0; v < nlex; v++)
			mu[m][v] += INITIAL_PCOUNT;
		for (v = 0; v < nlex; v++)
			mu[m][v] /= (1 + INITIAL_PCOUNT * nlex);
	}
	
	printf("number of documents   = %d\n", n);
	printf("number of words       = %d\n", nlex);
	printf("number of mixtures    = %d\n", nmixtures);
	printf("convergence criterion = %.6g %%\n", epsilon * 100);

	/*
	 *  learn main
	 *
	 */
	start = myclock();
	for (t = 0; t < emmax; t++)
	{
		/*
		 *  E step
		 *
		 */
		for (step = 1; step <= remmax; step++)
		{
			/* inner REM E step */
			printf("iteration %d/%d [REM %d+%d]..\t",
			       t + 1, emmax, step, steps);
			fflush(stdout);
			for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
			{
				for (m = 0; m < nmixtures; m++)
				{
					for (j = 0, z = 0; j < dp->len; j++) {
						if (dp->cnt[j] == 1) {
							z += log(s[m]*mu[m][dp->id[j]]);
						} else {
							z += lgamma(s[m]*mu[m][dp->id[j]] + dp->cnt[j])
								- lgamma(s[m]*mu[m][dp->id[j]]);
						}
					}
					p[i][m] = log(lambda[m])
						  + lgamma(s[m]) - lgamma(s[m] + d0[i])
						  + z;
				}
				/* normalize, and exp */
				for (m = 0, z = 0; m < nmixtures; m++)
					z = logsumexp(z, p[i][m], (m == 0));
				for (m = 0; m < nmixtures; m++)
					p[i][m] = exp(p[i][m] - z);
			}
			/* inner REM M step */
			for (m = 0; m < nmixtures; m++)
			{
				for (v = 0; v < nlex; v++)
					eps[m][v] = beta[v];
				t1 = t2 = 0;
				for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
				{
					for (j = 0, z = 0; j < dp->len; j++)
					{
						v = dp->id[j];
						if (dp->cnt[j] == 1) {
							aimv = 1;
						} else {
							aimv = s[m]*mu[m][v] *
								(psi(s[m]*mu[m][v] + dp->cnt[j])
								 - psi(s[m]*mu[m][v]));
						}
						eps[m][v] += p[i][m] * aimv;
						z += aimv;
					}
					t1 += p[i][m] * z;
					t2 += p[i][m] * (psi(s[m] + d0[i]) - psi(s[m]));
				}
				/* update s */
				s[m] = t1 / t2;
				/* update mu */
				for (v = 0, z = 0; v < nlex; v++)
					z += eps[m][v];
				for (v = 0; v < nlex; v++)
					mu[m][v] = eps[m][v] / z;
			}
			ppl = dm_ppl(data, lambda, s, mu, d0, nmixtures, nlex);
			printf("PPL = %.6g\r", ppl); fflush(stdout);
			if (fabs(pplp - ppl) / pplp < 1.0e-3)
				break;	/* inner loop converged */
			else
				pplp = ppl;
		}
		steps += step;
		
		/*
		 *  M step
		 *
		 */

		/* MLE lambda */
		for (m = 0; m < nmixtures; m++)
			lambda[m] = 0;
		for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
		{
			for (m = 0; m < nmixtures; m++)
				lambda[m] += p[i][m];
		}
		/* normalize */
		for (m = 0, z = 0; m < nmixtures; m++)
			z += lambda[m];
		for (m = 0; m < nmixtures; m++)
			lambda[m] /= z;
		
		/* compute alpha */
		for (m = 0; m < nmixtures; m++)
			for (v = 0; v < nlex; v++)
				alpha[m][v] = s[m] * mu[m][v];

		/* MLE beta */
		newton_beta (beta, eps, nmixtures, nlex, 0);
		
		/* converged? */
		sppl = dm_ppl(data, lambda, s, mu, d0, nmixtures, nlex);
		elapsed = myclock() - start;
		if ((t > 1) && (spplp - sppl) / spplp < epsilon) {
			printf("\nconverged. [%s]\n", rtime(elapsed));
			free_dmatrix(mu, nmixtures);
			free_dmatrix(eps, nmixtures);
			free_dmatrix(p, n);
			free(beta);
			free(d0);
			free(s);
			free(f);
			return;
		}
		spplp = sppl;
		/*
		 *  ETA
		 *
		 */
		printf("iteration %2d/%d [REM %d+%d]..  \t",
		       t + 1, emmax, step, steps);
		printf("PPL = %.6g\t", sppl);
		printf("ETA:%s (%d sec/step)\r",
		       rtime(elapsed * ((double) emmax / (t + 1) - 1)),
		       (int)((double) elapsed / (t + 1) + 0.5));
		
	}
	printf("\nmaximum iteration reached. exiting..\n");
	
	free_dmatrix(mu, nmixtures);
	free_dmatrix(eps, nmixtures);
	free_dmatrix(p, n);
	free(beta);
	free(d0);
	free(s);
	free(f);
	return;

}

		 
	
