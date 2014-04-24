/****************************************************************************
**
*A  print_arrays.c              ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"

/* procedure to print out integer array */

void print_array(int *a, int first, int last)
{
   register int i;
   for (i = first; i < last; ++i) {
      printf("%d ", a[i]);
      if (i > first && (i - first) % 20 == 0)
         printf("\n");
   }
   printf("\n");
}

/* procedure to print out character array */

void print_chars(char *a, int first, int last)
{
   register int i;
   for (i = first; i < last; ++i)
      printf("%d ", a[i]);
   printf("\n");
}
