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

#############################################################################
##
#F  JoinStringsWithSeparator( <list>[, <sep>] )
##
##  joins <list> (a list of strings) after interpolating <sep> (or  `","'  if
##  the second argument is omitted) between each adjacent  pair  of  strings;
##  <sep> should be a string.
##
DeclareGlobalFunction( "JoinStringsWithSeparator" );

#############################################################################
##
#F  ResetOptionsStack( ) . . . . . . . . . . . . . . . . . remove all options
##
##  unbinds (i.e. removes) all the options records from the options stack.
##
##  *Note:*
##  `ResetOptionsStack' should *not* be used within a function. Its  intended
##  use is to clean up the options stack in  the  event  that  the  user  has
##  `quit' from a `break'  loop,  so  leaving  a  stack  of  no-longer-needed
##  options (see~"quit").
##
DeclareGlobalFunction( "ResetOptionsStack");

#############################################################################
##
#F  EvalString( <expr> ) . . . . . . . . . . . . evaluate a string expression
##
##  passes <expr> (a string) through  an  input text stream  so  that  {\GAP}
##  interprets it, and returns the  result.  The  following  trivial  example
##  demonstrates its use.
##
##  \beginexample
##  gap> a:=10;
##  10
##  gap> EvalString("a^2");
##  100
##  \endexample
##
##  `EvalString' is intended for *single* expressions. A sequence of commands
##  may   be   interpreted   by   using   the   functions   `InputTextString'
##  (see~"InputTextString")  and  `ReadAsFunction'   (see~"ReadAsFunction!for
##  streams") together; see "Operations for Input Streams" for an example.
##
DeclareGlobalFunction( "EvalString" );

#############################################################################
##
#O  IsMatchingSublist( <list>, <sub> )
#O  IsMatchingSublist( <list>, <sub>, <at> )
##
##  returns `true' if <sub> matches a sublist of <list> from position  1  (or
##  position <at>, in the case of the second version), or `false', otherwise.
##  If <sub> is empty `true' is returned. If <list> is  empty  but  <sub>  is
##  non-empty `false' is returned.
##
DeclareOperation( "IsMatchingSublist", [ IsList, IsList, IS_INT ] );

#E  anupq4r2cpt.gd  . . . . . . . . . . . . . . . . . . . . . . . . ends here 
