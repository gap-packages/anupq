#############################################################################
####
##
#W  anupq4r2cpt.gd      ANUPQ Share Package                       Greg Gamble
##
##  This file declares functions not in GAP 4.2, unless already provided, for
##  backward compatibility.
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
#V  ANUPQ_PROVIDE_FUNCTIONS . .  list of GAP 4.3 functions ANUPQ must provide
#F  PQ_IF_NEW_DeclareGlobalFunction( <string> )  . . . . declare if necessary
#F  PQ_IF_NEW_DeclareOperation( <string>, <list> ) . . . declare if necessary
##
##  It's possible that some of the  functions  declared  in  this  file  have
##  already been provided (by say, another package). If <string> is already a
##  global variable, we assume the function has already been provided and  do
##  nothing; otherwise it behaves like `DeclareGlobalFunction(  <string>  )',
##  but also adds <string> to  `ANUPQ_PROVIDE_FUNCTIONS'  so  that  when  the
##  companion install file is read the function is installed.
##
##  `PQ_IF_NEW_DeclareOperation' does the same for an operation.
##
ANUPQ_PROVIDE_FUNCTIONS := [];
PQ_IF_NEW_DeclareGlobalFunction := function( string )
  if not IsBoundGlobal( string ) then
    DeclareGlobalFunction( string );
    Add(ANUPQ_PROVIDE_FUNCTIONS, string);
  fi;
end;
PQ_IF_NEW_DeclareOperation := function( string, list )
  if not IsBoundGlobal( string ) then
    DeclareOperation( string, list );
    Add(ANUPQ_PROVIDE_FUNCTIONS, string);
  fi;
end;

#############################################################################
##
#F  Chomp( <str> )  . . .  remove a trailing '\n' from a string if it has one
##
##  Like the similarly  named  Perl  function,  `Chomp'  removes  a  trailing
##  newline character from a string  argument  <str>  if  there  is  one  and
##  returns the result. If <str> is not a string or does not end in a newline
##  character it is returned unchanged.
##
PQ_IF_NEW_DeclareGlobalFunction( "Chomp" );

#############################################################################
##
#F  JoinStringsWithSeparator( <list>[, <sep>] )
##
##  joins <list> (a list of strings) after interpolating <sep> (or  `","'  if
##  the second argument is omitted) between each adjacent  pair  of  strings;
##  <sep> should be a string.
##
PQ_IF_NEW_DeclareGlobalFunction( "JoinStringsWithSeparator" );

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
PQ_IF_NEW_DeclareGlobalFunction( "ResetOptionsStack");

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
PQ_IF_NEW_DeclareGlobalFunction( "EvalString" );

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
PQ_IF_NEW_DeclareOperation( "IsMatchingSublist", [IsList,IsList,IS_INT] );

#############################################################################
##
#F  StringFile( <name> ) . . . . . . return content of file <name> as string
##
PQ_IF_NEW_DeclareGlobalFunction( "StringFile" );

#############################################################################
##
#F  FileDescriptorOfStream( <stream> )
#F  UNIXSelect( <arg> )
##
##  We provide dummy functions for these. In {\GAP} 4.3 they are  implemented
##  in the kernel. Each returns 1 for {\GAP} 4.2, which for the  way  we  use
##  them in the {\ANUPQ} package essentially renders them as  no-ops,  except
##  that `UNIXSelect' also sleeps 1 second.
##
PQ_IF_NEW_DeclareGlobalFunction( "FileDescriptorOfStream" );
PQ_IF_NEW_DeclareGlobalFunction( "UNIXSelect" );

#############################################################################
##
#O  ReadAllLine( <iostream>[, <nofail>][, <IsAllLine>] ) . .  read whole line
##
##  For an input/output stream <iostream> `ReadAllLine' reads until a newline
##  character if any input is found or returns `fail' if no input  is  found,
##  i.e.~if any input is found `ReadAllLine' is non-blocking.
##
##  If the argument <nofail> (which must be `false' or  `true')  is  provided
##  and it is set to `true' then `ReadAllLine' will wait, if  necessary,  for
##  input and never return `fail'.
##
##  If the argument <IsAllLine> (which must be a function that takes a string
##  argument and returns either  `true'  or  `false')  then  it  is  used  to
##  determine what  constitutes  a  whole  line.  The  default  behaviour  is
##  equivalent to passing the function
##
##  \begintt
##  line -> 0 < Length(line) and line[Length(line)] = '\n'
##  \endtt
##
##  for the <IsAllLine> argument. The purpose of the <IsAllLine> argument  is
##  to cater for the case where the input being  read  is  from  an  external
##  process that writes a ``prompt'' for data that does not terminate with  a
##  newline.
##
##  If the first argument is an input stream but not an  input/output  stream
##  then `ReadAllLine' behaves as if `ReadLine'  was  called  with  just  the
##  first argument and any additional arguments are ignored.
##
PQ_IF_NEW_DeclareOperation( "ReadAllLine", [IsInputStream,IsBool,IsFunction] );

#############################################################################
##
#F  OnBreakMessage( ) . . . . . . function to call at entry to the break loop
##
##  In GAP 4.2 we provide a dummy non-function definition.
##
if not IsBound( OnBreakMessage ) then
  OnBreakMessage := "";
fi;

#############################################################################
##
##  We don't need these anymore.
##
Unbind( PQ_IF_NEW_DeclareGlobalFunction );
Unbind( PQ_IF_NEW_DeclareOperation );

#E  anupq4r2cpt.gd  . . . . . . . . . . . . . . . . . . . . . . . . ends here 
