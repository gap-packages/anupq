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
#F  PQ_PC_PRESENTATION( <datarec> : <options> ) . . . . . . p-Q menu option 1
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
#F  PQ_WRITE_PC_PRESENTATION( <datarec> : <options> ) .  I p-Q menu option 25
##
DeclareGlobalFunction( "PQ_WRITE_PC_PRESENTATION" );

#############################################################################
##
#F  PqWritePcPresentation( <i> : <options> ) . user ver. of I p-Q menu op. 25
#F  PqWritePcPresentation( )
##
DeclareGlobalFunction( "PqWritePcPresentation" );

#E  anupqi.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
