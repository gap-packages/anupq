#############################################################################
####
##
#A  anupq.gd                    ANUPQ package                  Eamonn O'Brien
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
#F  PqEpimorphism( <arg> : <options> )  . . . . .  epimorphism onto a p-group
##
DeclareGlobalFunction( "PqEpimorphism" );

#############################################################################
##
#F  Pq( <arg> : <options> )  . . . . . . . . . . . . . . . . . prime quotient
##
DeclareGlobalFunction( "Pq" );

#############################################################################
##
#F  PQ_GET_PQUOTIENT( <datarec> ) . . . extract p-quotient from file into GAP
##
DeclareGlobalFunction( "PQ_GET_PQUOTIENT" );

#############################################################################
##
#F  PQ_EPIMORPHISM( <args> : <options> ) . . . . . prime quotient epimorphism
##
DeclareGlobalFunction( "PQ_EPIMORPHISM" );

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

#############################################################################
##
#F  PqLeftNormComm( <words> ) . . . . . . . . . . . . .  left norm commutator
##
DeclareGlobalFunction( "PqLeftNormComm" );

#############################################################################
##
#F  PqGAPRelators( <group>, <rels> ) . . . . . . . . pq relators as GAP words
##
DeclareGlobalFunction( "PqGAPRelators" );

#############################################################################
##
#F  PQ_EVALUATE( <string> ) . . . . . . . . . evaluate a string emulating GAP
##
DeclareGlobalFunction( "PQ_EVALUATE" );

#############################################################################
##
#F  PqExample() . . . . . . . . . . execute a pq example or display the index
#F  PqExample( <filename>[, PqStart] )
##
DeclareGlobalFunction( "PqExample" );

#E  anupq.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
