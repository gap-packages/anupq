/****************************************************************************
**
*A  read_value.c                ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "constants.h"
#include "pcp_vars.h"

/* function to read line */

void read_line(void)
{
   int c;

   while ((c = getchar()) != EOF && c != '\n')
      ;
}

/* continue to read parameter until its value is at least lower_bound */

void read_value(Logical newline, char *string, int *value, int lower_bound)
{
   char response[MAXWORD];
   Logical error;
   Logical reading = TRUE;
   int nmr_items;

   while (reading) {
      printf("%s", string);
      nmr_items = scanf(MAXWORD_SCANF, response);
      verify_read(nmr_items, 1);

      /* read past any comments */
      while (response[0] == COMMENT) {
         read_line();
         nmr_items = scanf(MAXWORD_SCANF, response);
         verify_read(nmr_items, 1);
      }
      if (!interactive_input())
         printf("%s ", response);
      if (!interactive_input() && newline)
         printf("\n");
      *value = string_to_int(response, &error);
      if (error)
         printf("Error in input -- must be integer only (but is '%s')\n", response);
      else if ((reading = (*value < lower_bound)))
         printf("Error: supplied value must be at least %d\n", lower_bound);
   }
}

/* convert string s to integer */

int string_to_int(char *s, Logical *error)
{
   int i, n, sign;

   *error = FALSE;

   for (i = 0; isspace(s[i]); i++) /* skip white space */
      ;
   sign = (s[i] == '-') ? -1 : 1;
   if (s[i] == '+' || s[i] == '-') /* skip sign */
      i++;
   for (n = 0; s[i] != '\0'; i++) {
      if (isdigit(s[i])) {
         n = 10 * n + (s[i] - '0');
      } else {
         *error = TRUE;
         return 0;
      }
   }

   return sign * n;
}

/* read a whitespace-delimited token of any length from stdin;
   return NULL at end of input */

static char *read_token(void)
{
   size_t size = MAXIDENT, length = 0;
   char *s;
   int c;

   while ((c = getchar()) != EOF && isspace(c))
      ;
   if (c == EOF)
      return NULL;

   s = (char *)malloc(size);
   for (; c != EOF && !isspace(c); c = getchar()) {
      if (length + 1 == size)
         s = (char *)realloc(s, size *= 2);
      s[length++] = c;
   }
   s[length] = '\0';

   /* leave the delimiter unread, as scanf does, for read_line */
   if (c != EOF)
      ungetc(c, stdin);

   return s;
}

/* read in string */

char *GetString(char *string)
{
   char *s;

   printf("%s", string);

   s = read_token();
   verify_read(s != NULL, 1);
   while (s[0] == COMMENT) {
      free(s);
      read_line();
      s = read_token();
      verify_read(s != NULL, 1);
   }
   if (!interactive_input())
      printf("%s\n", s);

   return s;
}
