#include "pq_defs.h"
#include "constants.h"

/* fopen file */

FILE* OpenFile (file_name, mode)
char *file_name;
char *mode;
{
   FILE *fp; 
  
   if ((fp = fopen (file_name, mode)) == NULL) {
#ifdef Magma
      error_internal ("Cannot open %s", file_name);
#else
      printf ("Cannot open %s\n", file_name);
      if (!isatty (0))
	 exit (FAILURE);
#endif
   }

   return fp;
}

FILE* OpenFileOutput (file_name)
char *file_name;
{
   FILE *fp; 
   char *mode = "w";
  
   if ((fp = fopen (file_name, mode)) == NULL) {
#ifdef Magma
      error_internal ("Cannot open %s", file_name);
#else
      printf ("Cannot open %s\n", file_name);
      if (!isatty (0))
	 exit (FAILURE);
#endif
   }

   return fp;
}

FILE* OpenFileInput (file_name)
char *file_name;
{
   FILE *fp; 
   char *mode = "r";

   if ((fp = fopen (file_name, mode)) == NULL) {
#ifdef Magma
      error_internal ("Cannot open %s", file_name);
#else
      printf ("Cannot open %s\n", file_name);
      if (!isatty (0))
	 exit (FAILURE);
#endif
   }

   return fp;
}

/* open file for fread and fwrite */

FILE* OpenSystemFile (file_name, mode)
char *file_name;
char *mode;
{
   FILE *fp; 
     
   if ((fp = fopen (file_name, mode)) == NULL) {
#ifdef Magma
      error_internal ("Cannot open %s", file_name);
#else
      perror (NULL);
      printf ("Cannot open %s\n", file_name);
      exit (FAILURE);
#endif
   }

   setbuf (fp, NULL);
   return fp;
}
