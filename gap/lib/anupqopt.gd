#############################################################################
####
##
#W  anupqopt.gd             ANUPQ Share Package                 Werner Nickel
#W                                                                Greg Gamble
##
##  Declares functions to do with option manipulation.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqopt_gd :=
    "@(#)$Id$";

#############################################################################
##
#V  ANUPQoptions  . . . . . . . . . . . . . . . . . . . .  admissible options
##
DeclareGlobalVariable( "ANUPQoptions", 
  Concatenation( [
    "A record of lists of names of admissible ANUPQ options.\n",
    "Each field is the name of an ANUPQ function and the\n",
    "corresponding value is the list of names of admissible\n",
    "for the function." ] )
  );

#############################################################################
##
#F  SET_ANUPQ_OPTIONS( <funcname>, <options> ) . set options from OptionStack
##    
DeclareGlobalFunction( "SET_ANUPQ_OPTIONS" );

#E  anupqopt.gd . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
