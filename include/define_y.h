/****************************************************************************
**
*A  define_y.h                  ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

/* definition of the y array;
   place this as the first line of the routine, before other declarations */

#ifdef Magma
register int *y = mem_access(pcp->y_handle);
#else
register int *y = y_address;
#endif
