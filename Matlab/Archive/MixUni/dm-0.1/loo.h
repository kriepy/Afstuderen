/*
    loo.h
    $Id: loo.h,v 1.3 2004/11/24 14:58:37 dmochiha Exp $

*/
#ifndef DM_LOO_H
#define DM_LOO_H
#include "feature.h"

#define LOO_ITER_MAX	50

extern void
loo_maximize_alpha (double **alpha, double **p, document *data, double *d0,
		    int nmixtures, int nlex, double epsilon);


#endif
