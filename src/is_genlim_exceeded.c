#include "pq_defs.h"
#include "pcp_vars.h"

/* test that the total number of occurrences of each defining 
   generator in the structure of a pcp-generator about to be 
   introduced in tails does not exceed some maximum set up in option */

Logical is_genlim_exceeded (pcp)
struct pcp_vars *pcp;   
{
#include "define_y.h"

   register int i, j;
   register int moccur;
   register int toccur;

   moccur = pcp->dgen + pcp->ndgen;
   toccur = pcp->lused + pcp->cc;

   for (i = pcp->ndgen; i > 0; i--)
      if ((j = y[moccur + i]) > 0 && y[toccur + i] > j)
	 return FALSE;

   return TRUE;
}
