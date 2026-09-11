/****************************************************************************
**
*A  system.c                    ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_author.h"
#include "pq_defs.h"
#include "global.h"
#include <sys/types.h>
#ifndef _WIN32
#include <sys/times.h>
#endif

/* system and operating system dependent pieces of code */

/* return CPU time in CLOCK TICKS -- the program should report
   correct CPU times for each of SunOS and Solaris if compiled
   and run under that operating system; under Solaris,
   CLK_TCK is defined in <limits.h>; if compiled under SunOS
   and run under Solaris, then multiply reported times by
   3/5 to get correct user time */

int runTime(void)
{
#ifdef _WIN32
   /* CLK_SCALE is 1.0/CLK_TCK and mingw defines CLK_TCK as
      CLOCKS_PER_SEC, so clock() has the right unit */
   return (int)clock();
#else
   struct tms buffer;

   times(&buffer);
   return buffer.tms_utime + buffer.tms_cutime;
#endif
}

/* pq behaves interactively (prompting, surviving errors) when its input is
   a terminal, and likewise when GAP drives it through a stream, which need
   not be a pty */

Logical interactive_input(void)
{
   return isatty(0) || GAP4iostream;
}

/* print startup message */

void print_message(int work_space)
{
   time_t now;
   char *id;
   char string[100];

#if defined(HAVE_GETHOSTNAME)
   char s[100];
   gethostname(s, 100);
#else
   char *s = (char *)getenv("HOST");
   if (s == NULL)
      s = "unknown";
#endif

#if defined(GROUP)
   id = PQ_VERSION;
#endif

   printf("%s running with workspace %d on %s\n", id, work_space, s);
   now = time(NULL);
#ifdef HAVE_STRFTIME
   strftime(string, 100, "%a %b %d %H:%M:%S %Z %Y", localtime(&now));
   printf("%s\n", string);
#else
   printf("\n");
#endif
}
