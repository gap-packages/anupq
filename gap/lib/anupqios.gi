#############################################################################
####
##
#W  anupqios.gi         ANUPQ Share Package                       Greg Gamble
##
##  This file installs core functions used with iostreams.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqios_gi :=
    "@(#)$Id$";

#############################################################################
##
#F  PqStart( <G>, <workspace> )  . . .  Initiate an interactive ANUPQ session
#F  PqStart( <G> )
##
##  activates an iostream for an interactive {\ANUPQ} process, i.e. it starts
##  up the `pq' binary and opens an iostream to ``talk'' to it;  and  returns
##  an integer <i> that can be used to  identify  that  process.  The  record
##  `ANUPQData.io[<i>]' stores information that is important for the  process
##  (see~"ANUPQData"). The argument <G> should be an fp group that  the  user
##  intends to manipute using interactive {\ANUPQ} functions. If `PqStart' is
##  given a second argument <workspace> then the `pq' binary  is  started  up
##  with a workspace (an integer array) of size <workspace> (i.e.  $4  \times
##  <workspace>$ bytes in a 32-bit environment); otherwise, the  `pq'  binary
##  sets a default workspace of $10000000$.
##
InstallGlobalFunction(PqStart, function(arg)
local stream, opts, workspace, G;

  opts := [ "-i", "-k" ];
  if IsEmpty(arg) or 2 < Length(arg) then
    Error("one or two arguments expected.\n");
  elif not IsFpGroup(arg[1]) then
    Error("first argument must be an fp group\n");
  elif 2 = Length(arg) then
    if not IsPosInt(arg[2]) then
      Error("argument (workspace) should be a positive integer.\n");
    fi;
    workspace := arg[2];
    Append( opts, [ "-s", String(workspace) ] );
  else
    workspace := 10000000;
  fi;
  G := arg[1];

  stream := InputOutputLocalProcess(DirectoryCurrent(), ANUPQData.binary, opts);
  if stream = fail then
    Error("sorry! Run out of pseudo-ttys. Can't initiate stream.\n");
  fi;

  Add( ANUPQData.io, rec( stream := stream, 
                          group  := G, 
                          workspace := workspace, 
                          menu   := "SP" ) );

  FLUSH_PQ_STREAM_UNTIL(stream, 4, 2, PQ_READ_NEXT_LINE, IS_PQ_PROMPT);
  return Length(ANUPQData.io);
end);

#############################################################################
##
#F  PqQuit( <i> )  . . . . . . . . . . . . Close an interactive ANUPQ session
#F  PqQuit()
##
##  closes the stream of the <i>th or default  interactive  {\ANUPQ}  process
##  and unbinds its `ANUPQData.io' record.
##
InstallGlobalFunction(PqQuit, function(arg)
local ioIndex;

  ioIndex := ANUPQ_IOINDEX(arg);
  # I don't think we need to bother about descending through the menus.
  CloseStream(ANUPQData.io[ioIndex].stream);
  Unbind(ANUPQData.io[ioIndex]);
end);

#############################################################################
##
#F  PqQuitAll() . . . . . . . . . . . .  Close all interactive ANUPQ sessions
##
##  closes the streams of all active interactive {\ANUPQ} process and unbinds
##  their `ANUPQData.io' records.
##
InstallGlobalFunction(PqQuitAll, function()
local ioIndex;

  for ioIndex in [1 .. Length(ANUPQData.io)] do
    if IsBound(ANUPQData.io[ioIndex]) then
      CloseStream(ANUPQData.io[ioIndex].stream);
      Unbind(ANUPQData.io[ioIndex]);
    fi;
  od;
end);

#############################################################################
##
#F  ANUPQ_IOINDEX . . . . the number identifying an interactive ANUPQ session
##
##  returns the index of the record in the `ANUPQData.io' list  corresponding
##  to an interactive {\ANUPQ} session. With  no  argument  the  first  bound
##  index in `ANUPQData.io' is returned. With integer (first)  argument  <i>,
##  <i> is returned if `ANUPQData.io[<i>]' is bound.
##
InstallGlobalFunction(ANUPQ_IOINDEX, function(arglist)
local ioIndex;

  if IsEmpty(arglist) then
    # Find the first bound ioIndex
    ioIndex := 1;
    while not(IsBound(ANUPQData.io[ioIndex])) and 
          ioIndex < Length(ANUPQData.io) do
      ioIndex := ioIndex + 1;
    od;
    if IsBound(ANUPQData.io[ioIndex]) then
      return ioIndex;
    else
      Info(InfoANUPQ + InfoWarning, 1, 
           "No interactive ANUPQ sessions are currently active");
      return fail;
    fi;
  elif IsBound(ANUPQData.io[ arglist[1] ]) then
    return arglist[1];
  else
    Error("no such interactive ANUPQ session\n");
  fi;
end);

#############################################################################
##
#F  ANUPQ_IOINDEX_ARG_CHK .  Checks ANUPQ_IOINDEX has the right no. of arg'ts
##
InstallGlobalFunction(ANUPQ_IOINDEX_ARG_CHK, function(arglist)
  if Length(arglist) > 1 then
    Info(InfoANUPQ + InfoWarning, 1,
         "Expected 0 or 1 arguments, all but first argument ignored");
  fi;
end);

#############################################################################
##
#F  PqProcessIndex( <i> ) . . . . . . . . . . . User version of ANUPQ_IOINDEX
#F  PqProcessIndex()
##
##  If given (at least) one integer  argument  `PqProcessIndex'  returns  its
##  first argument if it corresponds to  an  active  interactive  process  or
##  raises an error; otherwise, with no arguments,  it  returns  the  default
##  active interactive process. If the user provides more than  one  argument
##  then all arguments other than the  first  argument  are  ignored  (and  a
##  warning is issued to `Info' at `InfoANUPQ' or `InfoWarning' level 1).
##
InstallGlobalFunction(PqProcessIndex, function(arg)
  ANUPQ_IOINDEX_ARG_CHK(arg);
  return ANUPQ_IOINDEX(arg);
end);

#############################################################################
##
#F  PqProcessIndices() . . . . the list of active interactive ANUPQ processes
##
##  returns the list of (integer) indices of all active interactive  {\ANUPQ}
##  processes.
##
InstallGlobalFunction(PqProcessIndices, function()
  return Filtered( [1..Length(ANUPQData.io)], i -> IsBound( ANUPQData.io[i] ) );
end);

#############################################################################
##
#F  IsPqProcessAlive( <i> ) . .  checks an interactive ANUPQ process iostream
#F  IsPqProcessAlive()
##
##  return  `true'  if  the  {\GAP}  iostream  of  the  <i>th  (or   default)
##  interactive {\ANUPQ} process is alive (i.e. can still be written to),  or
##  `false', otherwise.
##
InstallGlobalFunction(IsPqProcessAlive, function(arg)
  ANUPQ_IOINDEX_ARG_CHK(arg);
  return not IsEndOfStream( ANUPQData.io[ ANUPQ_IOINDEX(arg) ].stream );
end);

#############################################################################
##
#V  PQ_MENUS . . . . . . . . . . . data describing the menus of the pq binary
##
##  a record whose fields are abbreviated names of  the  menus  of  the  `pq'
##  binary and whose values are themselves records with fields:
##
##    name
##        long name of menu;
##    depth
##        the number of times 0 must be passed to the `pq' binary for  it  to
##        exit;
##    prev
##        the menu one gets to from the current menu via option 0 (or `""' in
##        the case of the menu `SP';
##    nextopt
##        a record whose fields are the new menus of greater depth  that  can
##        be reached by an option of the current menu, and whose  values  are 
##        the corresponding numbers of the options of the current menu needed
##        to get to the new menus.
##
InstallValue(PQ_MENUS, rec(
  SP  := rec( name  := "Standard Presentation Menu",
              depth := 1, prev  := "",   nextopt := rec( pQ := 7 ) ),
  pQ  := rec( name  := "(Main) p-Quotient Menu",
              depth := 2, prev  := "SP", nextopt := rec( pG  := 9, IpQ := 8 ) ),
  pG  := rec( name  := "(Main) p-Group Generation Menu",
              depth := 3, prev  := "pQ", nextopt := rec( IpG := 6 ) ),
  IpQ := rec( name  := "Interactive p-Quotient Menu",
              depth := 3, prev  := "pQ", nextopt := rec() ),
  IpG := rec( name  := "Interactive p-Group Gen'n Menu",
              depth := 4, prev  := "pG", nextopt := rec() )
  ) );

#############################################################################
##
#F  PQ_MENU( <datarec>, <newmenu> ) . . . . . . change/get menu of pq process
#F  PQ_MENU( <datarec> )
##
InstallGlobalFunction(PQ_MENU, function(arg)
local datarec, newmenu, nextmenu, tomenu;
  datarec := arg[1];
  if 2 = Length(arg) then
    newmenu := arg[2];
    while datarec.menu <> newmenu do
      if PQ_MENUS.(datarec.menu).depth >= PQ_MENUS.(newmenu).depth then
        datarec.menu := PQ_MENUS.(datarec.menu).prev;
        tomenu := PQ_MENUS.(datarec.menu).name;
        WRITE_LIST_TO_PQ(datarec.stream, [ 0 , " #to ", tomenu]);
        FLUSH_PQ_STREAM_UNTIL(datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
                              IS_PQ_PROMPT);
      elif datarec.menu = "pQ" and newmenu = "IpQ" then
        datarec.menu := "IpQ";
        tomenu := PQ_MENUS.(datarec.menu).name;
        WRITE_LIST_TO_PQ(datarec.stream, 
                         [ PQ_MENUS.pQ.nextopt.IpQ, " #to ", tomenu ]);
        FLUSH_PQ_STREAM_UNTIL(datarec.stream, 4, 2, PQ_READ_NEXT_LINE,
                              IS_PQ_PROMPT);
      else
        nextmenu := RecNames( PQ_MENUS.(datarec.menu).nextopt )[1];
        tomenu := PQ_MENUS.(nextmenu).name;
        WRITE_LIST_TO_PQ(datarec.stream, 
                         [ PQ_MENUS.(datarec.menu).nextopt.(nextmenu),
                           " #to ", tomenu ]);
        FLUSH_PQ_STREAM_UNTIL(datarec.stream, 4, 2, PQ_READ_NEXT_LINE,
                              IS_PQ_PROMPT);
        datarec.menu := nextmenu;
      fi;
    od;
  fi;
  return datarec.menu;
end);

#############################################################################
##
#F  IS_PQ_PROMPT( <line> ) . . . .  checks whether the line is a prompt of pq
##
##  returns `true' if the string  <line>  ends  in  `":  "'  or  `"?  "',  or
##  otherwise returns `false'.
##
InstallGlobalFunction(IS_PQ_PROMPT, function(line)
local len;
  len := Length(line);
  return 1 < len  and line[len] = ' ' and line[len - 1] in ":?";
end);

#############################################################################
##
#F  PQ_READ_ALL_LINE . . read a line from a stream until a sentinel character
##
##  Essentially, like `ReadLine' but does not return a line fragment; if  the
##  initial `ReadLine' call doesn't return `fail', it waits until it has  all
##  the line (i.e. a line that ends with a '\n', or "? "  or  ": ")  before
##  returning.
##
InstallGlobalFunction(PQ_READ_ALL_LINE, function(iostream)
local line, moreOfline;

  line := "";
  repeat
    moreOfline := ReadLine(iostream);
    if moreOfline <> fail then
      Append(line, moreOfline);
    #else
    #  Sleep(1);
    fi;
  until 0 < Length(line) and
        (line[Length(line)] = '\n' or IS_PQ_PROMPT(line) );
  return line;
end);

#############################################################################
##
#F  PQ_READ_NEXT_LINE .  read complete line from stream but never return fail
##
##  Essentially, like `PQ_READ_ALL_LINE' but we know there is a complete line
##  to be got, so we wait for it, before returning.
##
InstallGlobalFunction(PQ_READ_NEXT_LINE, function(iostream)
local line;

  line := PQ_READ_ALL_LINE(iostream);
  while line = fail do
    #Sleep(1);
    line := PQ_READ_ALL_LINE(iostream);
  od;
  return line;
end);

#############################################################################
##
#F  FLUSH_PQ_STREAM_UNTIL(<stream>,<infoLev>,<infoLevMy>,<readln>,<IsMyLine>)
##  . . .  . . . . . . . . . . . read lines from a stream until a wanted line
##
##  calls <readln> (which should be one of `ReadLine', `PQ_READ_NEXT_LINE' or
##  `PQ_READ_ALL_LINE') to read lines from an  stream  <stream>  and  `Info's
##  each line read at `InfoANUPQ' level <infoLev> until a line <line> is read
##  for  which  `<IsMyLine>(<line>)'  is  `true';  <line>  is  `Info'-ed   at
##  `InfoANUPQ' level  <infoLevMy>  and  returned.  <IsMyLine>  should  be  a
##  boolean-valued function that expects a string as its only  argument,  and
##  <infoLev> and <infoLevMy> should be positive integers. An <infoLevMy>  of
##  10 means that the line  <line>  matched  by  `<IsMyLine>(<line>)'  should
##  never be `Info'-ed.
##
InstallGlobalFunction(FLUSH_PQ_STREAM_UNTIL, 
function(stream, infoLev, infoLevMy, readln, IsMyLine)
local line;

  if not IsInputStream(stream) then
    return fail;
  fi;

  line := readln(stream);
  while not IsMyLine(line) do
    Info(InfoANUPQ, infoLev, Chomp(line));
    line := readln(stream);
  od;
  if line <> fail and infoLevMy < 10 then
    Info(InfoANUPQ, infoLevMy, Chomp(line));
  fi;
  return line;
end);

#############################################################################
##
#F  WRITE_LIST_TO_PQ( <stream>, <list> ) . . . writes a list to a pq iostream
##
##  writes list <list> to iostream <stream> with  a  ```ToPQ> '''  prompt  to
##  `Info' at `InfoANUPQ' level 3 and returns `true' if successful and `fail'
##  otherwise.
##
InstallGlobalFunction(WRITE_LIST_TO_PQ, function(stream, list)
local string;

  if not IsOutputTextStream(stream) and IsEndOfStream(stream) then
    Info(InfoANUPQ + InfoWarning, 1, "Sorry. Process stream has died!");
    return fail;
  fi;
  string := Concatenation( List(list, x -> String(x)) );
  Info(InfoANUPQ, 3, "ToPQ> ", string);
  return WriteLine(stream, string);
end);

#############################################################################
##
#F  PqRead( <i> )  . . .  primitive read of a single line from ANUPQ iostream
#F  PqRead()
##
##  read a complete line of  {\ANUPQ}  output,  from  the  <i>th  or  default
##  interactive {\ANUPQ} process, if there is output to be read  and  returns
##  `fail' otherwise. When successful, the  line  is  returned  as  a  string
##  complete with trailing newline, colon, or question-mark character. Please
##  note that it is possible to be ``too  quick''  (i.e.~the  return  can  be
##  `fail' purely because the output from {\ANUPQ} is not there yet), but  if
##  `PqRead' finds any output at all, it waits for a complete line.  `PqRead'
##  also writes the line read via `Info' at `InfoANUPQ' level 2.  It  doesn't
##  try to distinguish banner and menu output from other output of  the  `pq'
##  binary.
##
InstallGlobalFunction(PqRead, function(arg)
local line;

  ANUPQ_IOINDEX_ARG_CHK(arg);
  line := PQ_READ_ALL_LINE( ANUPQData.io[ ANUPQ_IOINDEX(arg) ].stream );
  Info(InfoANUPQ, 2, Chomp(line));
  return line;
end);

#############################################################################
##
#F  PqReadAll( <i> ) . . . . . read all current output from an ANUPQ iostream
#F  PqReadAll()
##
##  read and return as many *complete* lines of  {\ANUPQ}  output,  from  the
##  <i>th or default interactive {\ANUPQ} process, as there are to  be  read,
##  *at the time of the call*,  as  a  list  of  strings  with  any  trailing
##  newlines removed and returns the empty list otherwise.  `PqReadAll'  also
##  writes each line read via `Info' at `InfoANUPQ' level 2. It  doesn't  try
##  to distinguish banner and menu output  from  other  output  of  the  `pq'
##  binary. Whenever `PqReadAll' finds only a partial line, it waits for  the
##  complete line, thus increasing the probability that it has  captured  all
##  the output to be had from {\ANUPQ}.
##
InstallGlobalFunction(PqReadAll, function(arg)
local lines, stream, line;

  ANUPQ_IOINDEX_ARG_CHK(arg);
  lines := [];
  stream := ANUPQData.io[ ANUPQ_IOINDEX(arg) ].stream;
  line := PQ_READ_ALL_LINE(stream);
  while line <> fail do
    line := Chomp(line);
    Info(InfoANUPQ, 2, line);
    Add(lines, line);
    line := PQ_READ_ALL_LINE(stream);
  od;
  return lines;
end);

#############################################################################
##
#F  PqReadUntil( <i>, <IsMyLine> ) .  read from ANUPQ iostream until a cond'n
#F  PqReadUntil( <IsMyLine> )
#F  PqReadUntil( <i>, <IsMyLine>, <Modify> )
#F  PqReadUntil( <IsMyLine>, <Modify> )
##
##  read complete lines  of  {\ANUPQ}  output,  from  the  <i>th  or  default
##  interactive {\ANUPQ} process, ``chomps'' them (i.e.~removes any  trailing
##  newline character), emits them to `Info' at `InfoANUPQ' level 2  (without
##  trying to distinguish banner and menu output from  other  output  of  the
##  `pq' binary), and applies the function <Modify> (where <Modify>  is  just
##  the identity map/function for the first two forms)  until  a  ``chomped''
##  line  <line>  for  which  `<IsMyLine>(  <Modify>(<line>)  )'   is   true.
##  `PqReadUntil' returns the list of <Modify>-ed ``chomped'' lines read.
##
InstallGlobalFunction(PqReadUntil, function(arg)
local idx1stfn, stream, IsMyLine, Modify, lines, line;

  idx1stfn := First([1..Length(arg)], i -> IsFunction(arg[i]));
  if idx1stfn = fail then
    Error("expected at least one function argument\n");
  elif Length(arg) > idx1stfn + 1 then
    Error("expected 1 or 2 function arguments, not ", 
          Length(arg) - idx1stfn + 1, "\n");
  elif idx1stfn > 2  then
    Error("expected 0 or 1 integer arguments, not ", idx1stfn - 1, "\n");
  else
    stream := ANUPQData.io[ ANUPQ_IOINDEX(arg{[1..idx1stfn - 1]}) ].stream;
    IsMyLine := arg[idx1stfn];
    if idx1stfn = Length(arg) then
      Modify := line -> line; # The identity function
    else
      Modify := arg[Length(arg)];
    fi;
    lines := [];
    repeat
      line := Chomp( PQ_READ_NEXT_LINE(stream) );
      Info(InfoANUPQ, 2, line);
      line := Modify(line);
      Add(lines, line);
    until IsMyLine(line);
    return lines;
  fi;
end);

#############################################################################
##
#F  PqWrite( <i>, <string> ) . . . . . . .  primitive write to ANUPQ iostream
#F  PqWrite( <string> )
##
##  write <string> to the <i>th  or  default  interactive  {\ANUPQ}  process;
##  <string> must be in exactly the form the {\ANUPQ} standalone expects. The
##  command is echoed via `Info' at `InfoANUPQ' level 3 (with a  ```ToPQ> '''
##  prompt); i.e.~do `SetInfoLevel(InfoANUPQ, 3);' to see what is transmitted
##  to the `pq' binary. `PqWrite' returns `true' if successful in writing  to
##  the stream of the interactive {\ANUPQ} process, and `fail' otherwise.
##
InstallGlobalFunction(PqWrite, function(arg)
local ioIndex, line;

  if Length(arg) in [1, 2] then
    ioIndex := ANUPQ_IOINDEX(arg{[1..Length(arg) - 1]});
    return WRITE_LIST_TO_PQ( ANUPQData.io[ioIndex].stream,
                             arg{[Length(arg)..Length(arg)]} );
  else
    Error("expected 1 or 2 arguments ... not ", Length(arg), " arguments\n");
  fi;
end);

#############################################################################
##
#F  WRITE_AND_FLUSH_PQ_STREAM( <stream>, <list> )
##
##  writes   list   <list>   to   iostream   <stream>   and    then    calls
##  `FLUSH_PQ_STREAM_UNTIL' to flush all `pq' output at `InfoANUPQ' level 2.
##
InstallGlobalFunction(WRITE_AND_FLUSH_PQ_STREAM, function(stream, list)
  WRITE_LIST_TO_PQ(stream, list);
  FLUSH_PQ_STREAM_UNTIL(stream, 2, 2, PQ_READ_NEXT_LINE, IS_PQ_PROMPT);
end);

#############################################################################
##
#F  VALUE_PQ_OPTION( <optname>, <defaultval> ) . . enhancement of ValueOption
##
##  returns  `ValueOption(  <optname>  )'  if  not  `fail'  and  <defaultval>
##  otherwise.
##
InstallGlobalFunction(VALUE_PQ_OPTION, function(optname, defaultval)
local optval;
  optval := ValueOption(optname);
  if optval = fail then
    return defaultval;
  else
    return optval;
  fi;
end);
  
#############################################################################
##
#F  PQ_INTERACTIVE( <i> : <options> ) . . . . . . . interactive version of Pq
#F  PQ_INTERACTIVE( : <options> )
##
InstallGlobalFunction(PQ_INTERACTIVE, function(arglist)
local datarec, gens, rels, ToPQk, ToPQ;

  ANUPQ_IOINDEX_ARG_CHK(arglist);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arglist) ];
  PQ_MENU(datarec, "pQ");

  ToPQk := function(list)
    WRITE_LIST_TO_PQ(datarec.stream, list);
  end;

  ToPQ := function(list)
    WRITE_AND_FLUSH_PQ_STREAM(datarec.stream, list);
  end;

  # at least "Prime" and "Class" must be given
  if not IsInt( ValueOption( "Prime" ) ) then
    Error( "you must supply a prime" );
  fi;
  if not IsInt( ValueOption( "ClassBound" ) ) then
    Error( "you must supply a class bound" );
  fi;

  # Option 1 of p-Quotient Menu: defining the group
  ToPQk([ "1 #define group" ]);
  ToPQk([ "prime ",    ValueOption( "Prime") ]);
  ToPQk([ "class ",    ValueOption( "ClassBound") ]);
  ToPQk([ "exponent ", VALUE_PQ_OPTION( "Exponent", 0) ]);
  if ValueOption( "Metabelian" ) = true then
    ToPQk([ "metabelian" ]);
  fi;
  if IsInt( ValueOption( "OutputLevel" ) ) then
    ToPQk([ "output ", ValueOption( "OutputLevel" ) ]);
  fi;
  gens := JoinStringsWithSeparator(
              List( FreeGeneratorsOfFpGroup( datarec.group ), String ) );
  ToPQk([ "generators { ", gens, " }" ]);
  rels := JoinStringsWithSeparator(
              List( Filtered( RelatorsOfFpGroup( datarec.group ), 
                              rel -> not IsOne(rel) ), String ) );
  ToPQ([ "relations  { ", rels, " };" ]);

  PrintTo(ANUPQData.outfile, ""); #to ensure it's empty
  PQ_MENU(datarec, "IpQ"); #we need options from the Interactive p-Q Menu
  ToPQ([ "25 #set output file" ]);
  ToPQ([ ANUPQData.outfile ]);
  ToPQ([ "2  #output in GAP format" ]);

  HideGlobalVariables( "F", "MapImages" );
  Read( ANUPQData.outfile );
  datarec.quotient := ValueGlobal( "F" );
  UnhideGlobalVariables( "F", "MapImages" );

  return datarec.quotient;
end);

#E  anupqios.gi . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
