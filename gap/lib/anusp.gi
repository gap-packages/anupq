#############################################################################
####
##
#A  anusp.gi                    ANUPQ package                  Eamonn O'Brien
#A                                                             Alice Niemeyer 
##
#A  @(#)$Id$
##
#Y  Copyright 1993-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  Copyright 1993-2001,  School of Mathematical Sciences, ANU,     Australia
##
#H  $Log$
#H  Revision 1.14  2001/09/29 22:04:19  gap
#H  `Pq', `PqEpimorphism', `PqPCover', `[Pq]StandardPresentation[Epimorphism]'
#H  now accept either an fp group or a pc group, and for each `ClassBound'
#H  defaults to 63 if not supplied except in the following case.
#H  If the group <F> supplied to `PqPCover' is a p-group and knows it is and
#H  `HasPrimePGroup(<F>)' is `true', `Prime' defaults to `PrimePGroup(<F>)' if
#H  not supplied, and if `HasPClassPGroup(<F>)' is `true' then `ClassBound'
#H  defaults to `PClassPGroup(<F>)' if not supplied or to 63 otherwise.
#H  The attributes and property `MultiplicatorRank', `NuclearRank' and
#H  `IsCapable' don't rely on the method to check that the group is a p-group
#H  and emit an error if `HasIsPGroup(<G>) and IsPGroup(<G>)' is `false' (the
#H  user must make sure the group knows it is a p-group first, except that
#H  `Pq', `PqEpimorphism', `PqPCover' ensure the group or image of the
#H  epimorphism have the property set). - GG
#H
#H  Revision 1.13  2001/09/19 14:40:58  gap
#H  Bugfix for `PqWeight'. Various improvements. Got rid of `share'. - GG
#H
#H  Revision 1.12  2001/09/12 13:27:46  gap
#H  Improvements due to Bettina + improvements in Info-ed output control. - GG
#H
#H  Revision 1.11  2001/08/30 21:21:16  gap
#H  `PqCurrentGroup' is now useful and returns a pc group, not just data.
#H  `PqEliminateRedundantGenerators' now updates the `ngens' and `forder'
#H  fieldss of the data record, so that `PqFactoredOrder', `PqOrder',
#H  `PqNrPcGenerators' and `PqWeight' are now accurate (as documented).
#H  The amount of output of `StandardPresentation' is out of sync. with docs;
#H  it can wait until I find the right adjustment formula. - GG
#H
#H  Revision 1.10  2001/08/30 01:09:54  gap
#H  - Make better use of InfoANUPQ, levels now mean:
#H    1:non-(timing,memory usage) output from `pq' and general info.
#H    2:timing,memory usage output from `pq'
#H    3:non-user invoked output from `pq' of nature of 1, 2
#H    4:commands sent to `pq' (behind a `ToPQ> ' prompt)
#H    5:menus and prompts and other info. that is usually meaningless to a user
#H    Still need to rethink `OutputLevel := 0' in this scheme. For the moment
#H    I've added a behind-the-scenes option: `nonuser' which makes all the
#H    output from `Pq', `PqDescendants' and `StandardPresentation' etc. get
#H    Info-ed at ANUPQ level 3.
#H  - Rationalised the `Display' functions. Now there is just
#H    `PqDisplayPcPresentation' and it uses whatever is the current `pq' menu.
#H  - Rationalised the ..Set..PrintLevel functions in the same way, except it
#H    is now called `PqSetOutputLevel' (like the `OutputLevel' option).
#H  - A number of functions now call `PQ_SET_GROUP_DATA' which may in turn
#H    call `PQ_DATA' which between them set the fields `name', `class' (current
#H    class), `forder' (factored order) and `ngens' (the no. of gen'rs for each
#H    class up to the current class) of the data record associated with an
#H    interactive process.
#H  - There are now functions: `PqFactoredOrder', `PqOrder', `PqNrPcGenerators',
#H    `PqPClass' and `PqWeight' (weight of a generator) which determine their
#H    values by looking at the fields `class', `forder' and `ngens' of the data
#H    record associated with a process. `PqCurrentGroup' is not useful yet.
#H  - Fixed bug in `PqDoConsistencyCheck'.
#H  - `PqDoExponentChecks', `PqDisplayStructure' (was `PqPrintStructure') and
#H    `PqDisplayAutomorphisms' now have their non-process-id arguments as the
#H    option `Bounds'.
#H  - There is now a guard against `pq' seg-faults just from changing menu.
#H     GG
#H
#H  Revision 1.9  2001/07/05 21:14:26  gap
#H  Bug fixes. ANUPQ_ARG_CHK now checks required options are set ... all
#H  functions that call it have been adjusted. The option `StepSize' had
#H  been mis-spelt `Stepsize' twice. - GG
#H
#H  Revision 1.8  2001/06/26 09:44:27  gap
#H  Just cleaning house. - GG
#H
#H  Revision 1.7  2001/06/21 23:04:20  gap
#H  src/*, include/*, Makefile.in:
#H   - pq binary now calls itself version 1.5 (global variable PQ_VERSION
#H     added in include/pq_author.h for this)
#H   - added -v option (gives pq version)
#H   - added -G option (equivalent to `-g -i -k' + assumes talking to GAP via
#H     an iostream ... extern variable: GAP4iostream added in include/global.h
#H     for this)
#H   - some idiosyncrasies in the menus cleaned up.
#H  standalone-doc/*:
#H   - updated ... see newly added header in guide.tex for details.
#H  gap/lib/anustab.g[id]:
#H   - replace gap/lib/anustab.g ... original code is now in function
#H     `PqStabiliserOfAllowableSubgroup'
#H  init.g,read.g:
#H   - now read in gap/lib/anustab.g[id] so that `PqStabiliserOfAllowableSubgroup'
#H     is defined. ANUPQ share package now calls itself Version 1.1.
#H  gap/lib/anupqhead.g:
#H   - now uses -v option of pq to extract the version. ANUPQData.infile is no
#H     longer defined.
#H  gap/lib/*.g[id] (other):
#H   - now when not being called to create a setup file GAP calls pq with the -G
#H     option. The setup file has comment on first line telling user to use:
#H     the `-i -g -k' flags. Modifications made to call
#H     `PqStabiliserOfAllowableSubgroup' in the `ToPQ' function when a
#H     `PQ_REQUEST' is detected.
#H   - `PQ_REQUEST' takes a string as argument and returns a boolean. It detects
#H     when a `GAP, please compute stabilisers!\n' request has been emitted by
#H     the `pq' binary.
#H  - GG
#H
#H  Revision 1.6  2001/06/19 17:21:39  gap
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
#H  Revision 1.5  2001/06/15 17:43:49  gap
#H  Correcting `success' variable check. - GG
#H
#H  Revision 1.4  2001/06/02 23:18:56  gap
#H  Bug fixes. - GG
#H
#H  Revision 1.3  2001/05/25 17:44:40  gap
#H  Bug fixes and additions to documentation. - GG
#H
#H  Revision 1.2  2001/05/24 22:05:03  gap
#H  Added interactive versions of `[Epimorphism][Pq]StandardPresentation' and
#H  factored out as separate functions the various menu items these functions
#H  use. - GG
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
#H  Revision 1.2  2000/07/12 17:00:06  werner
#H  Further work towards completing the GAP 4 interface to the ANU PQ.
#H                                                                      WN
#H
#H  Revision 1.1.1.1  1998/08/12 18:50:54  gap
#H  First attempt at adapting the ANU pq to GAP 4. 
#H
##
Revision.anusp_gi :=
    "@(#)$Id$";

#############################################################################
##
#F  ANUPQSPerror( <param> )  . . . . . . . . . . . . report illegal parameter
##
InstallGlobalFunction( ANUPQSPerror, function( param )
    Error(
    "Valid Options:\n",
    "    \"ClassBound\", <bound>\n",
    "    \"PcgsAutomorphisms\"\n",
    "    \"Exponent\", <exponent>\n",
    "    \"Metabelian\"\n",
    "    \"OutputLevel\", <level>\n",
    "    \"SetupFile\", <file>\n",
    "Illegal Parameter: \"", param, "\"" );
end );

#############################################################################
##
#F  ANUPQSPextractArgs( <args> )  . . . . . . . . . . . . parse argument list
##
InstallGlobalFunction( ANUPQSPextractArgs, function( args )
    local   CR,  i,  act,  G,  match;

    # allow to give only a prefix
    match := function( g, w )
    	return 1 < Length(g) and 
            Length(g) <= Length(w) and 
            w{[1..Length(g)]} = g;
    end;

    # extract arguments
    G  := args[2];
    CR := rec( group := G );
    i  := 3;
    while i <= Length(args)  do
        act := args[i];

        # "ClassBound", <class>
        if match( act, "ClassBound" )  then
            i := i + 1;
            CR.ClassBound := args[i];
            if CR.ClassBound <= PClassPGroup(G)  then
                Error( "\"ClassBound\" must be at least ", PClassPGroup(G)+1 );
            fi;

        # "PcgsAutomorphisms"
        elif match( act, "PcgsAutomorphisms" )  then
            CR.PcgsAutomorphisms := true;

        #this may be available later
        # "SpaceEfficient"
        #elif match( act, "SpaceEfficient" ) then
        #    CR.SpaceEfficient := true;

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

        # "SetupFile", <file>
        elif match( act, "SetupFile" )  then
            i := i + 1;
            CR.SetupFile := args[i];

    	# "TmpDir", <dir>
    	elif match( act, "TmpDir" )  then
    	    i := i + 1;
    	    CR.TmpDir := args[i];

        # "Output", <level>
        elif match( act, "OutputLevel" )  then
            i := i + 1;
            CR.OutputLevel := args[i];
            CR.Verbose     := true;

        # signal an error
        else
            ANUPQSPerror(act);
        fi;
        i := i + 1;
    od;
    return CR;

end );

#############################################################################
##
#V  ANUSPGlobalVariables
##
InstallValue( ANUSPGlobalVariables, 
              [ "ANUPQmagic",
                "ANUPQautos",
                "ANUPQgroups",
                ] );

#############################################################################
##
#F  PqFpGroupPcGroup( <G> ) . . . . . .  corresponding fp group of a pc group
##
InstallGlobalFunction( PqFpGroupPcGroup, 
    G -> Image( IsomorphismFpGroup( G ) )
);

#############################################################################
##
#M  FpGroupPcGroup( <G> ) . . . . . . .  corresponding fp group of a pc group
##
InstallMethod( FpGroupPcGroup, "pc group", [IsPcGroup], 0, PqFpGroupPcGroup );

#############################################################################
##
#F  PQ_EPIMORPHISM_STANDARD_PRESENTATION( <args> ) . . epi. onto SP for group
##
InstallGlobalFunction( PQ_EPIMORPHISM_STANDARD_PRESENTATION, 
function( args )
    local   datarec, p_or_Q, rank, p, Q, automorphisms, generators, x,
            images, i, r, j, aut, result, desc, k;

    datarec := ANUPQ_ARG_CHK(2, "StandardPresentation", args);
    p_or_Q := args[ Length(args) ];
    if IsInt(p_or_Q)  then
    	p := p_or_Q;
        if not IsPrimeInt(p)  then
            Error( "<p> must be a prime" );
        fi;
        rank := Number( List( AbelianInvariants(datarec.group), x->Gcd(x,p) ),
                        y->y=p );

        # construct free group with <rank> generators
        Q := FreeGroup( rank, "q" );
    
        # construct power-relation
        Q := Q / List( GeneratorsOfGroup(Q), x -> x^p );
    
        # construct pc group
        Q := PcGroupFpGroup(Q);
    
        # construct automorphism
        automorphisms := [];
        generators := GeneratorsOfGroup(Q);
        for x in GeneratorsOfGroup( GL(rank,p) ) do
            images := [];
            for i  in [ 1 .. rank ]  do
                r := One(Q);
                for j  in [ 1 .. rank ]  do
                    r := r * generators[j]^Int(x[i][j]);
                od;
                images[i] := r;
            od;
            aut := GroupHomomorphismByImages( Q, Q, generators, images );
            SetIsBijective( aut, true );
            Add( automorphisms, aut );
        od;
        SetAutomorphismGroup( Q, GroupByGenerators( automorphisms ) );
    else
        Q := p_or_Q;
        if not IsPcGroup(Q)  then
            Error( "<Q> must be a pc group" );
        else
            PQ_AUT_GROUP(Q);
        fi;
        p := PrimeOfPGroup( Q );
    fi;
    
    #PushOptions(rec(nonuser := true));
    PQ_PC_PRESENTATION(datarec, "SP" : Prime := p, 
                                       ClassBound := PClassPGroup(Q));

    datarec.pQuotient := Q;
    PQ_SP_STANDARD_PRESENTATION(datarec);

    PQ_SP_ISOMORPHISM(datarec);

    if datarec.calltype = "non-interactive" then
        PQ_COMPLETE_NONINTERACTIVE_FUNC_CALL(datarec);
        if IsBound( datarec.setupfile ) then
            #PopOptions();
            return true;
        fi;
    fi;

    # try to read output
    result := ANUPQReadOutput( ANUPQData.SPimages, ANUSPGlobalVariables );

    if not IsBound(result.ANUPQmagic)  then
        Error("something wrong with `pq' binary. Please check installation\n");
    fi;

    desc := rec();
    result.ANUPQgroups[Length(result.ANUPQgroups)](desc);
#    if result.ANUPQautos <> fail and 
#       Length( result.ANUPQautos ) = Length( result.ANUPQgroups ) then
#    	result.ANUPQautos[ Length(result.ANUPQgroups) ]( desc.group );
#    fi;

    # revise images to correspond to images of user-supplied generators 
    datarec.SP := desc.group;
    x  := Length( desc.map );
    k  := Length( GeneratorsOfGroup( datarec.group ) );
    # images of user supplied generators are last k entries in .pqImages 

    datarec.SPepi := GroupHomomorphismByImagesNC( 
                         datarec.group, 
                         datarec.SP, 
                         GeneratorsOfGroup(datarec.group),
                         desc.map{[x - k + 1..x]} );
    #PopOptions();
    return datarec.SPepi;
end );

#############################################################################
##
#F  EpimorphismPqStandardPresentation( <arg> ) . . . . epi. onto SP for group
##
InstallGlobalFunction( EpimorphismPqStandardPresentation, function( arg )
    return PQ_EPIMORPHISM_STANDARD_PRESENTATION( arg );
end );

#############################################################################
##
#F  PqStandardPresentation( <arg> : <options> ) . . . . . . . .  SP for group
##
InstallGlobalFunction( PqStandardPresentation, function( arg )
    local SPepi;

    SPepi := PQ_EPIMORPHISM_STANDARD_PRESENTATION( arg );
    if SPepi = true then
      return true; # the SetupFile case
    fi;
    return Range( SPepi );
end );

#############################################################################
##
#M  EpimorphismStandardPresentation( <F>, <G> ) . .  epi. onto SP for p-group
#M  EpimorphismStandardPresentation( <i>, <G> )
#M  EpimorphismStandardPresentation( <G> )
##
InstallMethod( EpimorphismStandardPresentation, 
               "fp group, pc group",
               [IsFpGroup, IsPcGroup], 0,
               EpimorphismPqStandardPresentation );

InstallMethod( EpimorphismStandardPresentation, 
               "fp group, prime integer",
               [IsFpGroup, IsPosInt], 0,
               EpimorphismPqStandardPresentation );

InstallMethod( EpimorphismStandardPresentation, 
               "positive integer, pc group",
               [IsPosInt, IsPcGroup], 0,
               EpimorphismPqStandardPresentation );

InstallMethod( EpimorphismStandardPresentation, 
               "positive integer, prime integer",
               [IsPosInt, IsPosInt], 0,
               EpimorphismPqStandardPresentation );

InstallOtherMethod( EpimorphismStandardPresentation, "pc group",
                    [IsPcGroup], 0,
                    EpimorphismPqStandardPresentation );

InstallOtherMethod( EpimorphismStandardPresentation, "prime integer",
                    [IsPosInt], 0,
                    EpimorphismPqStandardPresentation );

#############################################################################
##
#M  StandardPresentation( <F>, <G> ) . . . . . . . . . . . . . SP for p-group
#M  StandardPresentation( <i>, <G> )
#M  StandardPresentation( <G> )
##
InstallMethod( StandardPresentation, 
               "fp group, pc group",
               [IsFpGroup, IsPcGroup], 0,
               PqStandardPresentation );

InstallMethod( StandardPresentation, 
               "fp group, prime integer",
               [IsFpGroup, IsPosInt], 0,
               PqStandardPresentation );

InstallMethod( StandardPresentation, 
               "positive integer, pc group",
               [IsPosInt, IsPcGroup], 0,
               PqStandardPresentation );

InstallMethod( StandardPresentation, 
               "positive integer, prime integer",
               [IsPosInt, IsPosInt], 0,
               PqStandardPresentation );

InstallOtherMethod( StandardPresentation, "pc group",
                    [IsPcGroup], 0,
                    PqStandardPresentation );

InstallOtherMethod( StandardPresentation, "prime integer",
                    [IsPosInt], 0,
                    PqStandardPresentation );

#############################################################################
##
#F  IsPqIsomorphicPGroup( <G>, <H> )  . . . . . . . . . . .  isomorphism test
##
InstallGlobalFunction( IsPqIsomorphicPGroup, function( G, H )
    local   p,  class,  SG,  SH,  Ggens,  Hgens;
    
    # <G> and <H> must both be pc groups and p-groups
    if not IsPcGroup(G)  then
        Error( "<G> must be a pc group" );
    fi;
    if not IsPcGroup(H)  then
        Error( "<H> must be a pc group" );
    fi;
    if Size(G) <> Size(H)  then
        return false;
    fi;
    p := SmallestRootInt(Size(G));
    if not IsPrimeInt(p)  then
        Error( "<G> must be a p-group" );
    fi;
    
    # check the Frattini factor
    if RankPGroup(G) <> RankPGroup(H)  then
        return false;
    fi;

    # check the exponent-p-length
    class := Length(PCentralSeries(G,p))-1;
    if class <> Length(PCentralSeries(H,p))-1  then
        return false;
    fi;
    
    # if the groups are elementary abelian they are isomorphic
    if class = 1  then
        return true;
    fi;
    
    # compute a standard presentation for both
    SG := PqStandardPresentation(PqFpGroupPcGroup(G), p : ClassBound := class);
    SH := PqStandardPresentation(PqFpGroupPcGroup(H), p : ClassBound := class);
    
    # the groups are equal if the presentation are equal
    Ggens := GeneratorsOfGroup( FreeGroupOfFpGroup( SG ) );
    Hgens := GeneratorsOfGroup( FreeGroupOfFpGroup( SH ) );
    return RelatorsOfFpGroup(SG)
           = List( RelatorsOfFpGroup(SH), 
                   x -> MappedWord( x, Hgens, Ggens ) );
    
end );

#############################################################################
##
#M  IsIsomorphicPGroup( <F>, <G> )
##
InstallMethod( IsIsomorphicPGroup, "pc group, pc group",
               [IsPcGroup, IsPcGroup], 0,
               IsPqIsomorphicPGroup );

#E  anusp.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
