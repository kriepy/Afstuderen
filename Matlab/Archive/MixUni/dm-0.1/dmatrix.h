/*
    dmatrix.h
    a header file of double matrix.
    $Id: dmatrix.h,v 1.1 2004/11/09 04:46:51 dmochiha Exp $
    
*/
#ifndef __DMATRIX_H__
#define __DMATRIX_H__

extern double **dmatrix(int rows, int cols);
extern void free_dmatrix(double **matrix, int rows);

#endif
