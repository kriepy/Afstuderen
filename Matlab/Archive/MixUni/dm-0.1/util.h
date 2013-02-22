/*
    util.h
    $Id: util.h,v 1.2 2004/11/18 12:57:20 dmochiha Exp $

*/
#ifndef __UTIL_H__
#define __UTIL_H__
#define  min(x,y)	(((x) < (y)) ? (x) : (y))
#define  max(x,y)	(((x) > (y)) ? (x) : (y))

extern int  myclock (void);
extern char *rtime (double t);
extern char *strconcat(const char *s, const char *t);
extern int  converged (double *u, double *v, int n, double threshold);
extern int  doublecmp (double *x, double *y);
extern void normalize_matrix_row (double **dst, double **src, int rows, int cols);
extern void normalize_matrix_col (double **dst, double **src, int rows, int cols);
extern double logsumexp (double x, double y, int init);

#endif
