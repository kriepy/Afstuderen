/*
    likelihood.h
    $Id: likelihood.h,v 1.2 2004/11/18 12:57:19 dmochiha Exp $

*/
#ifndef DM_LIKELIHOOD_H
#define DM_LIKELIHOOD_H

extern double
dm_lik (document *data, double *lambda, double **alpha,
	double *d0, double *alpha0,
	int nmixtures, int nlex);

#endif
