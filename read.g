#############################################################################
##
#W  read.g                ANUPQ share package                   Werner Nickel
##
##  @(#)$Id$
##

#############################################################################
##
#R  Read the install files.
##
ReadPkg( "anupq", "gap/lib/anupq.gi" );
ReadPkg( "anupq", "gap/lib/anupga.gi" );
ReadPkg( "anupq", "gap/lib/anusp.gi" );
ReadPkg( "anupq", "gap/lib/anupqopt.gi" );
ReadPkg( "anupq", "gap/lib/anupqios.gi" );
ReadPkg( "anupq", "gap/lib/anupqi.gi" );
ReadPkg( "anupq", "gap/lib/anustab.gi" );
if not IsBound( LOADED_PACKAGES.autpgrp ) then
    Info(InfoWarning + InfoANUPQ,1, 
         "Share package ``AutPGrp'' is not available.");
    Info(InfoWarning + InfoANUPQ,1, 
         "You may run into trouble later if the pq");
    Info(InfoWarning + InfoANUPQ,1, 
         "binary needs GAP to compute stabilisers.");
    Info(InfoWarning + InfoANUPQ,1, 
         "See the installation instructions for the ``ANUPQ'' share package.");
fi;

#E  read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
