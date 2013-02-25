/*
    random.h
    $Id: random.h,v 1.1 2005/12/27 04:11:11 dmochiha Exp $

*/
#ifndef __RANDOM_H__
#define __RANDOM_H__
#include <stdlib.h>
#define RANDOM ((double)rand()/(double)RAND_MAX)

double exprand (void);
double gamrand (double a);
void   dirrand (double *theta, double *alpha, int k, double prec);

#endif
