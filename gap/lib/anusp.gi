#############################################################################
####
##
#A  anusp.gi                 ANUPQ share package               Eamonn O'Brien
#A                                                             Alice Niemeyer 
##
#A  @(#)$Id$
##
#Y  Copyright 1993-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  Copyright 1993-2001,  School of Mathematical Sciences, ANU,     Australia
##
#H  $Log$
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
#F  InfoANUPQSP1  . . . . . . . . . . . . . . . . . . . . . debug information
#F  InfoANUPQSP2  . . . . . . . . . . . . . . . . . . . . . debug information
##
if not IsBound(InfoANUPQSP1)  then InfoANUPQSP1 := Print;    fi;
if not IsBound(InfoANUPQSP2)  then InfoANUPQSP2 := Ignore;   fi;

##  ANUPQtmpDir can be used to supply a name for a temporary directory.
if not IsBound( ANUPQtmpDir ) then ANUPQtmpDir := "ThisIsAHack"; fi;

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
    "    \"TmpDir\"\n",
    "    \"Verbose\"\n",
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
#F  PqFpGroupPcGroup( <G> )
##
InstallGlobalFunction( PqFpGroupPcGroup, function( G )
    local   r;

    r := FpGroupPcGroupSQ( G );

    return r.group / r.relators;
end );

#############################################################################
##
#M  FpGroupPcGroup( <F>, <G> ... )
##
InstallMethod( FpGroupPcGroup, "pc group", [IsPcGroup], 0, PqFpGroupPcGroup );

#############################################################################
##
#F  PQ_EPIMORPHISM_STANDARD_PRESENTATION( <args> ) . . epi. onto SP for group
##
InstallGlobalFunction( PQ_EPIMORPHISM_STANDARD_PRESENTATION, 
function( args )
    local   datarec, p_or_G, rank, p, G, automorphisms, generators, x,
            images, i, r, j, aut, success, outfile, result, desc, k;

    datarec := ANUPQ_ARG_CHK(2, "StandardPresentation", "group", 
                             IsFpGroup,  "an fp group", args);
    p_or_G := args[ Length(args) ];
    if IsInt(p_or_G)  then
    	p := p_or_G;
        if not IsPrimeInt(p)  then
            Error( "<p> must be a prime" );
        fi;
        rank := Number( List( AbelianInvariants(datarec.group), x->Gcd(x,p) ),
                        y->y=p );

        # construct free group with <rank> generators
        G := FreeGroup( rank, "g" );
    
        # construct power-relation
        G := G / List( GeneratorsOfGroup(G), x -> x^p );
    
        # construct pc group
        G := PcGroupFpGroup(G);
    
        # construct automorphism
        automorphisms := [];
        generators := GeneratorsOfGroup(G);
        for x in GeneratorsOfGroup( GL(rank,p) ) do
            images := [];
            for i  in [ 1 .. rank ]  do
                r := One(G);
                for j  in [ 1 .. rank ]  do
                    r := r * generators[j]^Int(x[i][j]);
                od;
                images[i] := r;
            od;
            aut := GroupHomomorphismByImages( G, G, generators, images );
            SetIsBijective( aut, true );
            Add( automorphisms, aut );
        od;
        SetAutomorphismGroup( G, GroupByGenerators( automorphisms ) );
    else
        G := p_or_G;
        if not IsPcGroup(G)  then
            Error( "<G> must be a pc group" );
        elif not HasAutomorphismGroup(G)  then
            Error( "the automorphism group of <G> must be known" );
        fi;
        p := PrimeOfPGroup( G );
    fi;
    
    if datarec.calltype <> "interactive" or 
       not IsBound(datarec.pcp) or 
       ForAny( REC_NAMES( datarec.pcp ), 
               optname -> not(ValueOption(optname) in
                              [fail, datarec.pcp.(optname)]) ) then
        # only do it in the interactive case if it hasn't already been done
        # by checking whether options stored in datarec.pcp differ from those
        # of a previous call ... if a check of an option value returns `fail'
        # it is assumed the user intended the previous value stored in
        # `<datarec>.pcp' (this is potentially problematic for boolean
        # options, to reverse a previous `true', `false' must be explicitly
        # set for the option on the subsequent function call)
        
        PQ_SP_PC_PRESENTATION(datarec : Prime := p, 
                                        ClassBound := PClassPGroup(G));
    fi;

    datarec.pQuotient := G;
    PQ_SP_STANDARD_PRESENTATION(datarec);

    PQ_SP_ISOMORPHISM(datarec);

    if datarec.calltype <> "interactive" then
        success := PQ_COMPLETE_NONINTERACTIVE_FUNC_CALL(datarec);
        if success = true then
            return true;
        elif success <> 0 then
            Error( "process did not succeed\n" );
        fi;
    fi;

    # try to read output
    outfile := Filename( ANUPQData.tmpdir, "GAP_library" );
    result := ANUPQReadOutput( outfile, ANUSPGlobalVariables );

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
    datarec.sp := desc.group;
    x  := Length( desc.map );
    k  := Length( GeneratorsOfGroup( datarec.group ) );
    # images of user supplied generators are last k entries in .pqImages 

    datarec.spEpi := GroupHomomorphismByImagesNC( 
                         datarec.group, 
                         datarec.sp, 
                         GeneratorsOfGroup(datarec.group),
                         desc.map{[x - k + 1..x]} );
    return datarec.spEpi;
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
    local spEpi;

    spEpi := PQ_EPIMORPHISM_STANDARD_PRESENTATION( arg );
    if spEpi = true then
      return true; # the SetupFile case
    fi;
    return Image( spEpi );
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
