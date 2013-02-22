/*
    likelihood.h
    $Id: likelihood.h,v 1.3 2006/01/12 04:32:02 dmochiha Exp $

*/
#ifndef DM_LIKELIHOOD_H
#define DM_LIKELIHOOD_H
#include "feature.h"

extern double
dm_lik (document *data, double *lambda, double *s, double **mu,
	double *d0, int nmixtures, int nlex);
extern double
dm_ppl (document *data, double *lambda, double *s, double **mu,
	double *d0, int nmixtures, int nlex);

#endif
