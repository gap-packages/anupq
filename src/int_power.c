/****************************************************************************
**
*A  int_power.c                 ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

/* return the power, x^n  */

int int_power (int x, int n)
{
   register int result = 1;

   while (n != 0) {
      if (n % 2 == 1) result *= x;  
      if (n > 1) x *= x;
      n = n >> 1;
   }

   return result;
}
