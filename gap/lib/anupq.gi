#############################################################################
####
##
#A  anupq.gi                 ANUPQ share package               Eamonn O'Brien
#A                                                             & Frank Celler
##
#A  @(#)$Id$
##
#Y  Copyright 1992-1994,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  Copyright 1992-1994,  School of Mathematical Sciences, ANU,     Australia
##
#H  $Log$
#H  Revision 1.3  2001/05/17 22:40:57  gap
#H  pkg/anupq:
#H    Factored out the common code for interactive and non-interactive versions
#H    of `Pq' and `PqEpimorphism' and defined the two menu item functions
#H    `PqPcPresentation' and `PqWritePcPresentation' on which they depend.
#H    The intention is to put all functions based on menu items of the `pq'
#H    binary in the files gap/lib/anupqi.g[id]. - GG
#H
#H  Revision 1.2  2001/05/10 17:33:23  gap
#H  gap/lib/anupqios.g[id], doc/interact.tex:
#H    - defined and documented various interactive functions, in particular,
#H      `PqStart', `PqQuit', `PqQuitAll' and an interactive version of `Pq'.
#H  doc/intro.tex:
#H    - now describes `ANUPQData' and `InfoANUPQ'.
#H    - the Authors are in their own section.
#H  gap/lib/anupq4r2cpt.g[id]:
#H    - define functions as required for GAP 4.2 compatibility.
#H  - GG
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
Revision.anupq_gi :=
    "@(#)$Id$";


#############################################################################
##
#F  ANUPQDirectoryTemporary( <dir> ) . . . . .  redefine ANUPQ temp directory
##
##  calls the UNIX command `mkdir' to create <dir>, which must be  a  string,
##  and if successful a directory  object  for  <dir>  is  both  assigned  to
##  `ANUPQData.tmpdir'  and  returned.  The  fields  `ANUPQData.infile'   and
##  `ANUPQData.outfile' are also set to be files in  `ANUPQData.tmpdir',  and
##  on exit from {\GAP} <dir> is removed.
##
InstallGlobalFunction(ANUPQDirectoryTemporary, function(dir)
local created;

  # check arguments
  if not IsString(dir) then
    Error(
      "usage: ANUPQDirectoryTemporary( <dir> ) : <dir> must be a string.\n");
  fi; 

  # create temporary directory
  created := Process(DirectoryCurrent(),
                     Filename( DirectoriesSystemPrograms(), "sh" ),
                     InputTextUser(),
                     OutputTextUser(),
                     [ "-c", Concatenation("mkdir ", dir) ]);
  if created = fail then
    return fail;
  fi;

  Add( DIRECTORIES_TEMPORARY, dir );
  ANUPQData.tmpdir  := Directory(dir);
  ANUPQData.infile  := Filename(ANUPQData.tmpdir, "PQ_INPUT");
  ANUPQData.outfile := Filename(ANUPQData.tmpdir, "PQ_OUTPUT");
  return ANUPQData.tmpdir;
end);

#############################################################################
##
#F  ANUPQerrorPq( <param> ) . . . . . . . . . . . . . . . . . report an error
##
InstallGlobalFunction( ANUPQerrorPq, function( param )
    Error(
    "Valid Options:\n",
    "    \"ClassBound\", <bound>\n",
    "    \"Prime\", <prime>\n",
    "    \"Exponent\", <exponent>\n",
    "    \"Metabelian\"\n",
    "    \"OutputLevel\", <level>\n",
    "    \"Verbose\"\n",
    "    \"SetupFile\", <file>\n",
    "    \"PqWorkspace\", <workspace>\n",
    "Illegal Parameter: \"", param, "\"" );
end );

#############################################################################
##
#F  ANUPQextractPqArgs( <args> )  . . . . . . . . . . . . . extract arguments
##
InstallGlobalFunction( ANUPQextractPqArgs, function( args )
    local   CR,  i,  act,  match;

    # allow to give only a prefix
    match := function( g, w )
    	return 1 < Length(g) 
               and Length(g) <= Length(w) 
               and w{[1..Length(g)]} = g;
    end;

    # extract arguments
    CR := rec();
    i  := 2;
    while i <= Length(args)  do
        act := args[i];
        if not IsString( act ) then ANUPQerrorPq( act ); fi;

    	# "ClassBound", <class>
        if match( act, "ClassBound" ) then
            i := i + 1;
            CR.ClassBound := args[i];

    	# "Prime", <prime>
        elif match( act, "Prime" )  then
            i := i + 1;
            CR.Prime := args[i];

    	# "Exponent", <exp>
        elif match( act, "Exponent" )  then
            i := i + 1;
            CR.Exponent := args[i];

        # "Metabelian"
        elif match( act, "Metabelian" ) then
            CR.Metabelian := true;

    	# "Output", <level>
        elif match( act, "OutputLevel" )  then
            i := i + 1;
            CR.OutputLevel := args[i];
    	    CR.Verbose     := true;

    	# "SetupFile", <file>
        elif match( act, "SetupFile" )  then
    	    i := i + 1;
            CR.SetupFile := args[i];

    	# "PqWorkspace", <workspace>
        elif match( act, "PqWorkspace" )  then
    	    i := i + 1;
            CR.PqWorkspace := args[i];

    	# "Verbose"
        elif match( act, "Verbose" ) then
            CR.Verbose := true;

    	# signal an error
    	else
            ANUPQerrorPq( act );

    	fi; 
    	i := i + 1; 
    od;
    return CR;

end );

#############################################################################
##
#V  ANUPQGlobalVariables
##
InstallValue( ANUPQGlobalVariables, 
              [ "F",          #  a free group
                "MapImages"   #  images of the generators in G
                ] );

#############################################################################
##
#F  ANUPQReadOutput . . . . read pq output without affecting global variables
##
InstallGlobalFunction( ANUPQReadOutput, function( file, globalvars )
    local   var,  result;

    for var in globalvars do
        HideGlobalVariables( var );
    od;

    Read( file );

    result := rec();

    for var in globalvars do
        if IsBoundGlobal( var ) then
            result.(var) := ValueGlobal( var );
        else
            result.(var) := fail;
        fi;
    od;

    for var in globalvars do
        UnhideGlobalVariables( var );
    od;
    
    return result;
end );

#############################################################################
##
#F  PqEpimorphism( <arg> : <options> )  . . . . .  epimorphism onto a p-group
##
InstallGlobalFunction( PqEpimorphism, function( arg )
    return PQ_EPIMORPHISM( arg );
end );

#############################################################################
##
#F  Pq( <arg> : <options> )  . . . . . . . . . . . . . . . . . prime quotient
##
InstallGlobalFunction( Pq, function( arg )
    local pQepi;

    pQepi := PQ_EPIMORPHISM( arg );
    if pQepi = true then
      return true; # the SetupFile case
    fi;
    return Image( pQepi );
end );

#############################################################################
##
#F  PQ_EPIMORPHISM( <arglist> : <options> ) . . .  prime quotient epimorphism
##
InstallGlobalFunction( PQ_EPIMORPHISM, function( arglist )
    local   interactive, x, CR, datarec, infile, outfile, workspace, opts,
            pqOpening, output, proc;

    interactive := Length(arglist) < 1 or IsInt( arglist[1] );
    if interactive then
        ANUPQ_IOINDEX_ARG_CHK(arglist);
        datarec := ANUPQData.io[ ANUPQ_IOINDEX(arglist) ];
        outfile := ANUPQData.outfile;
    elif Length(arglist) = 1 then
        datarec := ANUPQData;
        datarec.menu := "SP";
        datarec.group := arglist[1];
        if not IsFpGroup( datarec.group ) then
    	    Error( "first argument must be a finitely presented group" );
        fi;
        infile := ValueOption( "SetupFile" );
        workspace := ValueOption( "PqWorkspace" );
        opts := "-i -k";
        if IsInt(workspace) then
            opts := Concatenation( opts, " -s ", String(workspace) );
        fi;
        if infile = fail then
            infile := ANUPQData.infile;
            outfile := ANUPQData.outfile;
            pqOpening := [ "#pq called with flags: '", opts, "'" ];
        else
            outfile := "PQ_OUTPUT";
            pqOpening := [ "#pq called with flags: '", opts, "'" ];
        fi;
        datarec.stream := OutputTextFile(infile, false);
        ToPQ(datarec, pqOpening);
    else
        # GAP 3 way of passing options is supported in non-interactive use
        if IsRecord(arglist[2]) then
            CR := ShallowCopy(arglist[2]);
            x := Set( REC_NAMES(CR) );
            SubtractSet( x, Set( ANUPQoptions.Pq ) );
            if not IsEmpty(x) then
                ANUPQerrorPq(x);
            fi;
        else
    	    CR := ANUPQextractPqArgs( arglist );
        fi;
        PushOptions(CR);
        PQ_EPIMORPHISM( arglist{[1]} );
        PopOptions();
        return ANUPQData.pQepi;
    fi;

    if not interactive or not IsBound(datarec.haspcp) then
        PQ_PC_PRESENTATION(datarec);
        if interactive then
            datarec.haspcp := true;
        fi;
    fi;

    PQ_WRITE_PC_PRESENTATION(datarec, ANUPQData.outfile);
    
    if not interactive then
        PQ_MENU(datarec, "SP");
        ToPQ(datarec, [ "0  #exit program" ]);
        CloseStream(datarec.stream);

        if ValueOption( "SetupFile" ) <> fail then
            Info(InfoANUPQ, 1, "Input file: '", infile, "' written.");
            Info(InfoANUPQ, 1, "Run `pq' with '", opts, "' flags.");
            Info(InfoANUPQ, 1, "The result will be saved in: 'PQ_OUTPUT'");
            return true;
        fi;

        if ValueOption( "Verbose" ) = true or
           IsPosInt( ValueOption( "OutputLevel" ) ) or
           InfoLevel(InfoANUPQ) >= 2 then
            output := OutputTextFile( "*stdout*", false );
        else 
            output := OutputTextNone();
        fi;
        proc := Process( 
                  ANUPQData.tmpdir, 
                  Filename( DirectoriesSystemPrograms(), "sh" ),
                  InputTextUser(),
                  output,
                  [ "-c", 
                    Concatenation(ANUPQData.binary, " ", opts, " <", infile) ]
                  );
        CloseStream( output );
        if proc <> 0 then
            Error( "process did not succeed" );
        fi;
    fi;
    
    # read group and images from file
    HideGlobalVariables( "F", "MapImages" );
    Read( outfile );
    datarec.pQuotient := ValueGlobal( "F" );
    datarec.pQepi := GroupHomomorphismByImages( 
                       datarec.group,
                       datarec.pQuotient,
                       GeneratorsOfGroup( datarec.group ),
                       ValueGlobal( "MapImages" )
                       );
    SetFeatureObj( datarec.pQepi, IsSurjective, true );
    UnhideGlobalVariables( "F", "MapImages" );
    return datarec.pQepi;
end );

#############################################################################
##
#F  PqRecoverDefinitions( <G> ) . . . . . . . . . . . . . . . . . definitions
##
##  This function finds a definition for each generator of the p-group <G>.
##  These definitions need not be the same as the ones used by pq.  But
##  they serve the purpose of defining each generator as a commutator or
##  power of earlier ones.  This is useful for extending an automorphism that
##  is given on a set of minimal generators of <G>.
##
InstallGlobalFunction( PqRecoverDefinitions, function( G )
    local   col,  gens,  definitions,  h,  g,  rhs,  gen;

    col  := ElementsFamily( FamilyObj( G ) )!.rewritingSystem;
    gens := GeneratorsOfRws( col );

    definitions := [];

    for h in [1..NumberGeneratorsOfRws( col )] do
        rhs := GetPowerNC( col, h );
        if Length( rhs ) = 1 then
            gen := Position( gens, rhs );
            if not IsBound( definitions[gen] ) then
                definitions[gen] := h;
            fi;
        fi;
        
        for g in [1..h-1] do
            rhs := GetConjugateNC( col, h, g );
            if Length( rhs ) = 2 then
                gen := SubSyllables( rhs, 2, 2 );
                gen := Position( gens, gen );
                if not IsBound( definitions[gen] ) then
                    definitions[gen] := [h, g];
                fi;
            fi;
        od;
    od;
    return definitions;
end );

#############################################################################
##
#F  PqAutomorphism( <epi>, <autoimages> ) . . . . . . . . . . . . definitions
##
##  Take an automorphism of the preimage and produce the induced automorphism
##  of the image of the epimorphism.
##
InstallGlobalFunction( PqAutomorphism, function( epi, autoimages )
    local   G,  p,  gens,  definitions,  d,  epimages,  i,  pos,  def,  
            phi;

    G      := Image( epi );
    p      := PrimeOfPGroup( G );
    gens   := GeneratorsOfGroup( G );
    
    autoimages := List( autoimages, im->Image( epi, im ) );

    ##  Get a definition for each generator.
    definitions := PqRecoverDefinitions( G );
    d := Number( [1..Length(definitions)], 
                 i->not IsBound( definitions[i] ) );

    ##  Find the images for the defining generators of G under the
    ##  automorphism.  We have to be careful, as some of the generators for
    ##  the source might be redundant as generators of G.
    epimages := List( GeneratorsOfGroup(Source(epi)), g->Image(epi,g) );
    for i in [1..d] do
        ##  Find G.i ...
        pos := Position( epimages, G.(i) );
        if pos = fail then 
            Error( "generators ", i, "not image of a generators" );
        fi;
        ##  ... and set its image.
        definitions[i] := autoimages[pos];
    od;
        
    ##  Replace each definition by its image under the automorphism.
    for i in [d+1..Length(definitions)] do
        def := definitions[i];
        if IsInt( def ) then
            definitions[i] := definitions[ def ]^p;
        else
            definitions[i] := Comm( definitions[ def[1] ],
                                    definitions[ def[2] ] );
        fi;
    od;
            
    phi := GroupHomomorphismByImages( G, G, gens, definitions );
    SetFeatureObj( phi, IsBijective, true );

    return phi;
end );

#E  anupq.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
