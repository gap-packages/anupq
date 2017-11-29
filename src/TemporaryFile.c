/****************************************************************************
**
*A  TemporaryFile.c             ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pq_functions.h"
#include "constants.h"

/* set up a temporary file and return an appropriate FILE * indicator;
   if in Unix environment, open temporary file in directory specified
   by value of environment variable TMPDIR, else on /var/tmp */

FILE *TemporaryFile(void)
{
   FILE *file = tmpfile();

   if (file == NULL) {
      perror("Cannot open temporary file");
      exit(FAILURE);
   }

   return file;
}
