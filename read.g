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
if not CompareVersionNumbers( VERSION, "4.3" ) then
    ReadPkg( "anupq", "gap/lib/anupq4r2cpt.gi" );
fi;

#E  read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
