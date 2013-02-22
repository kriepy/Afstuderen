/*
    loo.c
    LOO maximization of alpha[m], given data of counts.
    $Id: loo.c,v 1.4 2004/11/24 14:58:37 dmochiha Exp $

*/
#include <stdlib.h>
#include <math.h>
#include "loo.h"
#include "feature.h"
#include "util.h"

void
loo_maximize_alpha (double **alpha, double **p, document *data, double *d0,
		    int nmixtures, int nlex, double epsilon)
{
	document *dp;
	double *z1, z2;
	double *nalpha, alpha0;
	int i, j, m, t, v;

	if ((z1 = (double *)calloc(nlex, sizeof(double))) == NULL) {
		fprintf(stderr, "loo_maximize_alpha:: can't allocate z1.\n");
		exit(1);
	}
	if ((nalpha = (double *)calloc(nlex, sizeof(double))) == NULL) {
		fprintf(stderr, "loo_maximize_alpha:: can't allocate nalpha.\n");
		exit(1);
	}

	for (m = 0; m < nmixtures; m++)
	{
		for (t = 0; t < LOO_ITER_MAX; t++)
		{
			/* calculate alpha0 */
			for (v = 0, alpha0 = 0; v < nlex; v++)
				alpha0 += alpha[m][v];
			/* clear buffer */
			for (v = 0; v < nlex; v++)
				z1[v] = 0;
			z2 = 0;

			/* main */
			for (dp = data, i = 0; (dp->len) != -1; dp++, i++)
			{
				for (j = 0; j < dp->len; j++)
					z1[dp->id[j]] += p[m][i] *
						dp->cnt[j] / (dp->cnt[j] - 1 + alpha[m][dp->id[j]]);
				z2 += p[m][i] * d0[i] / (d0[i] - 1 + alpha0);
			}
			for (v = 0; v < nlex; v++) {
				if (!(z1[v] > 0)) {
					free(z1);
					free(nalpha);
					return;
				} else {
					nalpha[v] = alpha[m][v] * z1[v] / z2;
				}
			}
			
			/* converged? */
			if ((t > 0) && converged(alpha[m], nalpha, nlex, 1.0e-2))
				break;
			/* update */
			for (v = 0; v < nlex; v++)
				alpha[m][v] = nalpha[v];
		}
	}

	free(z1);
	free(nalpha);
	return;

}


