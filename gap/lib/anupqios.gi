#############################################################################
####
##
#W  anupqios.gi            ANUPQ package                          Greg Gamble
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
#F  PQ_START( <workspace>, <setupfile> ) . . . open a stream for a pq process
##
##  ensures the images file written by the `pq' binary when in  the  Standard
##  Presentation menu is empty, opens an io stream  to  a  `pq'  process  (if
##  <setupfile> is `fail') or a file stream for a setup file (if  <setupfile>
##  is a filename i.e. a string) and returns  a  record  with  fields  `menu'
##  (current menu for the `pq' binary), `opts' (the runtime switches used  by
##  the `pq' process), `workspace' (the value of <workspace> which should  be
##  a positive integer), and `stream' (the io or file stream opened).
##
InstallGlobalFunction(PQ_START, function( workspace, setupfile )
local opts, iorec;
  PrintTo(ANUPQData.SPimages, ""); #to ensure it's empty
  if setupfile = fail then
    opts := [ "-G" ];
  else
    opts := [ "-i", "-k", "-g" ];
  fi;
  if workspace <> 10000000 then
    Append( opts, [ "-s", String(workspace) ] );
  fi;
  iorec := rec( menu := "SP", 
                opts := opts,
                workspace := workspace );
  if setupfile = fail then
    iorec.stream := InputOutputLocalProcess( ANUPQData.tmpdir, 
                                             ANUPQData.binary, 
                                             opts );
    if iorec.stream = fail then
      Error( "sorry! Run out of pseudo-ttys. Can't open an io stream.\n" );
    fi;
    # menus are flushed at InfoANUPQ level 6, prompts at level 5
    FLUSH_PQ_STREAM_UNTIL(iorec.stream, 6, 5, PQ_READ_NEXT_LINE, IS_PQ_PROMPT);
  else
    iorec.stream := OutputTextFile(setupfile, false);
    iorec.setupfile := setupfile;
    ToPQk(iorec, [ "#call pq with flags: '",
                   JoinStringsWithSeparator(opts, " "),
                   "'" ]);
  fi;
  return iorec;
end );

#############################################################################
##
#F  PqStart(<G>,<workspace> : <options>) . Initiate interactive ANUPQ session
#F  PqStart(<G> : <options>)
#F  PqStart(<workspace> : <options>)
#F  PqStart( : <options>)
##
##  activate an iostream for an interactive {\ANUPQ} process (i.e.  `PqStart'
##  starts up a `pq' binary process and opens a {\GAP} iostream  to  ``talk''
##  to that process) and returns an integer <i> that can be used to  identify
##  that process. The argument <G>, if given, should be an *fp group* or  *pc
##  group* that the user  intends  to  manipute  using  interactive  {\ANUPQ}
##  functions. If `PqStart' is given an integer argument <workspace> then the
##  `pq' binary is started up with a workspace (an  integer  array)  of  size
##  <workspace> (i.e. $4 \times <workspace>$ bytes in a 32-bit  environment);
##  otherwise, the `pq' binary sets a default workspace of $10000000$.
##
##  The only <options> currently recognised  by  `PqStart'  are  `Prime'  and
##  `Exponent' (see~"Pq" for details) and if provided  they  are  essentially
##  global for the interactive {\ANUPQ} process, except that any  interactive
##  function interacting with the process and passing new  values  for  these
##  options will over-ride the global values.
##
InstallGlobalFunction(PqStart, function(arg)
local opts, iorec, G, workspace, optname;

  if 2 < Length(arg) then
    Error("at most two arguments expected.\n");
  fi;

  if not IsEmpty(arg) and IsGroup( arg[1] ) then
    G := arg[1];
    if not( IsFpGroup(G) or IsPcGroup(G) ) then
      Error( "argument <G> should be an fp group or a pc group\n" );
    fi;
    arg := arg{[2 .. Length(arg)]};
  fi;

  if not IsEmpty(arg) then
    workspace := arg[1];
    if not IsPosInt(workspace) then
      Error("argument <workspace> should be a positive integer.\n");
    fi;
  else
    workspace := 10000000;
  fi;

  iorec := PQ_START( workspace, fail );
  if IsBound( G ) then
    iorec.group := G;
  fi;
  iorec.calltype := "interactive";
  for optname in ANUPQGlobalOptions do
    VALUE_PQ_OPTION(optname, iorec);
  od;

  # We add iorec to the next *non-prime* position in ANUPQData.io
  # ... the reason for this is to be able to distinguish easily
  # the <i> and <p> arguments of [Epimorphism][Pq]StandardPresentation
  if 1 = Length(ANUPQData.io) then
    Append( ANUPQData.io, [,, iorec]);
  elif IsPrimeInt( Length(ANUPQData.io) + 1 ) then
    Append( ANUPQData.io, [, iorec] );
  else
    Add( ANUPQData.io, iorec );
  fi;
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
  # No need to bother about descending through the menus.
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
#F  ANUPQDataRecord([<i>]) . . . . . . . returns the data record of a process
##
InstallGlobalFunction(ANUPQDataRecord, function( arg )
  if not IsEmpty(arg) and arg[1] = 0 and IsBound( ANUPQData.ni ) then
    return ANUPQData.ni;
  else
    return ANUPQData.io[ CallFuncList(PqProcessIndex, arg) ];
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
  return not IsEndOfStream( ANUPQData.io[ PqProcessIndex(arg) ].stream );
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
              depth := 2, prev  := "SP", nextopt := rec( pG  := 9, ApQ := 8 ) ),
  pG  := rec( name  := "(Main) p-Group Generation Menu",
              depth := 3, prev  := "pQ", nextopt := rec( ApG := 6 ) ),
  ApQ := rec( name  := "Advanced p-Quotient Menu",
              depth := 3, prev  := "pQ", nextopt := rec() ),
  ApG := rec( name  := "Advanced p-Group Gen'n Menu",
              depth := 4, prev  := "pG", nextopt := rec() )
  ) );

#############################################################################
##
#F  PQ_MENU( <datarec>, <newmenu> ) . . . . . . change/get menu of pq process
#F  PQ_MENU( <datarec> )
##
InstallGlobalFunction(PQ_MENU, function(arg)
local datarec, newmenu, nextmenu, tomenu, infolev;
  datarec := arg[1];
  if 2 = Length(arg) then
    newmenu := arg[2];
    if datarec.menu in ["SP", "pQ"] and newmenu in ["ApQ", "pG", "ApG"] then
      PQ_GRP_EXISTS_CHK( datarec ); #We try to avoid seg-faults!
    fi;
    while datarec.menu <> newmenu do
      if PQ_MENUS.(datarec.menu).depth >= PQ_MENUS.(newmenu).depth then
        datarec.menu := PQ_MENUS.(datarec.menu).prev;
        tomenu := PQ_MENUS.(datarec.menu).name;
        ToPQk(datarec, [ 0 , "  #to ", tomenu]);
        infolev := 5;
      elif datarec.menu = "pQ" and newmenu = "ApQ" then
        datarec.menu := "ApQ";
        tomenu := PQ_MENUS.(datarec.menu).name;
        ToPQk(datarec, [ PQ_MENUS.pQ.nextopt.ApQ, "  #to ", tomenu ]);
        infolev := 6;
      else
        nextmenu := RecNames( PQ_MENUS.(datarec.menu).nextopt )[1];
        tomenu := PQ_MENUS.(nextmenu).name;
        ToPQk(datarec, [ PQ_MENUS.(datarec.menu).nextopt.(nextmenu),
                         "  #to ", tomenu ]);
        datarec.menu := nextmenu;
        infolev := 6;
      fi;
      # menus are flushed at InfoANUPQ level 6, prompts at level 5
      FLUSH_PQ_STREAM_UNTIL(datarec.stream, infolev, 5, PQ_READ_NEXT_LINE,
                            IS_PQ_PROMPT);
    od;
  fi;
  return datarec.menu;
end);

#############################################################################
##
#F  IS_PQ_PROMPT( <line> ) . . . .  checks whether the line is a prompt of pq
##
##  returns `true' if the string  <line>  is  a  `pq'  prompt,  or  otherwise
##  returns `false'.
##
InstallGlobalFunction(IS_PQ_PROMPT,
  line -> IS_ALL_PQ_LINE(line) and ANUPQData.linetype = "prompt"
);

#############################################################################
##
#F  IS_ALL_PQ_LINE( <line> ) . checks whether line is a complete line from pq
##
##  returns `true' if the string <line> is a `pq' prompt or  a  request  from
##  `pq' to {\GAP} to compute stabilisers or simply ends  in  a  newline  and
##  sets `ANUPQData.linetype' to `"prompt"', `"request"'  or  `"hasnewline"',
##  accordingly; otherwise `ANUPQData.linetype' is  set  to  `"unknown"'  and
##  `false' is returned.
##
InstallGlobalFunction(IS_ALL_PQ_LINE, function( line )
local len;
  ANUPQData.linetype := "unknown";
  len := Length(line);
  if 0 < len then
    if line[len] = '\n' then
      if 4 < len  and line{[1 .. 3]} = "GAP" and line[len - 1] = '!' then
        ANUPQData.linetype := "request";
      elif 6 < len and line{[1 .. 6]} in ["Enter ", "Input "] then
        ANUPQData.linetype := "prompt";
      else
        ANUPQData.linetype := "hasnewline";
      fi;
    elif line = "Select option: " or
         1 < len and line{[len - 1 .. len]} = "? "  or
         8 < len and line{[len - 1 .. len]} = ": " and
                     line{[1 .. 6]} in ["Enter ", "Input ", "Add ne"] then
      ANUPQData.linetype := "prompt";
    fi;
  fi;
  return ANUPQData.linetype <> "unknown";
end);

#############################################################################
##
#F  PQ_READ_ALL_LINE( <iostream> ) .  read line from pq but poss. return fail
##
##  reads a complete line from <iostream> or return `fail'.
##
InstallGlobalFunction(PQ_READ_ALL_LINE, 
  iostream -> ReadAllLine(iostream, false, IS_ALL_PQ_LINE)
);

#############################################################################
##
#F  PQ_READ_NEXT_LINE( <iostream> ) . read line from pq but never return fail
##
##  Essentially, like `PQ_READ_ALL_LINE' but we know there is a complete line
##  to be got, so we wait for it, before returning.
##
InstallGlobalFunction(PQ_READ_NEXT_LINE, 
  iostream -> ReadAllLine(iostream, true, IS_ALL_PQ_LINE)
);

#############################################################################
##
#F  FLUSH_PQ_STREAM_UNTIL(<stream>,<infoLev>,<infoLevMy>,<readln>,<IsMyLine>)
##  . . .  . . . . . . . . . . . read lines from a stream until a wanted line
##
##  calls <readln> (which should be one of `ReadLine', `PQ_READ_NEXT_LINE' or
##  `PQ_READ_ALL_LINE') to read lines from a stream <stream> and `Info's each
##  line read at `InfoANUPQ' level <infoLev> until a line <line> is read  for
##  which `<IsMyLine>(<line>)' is `true'; <line> is `Info'-ed at  `InfoANUPQ'
##  level <infoLevMy> and returned. <IsMyLine>  should  be  a  boolean-valued
##  function that expects a string as its only argument,  and  <infoLev>  and
##  <infoLevMy> should be positive integers. An <infoLevMy> of 10 means  that
##  the  line  <line>  matched  by  `<IsMyLine>(<line>)'  should   never   be
##  `Info'-ed.
##
InstallGlobalFunction(FLUSH_PQ_STREAM_UNTIL, 
function(stream, infoLev, infoLevMy, readln, IsMyLine)
local line;
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
#F  FILTER_PQ_STREAM_UNTIL_PROMPT( <datarec> )
##
##  reads `pq' output from `<datarec>.stream' until a `pq' prompt and `Info's
##  any lines that are prompts, blank lines, menu exits  or  start  with  the
##  strings in the list `<datarec>.filter' (if bound) at `InfoANUPQ' level 5;
##  all  other  lines  are  either  `Info'-ed  at  `InfoANUPQ'  level  3   if
##  `datarec.nonuser' is set, or, more usually, are `Info'-ed at  `InfoANUPQ'
##  level 2 if  they  are  computation  times  or  at  `InfoANUPQ'  level  1,
##  otherwise.
##
InstallGlobalFunction(FILTER_PQ_STREAM_UNTIL_PROMPT, function( datarec )
local match, filter, lowlev, ctimelev;
  filter := ["Exiting", "pq,", "Now enter", "Presentation listing images"];
  if IsBound(datarec.match) then
    if datarec.match = true then
      match := ["Group:", "Group completed"];
    else
      match := [datarec.match];
    fi;
  fi;
  if IsBound(datarec.filter) then
    Append(filter, datarec.filter);
  fi;
  if ValueOption("nonuser") = true then
    lowlev := 3;
    ctimelev := 3;
  else
    ctimelev := 2;
    if not IsBound(datarec.OutputLevel) or datarec.OutputLevel = 0 then
      lowlev := 3;
    else
      lowlev := 1;
    fi;
  fi;
  repeat
    datarec.line := PQ_READ_NEXT_LINE(datarec.stream);
    if ANUPQData.linetype in ["prompt", "request"] then
      Info( InfoANUPQ, 5,        Chomp(datarec.line) );
      break;
    elif ForAny(["seconds", "Lused", "*** Final "], 
                s -> PositionSublist(datarec.line, s) <> fail) then
      Info( InfoANUPQ, ctimelev, Chomp(datarec.line) );
    elif datarec.line = "\n" or
         ForAny( filter, s -> IsMatchingSublist(datarec.line, s) ) then
      Info( InfoANUPQ, 5,        Chomp(datarec.line) );
    elif PositionSublist(datarec.line, " saved on file") <> fail then
      Info( InfoANUPQ, ctimelev, Chomp(datarec.line) );
    else
      Info( InfoANUPQ, lowlev,   Chomp(datarec.line) );
    fi;
    if IsBound(match) then
      if ForAny( match, s -> IsMatchingSublist(datarec.line, s) ) then
        datarec.matchedline := datarec.line;
      fi;
    elif IsBound(datarec.matchlist) and 
         ForAny( datarec.matchlist, 
                 s -> PositionSublist(datarec.line, s) <> fail ) then
      Add(datarec.matchedlines, datarec.line);
    fi;
  until false;
end);

#############################################################################
##
#F  ToPQk( <datarec>, <list> ) . . . . . . . . . writes a list to a pq stream
##
##  writes list <list> to iostream `<datarec>.stream' and `Info's  <list>  at
##  `InfoANUPQ' level 3 after a ```ToPQ> ''' prompt, and  returns  `true'  if
##  successful and `fail' otherwise. The ``k'' at the  end  of  the  function
##  name is mnemonic for ``keyword'' (for  ``keyword''  inputs  to  the  `pq'
##  binary one never wants to flush output).
##
InstallGlobalFunction(ToPQk, function(datarec, list)
local string, ok;

  if not IsOutputTextStream(datarec.stream) and 
     IsEndOfStream(datarec.stream) then
    Error("sorry! Process stream has died!\n");
  fi;
  string := Concatenation( List(list, String) );
  Info(InfoANUPQ, 4, "ToPQ> ", string);
  ok := WriteLine(datarec.stream, string);
  if ok = fail then
    Error("write to stream failed\n");
  fi;
  return ok;
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

  line := PQ_READ_ALL_LINE( ANUPQData.io[ PqProcessIndex(arg) ].stream );
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

  stream := ANUPQData.io[ PqProcessIndex(arg) ].stream;
  lines := [];
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
    return ToPQk( ANUPQData.io[ioIndex], arg{[Length(arg)..Length(arg)]} );
  else
    Error("expected 1 or 2 arguments ... not ", Length(arg), " arguments\n");
  fi;
end);

#############################################################################
##
#F  ToPQ(<datarec>, <list>) .  write list to pq stream (& for iostream flush)
##
##  calls `ToPQk' to write list <list>  to  iostream  `<datarec>.stream'  and
##  `Info' <list> at `InfoANUPQ' level 3 after a  ```ToPQ>  '''  prompt,  and
##  then, if we are not just writing a setup  file  (determined  by  checking
##  whether       `<datarec>.setupfile'        is        bound),        calls
##  `FILTER_PQ_STREAM_UNTIL_PROMPT' to filter lines to `Info' at the  various
##  `InfoANUPQ' levels. If we are not writing a  setup  file  the  last  line
##  flushed is saved in `<datarec>.line'.
##
InstallGlobalFunction(ToPQ, function(datarec, list)
  ToPQk(datarec, list);
  if not IsBound( datarec.setupfile ) then
    FILTER_PQ_STREAM_UNTIL_PROMPT(datarec);
  
    while ANUPQData.linetype = "request" do
      HideGlobalVariables( "ANUPQglb", "F", "gens", "relativeOrders",
                           "ANUPQsize", "ANUPQagsize" );
      Read( Filename( ANUPQData.tmpdir, "GAP_input" ) );
      Read( Filename( ANUPQData.tmpdir, "GAP_rep" ) );
      UnhideGlobalVariables( "ANUPQglb", "F", "gens", "relativeOrders",
                             "ANUPQsize", "ANUPQagsize" );
      ToPQ( datarec, [ "pq, stabiliser is ready!" ] );
    od;
  fi;
end);

#############################################################################
##
#F  ANUPQ_ARG_CHK(<len>, <funcname>, <args>) .  check args of int/non-int fns
##
##  This checks the  argument  list  <args>  for  functions  that  have  both
##  interactive and non-interactive versions; <len> is the length  of  <args>
##  for the non-interactive  version  of  the  function,  <funcname>  is  the
##  generic name of the function and is used  for  determining  the  list  of
##  options for the function when they  are  passed  in  one  of  the  {\GAP}
##  3-compatible  ways  only  available  non-interactively.   `ANUPQ_ARG_CHK'
##  returns <datarec> which is either `ANUPQData.ni' in  the  non-interactive
##  case or `ANUPQData.io[<i>]' for some <i> in the interactive  case,  after
##  setting    <datarec>.calltype'     to     one     of     `"interactive"',
##  `"non-interactive"' or `"GAP3compatible"'.
##
InstallGlobalFunction(ANUPQ_ARG_CHK, function(len, funcname, args)
local interactive, ioArgs, ioIndex, datarec, group, posNonGroup, p,
      optrec, optname, optnames;
  interactive := IsEmpty(args) or not IsGroup( args[1] );
  if interactive then
    ioArgs := args{[1..Length(args) - len + 1]};
    if not IsEmpty(ioArgs) and IsInt( ioArgs[1] ) and IsPrime( ioArgs[1] ) then
      ioArgs := [];
    fi;
    ioIndex := CallFuncList( PqProcessIndex, ioArgs );
    datarec := ANUPQData.io[ ioIndex ];
    datarec.procId := ioIndex;
    group := datarec.group;
    posNonGroup := 1;
  else
    group := args[1];
    posNonGroup := 2;
  fi;
  if funcname = "StandardPresentation" and
     First( [posNonGroup .. Length(args)], 
            i -> IsPcGroup(args[i]) or
                 IsInt(args[i]) and IsPrime(args[i]) ) = fail then
    if not( IsPcGroup(group) and HasIsPGroup(group) and IsPGroup(group) ) then
      Error( "since group of process is not (known to be) a pc p-group,\n",
             "a prime or p-quotient (pc group) of the group of the process\n",
             "must be supplied\n" );
    fi;
    p := PrimePGroup(group);
    if interactive and 
       First( [1 .. Length(args)], i -> IsPosInt(args[i]) ) = fail then
      args := Concatenation( [ p ], args );
    else
      args := Concatenation( args{[1]}, [ p ], args{[2 .. Length(args)]} );
    fi;
  fi;
  if interactive then
    datarec.outfname := ANUPQData.outfile; # not always needed
    #datarec.calltype := "interactive";    # PqStart sets this
    if not IsBound(datarec.group) then
      Error( "huh! Interactive process has no group\n" );
    elif funcname = "PqDescendants" then
      if not IsPcGroup( datarec.group ) then
        Error( "group of process must be a pc group\n" );
      fi;
    else # if funcname = "Pq" check for Prime, ClassBound
      PQ_OPTION_CHECK( funcname, datarec );
    fi;
  elif Length(args) = len then
    if not IsPcGroup( args[1] ) then
      if funcname = "PqDescendants" then
        Error( "first argument <args[1]> must be a pc group\n" );
      elif not IsFpGroup( args[1] ) then
        Error( "first argument <args[1]> must be a pc group or an fp group\n" );
      fi;
    fi;
    ANUPQData.ni := PQ_START( VALUE_PQ_OPTION( "PqWorkspace", 10000000 ),
                              VALUE_PQ_OPTION( "SetupFile" ) );
    datarec := ANUPQData.ni;
    datarec.group := group;
    datarec.calltype := "non-interactive";
    datarec.procId := 0;
    PQ_OPTION_CHECK( funcname, datarec ); # Check for Prime, ClassBound if nec.
    if IsBound( datarec.setupfile ) then
      datarec.outfname := "PQ_OUTPUT";
    else
      datarec.outfname := ANUPQData.outfile; # not always needed
    fi;
  else
    # GAP 3 way of passing options is supported in non-interactive use
    if IsRecord(args[len + 1]) then
      optrec := ShallowCopy(args[len + 1]);
      optnames := Set( REC_NAMES(optrec) );
      SubtractSet( optnames, Set( ANUPQoptions.(funcname) ) );
      if not IsEmpty(optnames) then
        Error(ANUPQoptError( funcname, optnames ), "\n");
      fi;
    else
      optrec := ANUPQextractOptions(funcname, args{[len + 1 .. Length(args)]});
    fi;
    PushOptions(optrec);
    PQ_FUNCTION.(funcname)( args{[1..len]} );
    PopOptions();
    datarec := ANUPQData.ni;
    datarec.calltype := "GAP3compatible";
    datarec.procId := 0;
  fi;
  if IsBound(p) then
    datarec.p := p;
  fi;
  return datarec;
end );

#############################################################################
##
#F  PQ_COMPLETE_NONINTERACTIVE_FUNC_CALL( <datarec> )
##
##  writes the final commands to the `pq' setup file so that the `pq'  binary
##  makes a clean exit, or just closes the stream to kill the `pq' process.
##
InstallGlobalFunction(PQ_COMPLETE_NONINTERACTIVE_FUNC_CALL, function(datarec)
  if IsBound( datarec.setupfile ) then
    PQ_MENU(datarec, "SP");
    ToPQk(datarec, [ "0  #exit program" ]);
  fi;
  CloseStream(datarec.stream);

  if IsBound( datarec.setupfile ) then
    Info(InfoANUPQ, 1, "Input file: '", datarec.setupfile, "' written.");
    Info(InfoANUPQ, 1, "Run `pq' with '", datarec.opts, "' flags.");
    Info(InfoANUPQ, 1, "The result will be saved in: '", 
                       datarec.outfname, "'.");
  fi;
end );

#E  anupqios.gi . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
