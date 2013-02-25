/*
    feature.c
    an implementation of feature matrix.
    $Id: feature.c,v 1.1 2005/12/27 14:10:29 dmochiha Exp $

*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "feature.h"
#define  BUFSIZE  256000
static int n_fields (char *line);
static int file_lines (FILE *fp);
static int isspaces (char *s);

document *
feature_matrix (char *file_name, int *nid, int *maxlen)
{
	static char line[BUFSIZE];
	document *d;
	int  n, m;
	FILE *fp;
	*nid = 0;
	*maxlen =  0;

	if ((fp = fopen(file_name, "r")) == NULL)
		return NULL;
	m = file_lines(fp);
	if ((d = (document *)calloc(m + 1, sizeof(document))) == NULL)
		return NULL;
	d[m].len = -1;
	
	n = 0;
	while (fgets(line, sizeof(line), fp))
	{
		int i, len;
		char *cp, *sp, *lp = line;

		if (isspaces(line))
			continue;
		
		len = n_fields(line);
		if (len > *maxlen)
			*maxlen = len;
		if (!(len > 0)) {
			fprintf(stderr, "feature_matrix: suspicious line:\n%s",
				line);
			exit(1);
		}

		d[n].id  = (int *)calloc(len, sizeof(int));
		d[n].cnt = (double *)calloc(len, sizeof(double));
		d[n].len = len;
		if ((d[n].id == NULL) || (d[n].cnt == NULL))
			return NULL;

		i = 0;
		cp = strchr(lp, ':');
		sp = strpbrk(lp, " \t\n");
		if (sp < cp)
			lp = sp + 1;	/* skip for first numeral */
		
		while (*lp)
		{
			int id;
			double cnt;
			if ((cp = strchr(lp, ':')) == NULL)
				break;
			if ((sp = strpbrk(cp + 1, " \t\n")) == NULL)
				break;
			*cp = '\0';
			*sp = '\0';
			id  = atoi(lp) - 1;	/* zero origin */
			cnt = atof(cp + 1);
			if (id >= *nid)
				*nid = id + 1;
			d[n].id[i]  = id;
			d[n].cnt[i] = cnt;
			lp  = sp + 1;
			i++;
		}
		n++;
	}
	fclose(fp);
	return(d);
}

void
free_feature_matrix (document *matrix)
{
	document *dp;
	for (dp = matrix; (dp->len) != -1; dp++)
	{
		free(dp->id);
		free(dp->cnt);
	}
	free(matrix);
}

static int
file_lines (FILE *fp)
{
	int n = 0;
	char buf[BUFSIZE];
	
	while (fgets(buf, sizeof(buf), fp))
	{
		if (!isspaces(buf))
			n++;
	}
	rewind(fp);
	
	return n;
}

static int
n_fields (char *line)
{
	int n = 0;
	char *cp, *sp, *lp = line;

	cp = strchr(lp, ':');
	sp = strpbrk(lp, " \t\n");
	if (sp < cp)
		lp = sp + 1;	/* skip for first numeral */

	while (*lp)
	{
		if ((cp = strchr(lp, ':')) == NULL)
			break;
		if ((sp = strpbrk(cp + 1, " \t\n")) == NULL)
			break;
		lp = sp + 1;
		n++;
	}

	return n;
}

static int
isspaces (char *s)	/* return 1 if s consists of only white spaces */
{
	char *c = s;
	while (*c)
	{
		if (!isspace(*c))
			return 0;
		c++;
	}
	return 1;
}


/* $Id: feature.c,v 1.1 2005/12/27 14:10:29 dmochiha Exp $ */
