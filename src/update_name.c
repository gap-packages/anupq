#include "pq_defs.h"
#include "pcp_vars.h"

/* update the name of the immediate descendant by appending to the name, 
   string, of the parent a ' #' followed by its number, x, in the 
   sequence of immediate descendants constructed,  a '; ', and step size */

void update_name (string, x, step_size) 
char *string;
int x;
int step_size;
{
   register int length;
   if ((length = strlen (string)) < MAXIDENT - 15)
      sprintf (string + length, " #%d;%d\0", x, step_size);
}
