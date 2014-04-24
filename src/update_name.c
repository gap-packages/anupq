/****************************************************************************
**
*A  update_name.c               ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pcp_vars.h"

/* update the name of the immediate descendant by appending to the name,
   string, of the parent a ' #' followed by its number, x, in the
   sequence of immediate descendants constructed,  a '; ', and step size */

void update_name(char *string, int x, int step_size)
{
   register int length;
   if ((length = strlen(string)) < MAXIDENT - 15)
      sprintf(string + length, " #%d;%d", x, step_size);
}
