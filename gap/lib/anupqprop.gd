#############################################################################
####
##
#W  anupqprop.gd               ANUPQ package                    Werner Nickel
##
##
##  Declares properties and attributes needed for ANUPQ.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqprop_gd :=
    "@(#)$Id$";

#############################################################################
##
#F  SET_PQ_PROPS_AND_ATTRS( <G>, <fpG> )
##
DeclareGlobalFunction( "SET_PQ_PROPS_AND_ATTRS" );

#############################################################################
##
#D  Declare properties and  attributes
##    
DeclareProperty( "IsCapable", IsPGroup );

DeclareAttribute( "NuclearRank", IsPGroup );

DeclareAttribute( "MultiplicatorRank", IsPGroup );

DeclareAttribute( "ANUPQIdentity", IsGroup );

DeclareProperty( "IsPcgsAutomorphisms", IsGroup );

#E  anupqprop.gd  . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
