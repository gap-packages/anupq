#############################################################################
####
##
#W  anupqprop.gd               ANUPQ package                    Werner Nickel
##
##
##  Declares properties and attributes needed for ANUPQ.
##    
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##

#############################################################################
##
#F  SET_PQ_PROPS_AND_ATTRS( <G>, <func> )
##
DeclareGlobalFunction( "SET_PQ_PROPS_AND_ATTRS" );

#############################################################################
##
#D  Declare properties and  attributes
##    
DeclareProperty( "IsCapable", IsGroup );

DeclareAttribute( "NuclearRank", IsGroup );

DeclareAttribute( "MultiplicatorRank", IsGroup );

DeclareAttribute( "ANUPQIdentity", IsGroup );

DeclareAttribute( "ANUPQAutomorphisms", IsGroup );

DeclareProperty( "IsPcgsAutomorphisms", IsGroup );

#E  anupqprop.gd  . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
