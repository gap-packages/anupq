#############################################################################
####
##
#W  anupqios.gd         ANUPQ Share Package                       Greg Gamble
##
##  This file declares core functions used with streams.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqios_gd :=
    "@(#)$Id$";

#############################################################################
##
#F  PQ_START( <workspace>, <setupfile> ) . . . open a stream for a pq process
##
DeclareGlobalFunction( "PQ_START" );

#############################################################################
##
#F  PqStart( <G>, <workspace> )  . . .  Initiate an interactive ANUPQ session
#F  PqStart( <G> )
##
DeclareGlobalFunction( "PqStart" );

#############################################################################
##
#F  PqQuit( <i> )  . . . . . . . . . . . . . . . . .  User version of PQ_QUIT
#F  PqQuit()
##
DeclareGlobalFunction( "PqQuit" );

#############################################################################
##
#F  PqQuitAll() . . . . . . . . . . . .  Close all interactive ANUPQ sessions
##
DeclareGlobalFunction( "PqQuitAll" );

#############################################################################
##
#F  ANUPQ_IOINDEX . . . . the number identifying an interactive ANUPQ session
##
DeclareGlobalFunction( "ANUPQ_IOINDEX" );

#############################################################################
##
#F  ANUPQ_IOINDEX_ARG_CHK .  Checks ANUPQ_IOINDEX has the right no. of arg'ts
##
DeclareGlobalFunction( "ANUPQ_IOINDEX_ARG_CHK" );

#############################################################################
##
#F  PqProcessIndex( <i> ) . . . . . . . . . . . User version of ANUPQ_IOINDEX
#F  PqProcessIndex()
##
DeclareGlobalFunction( "PqProcessIndex" );

#############################################################################
##
#F  PqProcessIndices() . . . . the list of active interactive ANUPQ processes
##
DeclareGlobalFunction( "PqProcessIndices" );

#############################################################################
##
#F  IsPqProcessAlive( <i> ) . .  checks an interactive ANUPQ process iostream
#F  IsPqProcessAlive()
##
DeclareGlobalFunction( "IsPqProcessAlive" );

#############################################################################
##
#V  PQ_MENUS . . . . . . . . . . . data describing the menus of the pq binary
##
DeclareGlobalVariable( "PQ_MENUS",
  "A record containing data describing the tree of menus of the pq binary"
  );

#############################################################################
##
#F  PQ_MENU( <datarec>, <newmenu> ) . . . . . . change/get menu of pq process
#F  PQ_MENU( <datarec> )
##
DeclareGlobalFunction( "PQ_MENU" );

#############################################################################
##
#F  IS_PQ_PROMPT( <line> ) . . . .  checks whether the line is a prompt of pq
##
DeclareGlobalFunction( "IS_PQ_PROMPT" );

#############################################################################
##
#F  IS_PQ_REQUEST( <line> ) . .  checks whether the line is a request from pq
##
DeclareGlobalFunction( "IS_PQ_REQUEST" );

#############################################################################
##
#F  PQ_READ_ALL_LINE . . read a line from a stream until a sentinel character
##
DeclareGlobalFunction( "PQ_READ_ALL_LINE" );

#############################################################################
##
#F  PQ_READ_NEXT_LINE .  read complete line from stream but never return fail
##
DeclareGlobalFunction( "PQ_READ_NEXT_LINE" );

#############################################################################
##
#F  FLUSH_PQ_STREAM_UNTIL(<stream>,<infoLev>,<infoLevMy>,<readln>,<IsMyLine>)
##  . . .  . . . . . . . . . . . read lines from a stream until a wanted line
##
DeclareGlobalFunction( "FLUSH_PQ_STREAM_UNTIL" );

#############################################################################
##
#F  ToPQk( <datarec>, <list> ) . . . . . . . . writes a list to a pq iostream
##
DeclareGlobalFunction( "ToPQk" );

#############################################################################
##
#F  PqRead( <i> )  . . .  primitive read of a single line from ANUPQ iostream
#F  PqRead()
##
DeclareGlobalFunction( "PqRead" );

#############################################################################
##
#F  PqReadAll( <i> ) . . . . . read all current output from an ANUPQ iostream
#F  PqReadAll()
##
DeclareGlobalFunction( "PqReadAll" );

#############################################################################
##
#F  PqReadUntil( <i>, <IsMyLine> ) .  read from ANUPQ iostream until a cond'n
#F  PqReadUntil( <IsMyLine> )
#F  PqReadUntil( <i>, <IsMyLine>, <Modify> )
#F  PqReadUntil( <IsMyLine>, <Modify> )
##
DeclareGlobalFunction( "PqReadUntil" );

#############################################################################
##
#F  PqWrite( <i>, <string> ) . . . . . . .  primitive write to ANUPQ iostream
#F  PqWrite( <string> )
##
DeclareGlobalFunction( "PqWrite" );

#############################################################################
##
#F  ToPQ( <datarec>, <list> ) .  write list to pq iostream (& int'vely flush)
##
DeclareGlobalFunction( "ToPQ" );

#############################################################################
##
#F  ANUPQ_ARG_CHK(<len>,<funcname>,<arg1>,<arg1type>,<arg1err>,<args>,<opts>)
##
DeclareGlobalFunction( "ANUPQ_ARG_CHK" );

#############################################################################
##
#F  PQ_COMPLETE_NONINTERACTIVE_FUNC_CALL( <datarec> )
##
DeclareGlobalFunction( "PQ_COMPLETE_NONINTERACTIVE_FUNC_CALL" );

#E  anupqios.gd . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
