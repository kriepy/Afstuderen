/*
    newton.h
    a header file for Newton-Raphson.
    $Id: newton.h,v 1.2 2006/01/13 13:02:12 dmochiha Exp $

*/
#ifndef LDA_NEWTON_H
#define LDA_NEWTON_H
#define MAX_RECURSION_LIMIT  20
#define MAX_NEWTON_ITERATION 40

extern void newton_beta (double *alpha, double **gammas,
			 int nlen, int nclass, int level);


#endif
