#############################################################################
####
##
#W  anupqi.gd           ANUPQ Share Package                       Greg Gamble
##
##  This file declares interactive functions that execute individual pq  menu
##  options.
##
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqi_gd :=
    "@(#)$Id$";

#############################################################################
##
#F  PQ_AUT_INPUT( <datarec>, <G> : <options> ) . . . . . . automorphism input
##
DeclareGlobalFunction( "PQ_AUT_INPUT" );

#############################################################################
##
#F  PQ_PC_PRESENTATION( <datarec>, <menu> ) . . . . . .  p-Q/SP menu option 1
##
DeclareGlobalFunction( "PQ_PC_PRESENTATION" );

#############################################################################
##
#F  PqPcPresentation( <i> : <options> ) . . user version of p-Q menu option 1
#F  PqPcPresentation( : <options> )
##
DeclareGlobalFunction( "PqPcPresentation" );

#############################################################################
##
#F  PQ_P_COVER( <datarec> ) . . . . . . . . . . . . . . . . p-Q menu option 7
##
DeclareGlobalFunction( "PQ_P_COVER" );

#############################################################################
##
#F  PqPCover( <i> ) . . . . . . . . . . . . user version of p-Q menu option 7
#F  PqPCover()
##
DeclareGlobalFunction( "PqPCover" );

#############################################################################
##
#F  PQ_WRITE_PC_PRESENTATION( <datarec> : <options> ) .  I p-Q menu option 25
##
DeclareGlobalFunction( "PQ_WRITE_PC_PRESENTATION" );

#############################################################################
##
#F  PqWritePcPresentation( <i> : <options> ) . user ver. of I p-Q menu op. 25
#F  PqWritePcPresentation( )
##
DeclareGlobalFunction( "PqWritePcPresentation" );

#############################################################################
##
#F  PqSPPcPresentation( <i> : <options> ) . . user version of p-Q menu opt. 1
#F  PqSPPcPresentation( : <options> )
##
DeclareGlobalFunction( "PqSPPcPresentation" );

#############################################################################
##
#F  PQ_SP_STANDARD_PRESENTATION( <datarec> : <options> ) . . SP menu option 2
##
DeclareGlobalFunction( "PQ_SP_STANDARD_PRESENTATION" );

#############################################################################
##
#F  PqSPStandardPresentation( <i> : <options> ) . user ver. of SP menu opt. 2
#F  PqSPStandardPresentation( : <options> )
##
DeclareGlobalFunction( "PqSPStandardPresentation" );

#############################################################################
##
#F  PQ_SP_ISOMORPHISM( <datarec> ) . . . . . . . . . . . . . SP menu option 8
##
DeclareGlobalFunction( "PQ_SP_ISOMORPHISM" );

#############################################################################
##
#F  PqSPIsomorphism( <i> ) . . . . . . . . . user version of SP menu option 8
#F  PqSPIsomorphism()
##
DeclareGlobalFunction( "PqSPIsomorphism" );

#############################################################################
##
#F  PQ_PG_SUPPLY_AUTS( <datarec> ) . . . . . . . . . . . . . pG menu option 1
##
DeclareGlobalFunction( "PQ_PG_SUPPLY_AUTS" );

#############################################################################
##
#F  PqPGSupplyAutomorphisms( <i> ) . . . . . user version of pG menu option 1
#F  PqPGSupplyAutomorphisms()
##
DeclareGlobalFunction( "PqPGSupplyAutomorphisms" );

#############################################################################
##
#F  PQ_PG_CONSTRUCT_DESCENDANTS( <datarec> : <options> ) . . pG menu option 5
##
DeclareGlobalFunction( "PQ_PG_CONSTRUCT_DESCENDANTS" );

#E  anupqi.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
