/*
    writer.c
    an implementation of vector/matrix writer.
    $Id: writer.c,v 1.3 2006/02/02 08:51:24 dmochiha Exp $

*/
#include <stdio.h>
#include "writer.h"

void
dm_write (FILE *lp, FILE *ap, double *lambda, double **alpha,
	  int nmixtures, int nlex)
{
	printf("writing model..\n"); fflush(stdout);
	write_vector(lp, lambda, nmixtures);
	write_matrix_transposed(ap, alpha, nmixtures, nlex);
	printf("done.\n"); fflush(stdout);
}

void
write_vector (FILE *fp, double *vector, int n)
{
	int i;
	for (i = 0; i < n; i++)
		fprintf(fp, "%.7e%s", vector[i], (i == n - 1) ? "\n" : "   ");
}

void
write_matrix (FILE *fp, double **matrix, int rows, int cols)
{
	int i, j;
	for (i = 0; i < rows; i++)
		for (j = 0; j < cols; j++)
			fprintf(fp, "%.7e%s", matrix[i][j],
				(j == cols - 1) ? "\n" : "   ");
}

void
write_matrix_transposed (FILE *fp, double **matrix, int rows, int cols)
{
	int i, j;
	for (i = 0; i < cols; i++)
		for (j = 0; j < rows; j++) {
			fprintf(fp, "%.7e%s", matrix[j][i],
				(j == rows - 1) ? "\n" : "   ");
		}
}

void
write_vector_file (char *file, double *vector, int n)
{
	FILE *fp;
	if ((fp = fopen(file, "w")) == NULL) {
		fprintf(stderr, "write_vector_file: can't write %s.\n", file);
		return;
	}
	write_vector(fp, vector, n);
	fclose(fp);
}

void
write_matrix_file (char *file, double **matrix, int rows, int cols)
{
	FILE *fp;
	if ((fp = fopen(file, "w")) == NULL) {
		fprintf(stderr, "write_matrix_file: can't write %s.\n", file);
		return;
	}
	write_matrix(fp, matrix, rows, cols);
	fclose(fp);
}

void
write_matrix_file_transposed (char *file, double **matrix, int rows, int cols)
{
	FILE *fp;
	if ((fp = fopen(file, "w")) == NULL) {
		fprintf(stderr, "write_matrix_file_transposed: can't write %s.\n", file);
		return;
	}
	write_matrix_transposed(fp, matrix, rows, cols);
	fclose(fp);
}

