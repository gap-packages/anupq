#############################################################################
####
##
#A  anusp.gd                 ANUPQ share package               Eamonn O'Brien
#A                                                             Alice Niemeyer 
##
#A  @(#)$Id$
##
#Y  Copyright 1993-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  Copyright 1993-2001,  School of Mathematical Sciences, ANU,     Australia
##
#A  @(#)$Id$
##
Revision.anusp_gd :=
    "@(#)$Id$";

#############################################################################
##
#F  ANUPQSPerror( <param> )  . . . . . . . . . . . . report illegal parameter
##
DeclareGlobalFunction( "ANUPQSPerror" );

#############################################################################
##
#F  ANUPQSPextractArgs( <args> )  . . . . . . . . . . . . parse argument list
##
DeclareGlobalFunction( "ANUPQSPextractArgs" );

#############################################################################
##
#V  ANUSPGlobalVariables
##
DeclareGlobalVariable( "ANUSPGlobalVariables",
  "A list of names of ANUPQ standard presentation variables"
  );

#############################################################################
##
#F  PqFpGroupPcGroup( <G> )
#O  FpGroupPcGroup( <G> )
##
DeclareGlobalFunction( "PqFpGroupPcGroup" );
DeclareOperation( "FpGroupPcGroup", [ IsPcGroup ] );

#############################################################################
##
#F  PQ_EPIMORPHISM_STANDARD_PRESENTATION( <args> ) . . epi. onto SP for group
#F  EpimorphismPqStandardPresentation( <F>, <G> )
#O  EpimorphismStandardPresentation( <F>, <G> )
##
DeclareGlobalFunction( "PQ_EPIMORPHISM_STANDARD_PRESENTATION" );
DeclareGlobalFunction( "EpimorphismPqStandardPresentation" );
DeclareOperation( "EpimorphismStandardPresentation", [IsObject, IsObject] );

#############################################################################
##
#F  PqStandardPresentation( <arg> : <options> ) . . . . . . . .  SP for group
#O  StandardPresentation( <F>, <G> ) 
##
DeclareGlobalFunction( "PqStandardPresentation" );
DeclareOperation( "StandardPresentation", [IsObject, IsObject] );

#############################################################################
##
#F  IsPqIsomorphicPGroup( <G>, <H> )  . . . . . . . . . . .  isomorphism test
#O  IsIsomorphicPGroup( <G>, <H> )
##
DeclareGlobalFunction( "IsPqIsomorphicPGroup" );
DeclareOperation( "IsIsomorphicPGroup", [IsPcGroup, IsPcGroup] );

#E  anusp.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
