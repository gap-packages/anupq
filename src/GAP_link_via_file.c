/****************************************************************************
**
*A  GAP_link_via_file.c         ANUPQ source                   Eamonn O'Brien
*A                                                             & Frank Celler
*A                                                           & Benedikt Rothe
**
*A  @(#)$Id$
**
*Y  Copyright 1995-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-1997,  School of Mathematical Sciences, ANU,     Australia
**
*H  $Log$
*H  Revision 1.1.1.1  2001/04/15 15:09:32  werner
*H  Try again to import ANUPQ. WN
*H
*/
#if defined(GAP_LINK_VIA_FILE)

#include "pq_defs.h"
#include "pcp_vars.h"
#include "pga_vars.h"
#include "constants.h"
#include "pq_functions.h"
#include "menus.h"


/****************************************************************************
**
*F  start_GAP_file
**          write out initial information required for stabiliser calculation
**
*/
void start_GAP_file ( GAP_input, auts, pga, pcp )
    FILE             ** GAP_input;
    int             *** auts;
    struct pga_vars   * pga;
    struct pcp_vars   * pcp;
{
   register int i;
   int nmr_soluble = pga->nmr_soluble;

   /* open "GAP_input" file                                               */
   *GAP_input = OpenSystemFile( "GAP_input", "w+" );

   GAP_presentation (*GAP_input, pcp, 1);
#ifdef LARGE_INT
   Magma_report_autgp_order (*GAP_input, pga, pcp);                           
#endif

   /* write global variables                                              */
   fprintf( *GAP_input, "ANUPQglb := rec();;\n"                );
   fprintf( *GAP_input, "ANUPQglb.d := %d;;\n",     pcp->ccbeg - 1);
   fprintf( *GAP_input, "ANUPQglb.F := GF(%d);;\n", pga->p     );
   fprintf( *GAP_input, "ANUPQglb.one := One (ANUPQglb.F);;\n"     );
   fprintf( *GAP_input, "ANUPQglb.q := %d;;\n",     pga->q     );
   fprintf( *GAP_input, "ANUPQglb.s := %d;;\n",     pga->s     );
   fprintf( *GAP_input, "ANUPQglb.r := %d;;\n",     pga->r     );
   fprintf( *GAP_input, "ANUPQglb.agAutos := [];;\n"              );
   fprintf( *GAP_input, "ANUPQglb.glAutos := [];;\n"              );
   fprintf( *GAP_input, "ANUPQglb.genQ := [];;\n"              );

   /* write the generators <gendp> to file                                */
   for (i = 1; i <= nmr_soluble; ++i) 
     write_GAP_matrix(*GAP_input,"ANUPQglb.agAutos",auts[i],pcp->ccbeg - 1,1,i);


#ifdef DEBUG1 
   printf ("The relative orders are ");
      for (i = 1; i <= nmr_soluble; ++i) 
          printf ("%d, ", pga->relative[i]);
      printf ("\n");
#endif

   fprintf (*GAP_input,"relativeOrders := [");
   if (nmr_soluble > 0) {
      for (i = 1; i < nmr_soluble; ++i) 
          fprintf (*GAP_input, "%d, ", pga->relative[i]);
      fprintf (*GAP_input, "%d", pga->relative[nmr_soluble]);
   }
   fprintf (*GAP_input, "]; ");

   for (i = nmr_soluble + 1; i <= pga->m; ++i) 
     write_GAP_matrix(*GAP_input,"ANUPQglb.glAutos",auts[i],pcp->ccbeg - 1,
                      1, i - nmr_soluble);
}


/****************************************************************************
**
*F  write_GAP_matrix
**                                     write out a matrix in a GAP input form
**
*/
void write_GAP_matrix ( GAP_input, gen, A, size, start, nr ) 
    FILE      * GAP_input;
    char      * gen;
    int      ** A;
    int         size;
    int         start;
    int         nr;
{
   int         i, j;

   fprintf( GAP_input, "%s[%d] := [\n", gen, nr );
   for ( i = start;  i < start + size;  ++i )
   {
      fprintf( GAP_input, "[" );
      for ( j = start;  j < start + size - 1;  ++j )  
	 fprintf( GAP_input, "%d, ", A[i][j] );
      if ( i != start + size - 1 )
	 fprintf( GAP_input, "%d],\n", A[i][j] );
      else
	 fprintf( GAP_input, "%d]] * ANUPQglb.one;;\n", A[i][j] );
   }
}


/****************************************************************************
**
*F  insoluble_stab_gens
**          calculate the stabiliser of the supplied representative using GAP
**
*/
void insoluble_stab_gens ( rep, orbit_length, pga, pcp ) 
    int     rep;
    int     orbit_length;
    struct pga_vars *pga;
    struct pcp_vars *pcp;
{
   FILE  * GAP_rep;
   char  * path,  *command;
   int index;
   int *subset;
   int **S;                                                                     

   /* append the commands to compute the stabilizer                       */
   GAP_rep = OpenFile( "GAP_rep", "w+" );

/* 
   fprintf( GAP_rep, "RequirePackage( \"anupq\" );\n" );
   fprintf( GAP_rep, "stab := ANUPQstabilizer(%d, %d, ANUPQglb);;\n",
	    rep, orbit_length );
   fprintf( GAP_rep, "ANUPQoutputResult( stab, \"LINK_output\" );\n" );
*/

   S = label_to_subgroup (&index, &subset, rep, pga);
   GAP_factorise_subgroup (GAP_rep, S, index, subset, pga, pcp);
   free_matrix (S, pga->s, 0);
   free_vector (subset, 0);                                                     
   fprintf( GAP_rep, "ReadPkg(\"anupq\", \"gap/lib/anustab.g\");");
   fprintf( GAP_rep, "quit;\n" );

   CloseFile( GAP_rep );

   /* try to find gap                                                     */
   if ( ( path = (char*) getenv( "ANUPQ_GAP_EXEC" ) ) == NULL )
#       if defined( ANUPQ_GAP_EXEC )
      path = ANUPQ_GAP_EXEC;
#       else
   path = "gap";
#       endif
   command = (char*) malloc( strlen(path) + 200 );
#ifdef NeXT
   strcpy( command, "exec " );
   strcat( command, path    );
#else
   strcpy( command, path );
#endif
#if 0
   strcat( command, " -q GAP_input < GAP_rep > GAP_log" );
#else
   strcat( command, " -q GAP_input < GAP_rep" );
#endif

   /* inform the user that we are about to call gap                       */
   if (isatty (0)) 
      printf ("Now calling GAP to compute stabiliser...\n");
   unlink( "LINK_output" );

   /* compute the stabiliser of the orbit representative                  */
#   if defined (SPARC) || defined(NeXT)
   if ( vsystem(command) != 0 )
#   else
      if ( system(command) != 0 )
#   endif 
      {
	 printf( "Error in system call to GAP\n" );
	 exit(FAILURE);
      }
   CloseFile( OpenFile( "LINK_output", "r" ) );
   free( command );
   unlink( "GAP_log" );
   unlink( "GAP_rep" );
}

#endif 
