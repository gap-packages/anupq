#include "pq_defs.h"
#include "constants.h"

/* read information for tails */

void tail_info (tail_type)
int *tail_type;
{
   Logical reading = TRUE;

   while (reading) {
      read_value (TRUE, "Add new tails (1), compute tails (2) or both (0): ",
		  tail_type, 0);
      reading = (*tail_type > 2);
      if (reading) printf ("Supplied value must lie between 0 and 2\n");
   }
}
