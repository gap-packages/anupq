#############################################################################
####
##
#W  anupq4r2cpt.gd      ANUPQ Share Package                       Greg Gamble
##
##  This file declares functions not in GAP 4.2 for backward compatibility.
##  This file is not read if the version of GAP is 4.3 or later.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupq4r2cpt_gd :=
    "@(#)$Id$";

#############################################################################
##
#F  Chomp( <str> )  . . .  remove a trailing '\n' from a string if it has one
##
##  Like the similarly  named  Perl  function,  `Chomp'  removes  a  trailing
##  newline character from a string  argument  <str>  if  there  is  one  and
##  returns the result. If <str> is not a string or does not end in a newline
##  character it is returned unchanged.
##
DeclareGlobalFunction( "Chomp" );

#E  anupq4r2cpt.gd  . . . . . . . . . . . . . . . . . . . . . . . . ends here 
