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
local rank, automorphisms, gens, i, j, aut, g, exponents, pcgs;

  if VALUE_PQ_OPTION("PcgsAutomorphisms") = true then
    pcgs := "1  #do";
    automorphisms := Pcgs( AutomorphismGroup(G) );
    if automorphisms = fail then
      Error( "option \"PcgsAutomorphisms\" used with insoluble",
             "automorphism group\n" );
    fi;
    automorphisms := Reversed( automorphisms );
  else
    pcgs := "0  #do not";
    automorphisms := GeneratorsOfGroup( AutomorphismGroup( G ) );
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
  p := VALUE_PQ_OPTION("Prime", fail, datarec.(pcp));
  ToPQk(datarec, ["prime ",    p]);
  ToPQk(datarec, ["class ",    VALUE_PQ_OPTION("ClassBound", fail, 
                                                              datarec.(pcp))]);
  ToPQk(datarec, ["exponent ", VALUE_PQ_OPTION("Exponent", 0, datarec.(pcp))]);
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
  gens := JoinStringsWithSeparator(gens, String);
  rels := JoinStringsWithSeparator(rels, String);
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
#F  PQ_WRITE_PC_PRESENTATION( <datarec>, <outfile> ) . . I p-Q menu option 25
##
##  tells the `pq' binary to write a pc presentation to <outfile>  for  group
##  `<datarec>.group' (option 25 of the interactive $p$-Quotient menu).
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
##  performs option 25 of the interactive $p$-Quotient menu.
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

#############################################################################
##
#F  PQ_PG_SUPPLY_AUTS( <datarec> ) . . . . . . . . . . . . . pG menu option 1
##
##  defines the automorphism group of `<datarec>.group', using  option  1  of
##  the main p-Group Generation menu.
##
InstallGlobalFunction( PQ_PG_SUPPLY_AUTS, function( datarec )
local gens;
  PQ_MENU(datarec, "pG");
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
##  performs option 1 of the main p-Group Generation menu.
##
InstallGlobalFunction( PqPGSupplyAutomorphisms, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PG_SUPPLY_AUTS( datarec );
end );

#############################################################################
##
#F  PQ_PG_CONSTRUCT_DESCENDANTS( <datarec> : <options> ) . . pG menu option 5
##
##  inputs  data  given  by  <options>  to  the  `pq'  binary  to   construct
##  descendants, using option 5 of the main p-Group Generation menu.
##
InstallGlobalFunction( PQ_PG_CONSTRUCT_DESCENDANTS, function( datarec )
local orderbnd, efficient, pcgs, stepsize,
      G, firstStep,  ANUPQbool,  CR,  f,  i,  RF1,  RF2, pqi;

  # deal with the easy answer
  orderbnd := VALUE_PQ_OPTION("OrderBound");
  if orderbnd <> fail and 
     orderbnd <= LogInt(Size(datarec.group), PrimePGroup(datarec.group)) then
    return [];
  fi;

  # sanity checks
  efficient := VALUE_PQ_OPTION("SpaceEfficient", false);
  pcgs := VALUE_PQ_OPTION("PcgsAutomorphisms", false);
  if efficient and not pcgs then
    Error( "\"SpaceEfficient\" is only allowed in conjunction with ",
           "\"PcgsAutomorphisms\"\n");
  fi;
  stepsize := VALUE_PQ_OPTION("StepSize");
  if stepsize <> fail and orderbnd <> fail then
    Error( "\"StepSize\" and \"OrderBound\" must not be set simultaneously\n" );
  fi;

  PQ_MENU(datarec, "pG");
  ToPQk(datarec, [ "5  #construct descendants" ]);
    pqi:="";
    G:=datarec.group;
    CR := rec();
    CR.ClassBound                  := PClassPGroup(G) + 1;
    CR.StepSize                    := -1;
    CR.Verbose                     := false;
    CR.RankInitialSegmentSubgroups := 0;
    CR.AllDescendants              := false;
    CR.ExpSet                      := false;
    CR.Exponent                    := 0;
    CR.Metabelian                  := false;
    CR.SubList                     := -1; 


    # generate instructions
    AppendTo( pqi, "5\n", CR.ClassBound, "\n" );
    if CR.StepSize <> -1  then
        AppendTo( pqi, "0\n" );
        if CR.ClassBound = PClassPGroup(G) + 1  then
            if IsList(CR.StepSize)  then
                if Length(CR.StepSize) <> 1  then
                    return "Only one \"StepSize\" must be given";
                else
                    CR.StepSize := CR.StepSize[1];
                fi;
            fi;
            AppendTo( pqi, CR.StepSize, "\n" );
            firstStep := CR.StepSize;
        else
            if IsList(CR.StepSize)  then
                if Length (CR.StepSize) <> CR.ClassBound - PClassPGroup(G)  then
                    f := "The difference between maximal class and class ";
                    f := Concatenation(f, 
                      "of the starting group is ", 
                      String(CR.ClassBound-PClassPGroup(G)),
                      ".\nTherefore you must supply ",
                      String(CR.ClassBound-PClassPGroup(G)),
                      " step-sizes in the \"StepSize\" list \n" );
                    return f;
                fi;
                AppendTo( pqi, "0\n" );
                for i  in CR.StepSize  do
                    AppendTo( pqi, i, " " );
                od;
                AppendTo( pqi, "\n" );
                firstStep := CR.StepSize[1];
            else
                AppendTo( pqi, "1\n", CR.StepSize, "\n" );
            fi;
        fi;
    elif CR.OrderBound <> -1  then
        AppendTo( pqi, "1\n1\n", CR.OrderBound, "\n" );
    else
        AppendTo( pqi, "1\n0\n" );
    fi;    
    AppendTo( pqi, ANUPQbool(CR.PcgsAutomorphisms), "\n0\n",
                   CR.RankInitialSegmentSubgroups, "\n" );
    if CR.PcgsAutomorphisms  then
        AppendTo( pqi, ANUPQbool(CR.SpaceEfficient), "\n" );
    fi;
    if HasNuclearRank(G) and firstStep <> 0  and
        firstStep > NuclearRank(G) then
            f := Concatenation( "\"StepSize\" (=", String(firstStep),
                   ") must be smaller or equal the \"Nuclear Rank\" (=",
                   String(NuclearRank(G)), ")" );
            return f;
    fi;
    AppendTo( pqi, ANUPQbool(CR.AllDescendants), "\n" );
    AppendTo( pqi, CR.Exponent, "\n" );
    AppendTo( pqi, ANUPQbool(CR.Metabelian), "\n", "1\n" );

    # return success
    return [true, CR];
end );

#E  anupqi.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
