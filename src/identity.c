#include "pq_defs.h"
#include "pga_vars.h"

/* set up the identity permutation */

void setup_identity_perm (permutation, pga) 
int *permutation;
struct pga_vars *pga;
{
   register int i;

   for (i = 1; i <= pga->Degree; ++i)
      permutation[i] = i;
}
