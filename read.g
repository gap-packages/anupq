#############################################################################
##
#W  read.g                   ANUPQ package                      Werner Nickel
##
##  @(#)$Id$
##

#############################################################################
##
#R  Read the install files.
##
ReadPkg( "anupq", "lib/anupqprop.gi" );
ReadPkg( "anupq", "lib/anupq.gi" );
ReadPkg( "anupq", "lib/anupga.gi" );
ReadPkg( "anupq", "lib/anusp.gi" );
ReadPkg( "anupq", "lib/anupqopt.gi" );
ReadPkg( "anupq", "lib/anupqios.gi" );
ReadPkg( "anupq", "lib/anupqi.gi" );
ReadPkg( "anupq", "lib/anupqid.gi" );
ReadPkg( "anupq", "lib/anustab.gi" );
ReadPkg( "anupq", "lib/anupqxdesc.gi" );
if not IsBound( LOADED_PACKAGES.autpgrp ) then
    Info(InfoWarning + InfoANUPQ,1, "Package ``AutPGrp'' is not available.");
    Info(InfoWarning + InfoANUPQ,1, "You may run into trouble later if the pq");
    Info(InfoWarning + InfoANUPQ,1, "binary needs GAP to compute stabilisers.");
    Info(InfoWarning + InfoANUPQ,1, "E.g. see the note for ?PqDescendants");
fi;

#E  read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
