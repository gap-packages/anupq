/****************************************************************************
**
*A  expand_commutator.c         ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "constants.h"

/* routines for handling expansion of commutator relations */

static void add(int *x, int *y);
static void invert_symbols(int *x);
static int length(int *s);

/* expand the commutator of s and t */

void expand_commutator(int *s, int t)
{
   int a[MAXWORD];
   register int i;

   for (i = 0; i < MAXWORD; ++i)
      a[i] = s[i];

   invert_symbols(s);
   s[length(s)] = -t;
   add(s, a);
   s[length(s)] = t;
}

/* find the number of non-zero entries in s */

static int length(int *s)
{
   register int i = 0;

   while (i < MAXWORD && s[i] != 0)
      ++i;

   return i;
}

/* concatenate y with x */

static void add(int *x, int *y)
{
   register int j;
   int i = length(x);

   for (j = 0; j < MAXWORD && y[j] != 0; ++j)
      x[i + j] = y[j];
}

/* construct the group-theoretic inverse of the symbols in x */

static void invert_symbols(int *x)
{
   register int i = length(x) - 1;
   register int j;
   int temp, mid;

   mid = i / 2;

   for (j = 0; j <= mid; ++j) {
      temp = x[j];
      x[j] = -x[i - j];
      x[i - j] = -temp;
   }
}
