#include "pq_defs.h"
#include "pcp_vars.h"
#include "constants.h"
#include "pq_functions.h"

int **reallocate_matrix ();

/* extend the space available for storage of automorphisms */

int **extend_matrix (current, pcp)
int **current;
struct pcp_vars *pcp;
{
#include "define_y.h"

   int nmr_of_generators;
   int **auts;

   nmr_of_generators = y[pcp->clend + 1];

   auts = reallocate_matrix (current, nmr_of_generators,
			     nmr_of_generators, pcp->lastg, pcp->lastg, TRUE); 

   return auts;
}
