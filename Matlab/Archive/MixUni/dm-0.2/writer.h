/*
    writer.h
    a header file of vector/matrix writer.
    $Id: writer.h,v 1.3 2006/02/02 08:51:24 dmochiha Exp $

*/
#ifndef DM_WRITER_H
#define DM_WRITER_H
#include <stdio.h>

extern void dm_write (FILE *lp, FILE *ap, double *lambda, double **alpha,
		      int nmixtures, int nlex);
extern void write_vector (FILE *fp, double *vector, int n);
extern void write_vector_file (char *file, double *vector, int n);
extern void write_matrix (FILE *fp, double **matrix, int rows, int cols);
extern void write_matrix_transposed (FILE *fp, double **matrix, int rows, int cols);
extern void write_matrix_file (char *file, double **matrix, int rows, int cols);
extern void write_matrix_file_transposed (char *file, double **matrix, int rows, int cols);

#endif
