/****************************************************************************
**
*A  read_parameters.c           ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pcp_vars.h"
#include "constants.h"
#include "pq_functions.h"

/* exponents are packed into the top WORD_LENGTH - SC2 = 15 bits of an int
   (see storage_fixed.h), so p - 1 must fit there; MAXPRIME is the largest
   prime below 2^15 */
#define MAXPRIME 32749

/* return TRUE if p is a prime the pq can handle, else say why not */
int valid_prime(int p)
{
   int d;
   if (p > MAXPRIME) {
      printf("The prime must be at most %d\n", MAXPRIME);
      return FALSE;
   }
   if (p < 2) {
      printf("%d is not a prime\n", p);
      return FALSE;
   }
   for (d = 2; d * d <= p; ++d)
      if (p % d == 0) {
         printf("%d is not a prime\n", p);
         return FALSE;
      }
   return TRUE;
}

/* read parameters for p-quotient calculation */

void
read_parameters(int format, int *max_class, int *output, struct pcp_vars *pcp)
{
   Logical reading = TRUE;
   char *ident;

#if defined(GROUP)
   ident = GetString("Input group identifier: ");
#endif

   snprintf(pcp->ident, MAXIDENT, "%s", ident);

   while (reading) {
      read_value(TRUE, "Input prime: ", &pcp->p, 2);
      reading = !valid_prime(pcp->p);
   }

   read_value(TRUE, "Input maximum class: ", max_class, 0);
   if (*max_class == 0) {
      *max_class = DEFAULT_CLASS;
      text(15, DEFAULT_CLASS, 0, 0, 0);
   } else if (*max_class > MAXCLASS) {
      *max_class = MAXCLASS;
      text(15, MAXCLASS, 0, 0, 0);
   }

   print_level(output, pcp);

   if (format == BASIC) {
      reading = TRUE;
      while (reading) {
         read_value(TRUE, "Input number of generators: ", &pcp->ndgen, 1);
         reading = (pcp->ndgen > MAXGENS);
         if (reading)
            printf("The maximum number of defining generators is %d\n",
                   MAXGENS);
      }

#if defined(GROUP)
      read_value(TRUE, "Input number of relations: ", &pcp->ndrel, 0);
      read_value(
          TRUE, "Input exponent law (0 if none): ", &pcp->extra_relations, 0);
#endif

      /* initialise pcp structure */
      initialise_pcp(*output, pcp);
      setup(pcp);
      read_relations(pcp);
   } else {
      pretty_read_generators(pcp);
      pretty_read_relations(*output, max_class, pcp);
   }
}
