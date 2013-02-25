/*
    dm.c
    Dirichlet Mixture of unigrams, main driver.
    (precisely, mixture of Dirichlet process mixture of unigrams)
    $Id: dm.c,v 1.3 2004/11/24 14:58:37 dmochiha Exp $

*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "dm.h"
#include "learn.h"
#include "writer.h"
#include "feature.h"
#include "dmatrix.h"
#include "util.h"

int
main (int argc, char *argv[])
{
	char c;
	int nlex, dlenmax;
	int nmixtures  = NMIXTURES_DEFAULT;	// default in dm.h
	int emmax      = EMMAX_DEFAULT;		// default in dm.h
	double epsilon = EPSILON_DEFAULT;	// default in dm.h
	double *lambda, **alpha;
	document *data;
	FILE *lp, *ap;

	while ((c = getopt(argc, argv, "M:I:E:h")) != -1)
	{
		switch (c) {
		case 'M' : nmixtures = atoi(optarg); break;
		case 'I' : emmax = atoi(optarg); break;
		case 'E' : epsilon = atof(optarg); break;
		case 'h' : usage (); break;
		default  : break;
		}
	}
	if (!(argc - optind == 2))
		usage ();

	/* open data */
	if ((data = feature_matrix(argv[optind], &nlex, &dlenmax)) == NULL) {
		fprintf(stderr, "dm:: can't open training data.\n");
		exit(1);
	}
	/* allocate parameters */
	if ((lambda = (double *)calloc(nmixtures, sizeof(double))) == NULL) {
		fprintf(stderr, "dm:: can't allocate lambda.\n");
		exit(1);
	}
	if ((alpha = dmatrix(nmixtures, nlex)) == NULL) {
		fprintf(stderr, "dm:: can't allocate alpha.\n");
		exit(1);
	}
	/* open model outputs */
	if (((lp = fopen(strconcat(argv[optind + 1], ".lambda"), "w")) == NULL)
	 || ((ap = fopen(strconcat(argv[optind + 1], ".alphas"), "w")) == NULL))
	{
		fprintf(stderr, "dm:: can't open model outputs.\n");
		exit(1);
	}

	dm_learn (data, lambda, alpha, nmixtures, nlex,
		  emmax, epsilon);
	dm_write (lp, ap, lambda, alpha, nmixtures, nlex);
	
	free_feature_matrix(data);
	free_dmatrix(alpha, nmixtures);
	free(lambda);

	fclose(lp);
	fclose(ap);
	
	exit(0);
}


void
usage ()
{
	printf(DM_COPYRIGHT);
	printf("$Id: dm.c,v 1.3 2004/11/24 14:58:37 dmochiha Exp $\n");
	printf("usage: %s -M mixtures [-I iter] [-E epsilon] train model\n", "dm");
	exit(0);
}
