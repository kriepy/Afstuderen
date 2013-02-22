/*
   random.c
   $Id: random.c,v 1.1 2005/12/27 04:11:12 dmochiha Exp $

   References:
   [1]  L. Devroye, "Non-Uniform Random Variate Generation",
   Springer-Verlag, 1986
   http://cgm.cs.mcgill.ca/~luc/rnbookindex.html

*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "random.h"

double
gamrand (double a)
{
	double x, y, z;
	double u, v, w, b, c, e;
	int accept = 0;
	if (a < 1)
	{
		/* a < 1. Johnk's generator. Devroye (1986) p.418 */
		e = exprand();
		do {
			x = pow(RANDOM, 1 / a);
			y = pow(RANDOM, 1 / (1 - a));
		} while (x + y > 1);
		return (e * x / (x + y));
	} else {
		/* a >= 1. Best's rejection algorithm. Devroye (1986) p.410 */
		b = a - 1;
		c = 3 * a - 0.75;
		do {
			/* generate */
			u = RANDOM;
			v = RANDOM;
			w = u * (1 - u);
			y = sqrt(c / w) * (u - 0.5);
			x = b + y;
			if (x >= 0)
			{
				z = 64 * w * w * w * v * v;
				if (z <= 1 - (2 * y * y) / x)
				{
					accept = 1;
				} else {
					if (log(z) < 2 * (b * log(x / b) - y))
						accept = 1;
				}
			}
		} while (accept != 1);
		return x;
	}
}

void
dirrand (double *theta, double *alpha, int k, double prec)
{
	double z = 0;
	int i;
	/* theta must have been allocated */
	for (i = 0; i < k; i++)
		if (prec != 0)
			theta[i] = gamrand(alpha[i] * prec);
		else
			theta[i] = gamrand(alpha[i]);
	for (i = 0; i < k; i++)
		z += theta[i];
	for (i = 0; i < k; i++)
		theta[i] /= z;
}

double
exprand (void)
{
	return (- log(RANDOM));
}

