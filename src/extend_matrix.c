/****************************************************************************
**
*A  extend_matrix.c             ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pcp_vars.h"
#include "constants.h"
#include "pq_functions.h"

int **reallocate_matrix (int **a, int orig_n, int orig_m, int n, int m, Logical zero);

/* extend the space available for storage of automorphisms */

int **extend_matrix (int **current, struct pcp_vars *pcp)
{
   register int *y = y_address;

   int nmr_of_generators;
   int **auts;

   nmr_of_generators = y[pcp->clend + 1];

   auts = reallocate_matrix (current, nmr_of_generators,
			     nmr_of_generators, pcp->lastg, pcp->lastg, TRUE); 

   return auts;
}
