#############################################################################
####
##
#W  anupqi.gi           ANUPQ Share Package                       Greg Gamble
##
##  This file installs interactive functions that execute individual pq  menu
##  options.
##
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqi_gi :=
    "@(#)$Id$";

#############################################################################
##
#F  PQ_AUT_INPUT( <datarec>, <G> : <options> ) . . . . . . automorphism input
##
##  inputs automorphism data for `<datarec>.group' given by <options> to  the
##  `pq' binary derived from the pc group  <G>  (used  in  option  1  of  the
##  $p$-Group Generation menu and option 2 of the Standard Presentation menu).
##
InstallGlobalFunction( PQ_AUT_INPUT, function( datarec, G )
local autGrp, rank, automorphisms, gens, i, j, aut, g, exponents;
  autGrp := AutomorphismGroup(G); # GAP better be able to provide this
  if VALUE_PQ_OPTION("PcgsAutomorphisms", false, datarec) then
    automorphisms := Pcgs( autGrp );
    if automorphisms = fail then
      Error( "option \"PcgsAutomorphisms\" used with insoluble",
             "automorphism group\n" );
    fi;
    automorphisms := Reversed( automorphisms );
  else
    automorphisms := GeneratorsOfGroup( autGrp );
  fi;

  rank := RankPGroup( G );
  gens := PcgsPCentralSeriesPGroup( G );
  ToPQ(datarec, [ Length(automorphisms), "  #number of automorphisms" ]);
  for i in [1..Length(automorphisms)] do
    aut := automorphisms[i];
    for j in [1..Length(gens)] do
      g := gens[j];
      exponents := Flat( List( ExponentsOfPcElement( gens, Image( aut, g ) ),
                               e -> [ String(e), " "] ) );
      ToPQ(datarec, 
           [ exponents, " #gen'r exp'ts of im(aut ", i, ", gen ", j, ")" ]);
    od;
  od;
end );

#############################################################################
##
#F  PQ_MANUAL_AUT_INPUT(<datarec>,<mlist>) . automorphism input w/o an Aut gp
##
##  inputs automorphism data for `<datarec>.group' given by  <mlist>  to  the
##  `pq' binary.
##
InstallGlobalFunction( PQ_MANUAL_AUT_INPUT, function( datarec, mlist )
local line, nauts, rank, nexpts, i, j, aut, exponents;
  nauts  := Length(mlist);
  rank   := Length(mlist[1]);
  ToPQk(datarec, [ nauts,  "  #no. of auts" ]);
  line := FLUSH_PQ_STREAM_UNTIL( datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
                                 IS_PQ_PROMPT );
  if line = "Input the number of exponents: " then
    nexpts := Length(mlist[1][1]);
    ToPQ(datarec, [ nexpts, "  #no. of exponents" ]);
  fi;
  for i in [1..nauts] do
    aut := mlist[i];
    for j in [1..rank] do
      exponents := Flat( List( aut[j], e -> [ String(e), " "] ) );
      ToPQ(datarec, 
           [ exponents, " #gen'r exp'ts of im(aut ", i, ", gen ", j, ")" ]);
    od;
  od;
end );

#############################################################################
##
#F  PQ_AUT_ARG_CHK(<datarec>, <mlist>) .  checks a matrix list look like auts
##
##  checks as much as is possible that a list of matrices will be valid input
##  as automorphisms for the `pq' binary.
##
InstallGlobalFunction( PQ_AUT_ARG_CHK, function( datarec, mlist )
local rank, nexpts;
  if not( IsList(mlist) and ForAll(mlist, IsMatrix) and
          ForAll(Flat(mlist), i -> IsInt(i) and i >= 0) ) then
    Error("<mlist> must be a list of matrices with ",
          "non-negative integer coefficients\n");
  fi;
  if IsBound( datarec.pQuotient ) then
    rank := RankPGroup( datarec.pQuotient );
  else
    rank := Length(mlist[1]); # Should we allow this?
  fi;
  if not ForAll(mlist, mat -> Length(mat) = rank) then
    Error("no. of rows in each matrix of <mlist> must be the rank of ",
          "p-quotient (", rank, ")\n");
  fi;
  nexpts := Length(mlist[1][1]);
  if not ForAll(mlist, mat -> Length(mat[1]) = nexpts) then
    Error("each matrix of <mlist> must have the same no. of columns\n");
  fi;
end );

#############################################################################
##
#F  PQ_PC_PRESENTATION( <datarec>, <menu> ) . . . . . .  p-Q/SP menu option 1
##
##  inputs  data  given  by  <options>  to  the   `pq'   binary   for   group
##  `<datarec>.group' to compute a  pc  presentation  (do  option  1  of  the
##  relevant menu) according to the  <menu>  menu,  where  <menu>  is  either
##  `"pQ"' (main $p$-Quotient menu) or `"SP' (Standard Presentation menu).
##
InstallGlobalFunction( PQ_PC_PRESENTATION, function( datarec, menu )
local gens, rels, pcp, p, pcgs, len, strp, i, j, Rel;

  pcp := Concatenation( menu, "pcp");
  if datarec.calltype = "interactive" and IsBound(datarec.(pcp)) and
     ForAll( REC_NAMES( datarec.(pcp) ), 
             optname -> ValueOption(optname) 
                        in [fail, datarec.(pcp).(optname)] ) then
     # only do it in the interactive case if it hasn't already been done
     # by checking whether options stored in `<datarec>.(<pcp>)' differ 
     # from those of a previous call ... if a check of an option value 
     # returns `fail' it is assumed the user intended the previous value
     # stored in `<datarec>.(<pcp>)' (this is potentially problematic for 
     # boolean options, to reverse a previous `true', `false' must be
     # explicitly set for the option on the subsequent function call)
        
     Info(InfoANUPQ, 1, "Using previously computed (", menu, 
                        ") pc presentation.");
     return;
  fi;

  PQ_MENU(datarec, menu);
  datarec.(pcp) := rec(); # options processed are stored here

  # Option 1 of p-Quotient/Standard Presentation Menu: defining the group
  ToPQk(datarec, ["1  #define group"]);
  p := VALUE_PQ_OPTION("Prime", fail, datarec); # "Prime" is a `global' option
  ToPQk(datarec, ["prime ",    p]);
  ToPQk(datarec, ["class ",    VALUE_PQ_OPTION("ClassBound", fail, 
                                                              datarec.(pcp))]);
  ToPQk(datarec, ["exponent ", VALUE_PQ_OPTION("Exponent", 0, datarec)]);
                                             # "Exponent" is a `global' option
  if VALUE_PQ_OPTION( "Metabelian", false, datarec.(pcp) ) = true then
    ToPQk(datarec, [ "metabelian" ]);
  fi;
  ToPQk(datarec, ["output ", VALUE_PQ_OPTION("OutputLevel", 1, datarec.(pcp))]);

  if IsFpGroup(datarec.group) then
    gens := FreeGeneratorsOfFpGroup(datarec.group);
    rels := Filtered( RelatorsOfFpGroup(datarec.group), rel -> not IsOne(rel) );
  else
    pcgs := PcgsPCentralSeriesPGroup(datarec.group);
    len  := Length(pcgs);
    gens := List( [1..len], i -> Concatenation( "g", String(i) ) );
    strp := String(p);

    Rel := function(elt, eltstr)
      local rel, expts, factors;

      rel := eltstr;
      expts := ExponentsOfPcElement( pcgs, elt );
      if ForAny( expts, x -> x<>0 )  then
        factors 
            := Filtered(
                   List( [1..len], 
                         function(i)
                           if expts[i] = 0 then
                             return "";
                           fi;
                           return Concatenation(gens[i], "^", String(expts[i]));
                         end ),
                   factor -> factor <> "");
        Append(rel, "=");
        Append(rel, JoinStringsWithSeparator(factors));
      fi;
      return rel;
    end;

    rels := List( [1..len], 
                  i -> Rel( pcgs[i]^p, Concatenation(gens[i], "^", strp) ) );
    for i in [1..len] do
      for j in [1..i-1]  do
        Add(rels, Rel( Comm( pcgs[i], pcgs[j] ), 
                       Concatenation("[", gens[i], ",", gens[j], "]") ));
      od;
    od;
  fi;
  gens := JoinStringsWithSeparator( List(gens, String) );
  rels := JoinStringsWithSeparator( List(rels, String) );
  ToPQk(datarec, ["generators { ", gens, " }"]);
  ToPQ (datarec, ["relations  { ", rels, " };"]);
end );

#############################################################################
##
#F  PqPcPresentation( <i> : <options> ) . . user version of p-Q menu option 1
#F  PqPcPresentation( : <options> )
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data  given
##  by <options> for the group of  that  process  so  that  the  `pq'  binary
##  computes a pc presentation, where the group of a process is the one given
##  as first argument when `PqStart' was called to initiate that process (for
##  process <i> the group is stored as `ANUPQData.io[<i>].group').
##
##  The   possible   <options>   are   `Prime',   `ClassBound',   `Exponent',
##  `Metabelian' and `OutputLevel', which are as described for  the  function
##  `Pq' (see~"Pq"). The option `Prime' is required unless  already  provided
##  to `PqStart'. Also, option `ClassBound' *must* be supplied.
##
##  *Note:* For those  familiar  with  the  `pq'  binary,  `PqPcPresentation'
##  performs option 1 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PqPcPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PC_PRESENTATION( datarec, "pQ" );
end );

#############################################################################
##
#F  PQ_SAVE_PC_PRESENTATION( <datarec>, <filename> ) . . .  p-Q menu option 2
##
##  directs the `pq' binary to save the pc presentation  previously  computed
##  for  `<datarec>.group'  to  <filename>  using  option  2  of   the   main
##  $p$-Quotient menu.
##
InstallGlobalFunction( PQ_SAVE_PC_PRESENTATION, function( datarec, filename )
  PQ_MENU(datarec, "pQ");
  ToPQ(datarec, [ "2  #save pc presentation to file" ]);
  ToPQ(datarec, [ filename, "  #filename" ]);
end );

#############################################################################
##
#F  PQ_PATH_CURRENT_DIRECTORY() . . . . . . . . . .  essentially the UNIX pwd
##
##  returns a string that is the path of the current directory.
##
InstallGlobalFunction( PQ_PATH_CURRENT_DIRECTORY, function()
local path, stream;
  path := "";
  stream := OutputTextString(path, true);
  if 0 = Process( DirectoryCurrent(), 
                  Filename(DirectoriesSystemPrograms(), "pwd"),
                  InputTextNone(), 
                  stream,
                  [] ) then
    CloseStream(stream);
    return Chomp(path);
  fi;
  Error("could not determine the path of the current directory!?!\n");
end );

#############################################################################
##
#F  PQ_CHK_PATH(<filename>, <rw>) . add curr dir path if nec. & check file ok
##
##  checks <filename> is a non-empty string, if it doesn't begin with  a  `/'
##  prepends a path for the current directory, and checks the result  is  the
##  name of a readable (resp. writable) if <rw> is `"r"' (resp.  if  <rw>  is
##  `"w"') and if there is no error returns the result.
##
InstallGlobalFunction( PQ_CHK_PATH, function( filename, rw )
  if not IsString(filename) or filename = "" then
    Error( "argument <filename> must be a non-empty string\n" );
  fi;
  if filename[1] <> "/" then
    # we need to do this as pq executes in ANUPQData.tmpdir
    filename := Concatenation(PQ_PATH_CURRENT_DIRECTORY(), "/", filename);
  fi;
  if rw = "r" then
    if IsReadableFile(filename) <> true then
      Error( "file with name <filename> is not readable\n" );
    fi;
  else # rw = "w"
    PrintTo(filename, ""); # This is what will generate the error
                           # but it also ensures it's empty
    if IsWritableFile(filename) <> true then
      Error( "file with name <filename> cannot be written to\n" );
    fi;
  fi;
  return filename;
end );

#############################################################################
##
#F  PqSavePcPresentation( <i>, <filename> ) . .  user ver. of p-Q menu opt. 2
#F  PqSavePcPresentation( <filename> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to save the pc presentation previously computed for the  group  of
##  that process to the file with name  <filename>,  where  the  group  of  a
##  process is the one given as first argument when `PqStart' was  called  to
##  initiate that process. If the first character of the string <filename> is
##  not `/' <filename> is assumed to be the path of a writable file  relative
##  to the directory in which {\GAP} was started.
##
##  *Note:* For those familiar with the `pq'  binary,  `PqSavePcPresentation'
##  performs option 2 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PqSavePcPresentation, function( arg )
local datarec, filename;
  if 0 = Length(arg) or Length(arg) > 2 then
    Error( "expected 1 or 2 arguments\n" );
  fi;
  filename := PQ_CHK_PATH( arg[Length(arg)], "w" );
  arg := arg{[1..Length(arg) - 1]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_SAVE_PC_PRESENTATION( datarec, filename );
end );

#############################################################################
##
#F  PQ_RESTORE_PC_PRESENTATION( <datarec>, <filename> ) . . p-Q menu option 3
##
##  directs the `pq' binary to restore the pc presentation  previously  saved
##  to <filename> using option 3 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PQ_RESTORE_PC_PRESENTATION, function( datarec, filename )
  PQ_MENU(datarec, "pQ");
  ToPQ(datarec, [ "3  #restore pc presentation from file" ]);
  ToPQ(datarec, [ filename, "  #filename" ]);
  datarec.pQpcp := rec(); # Just so it's bound
end );

#############################################################################
##
#F  PqRestorePcPresentation( <i>, <filename> ) . user ver. of p-Q menu opt. 3
#F  PqRestorePcPresentation( <filename> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to restore the pc presentation previously saved to <filename>  for
##  the group of that process, where the group of a process is the one  given
##  as first argument when `PqStart' was called to initiate that process.  If
##  the first character of the string <filename> is  not  `/'  <filename>  is
##  assumed to be the path of a readable file relative to  the  directory  in
##  which {\GAP} was started.
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,  `PqRestorePcPresentation'
##  performs option 3 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PqRestorePcPresentation, function( arg )
local datarec, filename;
  if 0 = Length(arg) or Length(arg) > 2 then
    Error( "expected 1 or 2 arguments\n" );
  fi;
  filename := PQ_CHK_PATH( arg[Length(arg)], "r" );
  arg := arg{[1..Length(arg) - 1]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_RESTORE_PC_PRESENTATION( datarec );
end );

#############################################################################
##
#F  PQ_PRE_DISPLAY( <datarec>, <menu> ) . . . .  execute pre-display commands
##
##  sets  up  a  display  command  by  ensuring  the  print  level   is   set
##  appropriately and the `InfoLevel' of  `InfoANUPQ'  is  at  least  2,  and
##  returns  the  `InfoLevel'  of  `InfoANUPQ'  at  the  point   of   calling
##  `PQ_PRE_DISPLAY'.
##
InstallGlobalFunction( PQ_PRE_DISPLAY, function( datarec, menu )
local lev, infolev;
  PQ_MENU(datarec, menu);
  if menu[ Length(menu) ] <> 'G' then
    lev := VALUE_PQ_OPTION("OutputLevel");
    if lev <> fail then
      PQ_SET_PRINT_LEVEL( datarec, menu, lev );
    fi;
  fi;
  infolev := InfoLevel(InfoANUPQ);
  SetInfoLevel(InfoANUPQ, Maximum(2, infolev));
  return infolev;
end );

#############################################################################
##
#F  PQ_DISPLAY_PRESENTATION( <datarec>, <menu> ) . . . . .  any menu option 4
##
##  directs the  `pq'  binary  to  display  the  pc  presentation  previously
##  computed or restored from file using option 4 of <menu> menu.
##
InstallGlobalFunction( PQ_DISPLAY_PRESENTATION, function( datarec, menu )
local infolev;
  infolev := PQ_PRE_DISPLAY(datarec, menu);
  ToPQ(datarec, [ "4  #display presentation" ]);
  SetInfoLevel(InfoANUPQ, infolev);
end );

#############################################################################
##
#F  PQ_CURRENT_GROUP(<datarec>) .  uses p-Q menu opt 4 to set the current grp
##
##  sets the details of the current group in `<datarec>.pQ.currGrp'.
##
InstallGlobalFunction( PQ_CURRENT_GROUP, function( datarec )
local lev, line;
  PQ_MENU(datarec, "pQ");
  if not IsBound(datarec.pQ) then
    datarec.pQ := rec();
  fi;
  if IsBound(datarec.pQ.OutputLevel) then
    lev := datarec.pQ.OutputLevel;
    ToPQ(datarec, [ "5  #set print level" ]);
    ToPQ(datarec, [ "0  #minimal print level" ]);
  fi;
  ToPQk(datarec, [ "4  #display presentation" ]);
  line := FLUSH_PQ_STREAM_UNTIL( datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
                                 line -> IsMatchingSublist( line, "Group:" ) );
  line := SplitString(line, "", ": ");
  datarec.pQ.currGrp := rec( name := line[2], 
                             class := Int( line[8] ),
                             order := EvalString( line[11] ) );
  FLUSH_PQ_STREAM_UNTIL(datarec.stream, 2, 2, PQ_READ_NEXT_LINE, IS_PQ_PROMPT);
  if IsBound(lev) then
    ToPQ(datarec, [ "5  #set print level" ]);
    ToPQ(datarec, [ lev, "  #print level" ]);
  fi;
end );

#############################################################################
##
#F  PqCurrentGroup( <i> ) . . .  using p-Q menu opt 4 returns the current grp
#F  PqCurrentGroup()
##
##  for the <i>th or default interactive {\ANUPQ} process, returns  a  record
##  with fields `name', `class' and `order' which are respectively  the  name
##  (known to the `pq' binary, which is by default `"G"'), the class and  the
##  order of the current group.
##
InstallGlobalFunction( PqCurrentGroup, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  if not IsBound(datarec.pQpcp) then
    Error( "pq binary must have a pcp, call `PqPcPresentation' or\n",
           "`PqRestorePcPresentation' first\n" );
  fi;
  PQ_CURRENT_GROUP( datarec );
  return datarec.pQ.currGrp;
end );

#############################################################################
##
#F  PqDisplayPcPresentation( <i> ) . . . .  user version of p-Q menu option 4
#F  PqDisplayPcPresentation()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary  to  display  the  pc   presentation   previously   computed   (by
##  `PqPcPresentation'; see~"PqPcPresentation") or  restored  from  file  (by
##  `PqRestorePcPresentation'; see~"PqRestorePcPresentation") for  the  group
##  of that process, where the group of a process is the one given  as  first
##  argument when `PqStart' was called to initiate that process. To  set  the
##  amount of  information  this  command  displays  you  may  wish  to  call
##  `PqSetPrintLevel' first (see~"PqSetPrintLevel").
##
##  *Note:* 
##  For  those  familiar  with  the  `pq'  binary,  `PqDisplayPcPresentation'
##  performs option 4 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PqDisplayPcPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_DISPLAY_PRESENTATION( datarec, "pQ" );
end );

#############################################################################
##
#F  PQ_SET_PRINT_LEVEL(<datarec>, <menu>, <lev>) . . p-Q/SP/A p-Q menu opt. 5
##
##  inputs data to the `pq' binary to set the print level  to  <lev>  in  the
##  <menu> menu, where <menu> is either `"pQ"' (main  $p$-Quotient  menu)  or
##  `"SP' (Standard Presentation  menu)  or  `"ApQ"'  (Advanced  $p$-Quotient
##  menu), by performing option 5 of <menu> menu.
##
InstallGlobalFunction( PQ_SET_PRINT_LEVEL, function( datarec, menu, lev )
  if not IsBound( datarec.(menu) ) then
    datarec.(menu) := rec();
  fi;
  if not IsBound( datarec.(menu).OutputLevel ) or 
     datarec.(menu).OutputLevel <> lev then
    PQ_MENU(datarec, menu);
    ToPQ(datarec, [ "5  #set print level" ]);
    ToPQ(datarec, [ lev, "  #print level" ]);
    datarec.(menu).OutputLevel := lev;
  fi;
end );

#############################################################################
##
#F  PQ_CHK_PRINT_ARGS( <args> ) . . . . . . check args for print level cmd ok
##
InstallGlobalFunction( PQ_CHK_PRINT_ARGS, function( args )
local lev;
  if IsEmpty(args) or 2 < Length(args) then
    Error( "1 or 2 arguments expected\n");
  fi;
  lev := args[Length(args)];
  if not(lev in [0..3]) then
    Error( "argument <lev> should be an integer in [0 .. 3]\n" );
  fi;
  args := args{[1..Length(args) - 1]};
  ANUPQ_IOINDEX_ARG_CHK(args);
  return ANUPQData.io[ ANUPQ_IOINDEX(args) ];
end );

#############################################################################
##
#F  PqSetPrintLevel( <i>, <lev> ) . . . . . user version of p-Q menu option 5
#F  PqSetPrintLevel( <lev> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to set the print level to <lev>, in the main $p$-Quotient menu.
##
##  *Note:* For  those  familiar  with  the  `pq'  binary,  `PqSetPrintLevel'
##  performs option 5 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PqSetPrintLevel, function( arg )
local datarec;
  datarec := PQ_CHK_PRINT_ARGS( arg );
  PQ_SET_PRINT_LEVEL( datarec, "pQ", arg[Length(arg)] );
end );

#############################################################################
##
#F  PQ_NEXT_CLASS( <datarec> ) . . . . . . . . . . . . . .  p-Q menu option 6
##
##  directs the `pq' binary to calculate the next class of `<datarec>.group',
##  using option 6 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PQ_NEXT_CLASS, function( datarec )
  PQ_MENU(datarec, "pQ");
  ToPQ(datarec, [ "6  #calculate next class" ]);
end );

#############################################################################
##
#F  PqNextClass( <i> ) . . . . . . . . . .  user version of p-Q menu option 6
#F  PqNextClass()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  to calculate the next class of `<datarec>.group'.
##
##  *Note:* For those familiar with the `pq' binary,  `PqNextClass'  performs
##  option 6 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PqNextClass, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_NEXT_CLASS( datarec );
end );

#############################################################################
##
#F  PQ_P_COVER( <datarec> ) . . . . . . . . . . . . . . . . p-Q menu option 7
##
##  directs  the  `pq'  binary  to  compute   the   $p$-covering   group   of
##  `<datarec>.group', using option 7 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PQ_P_COVER, function( datarec )
local savefile;
  PQ_MENU(datarec, "pQ");
  ToPQ(datarec, [ "7  #compute p-cover" ]);
end );

#############################################################################
##
#F  PqPCover( <i> ) . . . . . . . . . . . . user version of p-Q menu option 7
#F  PqPCover()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  to compute the $p$-covering group of `<datarec>.group'.
##
##  *Note:* For those familiar with  the  `pq'  binary,  `PqPCover'  performs
##  option 7 of the main $p$-Quotient menu.
##
InstallGlobalFunction( PqPCover, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_P_COVER( datarec );
end );

#############################################################################
##
#F  PQ_COLLECT( <datarec>, <word> ) . . . . . . . . . . . A p-Q menu option 1
##
##  instructs the  `pq'  binary  to  do  a  collection  on  <word>  a  string
##  representing the product of three generators, e.g. `"x3*x2*x1"' (option 1
##  of the interactive $p$-Quotient menu).
##
InstallGlobalFunction( PQ_COLLECT, function( datarec, word )

  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQk(datarec, [ "1  #do individual collection" ]);
  FLUSH_PQ_STREAM_UNTIL(
      datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
      line -> 0 < Length(line) and line[Length(line)] = '\n');
  ToPQ(datarec, [ word, ";  #word to be collected" ]);
end );

#############################################################################
##
#F  PQ_CHK_COLLECT_COMMAND_ARGS( <args> ) . . check args for a collect cmd ok
##
##  returns a list of valid arguments for  a  low-level  collect  command  or
##  generates an error.
##
InstallGlobalFunction( PQ_CHK_COLLECT_COMMAND_ARGS, function( args )
local datarec, word;
  if IsEmpty(args) or 2 < Length(args) then
    Error( "1 or 2 arguments expected\n");
  fi;
  word := args[Length(args)];
  if not IsString(word) then
    Error( "argument <word> should be a string e.g. \"x3*x2*x1\"\n" );
  fi;
  args := args{[1..Length(args) - 1]};
  ANUPQ_IOINDEX_ARG_CHK(args);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(args) ];
  return [datarec, word];
end );

#############################################################################
##
#F  PqCollect( <i>, <word> ) . . . . . .  user version of A p-Q menu option 1
#F  PqCollect( <word> )
##
##  for the <i>th or default interactive {\ANUPQ} process, instructs the `pq'
##  binary to do a collection on <word> a string representing the product  of
##  three generators, e.g. `"x3*x2*x1"'.
##
##  *Note:* For those familiar with the  `pq'  binary,  `PqCollect'  performs
##  option 1 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqCollect, function( arg )
  CallFuncList( PQ_COLLECT, PQ_CHK_COLLECT_COMMAND_ARGS(arg) );
end );

#############################################################################
##
#F  PQ_SOLVE_EQUATION( <datarec>, <a>, <b> ) . . . . . .  A p-Q menu option 2
##
##  inputs data to the `pq' binary for option 2 of the Advanced  $p$-Quotient
##  menu, to solve $<a> * <x> = <b>$ for <x>.
##
InstallGlobalFunction( PQ_SOLVE_EQUATION, function( datarec, a, b )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQk(datarec, [ "2  #solve equation" ]);
  FLUSH_PQ_STREAM_UNTIL(
      datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
      line -> 0 < Length(line) and line[Length(line)] = '\n');
  ToPQk(datarec, [ a, ";  #word a" ]);
  FLUSH_PQ_STREAM_UNTIL(
      datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
      line -> 0 < Length(line) and line[Length(line)] = '\n');
  ToPQ(datarec, [ b, ";  #word b" ]);
end );

#############################################################################
##
#F  PqSolveEquation( <i>, <a>, <b> ) . .  user version of A p-Q menu option 2
#F  PqSolveEquation( <a>, <b> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to solve $<a> * <x> = <b>$ for <x>.
##
##  *Note:* 
##  For those familiar  with  the  `pq'  binary,  `PqSolveEquation'  performs
##  option 2 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqSolveEquation, function( arg )
local len, datarec;
  len := Length(arg);
  if not(len in [2,3]) then
    Error("expected 2 or 3 arguments\n");
  fi;
  #@need to add argument checking for a and b@
  ANUPQ_IOINDEX_ARG_CHK(arg{[1..len -2]});
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg{[1..len -2]}) ];
  PQ_SOLVE_EQUATION( datarec, arg[len - 1], arg[len] );
end );

#############################################################################
##
#F  PQ_COMMUTATOR( <datarec>, <words>, <pow>, <item> ) . A p-Q menu opts 3/24
##
##  inputs data to the `pq' binary  for  option  3  or  24  of  the  Advanced
##  $p$-Quotient menu, to compute  the  left  norm  commutator  of  the  list
##  <words> of words in the generators raised to  the  integer  power  <pow>,
##  where <item> is `"3 #commutator"' for option 3  or  `"24  #commutator  of
##  defining genrs"' for option 24.
##
InstallGlobalFunction( PQ_COMMUTATOR, function( datarec, words, pow, item )
local i;
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ item ]);
  # @add argument checking@
  ToPQk(datarec, [ Length(words), "  #no. of components" ]);
  for i in [1..Length(words)] do
    FLUSH_PQ_STREAM_UNTIL(
        datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
        line -> 1 < Length(line) and 
                line{[Length(line) - 1..Length(line)]} = ":\n");
    ToPQk(datarec, [ words[i], ";  #word ", i ]);
  od;
  FLUSH_PQ_STREAM_UNTIL(datarec.stream, 2, 2, PQ_READ_NEXT_LINE, IS_PQ_PROMPT);
  ToPQ(datarec, [ pow, "  #power" ]);
end );

#############################################################################
##
#F  PQ_COMMUTATOR_CHK_ARGS( <args> ) . . . . check args for commutator cmd ok
##
##  returns a list of valid arguments for a low-level commutator  command  or
##  generates an error.
##
InstallGlobalFunction( PQ_COMMUTATOR_CHK_ARGS, function( args )
local len, words, pow, datarec;
  len := Length(args);
  if not(len in [2, 3]) then
    Error("expected 2 or 3 arguments\n");
  fi;
  words := args[len - 1];
  pow   := args[len];
  if not(IsList(words) and ForAll(words, IsString)) then
    #@need to add more checking for words@
    Error( "argument <words> must be a list of strings,\n",
           "where each string represents a word in the generators\n" );
  fi;
  if not IsPosInt(pow) then
    Error( "argument <pow> must be a positive integer\n" );
  fi;
  args := args{[1 .. len - 2]};
  ANUPQ_IOINDEX_ARG_CHK(args);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(args) ];
  return [datarec, words, pow];
end );

#############################################################################
##
#F  PqCommutator( <i>, <words>, <pow> ) . user version of A p-Q menu option 3
#F  PqCommutator( <words>, <pow> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to compute the left norm commutator of the list <words>  of  words
##  in the generators raised to the integer power <pow>.
##
##  *Note:*
##  For those familiar with the `pq' binary, `PqCommutator' performs option 3
##  of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqCommutator, function( arg )
  CallFuncList( PQ_COMMUTATOR, Concatenation( PQ_COMMUTATOR_CHK_ARGS(arg), 
                                              [ "3  #commutator" ] ) );
end );

#############################################################################
##
#F  PqAPQDisplayPresentation( <i> ) . . . user version of A p-Q menu option 4
#F  PqAPQDisplayPresentation()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to display the presentation of the $p$-quotient. To set the amount
##  of  information  this   command   displays   you   may   wish   to   call
##  `PqAPQSetPrintLevel' first (see~"PqAPQSetPrintLevel").
##
##  *Note:* 
##  For those  familiar  with  the  `pq'  binary,  `PqAPQDisplayPresentation'
##  performs option 4 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqAPQDisplayPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_DISPLAY_PRESENTATION( datarec, "ApQ" );
end );

#############################################################################
##
#F  PqAPQSetPrintLevel( <i>, <lev> ) . . .  user version of p-Q menu option 5
#F  PqAPQSetPrintLevel( <lev> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to set the print level to  <lev>,  in  the  Advanced  $p$-Quotient
##  menu.
##
##  *Note:* For those familiar with  the  `pq'  binary,  `PqAPQSetPrintLevel'
##  performs option 5 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqAPQSetPrintLevel, function( arg )
local datarec;
  datarec := PQ_CHK_PRINT_ARGS( arg );
  PQ_SET_PRINT_LEVEL( datarec, "ApQ", arg[Length(arg)] );
end );

#############################################################################
##
#F  PQ_SETUP_TABLES_FOR_NEXT_CLASS( <datarec> ) . . . . . A p-Q menu option 6
##
##  inputs data to the `pq' binary for option 6 of the Advanced  $p$-Quotient
##  menu to set up tables for next class.
##
InstallGlobalFunction( PQ_SETUP_TABLES_FOR_NEXT_CLASS, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "6  #set up tables for next class" ]);
  #@datarec.class should be incremented here@
end );

#############################################################################
##
#F  PqSetupTablesForNextClass( <i> ) . .  user version of A p-Q menu option 6
#F  PqSetupTablesForNextClass()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to set up tables for the next class.
##
##  *Note:* 
##  For those  familiar  with  the  `pq'  binary, 
##  `PqSetupTablesForNextClass' performs option 6 of the
##  Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqSetupTablesForNextClass, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_SETUP_TABLES_FOR_NEXT_CLASS( datarec );
end );

#############################################################################
##
#F  PQ_INSERT_TAILS( <datarec>, <weight>, <which> )  . .  A p-Q menu option 7
##
##  inputs data to the `pq' binary for option 7 of the Advanced  $p$-Quotient
##  menu, to add and/or compute tails.
##
InstallGlobalFunction( PQ_INSERT_TAILS, function( datarec, weight, which )
local intwhich;
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  intwhich := Position( [ "compute and add", "add", "compute" ], which ) - 1;
  ToPQ(datarec, [ "7  #", which, " tails" ]);
  ToPQ(datarec, [ weight,   "  #weight of tails" ]);
  ToPQ(datarec, [ intwhich, "  #", which ]);
end );

#############################################################################
##
#F  PQ_CHK_TAILS_ARGS( <args> ) . . . . .  check args for insert tails cmd ok
##
InstallGlobalFunction( PQ_CHK_TAILS_ARGS, function( args )
local weight;
  if IsEmpty(args) or 2 < Length(args) then
    Error( "1 or 2 arguments expected\n");
  fi;
  weight := args[Length(args)];
  args := args{[1..Length(args) - 1]};
  ANUPQ_IOINDEX_ARG_CHK(args);
  if not IsInt(weight) or weight < 0 then
    #@check weight in [0..class]@
    Error( "argument <weight> should be a non-negative integer\n" );
  fi;
  return ANUPQData.io[ ANUPQ_IOINDEX(args) ];
end );

#############################################################################
##
#F  PqAddTails( <i>, <weight> ) . . . .  adds tails using A p-Q menu option 7
#F  PqAddTails( <weight> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to add tails of weight <weight>, where <weight> is a  non-negative
##  integer (a <weight> of `0' means all weights).
##
##  *Note:*
##  For those familiar with the `pq' binary, `PqAddTails' uses  option  7  of
##  the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqAddTails, function( arg )
  PQ_INSERT_TAILS( PQ_CHK_TAILS_ARGS(arg), arg[Length(arg)], "add" );
end );

#############################################################################
##
#F  PqComputeTails( <i>, <weight> ) . . computes tails using A p-Q menu opt 7
#F  PqComputeTails( <weight> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary  to  compute  tails  of  weight  <weight>,  where  <weight>  is  a
##  non-negative integer (a <weight> of `0' means all weights).
##
##  *Note:*
##  For those familiar with the `pq' binary, `PqComputeTails' uses  option  7
##  of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqComputeTails, function( arg )
  PQ_INSERT_TAILS( PQ_CHK_TAILS_ARGS(arg), arg[Length(arg)], "compute" );
end );

#############################################################################
##
#F  PqTails( <i>, <weight> ) . computes and adds tails using A p-Q menu opt 7
#F  PqTails( <weight> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to compute and add tails of weight <weight>, where <weight>  is  a
##  non-negative integer (a <weight> of `0' means all weights).
##
##  *Note:*
##  For those familiar with the `pq' binary, `PqTails' uses option 7  of  the
##  Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqTails, function( arg )
  PQ_INSERT_TAILS(PQ_CHK_TAILS_ARGS(arg), arg[Length(arg)], "compute and add");
end );

#############################################################################
##
#F  PQ_DO_CONSISTENCY_CHECKS( <datarec>, <weight>, <type> ) . A p-Q menu opt 8
##
##  inputs data to the `pq' binary for option 8 of the Advanced  $p$-Quotient
##  menu, to do consistency checks.
##
InstallGlobalFunction( PQ_DO_CONSISTENCY_CHECKS, 
function( datarec, weight, type )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "8  #check consistency" ]);
  ToPQ(datarec, [ weight, "  #weight of tails to add/compute" ]);
  ToPQ(datarec, [ type, "  #type" ]);
end );

#############################################################################
##
#F  PqDoConsistencyChecks(<i>,<weight>,<type>) . user ver of A p-Q menu opt 8
#F  PqDoConsistencyChecks( <weight>, <type> )
##
##  for the <i>th or default interactive  {\ANUPQ}  process,  do  consistency
##  checks of type <type> for weight <weight>; <type> should be an integer in
##  `[0,1,2,3]' (`0' means do  *all*  checks),  and  <weight>  should  be  an
##  integer in `[0 .. <class>]' where <class> is the maximum class (`0' means
##  all weights).
##
##  *Note:*
##  For those familiar with the `pq' binary, `PqDoConsistencyChecks' performs
##  option 8 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqDoConsistencyChecks, function( arg )
local len, datarec, weight, type;
  len := Length(arg);
  if not(len in [2, 3]) then
    Error("expected 2 or 3 arguments\n");
  fi;
  weight := arg[len - 1];
  type   := arg[len];
  if not IsInt(weight) or weight < 0 then
    #@check weight in [0..class]@
    Error( "argument <weight> should be a non-negative integer\n" );
  fi;
  if not(type in [0..3]) then
    Error( "argument <type> should be in [0,1,2,3]\n" );
  fi;
  arg := arg{[1 .. len - 2]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_DO_CONSISTENCY_CHECKS( datarec, weight, type );
end );

#############################################################################
##
#F  PQ_COLLECT_DEFINING_RELATIONS( <datarec> ) . . . . .  A p-Q menu option 9
##
##  inputs data to the `pq' binary for option 9 of the Advanced  $p$-Quotient
##  menu, to collect defining relations.
##
InstallGlobalFunction( PQ_COLLECT_DEFINING_RELATIONS, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "9  #collect defining relations" ]);
end );

#############################################################################
##
#F  PqCollectDefiningRelations( <i> ) . . user version of A p-Q menu option 9
#F  PqCollectDefiningRelations()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to collect defining relations.
##
##  *Note:*
##  For those familiar with  the  `pq'  binary,  `PqCollectDefiningRelations'
##  performs option 9 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqCollectDefiningRelations, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_COLLECT_DEFINING_RELATIONS( datarec );
end );

#############################################################################
##
#F  PQ_DO_EXPONENT_CHECKS( <datarec>, <w1>, <w2> ) . . . A p-Q menu option 10
##
##  inputs data to the `pq' binary for option 10 of the Advanced $p$-Quotient
##  menu, to do exponent checks.
##
InstallGlobalFunction( PQ_DO_EXPONENT_CHECKS, function( datarec, w1, w2 )
  #@does default only at the moment@
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "10  #do exponent checks" ]);
  ToPQ(datarec, [ VALUE_PQ_OPTION("Exponent", 0, datarec),
                      "  #exponent law" ]);
  ToPQ(datarec, [ w1, "  #start weight"     ]);
  ToPQ(datarec, [ w2, "  #end weight"       ]);
  ToPQ(datarec, [ 1,  "  #do default check" ]);
end );

#############################################################################
##
#F  PqDoExponentChecks( <i>, <w1>, <w2> ) . .  user version A p-Q menu opt 10
#F  PqDoExponentChecks( <w1>, <w2> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to do exponent checks between weights <w1> and <w2>, where $0  \le
##  <w1> \< <w2> \le <class>$ and <class> is the maximum class.
##
##  *Note:* 
##  For those familiar with the `pq'  binary,  `PqDoExponentChecks'  performs
##  option 10 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqDoExponentChecks, function( arg )
local len, w1, w2, datarec;
  len := Length(arg);
  if not(len in [2, 3]) then
    Error( "expected 2 or 3 arguments\n" );
  fi;
  w1 := arg[len - 1];
  w2 := arg[len];
  if not( IsInt(w1) and IsInt(w2) and 0 <= w1 and w1 < w2 ) then
    Error( "weights should satisfy 0 <= <w1> < <w2>\n" );
  fi;
  arg := arg{[1 .. len - 2]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_DO_EXPONENT_CHECKS( datarec, w1, w2 );
end );

#############################################################################
##
#F  PQ_ELIMINATE_REDUNDANT_GENERATORS( <datarec> ) . . . A p-Q menu option 11
##
##  inputs data to the `pq' binary for option 11 of the Advanced $p$-Quotient
##  menu, to eliminate redundant generators.
##
InstallGlobalFunction( PQ_ELIMINATE_REDUNDANT_GENERATORS, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "11  #eliminate redundant generators" ]);
end );

#############################################################################
##
#F  PqEliminateRedundantGenerators( <i> ) .  user ver of A p-Q menu option 11
#F  PqEliminateRedundantGenerators()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to eliminate redundant generators.
##
##  *Note:* 
##  For those familiar with the `pq' binary, `PqEliminateRedundantGenerators'
##  performs option 11 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqEliminateRedundantGenerators, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_ELIMINATE_REDUNDANT_GENERATORS( datarec );
end );

#############################################################################
##
#F  PQ_REVERT_TO_PREVIOUS_CLASS( <datarec> ) . . . . . . A p-Q menu option 12
##
##  inputs data to the `pq' binary for option 12 of the Advanced $p$-Quotient
##  menu, to abandon the current class and revert to the previous class.
##
InstallGlobalFunction( PQ_REVERT_TO_PREVIOUS_CLASS, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "12  #revert to previous class" ]);
end );

#############################################################################
##
#F  PqRevertToPreviousClass( <i> ) . . . user version of A p-Q menu option 12
#F  PqRevertToPreviousClass()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to abandon the current class and revert to the previous class.
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,  `PqRevertToPreviousClass'
##  performs option 12 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqRevertToPreviousClass, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_REVERT_TO_PREVIOUS_CLASS( datarec );
end );

#############################################################################
##
#F  PQ_SET_MAXIMAL_OCCURRENCES( <datarec>, <weights> ) . . A p-Q menu opt. 13
##
##  inputs data to the `pq' binary for option 13 of the
##  Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PQ_SET_MAXIMAL_OCCURRENCES, function( datarec, weights )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "13  #set maximal occurrences" ]);
  ToPQ(datarec, [ JoinStringsWithSeparator( List(weights, String), " " ),
                    "  #weights"]);
end );

#############################################################################
##
#F  PQ_PQUOTIENT_CHK( <datarec> ) . . . .  check p-quotient has been computed
##
##  returns the number of generators of `<datarec>.pQuotient' if it has  been
##  computed or otherwise generates an error.
##
InstallGlobalFunction( PQ_PQUOTIENT_CHK, function( datarec )
  if not IsBound( datarec.pQuotient ) then
    Error( "huh! p-Quotient hasn't been generated\n" );
  fi;
  return Length( GeneratorsOfGroup( datarec.pQuotient ) );
end );

#############################################################################
##
#F  PqSetMaximalOccurrences( <i>, <weights> ) . user ver of A p-Q menu opt 13
#F  PqSetMaximalOccurrences( <weights> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to set maximal occurrences; <weights> must be a list of  equal  in
##  number to the number of generators of weight 1 of the $p$-quotient  which
##  must have been previously computed.
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,  `PqSetMaximalOccurrences'
##  performs option 13 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqSetMaximalOccurrences, function( arg )
local len, ngens, weights, datarec;
  len := Length(arg);
  if not(len in [1, 2]) then
    Error( "expected 1 or 2 arguments\n");
  fi;
  weights := arg[len];
  arg := arg{[1 .. len - 1]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  ngens := PQ_PQUOTIENT_CHK( datarec );
  if ngens <> Length(weights) then
    Error( "no. of weights must be equal to the no. of generators of ",
           "weight 1 (", ngens, ")\n" );
  fi;
  PQ_SET_MAXIMAL_OCCURRENCES( datarec, weights );
end );

#############################################################################
##
#F  PQ_SET_METABELIAN( <datarec> ) . . . . . . . . . . . A p-Q menu option 14
##
##  inputs data to the `pq' binary for option 14 of the Advanced $p$-Quotient
##  menu, to set the metabelian flag.
##
InstallGlobalFunction( PQ_SET_METABELIAN, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "14  #set metabelian" ]);
end );

#############################################################################
##
#F  PqSetMetabelian( <i> ) . . . . . . . user version of A p-Q menu option 14
#F  PqSetMetabelian()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to enforce metabelian-ness.
##
##  *Note:* 
##  For those familiar  with  the  `pq'  binary,  `PqSetMetabelian'  performs
##  option 14 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqSetMetabelian, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_SET_METABELIAN( datarec );
end );

#############################################################################
##
#F  PQ_DO_CONSISTENCY_CHECK( <datarec>, <c>, <b>, <a> ) . A p-Q menu option 15
##
##  inputs data to the `pq' binary for option 15 of the Advanced $p$-Quotient
##  menu, to do a consistency check.
##
InstallGlobalFunction( PQ_DO_CONSISTENCY_CHECK, function( datarec, c, b, a )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "15  #do individual consistency check" ]);
  ToPQ(datarec, [ c, " ", b, " ", a, "  #generator indices"]);
end );

#############################################################################
##
#F  PqDoConsistencyCheck(<i>, <c>, <b>, <a>) .  user ver of A p-Q menu opt 15
#F  PqDoConsistencyCheck( <c>, <b>, <a> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to do a consistency check; the generator  indices  <c>,  <b>,  <a>
##  should be non-increasing positive integers, i.e.~$<c> \ge <b> \ge <a>$.
##
##  *Note:* 
##  For those familiar with the `pq' binary, `PqDoConsistencyCheck'  performs
##  option 15 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqDoConsistencyCheck, function( arg )
local len, c, b, a, datarec;
  len := Length(arg);
  if not(len in [3, 4]) then
    Error( "expected 3 or 4 arguments\n" );
  fi;
  c := arg[len - 2];
  b := arg[len - 1];
  a := arg[len];
  if not ForAll([c, b, a], IsPosInt) or c < b or b < a then
    Error( "generator indices must be non-increasing positive integers\n" );
  fi;
  #@more checking required here@
  arg := arg{[1 .. len - 3]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_DO_CONSISTENCY_CHECK( datarec, a, b, c );
end );

#############################################################################
##
#F  PQ_COMPACT( <datarec> ) . . . . . . . . . . . . . .  A p-Q menu option 16
##
##  inputs data to the `pq' binary for option 16 of the Advanced $p$-Quotient
##  menu, to do a compaction.
##
InstallGlobalFunction( PQ_COMPACT, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "16  #compact" ]);
end );

#############################################################################
##
#F  PqCompact( <i> ) . . . . . . . . . . user version of A p-Q menu option 16
#F  PqCompact()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to do a compaction.
##
##  *Note:*
##  For those familiar with the `pq' binary, `PqCompact' performs  option  16
##  of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqCompact, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_COMPACT( datarec );
end );

#############################################################################
##
#F  PQ_ECHELONISE( <datarec> ) . . . . . . . . . . . . . A p-Q menu option 17
##
##  inputs data to the `pq' binary for option 17 of the Advanced $p$-Quotient
##  menu, to echelonise.
##
InstallGlobalFunction( PQ_ECHELONISE, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  #@dependence@
  ToPQ(datarec, [ "17  #echelonise" ]);
end );

#############################################################################
##
#F  PqEchelonise( <i> ) . . . . . . . .  user version of A p-Q menu option 17
#F  PqEchelonise()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to echelonise relation. A call to `PqCollect' (see~"PqCollect") or
##  `PqCommutator' needs to be performed prior to using this command.
##
##  *Note:*
##  For those familiar with the `pq' binary, `PqEchelonise'  performs  option
##  17 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqEchelonise, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_ECHELONISE( datarec );
end );

#############################################################################
##
#F  PQ_SUPPLY_OR_EXTEND_AUTOMORPHISMS(<datarec>[,<mlist>])  A p-Q menu opt 18
##
##  inputs data to the `pq' binary for option 18 of the Advanced $p$-Quotient
##  menu.  If  a  list  <mlist>  of  matrices   with   non-negative   integer
##  coefficients  is  supplied  it  is  used  to  ``supply''   automorphisms;
##  otherwise, previously supplied automorphisms are ``extended''.
##
InstallGlobalFunction( PQ_SUPPLY_OR_EXTEND_AUTOMORPHISMS, function( arg )
local datarec;
  datarec := arg[1];
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  if 1 = Length(arg) then
    ToPQ(datarec, [ "18  #extend auts" ]);
  else
    ToPQ(datarec, [ "18  #supply auts" ]);
    CallFuncList(PQ_MANUAL_AUT_INPUT, arg);
  fi;
  datarec.hasAuts := true;
end );

#############################################################################
##
#F  PqSupplyAutomorphisms(<i>, <mlist>) . . supply auts via A p-Q menu opt 18
#F  PqSupplyAutomorphisms( <mlist> )
##
##  for the <i>th or  default  interactive  {\ANUPQ}  process,  supplies  the
##  automorphism  data  provided  by  the  list  <mlist>  of  matrices   with
##  non-negative integer coefficients. Each matrix in <mlist> must  have  the
##  same dimensions; in particular, the number of rows of each matrix must be
##  the rank of the $p$-quotient of the group associated with the interactive
##  {\ANUPQ} process.
##
##  *Note:*
##  For those familiar with the  `pq'  binary,  `PqSupplyAutomorphisms'  uses
##  option 18 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqSupplyAutomorphisms, function( arg )
local datarec, mlist;
  if IsEmpty(arg) or 2 < Length(arg) then
    Error("expected 1 or 2 arguments\n");
  fi;
  mlist := arg[ Length(arg) ];
  arg := arg{[1 .. Length(arg) - 1]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  if IsBound(datarec.hasAuts) and datarec.hasAuts then
    Error("huh! already have automorphisms.\n",
          "Perhaps you wanted to use `PqExtendAutomorphisms'\n");
  fi;
  PQ_AUT_ARG_CHK(datarec, mlist);
  PQ_SUPPLY_OR_EXTEND_AUTOMORPHISMS(datarec, mlist);
end );

#############################################################################
##
#F  PqExtendAutomorphisms( <i> ) . . . . .  extend auts via A p-Q menu opt 18
#F  PqExtendAutomorphisms()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data to the
##  `pq' binary to extend previously-supplied automorphisms.
##
##  *Note:*
##  For those familiar with the  `pq'  binary,  `PqExtendAutomorphisms'  uses
##  option 18 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqExtendAutomorphisms, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  if not(IsBound(datarec.hasAuts) and datarec.hasAuts) then
    Error("huh! don't have any automorphisms to extend.\n",
          "Perhaps you wanted to use `PqSupplyAutomorphisms'\n");
  fi;
  PQ_SUPPLY_OR_EXTEND_AUTOMORPHISMS( datarec );
end );

#############################################################################
##
#F  PQ_CLOSE_RELATIONS( <datarec>, <qfac> ) . . . . . .  A p-Q menu option 19
##
##  inputs data to the `pq' binary for option 19 of the Advanced $p$-Quotient
##  menu, to apply automorphisms.
##
InstallGlobalFunction( PQ_CLOSE_RELATIONS, function( datarec, qfac )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "19  #close relations"  ]);
  ToPQ(datarec, [ qfac, "  #queue factor" ]);
end );

#############################################################################
##
#F  PqApplyAutomorphisms( <i>, <qfac> ) . .  user ver of A p-Q menu option 19
#F  PqApplyAutomorphisms( <qfac> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to apply automorphisms; <qfac> is the queue factor e.g. `15'.
##
##  *Note:* 
##  For those familiar with  the  `pq'  binary,  `PqCloseRelations'  performs
##  option 19 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqApplyAutomorphisms, function( arg )
local len, datarec, qfac;
  len := Length(arg);
  if not(len in [1, 2]) then
    Error("expected 1 or 2 arguments\n");
  fi;
  ANUPQ_IOINDEX_ARG_CHK(arg{[1 .. len - 1]});
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg{[1 .. len - 1]}) ];
  PQ_CLOSE_RELATIONS( datarec, arg[len] );
end );

#############################################################################
##
#F  PQ_PRINT_STRUCTURE( <datarec>, <m>, <n> ) . . . . .  A p-Q menu option 20
##
##  inputs data to the `pq' binary for option 20 of the Advanced $p$-Quotient
##  menu, to print the structure for the pcp generators numbered from <m>  to
##  <n>.
##
InstallGlobalFunction( PQ_PRINT_STRUCTURE, function( datarec, m, n )
local infolev;
  infolev := PQ_PRE_DISPLAY(datarec, "ApQ");
  ToPQ(datarec, [ "20  #print structure" ]);
  ToPQ(datarec, [ m, "  #no. of first generator" ]);
  ToPQ(datarec, [ n, "  #no. of last generator"  ]);
  SetInfoLevel(InfoANUPQ, infolev);
end );

#############################################################################
##
#F  PQ_CHK_DISPLAY_COMMAND_ARGS( <args> ) . . check args for a display cmd ok
##
##  returns a list of valid arguments for  a  low-level  display  command  or
##  generates an error.
##
InstallGlobalFunction( PQ_CHK_DISPLAY_COMMAND_ARGS, function( args )
local len, ngens, m, n, datarec;
  len := Length(args);
  if not(len in [2, 3]) then
    Error( "expected 2 or 3 arguments\n");
  fi;
  m := args[len - 1];
  n := args[len];
  args := args{[1 .. len - 2]};
  ANUPQ_IOINDEX_ARG_CHK(args);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(args) ];
  ngens := PQ_PQUOTIENT_CHK( datarec );
  if not ForAll([m, n], IsPosInt) or m > ngens or m > n then
    Error( "<m> and <n> must satisfy: 1 <= <m> <= <n> <= ",
           "no. of pcp generators\n" );
  fi;
  return [datarec, m, n];
end );

#############################################################################
##
#F  PqPrintStructure( <i>, <m>, <n> ) .  user version of A p-Q menu option 20
#F  PqPrintStructure( <m>, <n> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to print the structure for the pcp generators numbered from <m> to
##  <n>.
##
##  *Note:*
##  For those familiar with  the  `pq'  binary,  `PqPrintStructure'  performs
##  option 20 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqPrintStructure, function( arg )
  CallFuncList( PQ_PRINT_STRUCTURE, PQ_CHK_DISPLAY_COMMAND_ARGS(arg) );
end );

#############################################################################
##
#F  PQ_DISPLAY_AUTOMORPHISMS( <datarec>, <m>, <n> ) . .  A p-Q menu option 21
##
##  inputs data to the `pq' binary for option 21 of the Advanced $p$-Quotient
##  menu, to display automorphisms for the generators numbered  from  <m>  to
##  <n>.
##
InstallGlobalFunction( PQ_DISPLAY_AUTOMORPHISMS, function( datarec, m, n )
local infolev;
  infolev := PQ_PRE_DISPLAY(datarec, "ApQ");
  ToPQ(datarec, [ "21 #display automorphisms" ]);
  ToPQ(datarec, [ m, "  #no. of first generator" ]);
  ToPQ(datarec, [ n, "  #no. of last generator"  ]);
  SetInfoLevel(InfoANUPQ, infolev);
end );

#############################################################################
##
#F  PqDisplayAutomorphisms( <i>, <m>, <n> ) . . user ver of A p-Q menu opt 21
#F  PqDisplayAutomorphisms( <m>, <n> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to display automorphisms for the generators numbered from  <m>  to
##  <n>.
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,   `PqDisplayAutomorphisms'
##  performs option 21 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqDisplayAutomorphisms, function( arg )
  CallFuncList( PQ_DISPLAY_AUTOMORPHISMS, PQ_CHK_DISPLAY_COMMAND_ARGS(arg) );
end );

#############################################################################
##
#F  PQ_COLLECT_DEFINING_GENERATORS( <datarec>, <word> ) . . A p-Q menu opt 23
##
##  inputs data to the `pq' binary for option 23 of the Advanced $p$-Quotient
##  menu, to collect defining generators for <word> a string representing the
##  product of three generators, e.g. `"x3*x2*x1"'.
##
InstallGlobalFunction( PQ_COLLECT_DEFINING_GENERATORS, function( datarec, word )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQk(datarec, [ "23  #collect defining generators" ]);
  FLUSH_PQ_STREAM_UNTIL(
      datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
      line -> 0 < Length(line) and line[Length(line)] = '\n');
  ToPQ(datarec, [ word, ";  #word to be collected" ]);
end );

#############################################################################
##
#F  PqCollectDefiningGenerators(<i>, <word>) .  user ver of A p-Q menu opt 23
#F  PqCollectDefiningGenerators( <word> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to do a collection on <word> a string representing the product  of
##  three generators, e.g. `"x3*x2*x1"'.
##
##  *Note:*
##  For those familiar with the  `pq'  binary,  `PqCollectDefiningGenerators'
##  performs option 23 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqCollectDefiningGenerators, function( arg )
  CallFuncList( PQ_COLLECT_DEFINING_GENERATORS, 
                PQ_CHK_COLLECT_COMMAND_ARGS(arg) );
end );

#############################################################################
##
#F  PqCommutatorDefiningGenerators(<i>,<words>,<pow>) . user ver A p-Q opt 24
#F  PqCommutatorDefiningGenerators( <words>, <pow> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to compute the left norm commutator of the list <words>  of  words
##  in the generators raised to the integer power <pow>.
##
##  *Note:*
##  For those familiar with the `pq' binary, `PqCommutatorDefiningGenerators'
##  performs option 24 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqCommutatorDefiningGenerators, function( arg )
  CallFuncList( PQ_COMMUTATOR, 
                Concatenation( PQ_COMMUTATOR_CHK_ARGS(arg), 
                               [ "24 #commutator of defining genrs" ] ) );
end );

#############################################################################
##
#F  PQ_WRITE_PC_PRESENTATION( <datarec>, <filename> ) .  A p-Q menu option 25
##
##  tells the `pq' binary to write a pc presentation to the  file  with  name
##  <filename> for group `<datarec>.group'  (option  25  of  the  interactive
##  $p$-Quotient menu).
##
InstallGlobalFunction( PQ_WRITE_PC_PRESENTATION, function( datarec, filename )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "25 #set output file" ]);
  ToPQ(datarec, [ filename ]);
  ToPQ(datarec, [ "2  #output in GAP format" ]);
end );

#############################################################################
##
#F  PqWritePcPresentation( <i>, <filename> ) . user ver. of A p-Q menu opt 25
#F  PqWritePcPresentation( <filename> )
##
##  for the <i>th or default interactive {\ANUPQ}  process,  tells  the  `pq'
##  binary to write a pc presentation to the file with  name  <filename>  for
##  the group of that process for which a pc presentation has been previously
##  computed, where the group of a process is the one given as first argument
##  when `PqStart' was called to initiate that process (for process  <i>  the
##  group is stored as `ANUPQData.io[<i>].group'). If the first character  of
##  the string <filename> is not `/' <filename> is assumed to be the path  of
##  a writable file relative to the directory in which {\GAP} was started. If
##  a pc presentation has not been previously computed by  the  `pq'  binary,
##  then  `pq'  is  called  to  compute  it   first,   effectively   invoking
##  `PqPcPresentation' (see~"PqPcPresentation").
##
##  *Note:* For those familiar with the `pq' binary,  `PqPcWritePresentation'
##  performs option 25 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqWritePcPresentation, function( arg )
local filename, datarec;
  if 2 < Length(arg) or IsEmpty(arg) then
    Error("expected one or two arguments.\n");
  fi;
  filename := PQ_CHK_PATH( arg[Length(arg)], "w" );
  Unbind( arg[ Length(arg) ] );
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  if not IsBound(datarec.pcp) then
    Info(InfoANUPQ, 1, "pq had not previously computed a pc presentation");
    Info(InfoANUPQ, 1, "... remedying that now.");
    PQ_PC_PRESENTATION( datarec, "pQ" );
  fi;
  PQ_WRITE_PC_PRESENTATION( datarec, filename );
end );

#############################################################################
##
#F  PQ_WRITE_COMPACT_DESCRIPTION( <datarec> ) . . . . .  A p-Q menu option 26
##
##  tells the `pq' binary to write a compact description to a file.
##
InstallGlobalFunction( PQ_WRITE_COMPACT_DESCRIPTION, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "26 #write compact description to file" ]);
end );

#############################################################################
##
#F  PqWriteCompactDescription( <i> ) . . user version of A p-Q menu option 26
#F  PqWriteCompactDescription()
##
##  for the <i>th or default interactive {\ANUPQ}  process,  tells  the  `pq'
##  binary to write a compact description to a file.
##
##  *Note:* 
##  For those familiar  with  the  `pq'  binary,  `PqWriteCompactDescription'
##  performs option 26 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqWriteCompactDescription, function( arg )
  ANUPQ_IOINDEX_ARG_CHK(arg);
  PQ_WRITE_COMPACT_DESCRIPTION( ANUPQData.io[ ANUPQ_IOINDEX(arg) ] );
end );

#############################################################################
##
#F  PQ_EVALUATE_CERTAIN_FORMULAE( <datarec> ) . . . . .  A p-Q menu option 27
##
##  inputs data to the `pq' binary for option 27 of the Advanced $p$-Quotient
##  menu, to evaluate certain formulae.
##
InstallGlobalFunction( PQ_EVALUATE_CERTAIN_FORMULAE, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "27  #evaluate certain formulae" ]);
end );

#############################################################################
##
#F  PqEvaluateCertainFormulae( <i> ) . . user version of A p-Q menu option 27
#F  PqEvaluateCertainFormulae()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to evaluate certain formulae.
##
##  *Note:*
##  For those familiar  with  the  `pq'  binary,  `PqEvaluateCertainFormulae'
##  performs option 27 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqEvaluateCertainFormulae, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_EVALUATE_CERTAIN_FORMULAE( datarec );
end );

#############################################################################
##
#F  PQ_EVALUATE_ACTION( <datarec> ) . . . . . . . . . .  A p-Q menu option 28
##
##  inputs data to the `pq' binary for option 28 of the Advanced $p$-Quotient
##  menu, to evaluate the action.
##
InstallGlobalFunction( PQ_EVALUATE_ACTION, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "28  #evaluate action" ]);
end );

#############################################################################
##
#F  PqEvaluateAction( <i> ) . . . . . .  user version of A p-Q menu option 28
#F  PqEvaluateAction()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to evaluate the action.
##
##  *Note:*
##  For those familiar with  the  `pq'  binary,  `PqEvaluateAction'  performs
##  option 28 of the Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqEvaluateAction, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_EVALUATE_ACTION( datarec );
end );

#############################################################################
##
#F  PQ_EVALUATE_ENGEL_IDENTITY( <datarec> ) . . . . . .  A p-Q menu option 29
##
##  inputs data to the `pq' binary for option 29 of the
##  Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PQ_EVALUATE_ENGEL_IDENTITY, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "29  #evaluate Engel identity" ]);
end );

#############################################################################
##
#F  PqEvaluateEngelIdentity( <i> ) . . . user version of A p-Q menu option 29
#F  PqEvaluateEngelIdentity()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqEvaluateEngelIdentity' performs option 29 of the
##  Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqEvaluateEngelIdentity, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_EVALUATE_ENGEL_IDENTITY( datarec );
end );

#############################################################################
##
#F  PQ_PROCESS_RELATIONS_FILE( <datarec> ) . . . . . . . A p-Q menu option 30
##
##  inputs data to the `pq' binary for option 30 of the
##  Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PQ_PROCESS_RELATIONS_FILE, function( datarec )
  PQ_MENU(datarec, "ApQ"); #we need options from the Advanced p-Q Menu
  ToPQ(datarec, [ "30  #process relations file" ]);
end );

#############################################################################
##
#F  PqProcessRelationsFile( <i> ) . . .  user version of A p-Q menu option 30
#F  PqProcessRelationsFile()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqProcessRelationsFile' performs option 30 of the
##  Advanced $p$-Quotient menu.
##
InstallGlobalFunction( PqProcessRelationsFile, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PROCESS_RELATIONS_FILE( datarec );
end );

#############################################################################
##
#F  PqSPPcPresentation( <i> : <options> ) . .  user version of SP menu opt. 1
#F  PqSPPcPresentation( : <options> )
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data  given
##  by <options> for the group of  that  process  so  that  the  `pq'  binary
##  computes a pc presentation, where the group of a process is the one given
##  as first argument when `PqStart' was called to initiate that process (for
##  process <i> the group is stored as `ANUPQData.io[<i>].group').
##
##  The   possible   <options>   are   `Prime',   `ClassBound',   `Exponent',
##  `Metabelian' and `OutputLevel', which are as described for  the  function
##  `Pq' (see~"Pq"). The option `Prime' is required unless  already  provided
##  to `PqStart'. Also, option `ClassBound' *must* be supplied.
##
##  *Note:* For those familiar with  the  `pq'  binary,  `PqSPPcPresentation'
##  performs option 1 of the Standard Presentation menu.
##
InstallGlobalFunction( PqSPPcPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PC_PRESENTATION( datarec, "SP" );
end );

#############################################################################
##
#F  PQ_SP_STANDARD_PRESENTATION(<datarec>[,<mlist>] :<options>) SP menu opt 2
##
##  inputs data given by <options> to the `pq' binary to compute  a  standard
##  presentation for group `<datarec>.group'. If argument <mlist> is given it
##  is assumed to be the automorphism group data required.  Otherwise  it  is
##  assumed that `<datarec>.pQuotient' exists and that {\GAP} can compute its
##  automorphism group and the  necessary  automorphism  group  data  can  be
##  derived from `<datarec>.pQuotient'. This uses option 2  of  the  Standard
##  Presentation menu.
##
InstallGlobalFunction( PQ_SP_STANDARD_PRESENTATION, function( arg )
local datarec, savefile;
  datarec := arg[1];
  savefile := PQ_CHK_PATH( 
                  VALUE_PQ_OPTION( "StandardPresentationFile",
                                   Filename( ANUPQData.tmpdir, "SPres" ) ),
                  "w");
  PQ_MENU(datarec, "SP");
  ToPQ(datarec, [ "2  #compute standard presentation" ]);
  ToPQ(datarec, [ savefile, "  #file for saving pres'n" ]);
  ToPQ(datarec, [ VALUE_PQ_OPTION("ClassBound", 63), "  #class bound" ]);

  if 1 = Length(arg) then
    PQ_AUT_INPUT( datarec, datarec.pQuotient );
  else
    PQ_MANUAL_AUT_INPUT( datarec, arg[2] );
  fi;
  ToPQ(datarec, 
       [ PQ_BOOL( VALUE_PQ_OPTION("PcgsAutomorphisms", false, datarec) ), 
         "compute pcgs gen. seq. for auts." ]);
end );

#############################################################################
##
#F  PqSPStandardPresentation(<i>[,<mlist>]:<options>)  user ver SP menu opt 2
#F  PqSPStandardPresentation([<mlist>] : <options> )
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data  given
##  by <options> to compute a standard presentation for  the  group  of  that
##  process.  If  argument  <mlist>  is  given  it  is  assumed  to  be   the
##  automorphism group data required. Otherwise it is assumed that a call  to
##  either      `Pq'      (see~"Pq!interactive")      or      `PqEpimorphism'
##  (see~"PqEpimorphism!interactive") has generated a $p$-quotient  and  that
##  {\GAP} can compute  its  automorphism  group  from  which  the  necessary
##  automorphism group data can be derived. The group of the process  is  the
##  one given as first argument when `PqStart' was  called  to  initiate  the
##  process (for process <i> the group is stored as `ANUPQData.io[<i>].group'
##  and     the     $p$-quotient     if     existent     is     stored     as
##  `ANUPQData.io[<i>].pQuotient').  If  <mlist>   is   not   given   and   a
##  $p$-quotient of the group has not been  previously  computed  a  class  1
##  $p$-quotient is computed.
##
##  `PqSPStandardPresentation' accepts three options, all optional:
##  
##  \beginitems
##  
##  `StandardPresentationFile := <filename>'&
##  Specifies that the file to which the standard presentation is written has
##  name <filename>. If the first character of the string <filename>  is  not
##  `/', <filename> is assumed to be the path of a writable file relative  to
##  the directory in which {\GAP} was started. If this option is  omitted  it
##  is written to the file with the name generated by the command  `Filename(
##  ANUPQData.tmpdir, "SPres" );', i.e.~the file with name  `"SPres"' in  the
##  temporary directory in which the `pq' binary executes.
##  
##  `ClassBound := <n>' &
##  Specifies that the $p$-quotient computed has lower exponent-$p$ class  at
##  most <n>. If this option is omitted a default of 63 is used.
##  
##  `PcgsAutomorphisms' &
##  Specifies that a polycyclic  generating  sequence  for  the  automorphism
##  group of the group of the process (which must be *soluble*), be  computed
##  and passed to the `pq' binary.  This  increases  the  efficiency  of  the
##  computation;  it  also  prevents  the  `pq'  from  calling   {\GAP}   for
##  orbit-stabilizer calculations. See section "Computing  Descendants  of  a
##  p-Group" for further explanations.
##  
##  \enditems
##
##  *Note:* For those familiar with  the  `pq'  binary,  `PqSPPcPresentation'
##  performs option 2 of the Standard Presentation menu.
##
InstallGlobalFunction( PqSPStandardPresentation, function( arg )
local ioIndex, datarec, mlist;
  if 2 < Length(arg) then
    Error("expected at most 2 arguments\n");
  fi;
  if not IsEmpty(arg) and IsList(arg[ Length(arg) ]) then
    mlist := arg[ Length(arg) ];
    arg := arg{[1 .. Length(arg) - 1]};
  fi;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  if IsBound(mlist) then
    PQ_AUT_ARG_CHK( datarec, mlist );
    PQ_SP_STANDARD_PRESENTATION( datarec, mlist );
  else
    if not IsBound(datarec.pQuotient) then
      PQ_EPIMORPHISM(ioIndex);
    fi;
    PQ_SP_STANDARD_PRESENTATION( datarec );
  fi;
end );

#############################################################################
##
#F  PQ_SP_SAVE_PRESENTATION( <datarec>, <filename> ) . . . . SP menu option 3
##
##  directs the `pq' binary to  save  the  standard  presentation  previously
##  computed for `<datarec>.group'  to  <filename>  using  option  3  of  the
##  Standard Presentation menu.
##
InstallGlobalFunction( PQ_SP_SAVE_PRESENTATION, function( datarec, filename )
  PQ_MENU(datarec, "SP");
  ToPQ(datarec, [ "3  #save standard presentation to file" ]);
  ToPQ(datarec, [ filename, "  #filename" ]);
end );

#############################################################################
##
#F  PqSPSavePresentation( <i>, <filename> ) . .  user ver of SP menu option 3
#F  PqSPSavePresentation( <filename> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to save the standard  presentation  previously  computed  for  the
##  group of that process to the file with name <filename>, where  the  group
##  of a process is the one given as first argument when `PqStart' was called
##  to initiate that process. If the first character of the string <filename>
##  is not `/' <filename> is assumed to  be  the  path  of  a  writable  file
##  relative to the directory in which {\GAP} was started.
##
##  *Note:* For those familiar with the `pq'  binary,  `PqSPSavePresentation'
##  performs option 3 of the Standard Presentation menu.
##
InstallGlobalFunction( PqSPSavePresentation, function( arg )
local datarec, filename;
  if 0 = Length(arg) or Length(arg) > 2 then
    Error( "expected 1 or 2 arguments\n" );
  fi;
  filename := PQ_CHK_PATH( arg[Length(arg)], "w" );
  arg := arg{[1..Length(arg) - 1]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_SP_SAVE_PRESENTATION( datarec, filename );
end );

#############################################################################
##
#F  PqSPDisplayPresentation( <i> ) . . . . . user version of SP menu option 4
#F  PqSPDisplayPresentation()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data to the
##  `pq' binary for  the  <i>th  or  default  interactive  {\ANUPQ}  process,
##  directs the `pq' binary to  display  the  standard  presentation  of  the
##  $p$-quotient. To set the amount of information this command displays  you
##  may wish to call `PqSPSetPrintLevel' first (see~"PqSPSetPrintLevel").
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,  `PqSPDisplayPresentation'
##  performs option 4 of the Standard Presentation menu.
##
InstallGlobalFunction( PqSPDisplayPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_DISPLAY_PRESENTATION( datarec, "SP" );
end );

#############################################################################
##
#F  PqSPSetPrintLevel( <i>, <lev> ) . . . .  user version of SP menu option 5
#F  PqSPSetPrintLevel( <lev> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to set the print level to  <lev>,  in  the  Standard  Presentation
##  menu.
##
##  *Note:* For those familiar  with  the  `pq'  binary,  `PqSPSetPrintLevel'
##  performs option 5 of the Standard Presentation menu.
##
InstallGlobalFunction( PqSPSetPrintLevel, function( arg )
local datarec;
  datarec := PQ_CHK_PRINT_ARGS( arg );
  PQ_SET_PRINT_LEVEL( datarec, "SP", arg[Length(arg)] );
end );

#############################################################################
##
#F  PQ_SP_COMPARE_TWO_FILE_PRESENTATIONS(<datarec>,<f1>,<f2>) . SP menu opt 6
##
##  inputs data to the `pq' binary for option 6 of the Standard  Presentation
##  menu, to compare the presentations in the files with names <f1> and  <f2>
##  and returns `true' if they are identical and `false' otherwise.
##
InstallGlobalFunction( PQ_SP_COMPARE_TWO_FILE_PRESENTATIONS, 
function( datarec, f1, f2 )
local line;
  PQ_MENU(datarec, "SP");
  ToPQ( datarec, [ "6  #compare to file presentations" ]);
  ToPQ( datarec, [ f1, "  #1st filename" ]);
  ToPQk(datarec, [ f2, "  #2nd filename" ]);
  line := FLUSH_PQ_STREAM_UNTIL( datarec.stream, 2, 2, PQ_READ_NEXT_LINE,
                                 line -> IsMatchingSublist(line, "Identical") );
  FLUSH_PQ_STREAM_UNTIL(datarec.stream, 2, 2, PQ_READ_NEXT_LINE, IS_PQ_PROMPT);
  return EvalString( LowercaseString( SplitString(line, "", "? \n")[3] ) );
end );

#############################################################################
##
#F  PqSPCompareTwoFilePresentations(<i>,<f1>,<f2>)  user ver of SP menu opt 6
#F  PqSPCompareTwoFilePresentations(<f1>,<f2>)
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to compare the presentations in the files with names <f1> and <f2>
##  and returns `true' if they are identical and `false' otherwise. For  each
##  of the strings <f1> and <f2>, if the first character is not a `/' then it
##  is assumed to be the path of a readable file relative to the directory in
##  which {\GAP} was started.
##
##  *Notes*
##
##  The presentations in files <f1> and <f2> must have been generated by  the
##  `pq' binary but they do *not* need to be *standard* presentations.
##
##   For      those      familiar      with      the       `pq'       binary,
##   `PqSPCompareTwoFilePresentations' performs  option  6  of  the  Standard
##   Presentation menu.
##
InstallGlobalFunction( PqSPCompareTwoFilePresentations, function( arg )
local len, datarec, f1, f2;
  len := Length(arg);
  if not(len in [2, 3]) then
    Error( "expected 2 or 3 arguments\n" );
  fi;
  f1 := PQ_CHK_PATH( arg[len - 1], "r" );
  f2 := PQ_CHK_PATH( arg[len], "r" );
  arg := arg{[1..len - 2]};
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  return PQ_SP_COMPARE_TWO_FILE_PRESENTATIONS( datarec, f1, f2 );
end );

#############################################################################
##
#F  PQ_SP_ISOMORPHISM( <datarec> ) . . . . . . . . . . . . . SP menu option 8
##
##  computes the mapping  from  the  automorphism  group  generators  to  the
##  generators of the standard presentation,  using  option  8  of  the  main
##  Standard Presentation menu.
##
InstallGlobalFunction( PQ_SP_ISOMORPHISM, function( datarec )
  PQ_MENU(datarec, "SP");
  ToPQ(datarec, [ "8  #compute isomorphism" ]);
end );

#############################################################################
##
#F  PqSPIsomorphism( <i> ) . . . . . . . . . user version of SP menu option 8
#F  PqSPIsomorphism()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to compute the isomorphism from the generators of the automorphism
##  group of `ANUPQData.io[<i>].pQuotient' to the generators for the standard
##  presentation.
##
##  *Note:* For  those  familiar  with  the  `pq'  binary,  `PqSPIsomorphism'
##  performs option 8 of the Standard Presentation menu.
##
InstallGlobalFunction( PqSPIsomorphism, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_SP_ISOMORPHISM( datarec );
end );

#############################################################################
##
#F  PQ_PG_SUPPLY_AUTS( <datarec>, <menu> ) . . . . .  p-G/A p-G menu option 1
##
##  defines the automorphism group of `<datarec>.group', using  option  1  of
##  the main or Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_PG_SUPPLY_AUTS, function( datarec, menu )
local gens;
  PQ_MENU(datarec, menu);
  ToPQk(datarec, [ "1  #supply automorphism data" ]);
  PQ_AUT_INPUT( datarec, datarec.group );
end );

#############################################################################
##
#F  PqPGSupplyAutomorphisms( <i> ) . . . . . user version of pG menu option 1
#F  PqPGSupplyAutomorphisms()
##
##  for the <i>th or default interactive {\ANUPQ} process, supplies the  `pq'
##  binary with the automorphism group  data  needed  for  `<datarec>.group'.
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,  `PqPGSupplyAutomorphisms'
##  performs option 1 of the main $p$-Group Generation menu.
##
InstallGlobalFunction( PqPGSupplyAutomorphisms, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PG_SUPPLY_AUTS( datarec, "pG" );
end );

#############################################################################
##
#F  PQ_PG_EXTEND_AUTOMORPHISMS( <datarec>, <menu> ) . p-G/A p-G menu option 2
##
##  inputs data to the `pq' binary for option  2  of  the  main  or  Advanced
##  $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_PG_EXTEND_AUTOMORPHISMS, function( datarec, menu )
  PQ_MENU(datarec, menu);
  ToPQ(datarec, [ "2  #extend automorphisms" ]);
end );

#############################################################################
##
#F  PqPGExtendAutomorphisms( <i> ) . . . .  user version of p-G menu option 2
#F  PqPGExtendAutomorphisms()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to compute the extensions of the automorphisms defined by  calling
##  `PqPGSupplyAutomorphisms' (see~"PqPGSupplyAutomorphisms"). You  may  wish
##  to set the `InfoLevel' of `InfoANUPQ' to 2 (or more) in order to see  the
##  output from the `pq' (see~"InfoANUPQ").
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,  `PqPGExtendAutomorphisms'
##  performs option 2 of the main $p$-Group Generation menu.
##
InstallGlobalFunction( PqPGExtendAutomorphisms, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PG_EXTEND_AUTOMORPHISMS( datarec, "pG" );
end );

#############################################################################
##
#F  PQ_PG_RESTORE_GROUP(<datarec>, <menu>, <cls>, <n>) . p-G/A p-G menu opt 3
##
##  inputs data to the `pq' binary to restore group <n> of  class  <cls>  for
##  option 3 of the main or Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_PG_RESTORE_GROUP, function( datarec, menu, cls, n )
  PQ_MENU(datarec, menu);
  ToPQ(datarec, [ "3  #restore group from file" ]);
  ToPQ(datarec, [ "G_class", cls, "  #filename" ]);
  ToPQ(datarec, [ n,              "  #no. of group" ]);
end );

#############################################################################
##
#F  PQ_PG_RESTORE_GROUP_ARG_CHK( <arg> ) .  check args for restore grp cmd ok
##
##  checks    the     arguments     for     `PqPGRestoreGroupFromFile'     or
##  `PqPGARestoreGroupFromFile' are ok and returns the appropriate <datarec>.
##
InstallGlobalFunction( PQ_PG_RESTORE_GROUP_ARG_CHK, function( args )
  if not(Length(args) in [2, 3]) or not(ForAll(args, IsPosInt)) then
    #@should also check <cls> and <n> arg are feasible@
    Error("expected 2 or 3 positive integer arguments\n");
  fi;
  ANUPQ_IOINDEX_ARG_CHK(args);
  return ANUPQData.io[ ANUPQ_IOINDEX(args) ];
end );

#############################################################################
##
#F  PqPGRestoreGroupFromFile( <i>, <cls>, <n> ) .  user ver of p-G menu opt 3
#F  PqPGRestoreGroupFromFile( <cls>, <n> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to restore group <n> of class <cls> from a temporary  file,  where
##  <cls> and <n> are positive integers.
##
##  *Note:*
##  For those  familiar  with  the  `pq'  binary,  `PqPGRestoreGroupFromFile'
##  performs option 3 of the main $p$-Group Generation menu.
##
InstallGlobalFunction( PqPGRestoreGroupFromFile, function( arg )
local len, datarec, cls, n;
  datarec := PQ_PG_RESTORE_GROUP_ARG_CHK(arg);
  len := Length(arg);
  PQ_PG_RESTORE_GROUP( datarec, "pG", arg[len - 1], arg[len] );
end );

#############################################################################
##
#F  PqPGDisplayPresentation( <i> ) . . . .  user version of p-G menu option 4
#F  PqPGDisplayPresentation()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data to the
##  `pq' binary for the <i>th or default interactive {\ANUPQ} process, inputs
##  data to the `pq' binary for the <i>th  or  default  interactive  {\ANUPQ}
##  process, directs the `pq' binary to display the presentation of  a  group
##  previously         selected         by         `PqPGRestoreGroupFromFile'
##  (see~"PqPGRestoreGroupFromFile").
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,  `PqPGDisplayPresentation'
##  performs option 4 of the main $p$-Group Generation menu.
##
InstallGlobalFunction( PqPGDisplayPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_DISPLAY_PRESENTATION( datarec, "pG" );
end );

#############################################################################
##
#F  PQ_PG_CONSTRUCT_DESCENDANTS( <datarec> : <options> ) .  p-G menu option 5
##
##  inputs  data  given  by  <options>  to  the  `pq'  binary  to   construct
##  descendants, using option 5 of the main $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_PG_CONSTRUCT_DESCENDANTS, function( datarec )
local firstStep, expectedNsteps;

  datarec.des := rec();
  # deal with the easy answer
  if VALUE_PQ_OPTION("OrderBound", 0, datarec.des) <> 0 and 
     datarec.des.OrderBound <= LogInt(Size(datarec.group), 
                                      PrimePGroup(datarec.group)) then
    return [];
  fi;

  # sanity checks
  if     VALUE_PQ_OPTION("SpaceEfficient", false, datarec.des) and 
     not VALUE_PQ_OPTION("PcgsAutomorphisms", false, datarec.des) then
    Error( "\"SpaceEfficient\" is only allowed in conjunction with ",
           "\"PcgsAutomorphisms\"\n");
  fi;
  if VALUE_PQ_OPTION("StepSize", datarec.des) <> fail then
    if datarec.des.OrderBound <> 0 then
      Error("\"StepSize\" and \"OrderBound\" must not be set simultaneously\n");
    fi;
    if IsList(datarec.des.StepSize) then
      firstStep := datarec.des.StepSize[1];
    else
      firstStep := datarec.des.StepSize;
    fi;
    if HasNuclearRank(datarec.group) and 
       firstStep > NuclearRank(datarec.group) then
      Error("the first \"StepSize\" element (= ", firstStep, ") must not be\n",
            "greater than the \"Nuclear Rank\" (= ",
            NuclearRank(datarec.group), ")\n");
    fi;
  fi;

  PQ_MENU(datarec, "pG");
  ToPQ(datarec, [ "5  #construct descendants" ]);
  ToPQ(datarec, [ VALUE_PQ_OPTION("ClassBound", 
                                  PClassPGroup(datarec.group) + 1, 
                                  datarec.des),
                   "  #class bound" ]);

  #Construct all descendants?
  if not IsBound(datarec.des.StepSize) then
    ToPQ(datarec, [ "1  #do construct all descendants" ]);
    #Set an order bound for descendants?
    if datarec.des.OrderBound <> 0 then
      ToPQ(datarec, [ "1  #do set an order bound" ]);
      ToPQ(datarec, [ datarec.des.OrderBound, "  #order bound" ]);
    else
      ToPQ(datarec, [ "0  #do not set an order bound" ]);
    fi;
  else
    ToPQ(datarec, [ "0  #do not construct all descendants" ]);
    #Constant step size?
    if IsInt(datarec.des.StepSize) then
      ToPQ(datarec, [ "1  #set constant step size" ]);
      ToPQ(datarec, [ datarec.des.StepSize, "  #step size" ]);
    else
      expectedNsteps := datarec.des.ClassBound - PClassPGroup(datarec.group);
      if Length(datarec.des.StepSize) <> expectedNsteps then
        Error( "the number of step-sizes in the \"StepSize\" list must\n",
               "equal ", expectedNsteps, " (the difference of \"ClassBound\"\n",
               "and the current class)\n" );
      fi;
      ToPQ(datarec, [ "0  #set variable step size" ]);
      ToPQ(datarec, [ JoinStringsWithSeparator(
                          List(datarec.des.StepSize, String), " "),
                       "  #step sizes" ]);
    fi;
  fi;
  ToPQ(datarec, [ PQ_BOOL(
                      VALUE_PQ_OPTION("PcgsAutomorphisms", false, datarec.des)
                      ),
                   "compute pcgs gen. seq. for auts." ]);
  ToPQ(datarec, [ "0  #do not use default algorithm" ]);
  ToPQ(datarec, [ VALUE_PQ_OPTION("RankInitialSegmentSubgroups", 0,
                                  datarec.des),
                   "  #rank of initial segment subgrp" ]);
  if datarec.des.PcgsAutomorphisms then
    ToPQ(datarec, [ PQ_BOOL(datarec.des.SpaceEfficient),
                   "be space efficient" ]);
  fi;
  ToPQ(datarec, [ PQ_BOOL(
                      VALUE_PQ_OPTION( "AllDescendants", false, datarec.des ) ),
                   "completely process terminal descendants" ]);
  ToPQ(datarec, [ VALUE_PQ_OPTION("Exponent", 0, datarec), "  #exponent" ]);
                                           # "Exponent" is a `global' option
  ToPQ(datarec, [ PQ_BOOL( VALUE_PQ_OPTION("Metabelian", false, datarec.des) ),
                   "enforce metabelian law" ]);
  ToPQ(datarec, [ "1  #default output" ]); # There are > 18 questions to deal
                                           # with by not taking the default
                                           # ... maybe in the future we will
                                           # give the user more control
end );

#############################################################################
##
#F  PqPGConstructDescendants( <i> : <options> ) . user ver. of p-G menu op. 5
#F  PqPGConstructDescendants( : <options> )
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data  given
##  by <options> to the `pq' binary to  construct  descendants.  The  options
##  possible are all those given  for  `PqDescendants'  (see~"PqDescendants")
##  except for `SubList' and `SetupFile'.
##
##  *Note:* 
##  For those  familiar  with  the  `pq'  binary,  `PqPGConstructDescendants'
##  performs option 5 of the main $p$-Group Generation menu.
##
InstallGlobalFunction( PqPGConstructDescendants, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PG_CONSTRUCT_DESCENDANTS( datarec );
end );

#############################################################################
##
#F  PqAPGSupplyAutomorphisms( <i> ) . . . user version of A p-G menu option 1
#F  PqAPGSupplyAutomorphisms()
##
##  for the <i>th or default interactive {\ANUPQ} process, supplies the  `pq'
##  binary    with    the    automorphism    group    data     needed     for
##  `ANUPQData.io[<i>].group'.
##
##  *Note:*
##  For those  familiar  with  the  `pq'  binary,  `PqAPGSupplyAutomorphisms'
##  performs option 1 of the Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGSupplyAutomorphisms, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PG_SUPPLY_AUTS( datarec, "ApG" );
end );

#############################################################################
##
#F  PqAPGExtendAutomorphisms( <i> ) . . . user version of A p-G menu option 2
#F  PqAPGExtendAutomorphisms()
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to compute the extensions of the automorphisms defined by  calling
##  `PqAPGSupplyAutomorphisms' (see~"PqAPGSupplyAutomorphisms"). You may wish
##  to set the `InfoLevel' of `InfoANUPQ' to 2 (or more) in order to see  the
##  output from the `pq' (see~"InfoANUPQ").
##
##  *Note:*
##  For  those  familiar  with  the  `pq'  binary,  `PqAPGExtendAutomorphisms'
##  performs option 2 of the Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGExtendAutomorphisms, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PG_EXTEND_AUTOMORPHISMS( datarec, "ApG" );
end );

#############################################################################
##
#F  PqAPGRestoreGroupFromFile(<i>, <cls>, <n>) . user ver of A p-G menu opt 3
#F  PqAPGRestoreGroupFromFile( <cls>, <n> )
##
##  for the <i>th or default interactive {\ANUPQ} process, directs  the  `pq'
##  binary to restore group <n> of class <cls> from a temporary  file,  where
##  <cls> and <n> are positive integers.
##
##  *Note:*
##  For those familiar  with  the  `pq'  binary,  `PqAPGRestoreGroupFromFile'
##  performs option 3 of the Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGRestoreGroupFromFile, function( arg )
local len, datarec, cls, n;
  datarec := PQ_PG_RESTORE_GROUP_ARG_CHK(arg);
  len := Length(arg);
  PQ_PG_RESTORE_GROUP( datarec, "ApG", arg[len - 1], arg[len] );
end );

#############################################################################
##
#F  PqAPGDisplayPresentation( <i> ) . . . user version of A p-G menu option 4
#F  PqAPGDisplayPresentation()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data to the
##  `pq' binary for the <i>th or default interactive {\ANUPQ} process, inputs
##  data to the `pq' binary for the <i>th  or  default  interactive  {\ANUPQ}
##  process, directs the `pq' binary to display the presentation of  a  group
##  previously        selected         by         `PqAPGRestoreGroupFromFile'
##  (see~"PqAPGRestoreGroupFromFile").
##
##  *Note:*
##  For those  familiar  with  the  `pq'  binary,  `PqAPGDisplayPresentation'
##  performs option 4 of the Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGDisplayPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_DISPLAY_PRESENTATION( datarec, "ApG" );
end );

#############################################################################
##
#F  PQ_APG_SINGLE_STAGE( <datarec> ) . . . . . . . . . .  A p-G menu option 5
##
##  inputs data to the `pq' binary for option 5 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_SINGLE_STAGE, function( datarec )
end );

#############################################################################
##
#F  PqAPGSingleStage( <i> ) . . . . . . . user version of A p-G menu option 5
#F  PqAPGSingleStage()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGSingleStage' performs option 5 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGSingleStage, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_SINGLE_STAGE( datarec );
end );

#############################################################################
##
#F  PQ_APG_DEGREE( <datarec> ) . . . . . . . . . . . . .  A p-G menu option 6
##
##  inputs data to the `pq' binary for option 6 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_DEGREE, function( datarec )
end );

#############################################################################
##
#F  PqAPGDegree( <i> ) . . . . . . . . .  user version of A p-G menu option 6
#F  PqAPGDegree()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGDegree' performs option 6 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGDegree, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_DEGREE( datarec );
end );

#############################################################################
##
#F  PQ_APG_PERMUTATIONS( <datarec> ) . . . . . . . . . .  A p-G menu option 7
##
##  inputs data to the `pq' binary for option 7 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_PERMUTATIONS, function( datarec )
end );

#############################################################################
##
#F  PqAPGPermutations( <i> ) . . . . . .  user version of A p-G menu option 7
#F  PqAPGPermutations()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGPermutations' performs option 7 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGPermutations, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_PERMUTATIONS( datarec );
end );

#############################################################################
##
#F  PQ_APG_ORBITS( <datarec> ) . . . . . . . . . . . . .  A p-G menu option 8
##
##  inputs data to the `pq' binary for option 8 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_ORBITS, function( datarec )
end );

#############################################################################
##
#F  PqAPGOrbits( <i> ) . . . . . . . . .  user version of A p-G menu option 8
#F  PqAPGOrbits()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGOrbits' performs option 8 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGOrbits, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_ORBITS( datarec );
end );

#############################################################################
##
#F  PQ_APG_ORBIT_REPRESENTATIVES( <datarec> ) . . . . . . A p-G menu option 9
##
##  inputs data to the `pq' binary for option 9 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_ORBIT_REPRESENTATIVES, function( datarec )
end );

#############################################################################
##
#F  PqAPGOrbitRepresentatives( <i> ) . .  user version of A p-G menu option 9
#F  PqAPGOrbitRepresentatives()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGOrbitRepresentatives' performs option 9 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGOrbitRepresentatives, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_ORBIT_REPRESENTATIVES( datarec );
end );

#############################################################################
##
#F  PQ_APG_ORBIT_REPRESENTATIVE( <datarec> ) . . . . . . A p-G menu option 10
##
##  inputs data to the `pq' binary for option 10 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_ORBIT_REPRESENTATIVE, function( datarec )
end );

#############################################################################
##
#F  PqAPGOrbitRepresentative( <i> ) . .  user version of A p-G menu option 10
#F  PqAPGOrbitRepresentative()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGOrbitRepresentative' performs option 10 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGOrbitRepresentative, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_ORBIT_REPRESENTATIVE( datarec );
end );

#############################################################################
##
#F  PQ_APG_STANDARD_MATRIX_LABEL( <datarec> ) . . . . .  A p-G menu option 11
##
##  inputs data to the `pq' binary for option 11 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_STANDARD_MATRIX_LABEL, function( datarec )
end );

#############################################################################
##
#F  PqAPGStandardMatrixLabel( <i> ) . .  user version of A p-G menu option 11
#F  PqAPGStandardMatrixLabel()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGStandardMatrixLabel' performs option 11 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGStandardMatrixLabel, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_STANDARD_MATRIX_LABEL( datarec );
end );

#############################################################################
##
#F  PQ_APG_MATRIX_OF_LABEL( <datarec> ) . . . . . . . .  A p-G menu option 12
##
##  inputs data to the `pq' binary for option 12 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_MATRIX_OF_LABEL, function( datarec )
end );

#############################################################################
##
#F  PqAPGMatrixOfLabel( <i> ) . . . . .  user version of A p-G menu option 12
#F  PqAPGMatrixOfLabel()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGMatrixOfLabel' performs option 12 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGMatrixOfLabel, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_MATRIX_OF_LABEL( datarec );
end );

#############################################################################
##
#F  PQ_APG_IMAGE_OF_ALLOWABLE_SUBGROUP( <datarec> ) . .  A p-G menu option 13
##
##  inputs data to the `pq' binary for option 13 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_IMAGE_OF_ALLOWABLE_SUBGROUP, function( datarec )
end );

#############################################################################
##
#F  PqAPGImageOfAllowableSubgroup( <i> ) user version of A p-G menu option 13
#F  PqAPGImageOfAllowableSubgroup()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGImageOfAllowableSubgroup' performs option 13 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGImageOfAllowableSubgroup, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_IMAGE_OF_ALLOWABLE_SUBGROUP( datarec );
end );

#############################################################################
##
#F  PQ_APG_RANK_CLOSURE_OF_INITIAL_SEGMENT( <datarec> )  A p-G menu option 14
##
##  inputs data to the `pq' binary for option 14 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_RANK_CLOSURE_OF_INITIAL_SEGMENT, function( datarec )
end );

#############################################################################
##
#F  PqAPGRankClosureOfInitialSegment( <i> )  user version of A p-G menu option 14
#F  PqAPGRankClosureOfInitialSegment()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGRankClosureOfInitialSegment' performs option 14 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGRankClosureOfInitialSegment, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_RANK_CLOSURE_OF_INITIAL_SEGMENT( datarec );
end );

#############################################################################
##
#F  PQ_APG_ORBIT_REPRESENTATIVE_OF_LABEL( <datarec> ) .  A p-G menu option 15
##
##  inputs data to the `pq' binary for option 15 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_ORBIT_REPRESENTATIVE_OF_LABEL, function( datarec )
end );

#############################################################################
##
#F  PqAPGOrbitRepresentativeOfLabel( <i> )  user version of A p-G menu option 15
#F  PqAPGOrbitRepresentativeOfLabel()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGOrbitRepresentativeOfLabel' performs option 15 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGOrbitRepresentativeOfLabel, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_ORBIT_REPRESENTATIVE_OF_LABEL( datarec );
end );

#############################################################################
##
#F  PQ_APG_WRITE_COMPACT_DESCRIPTION( <datarec> ) . . .  A p-G menu option 16
##
##  inputs data to the `pq' binary for option 16 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_WRITE_COMPACT_DESCRIPTION, function( datarec )
end );

#############################################################################
##
#F  PqAPGWriteCompactDescription( <i> )  user version of A p-G menu option 16
#F  PqAPGWriteCompactDescription()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGWriteCompactDescription' performs option 16 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGWriteCompactDescription, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_WRITE_COMPACT_DESCRIPTION( datarec );
end );

#############################################################################
##
#F  PQ_APG_AUTOMORPHISM_CLASSES( <datarec> ) . . . . . . A p-G menu option 17
##
##  inputs data to the `pq' binary for option 17 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PQ_APG_AUTOMORPHISM_CLASSES, function( datarec )
end );

#############################################################################
##
#F  PqAPGAutomorphismClasses( <i> ) . .  user version of A p-G menu option 17
#F  PqAPGAutomorphismClasses()
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data
##  to the `pq' binary
##
##  *Note:* For those  familiar  with  the  `pq'  binary, 
##  `PqAPGAutomorphismClasses' performs option 17 of the
##  Advanced $p$-Group Generation menu.
##
InstallGlobalFunction( PqAPGAutomorphismClasses, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_APG_AUTOMORPHISM_CLASSES( datarec );
end );

#E  anupqi.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
