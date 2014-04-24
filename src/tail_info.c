/****************************************************************************
**
*A  tail_info.c                 ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "constants.h"

/* read information for tails */

void tail_info(int *tail_type)
{
   Logical reading = TRUE;

   while (reading) {
      read_value(TRUE,
                 "Add new tails (1), compute tails (2) or both (0): ",
                 tail_type,
                 0);
      reading = (*tail_type > 2);
      if (reading)
         printf("Supplied value must lie between 0 and 2\n");
   }
}
