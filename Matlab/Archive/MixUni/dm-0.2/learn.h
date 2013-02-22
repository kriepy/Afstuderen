/*
   learn.h
   $Id: learn.h,v 1.2 2006/02/02 16:28:56 dmochiha Exp $

*/
#ifndef DM_LEARN_H
#define DM_LEARN_H
#include "feature.h"
#define RANDOM ((double)rand()/(double)RAND_MAX)
#define INITIAL_PCOUNT	0.01	/* initial pseudo count per word */

extern void dm_learn (document *data, double *lambda, double **alpha,
		      int nmixtures, int nlex, int emmax, int remmax, double epsilon);

#endif
