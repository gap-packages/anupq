#############################################################################
####
##
#A  anupga.gi                ANUPQ share package                 Frank Celler
#A                                                           & Eamonn O'Brien
#A                                                           & Benedikt Rothe
##
##  Install file for p-group generation of automorphism group  functions  and
##  variables.
##
#A  @(#)$Id$
##
#Y  Copyright 1992-1994,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  Copyright 1992-1994,  School of Mathematical Sciences, ANU,     Australia
##
#H  $Log$
#H  Revision 1.7  2001/06/19 17:21:39  gap
#H  - Non-interactive functions now use iostreams (when not creating a SetupFile).
#H  - The `Verbose' option has now been eliminated; it's function is now provided
#H    by using `InfoANUPQ'.
#H  - Data recorded for a non-interactive function is now stored in the record
#H    `ANUPQData.ni' entirely analogous to the interactive function records
#H    `ANUPQData.io[<i>]'.
#H  - `ToPQ' now takes care of the cases where the `pq' binary calls GAP to
#H    compute stabilisers.
#H  - A header was added to `anustab.g'. - GG
#H
#H  Revision 1.6  2001/06/16 15:05:04  werner
#H  Progress (?) with talking to pq
#H
#H  Revision 1.5  2001/06/15 17:35:38  werner
#H  Changing the way Process() is handled.                                WN
#H
#H  Revision 1.4  2001/06/13 21:34:25  gap
#H  - The non-interactive `PqDescendants' and `PqList' have been modified.
#H    o `PqList' now takes the option `SubList' which enables `PqDescendants'
#H      to call `PqList' and pass its `SubList' recursively (much neater).
#H    o The non-interactive `PqDescendants' no longer has `TmpDir' as an option,
#H      but it now has `PqWorkspace' like the other non-interactive functions.
#H  - There is now an interactive `PqDescendants'.
#H  - Menu item function: `PqPGConstructDescendants' has been added.
#H    (This does most of the work for `PqDescendants'.)
#H  - `PqStart' now accepts either an *fp group* or a *pc group*.
#H    (`PqDescendants' expects the group to be a pc group.)               - GG
#H
#H  Revision 1.3  2001/06/05 16:42:24  gap
#H  Up-to-the-minute changes. - GG
#H
#H  Revision 1.2  2001/06/05 12:09:22  gap
#H  Mainly half-baked changes, just to ensure CVS and me don't differ. - GG
#H
#H  Revision 1.1  2001/04/21 21:15:40  gap
#H  lib/
#H     *.g,*.gd:
#H     - following global variables modified to have `Pq' in them:
#H       `LetterInt' -> `PqLetterInt' (now defined in `anupga.g[id]')
#H       `EpimorphismStandardPresentation' -> `EpimorphismPqStandardPresentation'
#H       `StandardPresentation' -> `PqStandardPresentation'
#H       `FpGroupPcGroup' -> `PqFpGroupPcGroup'
#H       `IsIsomorphicPGroup' -> `IsPqIsomorphicPGroup'
#H       The last four functions now have methods of the same name as
#H       previously which are equivalent to the functions with `Pq' in them.
#H     anupqhead.g:
#H     - new file: defines `ANUPQData' record, `InfoANUPQ' and sets its level to 1,
#H       and outputs a banner.
#H     anupqprop.gd:
#H     - new file: contains previous contents of `anupq.gd'
#H     anupqopt.gd, anupqopt.gi:
#H     - new files: so far defines `ANUPQoptions', `SET_ANUPQ_OPTIONS'
#H     anupq.g -> anupq.gd, anupq.gi
#H     - headers put on files
#H     - `anupq.gd' has all the `DeclareGlobalFunction' and `DeclareGlobalVariable'
#H       commands, and `anupq.gi' is the old `.g' file converted to using
#H       `InstallGlobalFunction' and `InstallValue'.
#H     anupq.gi:
#H     - `ANUPQoptions' moved to `anupqopt.g[id]' and generalised.
#H     - `Pq'
#H       now accepts options; modified error messages ... usage now says to use
#H       options
#H     anupga.g -> anupga.gd, anupga.gi
#H     - headers put on files
#H     - `anupga.gd' has all the `DeclareGlobalFunction' and `DeclareGlobalVariable'
#H       commands, and `anupga.gi' is the old `.g' file converted to using
#H       `InstallGlobalFunction' and `InstallValue'.
#H     - `PqDescendants'
#H       now accepts options; its options are a field of the record in
#H       `ANUPQoptions' defined in `anupqopt.g[id]'
#H     anusp.g -> anusp.gd, anusp.gi
#H     - headers put on files
#H     - `anusp.gd' has all the `DeclareGlobalFunction' and `DeclareGlobalVariable'
#H       commands, and `anusp.gi' is the old `.g' file converted to using
#H       `InstallGlobalFunction' and `InstallValue'.
#H     - list of options for `StandardPresentation' etc. is now a field of the
#H       record `ANUPQoptions' in `anupqopt.g[id]'.
#H     - Operations/Methods declared and installed for
#H       `EpimorphismStandardPresentation', `StandardPresentation' and
#H       `FpGroupPcGroup', `IsIsomorphicPGroup' and each has a function
#H       counterpart with a `Pq' in its name.
#H     - `EpimorphismPqStandardPresentation', `PqStandardPresentation' now
#H       accept options. Their non-`Pq' method counterparts only accept
#H       options.
#H  - GG
#H
#H  Revision 1.3  2000/07/13 16:16:43  werner
#H  p-group generation now works for soluble automorphism groups and with
#H  the help of GAP3 for insoluble automorphism groups.
#H  We are getting there.                                                   WN
#H
#H  Revision 1.2  2000/07/12 17:00:06  werner
#H  Further work towards completing the GAP 4 interface to the ANU PQ.
#H                                                                      WN
#H
#H  Revision 1.1.1.1  1998/08/12 18:50:54  gap
#H  First attempt at adapting the ANU pq to GAP 4. 
#H
##
Revision.anupga_gi :=
    "@(#)$Id$";

if IsBound(ANUPQtmpDir)  then
    ThisIsAHack := ANUPQtmpDir;
else
    ThisIsAHack := "ThisIsAHack";
fi;
ANUPQtmpDir := ThisIsAHack;

#############################################################################
##
#F  InfoANUPQ1  . . . . . . . . . . . . . . . . . . . . . . debug information
#F  InfoANUPQ2  . . . . . . . . . . . . . . . . . . . . . . debug information
##
if not IsBound(InfoANUPQ1)  then InfoANUPQ1 := Print;    fi;
if not IsBound(InfoANUPQ2)  then InfoANUPQ2 := Ignore;   fi;

#############################################################################
##
#F  ANUPQerror( <param> ) . . . . . . . . . . . . .  report illegal parameter
##
InstallGlobalFunction( ANUPQerror, function( param )
    Error(
    "Valid Options:\n",
    "    \"ClassBound\", <bound>\n",
    "    \"OrderBound\", <order>\n",
    "    \"StepSize\", <size>\n",
    "    \"PcgsAutomorphisms\"\n",
    "    \"RankInitialSegmentSubgroups\", <rank>\n",
    "    \"SpaceEfficient\"\n",
    "    \"AllDescendants\"\n",
    "    \"Exponent\", <exponent>\n",
    "    \"Metabelian\"\n",
    "    \"SubList\"\n",
    "    \"TmpDir\"\n",
    "    \"Verbose\"\n",
    "    \"SetupFile\", <file>\n",
    "Illegal Parameter: \"", param, "\"" );
end );

#############################################################################
##
#F  ANUPQextractArgs( <args>) . . . . . . . . . . . . . . parse argument list
##
InstallGlobalFunction( ANUPQextractArgs, function( args )
    local   CR,  i,  act,  G,  match;

    # allow to give only a prefix
    match := function( g, w )
    	return 1 < Length(g) and 
            Length(g) <= Length(w) and 
            w{[1..Length(g)]} = g;
     end;

    # extract arguments
    G  := args[1];
    CR := rec( group := G );
    i  := 2;
    while i <= Length(args)  do
        act := args[i];

        # "ClassBound", <class>
        if match( act, "ClassBound" )  then
            i := i + 1;
            CR.ClassBound := args[i];
            if CR.ClassBound <= PClassPGroup(G) then
                Error( "\"ClassBound\" must be at least ", PClassPGroup(G)+1 );
            fi;

        # "OrderBound", <order>
        elif match( act, "OrderBound" )  then
            i := i + 1;
            CR.OrderBound := args[i];

        # "StepSize", <size>
        elif match( act, "StepSize" )  then
            i := i + 1;
            CR.StepSize := args[i];

        # "PcgsAutomorphisms"
        elif match( act, "PcgsAutomorphisms" )  then
            CR.PcgsAutomorphisms := true;

        # "RankInitialSegmentSubgroups", <rank>
        elif match( act, "RankInitialSegmentSubgroups" )  then
            i := i + 1;
            CR.RankInitialSegmentSubgroups := args[i];

        # "SpaceEfficient"
        elif match( act, "SpaceEfficient" ) then
            CR.SpaceEfficient := true;

        # "AllDescendants"
        elif match( act, "AllDescendants" )  then
            CR.AllDescendants := true;

        # "Exponent", <exp>
        elif match( act, "Exponent" )  then
            i := i + 1;
            CR.Exponent := args[i];

        # "Metabelian"
        elif match( act, "Metabelian" ) then
            CR.Metabelian := true;

        # "Verbose"
        elif match( act, "Verbose" )  then
            CR.Verbose := true;

        # "SubList"
        elif match( act, "SubList" )  then
            i := i + 1;
            CR.SubList := args[i];

        # temporary directory
        elif match( act, "TmpDir" )  then
            i := i + 1;
            CR.TmpDir := args[i];

        # "SetupFile", <file>
        elif match( act, "SetupFile" )  then
            i := i + 1;
            CR.SetupFile := args[i];

        # signal an error
        else
            ANUPQerror( act );
        fi;
        i := i + 1;
    od;
    return CR;

end );

#############################################################################
##
#F  ANUPQinstructions( <pqi>, <param>, <p> )  . . . . . .  construct PQ input
##
InstallGlobalFunction( ANUPQinstructions, function( pqi, param, p )
    local   G, firstStep,  ANUPQbool,  CR,  f,  i,  RF1,  RF2;

    G := param.group;
    firstStep := 0;

    # function to print boolean value
    ANUPQbool := function(b)
        if b  then
            return 1;
        else
            return 0;
        fi;
    end;

    # <CR> will hold the parameters
    CR := rec ();
    CR.ClassBound                  := PClassPGroup(G) + 1;
    CR.StepSize                    := -1;
    CR.OrderBound                  := -1;
    CR.PcgsAutomorphisms           := false;
    CR.Verbose                     := false;
    CR.RankInitialSegmentSubgroups := 0;
    CR.SpaceEfficient              := false;
    CR.AllDescendants              := false;
    CR.ExpSet                      := false;
    CR.Exponent                    := 0;
    CR.Metabelian                  := false;
    CR.group                       := G;
    CR.SubList                     := -1; 

    # merge arguments with default parameters
    RF1 := REC_NAMES(CR);
    RF2 := REC_NAMES(param);
    for f  in RF2  do
        if not f in RF1  then
            ANUPQerror(f);
        else
            CR.(f) := param.(f);
        fi;
    od;

    # sanity check
    if CR.OrderBound <> -1 and CR.OrderBound <= LogInt(Size(G), p)  then
        return [false];
    fi;
    if CR.SpaceEfficient and not CR.PcgsAutomorphisms  then
        f := "\"SpaceEfficient\" is only allowed in conjunction with ";
        f := Concatenation( f, "\"PcgsAutomorphisms\"" );
        return f;
    fi;
    if CR.StepSize <> -1 and CR.OrderBound <> -1  then
        f := "\"StepSize\" and \"OrderBound\" must not be set ";
        f := Concatenation( f, "simultaneously" );
        return f;
    fi;

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

#############################################################################
##
#F  ANUPQauto( <G>, <gens>, <imgs> )  . . . . . . . .  construct automorphism
##
InstallGlobalFunction( ANUPQauto, function( G, gens, images )
   local   f;

   f := GroupHomomorphismByImagesNC( G, G, gens, images );
   SetIsBijective( f, true );
   SetKernelOfMultiplicativeGeneralMapping( f, TrivialSubgroup(G) );

   return f;
end );

#############################################################################
##
#F  ANUPQautoList( <G>, <gens>, <L> ) . . . . . . . construct a list of autos
##
InstallGlobalFunction( ANUPQautoList, function( G, gens, automs )
    local   D,  g,  igs,  auts,  i;

    # construct direct product elements
    D := [];
    for g  in [ 1 .. Length(gens) ]  do
	Add( D, Tuple( automs{[1..Length(automs)]}[g] ) );
    od;

    # and compute the abstract igs simultaneously
    igs := InducedPcgsByGeneratorsWithImages( Pcgs(G), gens, D );
    gens := igs[1];
    D := igs[2];


    # construct the automorphisms
    auts := [];
    for i in [ 1 .. Length(automs) ]  do
	Add( auts, ANUPQauto( G, gens, D{[1..Length(gens)]}[i] ) );
    od;

    # and then the automorphisms
    return auts;

end );

#############################################################################
##
#F  ANUPQSetAutomorphismGroup( <G>, <gens>, <automs>, <isSoluble> ) 
##
InstallGlobalFunction( ANUPQSetAutomorphismGroup, 
function( G, gens, automs, isSoluble )
    local   A;

    automs := ANUPQautoList( G, gens, automs );
    
    if automs <> [] then
        A := GroupByGenerators( automs );
    else
        A := GroupByGenerators( [ ANUPQauto( G, GeneratorsOfGroup(G),
                     GeneratorsOfGroup(G) ) ] );
    fi;

    SetIsAutomorphismGroup( A, true );
    SetIsFinite( A, true );

    if isSoluble then SetPcgs( A, automs ); fi;

    SetAutomorphismGroup( G, A );

end );

#############################################################################
##
#F  ANUPQprintExps( <pqi>, <lst> ) . . . . . . . . . . .  print exponent list
##
InstallGlobalFunction( ANUPQprintExps, function( pqi, lst )
    local   first,  l,  j;

    l := Length(lst);
    first := true;
    for j  in [1 .. l]  do
        if lst[j] <> 0  then
          if not first  then
              AppendTo( pqi, "*" );
          fi;
          first := false;
          AppendTo( pqi, "g", j, "^", lst[j] );
        fi;
    od;
end );

#############################################################################
##
#V  ANUPGAGlobalVariables
##
InstallValue( ANUPGAGlobalVariables,
              [ "ANUPQgroups", 
                "ANUPQautos", 
                "ANUPQmagic" ] );

#############################################################################
##
#F  PqList( <file> [: SubList := <sub>]) . . . . .  get a list of descendants
##
InstallGlobalFunction( PqList, function( file )
    local   var,  retval,  lst,  groups,  autos,  sublist,  func;

    # check arguments
    if not IsString(file) then
        Error( "usage: PqList( <file> [: SubList := <sub>])\n" );
    fi;

    for var in ANUPGAGlobalVariables do
        HideGlobalVariables( var );
    od;

    # try to read <file>
    retval := READ( file );
    if not retval or not IsBoundGlobal( "ANUPQmagic" )  then

        for var in ANUPGAGlobalVariables do
            UnhideGlobalVariables( var );
        od;
        return false;
    fi;
Error();
    # <lst> will hold the groups
    lst := [];
    if IsBoundGlobal( "ANUPQgroups" ) then
        groups := ValueGlobal( "ANUPQgroups" );
        if IsBoundGlobal( "ANUPQautos" ) then
            autos := ValueGlobal( "ANUPQautos" );
        fi;

        sublist := VALUE_PQ_OPTION("SubList", [ 1 .. Length( groups ) ]);
        if not IsList(sublist) then
            sublist := [ sublist ];
        fi;

        for func  in sublist  do
            groups[func](lst);
            if IsBound( autos) and IsBound( autos[func] )  then
                autos[func]( lst[Length(lst)] );
            fi;
        od;
    fi;
    
    for var in ANUPGAGlobalVariables do
        UnhideGlobalVariables( var );
    od;

    # return the groups
    return lst;

end );

#############################################################################
##
#F  PqLetterInt( <n> ) . . . . . . . . . . . . . . . 
##
InstallGlobalFunction( PqLetterInt, function ( n )
    local  letters, str, x, d;
    letters := [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", 
        "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" ]
     ;
    if n < 1  then
        Error( "number must be positive" );
    elif n <= Length( letters )  then
        return letters[n];
    fi;
    str := "";
    n := n - 1;
    d := 1;
    repeat
        x := n mod Length( letters ) + d;
        str := Concatenation( letters[x], str );
        n := QuoInt( n, Length( letters ) );
        if n < 26  then
            d := 0;
        fi;
    until n < 1;
    return str;
end );

#############################################################################
##
#F  PQ_DESCENDANTS( <args> ) . . . . . . . . . construct descendants of group
##
InstallGlobalFunction( PQ_DESCENDANTS, function( args )
    local   datarec,  G,  pd,  desc;

    datarec := ANUPQ_ARG_CHK(1, "PqDescendants", "group", IsPcGroup, 
                             "a pc group", args);
    if datarec.calltype = "GAP3compatible" then
        # ANUPQ_ARG_CHK calls PQ_DESCENDANTS itself in this case
        # (so datarec.descendants has already been computed)
        return datarec.descendants;
    fi;

    # if automorphisms are not supplied and group has p-class 1, 
    # construct automorphisms, else signal Error 
    if not HasAutomorphismGroup(datarec.group) then 
        if (PClassPGroup(datarec.group) = 1) then 
            AutomorphismGroup( datarec.group );
        else 
            G := datarec.group;
            Error ("<G> must have class 1 or ",
                   "<G>'s automorphism group must be known\n");
        fi;
    fi;

    # if <G> is not capable and we want to compute something, return
    if HasIsCapable(datarec.group) and not IsCapable(datarec.group) and 
       VALUE_PQ_OPTION("SetupFile") = fail then
        return [];
    fi;

    PQ_PC_PRESENTATION( datarec, "pQ" 
                        : Prime      := PrimePGroup(datarec.group),
                          ClassBound := PClassPGroup(datarec.group) );
    PQ_P_COVER( datarec );
    PQ_PG_SUPPLY_AUTS( datarec );
    PQ_PG_CONSTRUCT_DESCENDANTS( datarec );

    if datarec.calltype = "non-interactive" then
      PQ_COMPLETE_NONINTERACTIVE_FUNC_CALL(datarec);
      if IsBound( datarec.setupfile ) then
        return true;
      fi;
    fi;
        
    datarec.descendants 
        := PqList( Filename( ANUPQData.tmpdir, "GAP_library" ) );
    for G in datarec.descendants do
        if not HasIsCapable(G)  then
            SetIsCapable( G, false );
        fi;
    od;

    return datarec.descendants;
end );

#############################################################################
##
#F  PqDescendants( <G> ... )  . . . . . . . . .  construct descendants of <G>
#F  PqDescendants( <i> )
#F  PqDescendants()
##
InstallGlobalFunction( PqDescendants, function( arg )
    return PQ_DESCENDANTS(arg);
end );

#############################################################################
##
#F  SavePqList( <file>, <lst> ) . . . . . . . . .  save a list of descendants
##
InstallGlobalFunction( SavePqList, function( file, list )
    local   appendExp,  l,  G,  pcgs,  p,  i,  w,  str,  word,  j,  
            automorphisms,  r;

    # function to add exponent vector
    appendExp := function( str, word )
        local   first, s, oldLen, i, w;

        first  := true;
        s      := str;
        oldLen := 0;
        for i  in [ 1 .. Length (word) ]  do
            if word[i] <> 0 then
                w := Concatenation( "G.", String (i) );
                if word[i] <> 1  then
                    w := Concatenation( w, "^", String(word[i]) );
                fi;
                if not first  then
                    w := Concatenation( "*", w );
                fi;
                if Length(s)+Length(w)-oldLen >= 77  then
                    s := Concatenation( s, "\n" );
                    oldLen := Length(s);
                fi;
                s := Concatenation( s, w );
                first := false;
            fi;
        od;
        if first  then
            s := Concatenation( s, "G.1^0" );
        fi;
        return s;
    end;

    # print head of file
    PrintTo(  file, "ANUPQgroups := [];\n"    );
    AppendTo( file, "Unbind(ANUPQautos);\n\n" );

    # run through all groups in <list>
    for l  in [ 1 .. Length(list) ]  do
        G    := list[l];
        pcgs := PcgsPCentralSeriesPGroup( G );
        p    := PrimeOfPGroup( G );
        AppendTo( file, "## group number: ", l, "\n"                     );
        AppendTo( file, "ANUPQgroups[", l, "] := function( L )\n"        );
        AppendTo( file, "local   G,  A,  B;\n"                           );
        AppendTo( file, "G := FreeGroup( ", Length(pcgs), ", \"G\" );\n" );
        AppendTo( file, "G := G / [\n"                                   );

        # at first the power relators
        for i in [ 1 .. Length(pcgs) ]  do
            if 1 < i  then
                AppendTo( file, ",\n" );
            fi;
            w   := pcgs[i]^p;
            str := Concatenation( "G.", String(i), "^", String(p) );
            if w <> One(G) then
                word := ExponentsOfPcElement( pcgs, w );
                str  := Concatenation( str, "/(" );
                str  := appendExp( str,word );
                str  := Concatenation( str, ")" );
            fi;
            AppendTo( file, str );
        od;

        # and now the commutator relators
        for i  in [ 1 .. Length(pcgs)-1 ]  do
            for j  in [ i+1 .. Length(pcgs) ]  do
                w := Comm( pcgs[j], pcgs[i] );
                if w <> One(G) then
                    word := ExponentsOfPcElement( pcgs, w );
                    str  := Concatenation(
                                ",\nComm( G.", String(j),
                                ", G.", String(i), " )/(" );
                    str := appendExp( str, word );
                    AppendTo( file, str, ")" );
                fi;
            od;
        od;
        AppendTo( file, "];\n" );

        # convert group into an ag group, save presentation
        AppendTo( file, "G := PcGroupFpGroupNC(G);\n"              );

        # add automorphisms
        if HasAutomorphismGroup(G) then
            AppendTo( file, "A := [];\nB := [" );
    	    for r  in [ 1 .. RankPGroup(G) ]  do
                AppendTo( file, "G.", r );
                if r <> RankPGroup(G)  then
                    AppendTo( file, ", " );
    	    	else
    	    	    AppendTo( file, "];\n" );
                fi;
            od;
            automorphisms := GeneratorsOfGroup( AutomorphismGroup( G ) );
            for j  in [ 1 .. Length(automorphisms) ]  do
                AppendTo( file, "A[", j, "] := [");
                for r  in [ 1 .. RankPGroup(G) ]  do
                    word := Image( automorphisms[j], pcgs[r] );
                    word := ExponentsOfPcElement( pcgs, word );
                    AppendTo( file, appendExp( "", word ) );
                    if r <> RankPGroup(G)  then
                        AppendTo (file, ", \n");
                    fi;
                od;
                AppendTo( file, "]; \n");
            od;
    	    AppendTo( file, "ANUPQSetAutomorphismGroup( G, B, A, " );
            if HasIsSolvableGroup( AutomorphismGroup(G) ) then
                AppendTo( file, IsSolvable( G ), " );\n" );
            else
                AppendTo( file, false, " );\n" );
            fi;
        fi;

        if HasNuclearRank( G ) then
            AppendTo( file, "SetNuclearRank( G, ", NuclearRank(G), " );\n" );
        fi;
        if HasIsCapable( G ) then
            AppendTo( file, "SetIsCapable( G, ", IsCapable(G), " );\n" );
        fi;
        if HasANUPQIdentity( G ) then
            AppendTo( file, "SetANUPQIdentity( G, ", 
                    ANUPQIdentity(G), " );\n" );
        fi;

        AppendTo( file, "Add( L, G );\n" );
        AppendTo( file, "end;\n\n\n"     );
    od;

    # write a magic string to the files
    AppendTo( file, "ANUPQmagic := \"groups saved to file\";\n" );
end );

#E  anupga.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
