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
#V  PQ_FUNCTION . . . . . . . . . internal functions called by user functions 
##
DeclareGlobalVariable( "PQ_FUNCTION", 
  Concatenation( [
    "A record whose fields are (function) names and whose values are\n",
    "the internal functions called by the functions with those names." ] )
  );

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
#V  ANUPQoptionChecks . . . . . . . . . . . the checks for admissible options
##
DeclareGlobalVariable( "ANUPQoptionChecks", 
  Concatenation( [
    "A record of lists of names of admissible ANUPQ options.\n",
    "A record whose fields are the names of admissible ANUPQ options,\n",
    "and whose values are one-argument functions that return `true' when\n",
    "given a value that is a valid value for the option, and `false'\n",
    "otherwise." ] )
  );

#############################################################################
##
#V  ANUPQoptionTypes . . . . . .  the types (in words) for admissible options
##
DeclareGlobalVariable( "ANUPQoptionTypes", 
  Concatenation( [
    "A record whose fields are the names of admissible ANUPQ options\n",
    "and whose values are words in angle brackets representing the valid\n",
    "types of the options." ] )
  );

#############################################################################
##
#F  VALUE_PQ_OPTION( <optname> ) . . . . . . . . . enhancement of ValueOption
#F  VALUE_PQ_OPTION( <optname>, <defaultval> ) 
##
DeclareGlobalFunction( "VALUE_PQ_OPTION" );

#############################################################################
##
#F  SET_ANUPQ_OPTIONS( <funcname>, <options> ) . set options from OptionStack
##    
DeclareGlobalFunction( "SET_ANUPQ_OPTIONS" );

#############################################################################
##
#F  ANUPQoptError( <funcname>, <optnames> ) . . . . . create an error message
##
DeclareGlobalFunction( "ANUPQoptError" );

#############################################################################
##
#F  ANUPQextractOptions( <funcname>, <i>, <args> ) . . . . .  extract options
##
DeclareGlobalFunction( "ANUPQextractOptions" );

#E  anupqopt.gd . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
