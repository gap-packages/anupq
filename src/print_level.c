#include "pq_defs.h"
#include "pcp_vars.h"
#include "constants.h"

/* set print levels for p-quotient calculation */

void print_level (output, pcp)
int *output;
struct pcp_vars *pcp;
{
   Logical reading = TRUE;

#ifndef Magma
   while (reading) {
      read_value (TRUE, "Input print level (0-3): ", output, MIN_PRINT);
      if (reading = (*output > MAX_PRINT))  
	 printf ("Print level must lie between %d and %d\n",
		 MIN_PRINT, MAX_PRINT);
   }
#endif

   pcp->diagn = (*output == MAX_PRINT);
   pcp->fullop = (*output >= INTERMEDIATE_PRINT);
}
