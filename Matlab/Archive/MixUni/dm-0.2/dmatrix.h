/*
    dmatrix.h
    a header file of double matrix.
    $Id: dmatrix.h,v 1.1 2005/12/27 14:10:28 dmochiha Exp $
    
*/
#ifndef __DMATRIX_H__
#define __DMATRIX_H__

extern double **dmatrix(int rows, int cols);
extern void free_dmatrix(double **matrix, int rows);

#endif
