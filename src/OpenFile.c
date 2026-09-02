/****************************************************************************
**
*A  OpenFile.c                  ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "constants.h"

/* pq exchanges its files with GAP and with itself, and some hold raw
   fread/fwrite data: never let the Windows C runtime translate line
   endings in them, or take a 0x1A byte for end of file */

static FILE *fopen_untranslated(const char *file_name, const char *mode)
{
#ifdef _WIN32
   char bmode[8];
   snprintf(bmode, sizeof(bmode), "%sb", mode);
   mode = bmode;
#endif
   return fopen(file_name, mode);
}

/* fopen file */

FILE *OpenFile(const char *file_name, const char *mode)
{
   FILE *fp = fopen_untranslated(file_name, mode);

   if (fp == NULL) {
      fprintf(stderr, "Cannot open %s\n", file_name);
      if (!interactive_input())
         exit(FAILURE);
   }

   return fp;
}

FILE *OpenFileOutput(const char *file_name)
{
   return OpenFile(file_name, "w");
}

FILE *OpenFileInput(const char *file_name)
{
   return OpenFile(file_name, "r");
}

/* open file for fread and fwrite */

FILE *OpenSystemFile(const char *file_name, const char *mode)
{
   FILE *fp;

   if ((fp = fopen_untranslated(file_name, mode)) == NULL) {
      perror(NULL);
      printf("Cannot open %s\n", file_name);
      exit(FAILURE);
   }

   setbuf(fp, NULL);
   return fp;
}
