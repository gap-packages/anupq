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
#D  Declare properties and  attributes
##    
##

DeclareProperty( "IsCapable", IsGroup );

DeclareAttribute( "NuclearRank", IsGroup );

DeclareAttribute( "MultiplicatorRank", IsGroup );

DeclareAttribute( "ANUPQIdentity", IsGroup );

DeclareProperty( "IsPcgsAutomorphisms", IsGroup );

#E  anupqprop.gd  . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
