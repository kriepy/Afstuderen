/*
   learn.h
   $Id: learn.h,v 1.1 2004/11/12 07:57:15 dmochiha Exp $

*/
#ifndef DM_LEARN_H
#define DM_LEARN_H
#include "feature.h"
#define RANDOM ((double)rand()/(double)RAND_MAX)

extern void dm_learn (document *data, double *lambda, double **alpha,
		      int nmixtures, int nlex, int emmax, double epsilon);


#endif
