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
#F  EpimorphismPqStandardPresentation( <F>, <G> ... )  . compute a SP for <F>
#O  EpimorphismStandardPresentation( <F>, <G> )
##
DeclareGlobalFunction( "EpimorphismPqStandardPresentation" );
DeclareOperation( "EpimorphismStandardPresentation", [IsFpGroup, IsObject] );

#############################################################################
##
#F  PqStandardPresentation( <F>, <G> ... ) 
#O  StandardPresentation( <F>, <G> ) 
##
DeclareGlobalFunction( "PqStandardPresentation" );
DeclareOperation( "StandardPresentation", [IsFpGroup, IsObject] );

#############################################################################
##
#F  IsPqIsomorphicPGroup( <G>, <H> )  . . . . . . . . . . .  isomorphism test
#O  IsIsomorphicPGroup( <G>, <H> )
##
DeclareGlobalFunction( "IsPqIsomorphicPGroup" );
DeclareOperation( "IsIsomorphicPGroup", [IsPcGroup, IsPcGroup] );

#E  anusp.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
