#############################################################################
####
##
#W  anupqprop.gi               ANUPQ package                    Werner Nickel
#W                                                                Greg Gamble
##
##  Installs methods for properties and attributes needed for ANUPQ.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqprop_gi :=
    "@(#)$Id$";

#############################################################################
##
#F  SET_PQ_PROPS_AND_ATTRS( <G>, <fpG> )
##
InstallGlobalFunction( SET_PQ_PROPS_AND_ATTRS, function( G, fpG )
local S;
  S := PqStandardPresentation(fpG, PrimeOfPGroup(fpG));
  SetIsCapable( G, IsCapable(S) );
  SetNuclearRank( G, NuclearRank(S) );
  SetMultiplicatorRank( G, MultiplicatorRank(S) );
end );

#############################################################################
##
#M  IsCapable( <G> )
##    
RedispatchOnCondition( IsCapable, true, [ IsGroup ], [ IsPGroup ], 0 );

InstallMethod( IsCapable, "fp p-groups", true, [ IsPGroup and IsFpGroup ], 0,
function( G )
  SET_PQ_PROPS_AND_ATTRS(G, G);
  return IsCapable(G);
end );

InstallMethod( IsCapable, "pc p-groups", true, [ IsPGroup and IsPcGroup ], 0,
function( G )
  SET_PQ_PROPS_AND_ATTRS( G, FpGroupPcGroup(G) );
  return IsCapable(G);
end );

#############################################################################
##
#M  NuclearRank( <G> )
##    
RedispatchOnCondition( NuclearRank, true, [ IsGroup ], [ IsPGroup ], 0 );

InstallMethod( NuclearRank, "fp p-groups", [ IsPGroup and IsFpGroup ], 0,
function( G )
  SET_PQ_PROPS_AND_ATTRS(G, G);
  return NuclearRank(G);
end );

InstallMethod( NuclearRank, "pc p-groups", [ IsPGroup and IsPcGroup ], 0,
function( G )
  SET_PQ_PROPS_AND_ATTRS( G, FpGroupPcGroup(G) );
  return NuclearRank(G);
end );

#############################################################################
##
#M  MultiplicatorRank( <G> )
##    
RedispatchOnCondition( MultiplicatorRank, true, [ IsGroup ], [ IsPGroup ], 0 );

InstallMethod( MultiplicatorRank, "fp p-groups", [ IsPGroup and IsFpGroup ], 0,
function( G )
  SET_PQ_PROPS_AND_ATTRS(G, G);
  return MultiplicatorRank(G);
end );

InstallMethod( MultiplicatorRank, "pc p-groups", [ IsPGroup and IsPcGroup ], 0,
function( G )
  SET_PQ_PROPS_AND_ATTRS( G, FpGroupPcGroup(G) );
  return MultiplicatorRank(G);
end );

#E  anupqprop.gi  . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
