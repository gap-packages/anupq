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
##  p-Group Generation menu and option 2 of the Standard Presentation menu).
##
InstallGlobalFunction( PQ_AUT_INPUT, function( datarec, G )
local rank, automorphisms, gens, i, j, aut, g, exponents, pcgs;

  rank := RankPGroup( G );
  gens := PcgsPCentralSeriesPGroup( G );
  automorphisms := GeneratorsOfGroup( AutomorphismGroup( G ) );
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
  if VALUE_PQ_OPTION("PcgsAutomorphisms") = true then
    pcgs := "1  #do";
  else
    pcgs := "0  #do not";
  fi;
  ToPQ(datarec, [ pcgs, " compute pcgs gen. seq. for auts." ]);
end );

#############################################################################
##
#F  PQ_PC_PRESENTATION( <datarec>, <menu> ) . . . . . .  p-Q/SP menu option 1
##
##  inputs  data  given  by  <options>  to  the   `pq'   binary   for   group
##  `<datarec>.group' to compute a  pc  presentation  (do  option  1  of  the
##  relevant menu) according to the  <menu>  menu,  where  <menu>  is  either
##  `"pQ"' (Basic p-Quotient menu) or `"SP' (Standard Presentation menu).
##
InstallGlobalFunction( PQ_PC_PRESENTATION, function( datarec, menu )
local gens, rels, pcp;

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
  ToPQk(datarec, ["prime ",    VALUE_PQ_OPTION("Prime", fail, datarec.(pcp))]);
  ToPQk(datarec, ["class ",    VALUE_PQ_OPTION("ClassBound", fail, 
                                                              datarec.(pcp))]);
  ToPQk(datarec, ["exponent ", VALUE_PQ_OPTION("Exponent", 0, datarec.(pcp))]);
  if VALUE_PQ_OPTION( "Metabelian", false, datarec.(pcp) ) = true then
    ToPQk(datarec, [ "metabelian" ]);
  fi;
  ToPQk(datarec, ["output ", VALUE_PQ_OPTION("OutputLevel", 1, datarec.(pcp))]);
  gens := JoinStringsWithSeparator(
              List( FreeGeneratorsOfFpGroup( datarec.group ), String ) );
  ToPQk(datarec, ["generators { ", gens, " }"]);
  rels := JoinStringsWithSeparator(
              List( Filtered( RelatorsOfFpGroup( datarec.group ), 
                              rel -> not IsOne(rel) ), String ) );
  ToPQ(datarec,  ["relations  { ", rels, " };"]);
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
##  *Note:* For those  familiar  with  the  `pq'  binary,  `PqPcPresentation'
##  performs option 1 of the main p-Quotient menu.
##
InstallGlobalFunction( PqPcPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PC_PRESENTATION( datarec, "pQ" );
end );

#############################################################################
##
#F  PQ_WRITE_PC_PRESENTATION( <datarec>, <outfile> ) . . I p-Q menu option 25
##
##  tells the `pq' binary to write a pc presentation to <outfile>  for  group
##  `<datarec>.group' (option 25 of the interactive p-Quotient menu).
##
InstallGlobalFunction( PQ_WRITE_PC_PRESENTATION, function( datarec, outfile )
  PrintTo(outfile, ""); #to ensure it's empty
  PQ_MENU(datarec, "IpQ"); #we need options from the Interactive p-Q Menu
  ToPQ(datarec, [ "25 #set output file" ]);
  ToPQ(datarec, [ outfile ]);
  ToPQ(datarec, [ "2  #output in GAP format" ]);
end );

#############################################################################
##
#F  PqWritePcPresentation( <i>, <outfile> ) .  user ver. of I p-Q menu op. 25
#F  PqWritePcPresentation( <outfile> )
##
##  for the <i>th or default interactive {\ANUPQ}  process,  tells  the  `pq'
##  binary to write a pc presentation to <outfile>  for  the  group  of  that
##  process for which a pc presentation has been previously  computed,  where
##  the group of a process is the one given as first argument when  `PqStart'
##  was called to initiate that process (for process <i> the group is  stored
##  as  `ANUPQData.io[<i>].group').  If  a  pc  presentation  has  not   been
##  previously computed by the `pq' binary, then `pq' is called to compute it
##  first, effectively invoking `PqPcPresentation' (see~"PqPcPresentation").
##
##  *Note:* For those familiar with the `pq' binary,  `PqPcWritePresentation'
##  performs option 25 of the interactive p-Quotient menu.
##
InstallGlobalFunction( PqWritePcPresentation, function( arg )
local outfile, datarec;
  if 2 < Length(arg) or IsEmpty(arg) then
    Error("expected one or two arguments.\n");
  fi;
  outfile := arg[ Length(arg) ];
  if not IsString(outfile) then
    Error("last argument must be a string (filename).\n");
  fi;
  Unbind( arg[ Length(arg) ] );
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  if not IsBound(datarec.pcp) then
    Info(InfoANUPQ, 1, "pq had not previously computed a pc presentation");
    Info(InfoANUPQ, 1, "... remedying that now.");
    PQ_PC_PRESENTATION( datarec, "pQ" );
  fi;
  PQ_WRITE_PC_PRESENTATION( datarec, outfile );
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
#F  PQ_SP_STANDARD_PRESENTATION( <datarec> : <options> ) . . SP menu option 2
##
##  inputs data given by <options> to the `pq' binary to compute  a  standard
##  presentation  for  group  `<datarec>.group'  using  `<datarec>.pQuotient'
##  which must have been  previously  computed  and  option  2  of  the  main
##  Standard Presentation menu.
##
InstallGlobalFunction( PQ_SP_STANDARD_PRESENTATION, function( datarec )
local savefile;
  PQ_MENU(datarec, "SP");

  ToPQ(datarec, [ "2  #compute standard presentation" ]);
  savefile := VALUE_PQ_OPTION("StandardPresentationFile",
                              Filename( ANUPQData.tmpdir, "SPres" ));
  ToPQ(datarec, [ savefile, "  #file for saving pres'n" ]);
  ToPQ(datarec, [ VALUE_PQ_OPTION("ClassBound", 63), "  #class bound" ]);

  PQ_AUT_INPUT( datarec, datarec.pQuotient );
end );

#############################################################################
##
#F  PqSPStandardPresentation( <i> : <options> ) . user ver. of SP menu opt. 2
#F  PqSPStandardPresentation( : <options> )
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data  given
##  by <options> to compute a standard presentation for  the  group  of  that
##  process and a previously computed $p$-quotient of the  group,  where  the
##  group of a process is the one given as first argument when `PqStart'  was
##  called to initiate that process (for process <i> the group is  stored  as
##  `ANUPQData.io[<i>].group'   and   the   $p$-quotient   is    stored    as
##  `ANUPQData.io[<i>].pQuotient'). If a $p$-quotient of the  group  has  not
##  been previously computed a class 1 $p$-quotient is computed.
##
##  *Note:* For those familiar with  the  `pq'  binary,  `PqSPPcPresentation'
##  performs option 2 of the Standard Presentation menu.
##
InstallGlobalFunction( PqSPStandardPresentation, function( arg )
local ioIndex, datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  ioIndex := ANUPQ_IOINDEX(arg);
  datarec := ANUPQData.io[ ioIndex ];
  if not IsBound(datarec.pQuotient) then
    PQ_EPIMORPHISM(ioIndex);
  fi;
  PQ_SP_STANDARD_PRESENTATION( datarec );
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
local savefile;
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

#E  anupqi.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
