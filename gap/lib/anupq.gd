#############################################################################
####
##
#A  anupq.gd                 ANUPQ share package               Eamonn O'Brien
#A                                                             & Frank Celler
##
##  Declaration file for ``general'' group functions and variables.
##
#A  @(#)$Id$
##
#Y  Copyright 1992-1994,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  Copyright 1992-1994,  School of Mathematical Sciences, ANU,     Australia
##
Revision.anupq_gd :=
    "@(#)$Id$";

#############################################################################
##
#F  ANUPQDirectoryTemporary( <dir> ) . . . . .  redefine ANUPQ temp directory
##
DeclareGlobalFunction( "ANUPQDirectoryTemporary" );

#############################################################################
##
#F  ANUPQerrorPq( <param> ) . . . . . . . . . . . . . . . . . report an error
##
DeclareGlobalFunction( "ANUPQerrorPq" );

#############################################################################
##
#F  ANUPQextractPqArgs( <args> )  . . . . . . . . . . . . . extract arguments
##
DeclareGlobalFunction( "ANUPQextractPqArgs" );

#############################################################################
##
#V  ANUPQGlobalVariables
##
DeclareGlobalVariable( "ANUPQGlobalVariables", 
                       "A list of names of ANUPQ global variables" );

#############################################################################
##
#F  ANUPQReadOutput . . . . read pq output without affecting global variables
##
DeclareGlobalFunction( "ANUPQReadOutput" );

#############################################################################
##
#F  PqEpimorphism   . . . . . . . . . . . . . . .  epimorphism onto a p-group
##
DeclareGlobalFunction( "PqEpimorphism" );

#############################################################################
##
#F  Pq( <G>, ... )  . . . . . . . . . . . . . . . . . . . . .  prime quotient
##
DeclareGlobalFunction( "Pq" );

#############################################################################
##
#F  PqRecoverDefinitions( <G> ) . . . . . . . . . . . . . . . . . definitions
##
##  This function finds a definition for each generator of the p-group <G>.
##  These definitions need not be the same as the ones used by pq.  But
##  they serve the purpose of defining each generator as a commutator or
##  power of earlier ones.  This is useful for extending an automorphism that
##  is given on a set of minimal generators of <G>.
##
DeclareGlobalFunction( "PqRecoverDefinitions" );
 
#############################################################################
##
#F  PqAutomorphism( <epi>, <autoimages> ) . . . . . . . . . . . . definitions
##
##  Take an automorphism of the preimage and produce the induced automorphism
##  of the image of the epimorphism.
##
DeclareGlobalFunction( "PqAutomorphism" );

#E  anupq.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
