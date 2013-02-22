/*
    sdm.c
    hierarchically smoothed Dirichlet Mixtures.
    $Id: sdm.c,v 1.2 2006/02/02 16:28:51 dmochiha Exp $

*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "sdm.h"
#include "learn.h"
#include "writer.h"
#include "feature.h"
#include "dmatrix.h"
#include "util.h"

int
main (int argc, char *argv[])
{
	int nmixtures  = NMIXTURES_DEFAULT;	// default in sdm.h
	int emmax      = EMMAX_DEFAULT;		// default in sdm.h
	int remmax     = REMMAX_DEFAULT;	// default in sdm.h
	double epsilon = EPSILON_DEFAULT;	// default in sdm.h
	double *lambda, **alpha;
	document *data;
	FILE *lp, *ap;
	char c;
	int nlex, dlenmax;

	while ((c = getopt(argc, argv, "M:I:E:h")) != -1)
	{
		switch (c) {
		case 'M' : nmixtures = atoi(optarg); break;
		case 'I' : emmax = atoi(optarg); break;
		case 'R' : remmax = atoi(optarg); break;
		case 'E' : epsilon = atof(optarg) / 100.0; break;
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
		  emmax, remmax, epsilon);
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
	printf(SDM_COPYRIGHT);
	printf("$Id: sdm.c,v 1.2 2006/02/02 16:28:51 dmochiha Exp $\n");
	printf("usage: %s -M mixtures [-I emmax] [-R remmax] [-E epsilon] train model\n", "sdm");
	exit(0);
}
