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
                "MapImages",  #  images of the generators in G
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
#F  PqEpimorphism   . . . . . . . . . . . . . . .  epimorphism onto a p-group
##
InstallGlobalFunction( PqEpimorphism, function( arg )
    local   F,  Fgens,  gens,  x,  r,  outname,  pq,  input,  phi,
            output,  proc,  result,  images,  CR,  string,  cmd;

    # check arguments
    if Length(arg) = 2 and ValueOption("PqChecked") = true then
        # We got here via a call to Pq and the args have been checked already
        F  := arg[1];
        CR := arg[2];
    else
        if Length(arg) < 1  then
    	    Error( "usage: PqEpimorphism( <F> : <control-options> )" );
        fi;
        F := arg[1];
        if not IsFpGroup( F ) then
    	    Error( "first argument must be a finitely presented group" );
        fi;
        if Length(arg) = 1 then
            CR := SET_ANUPQ_OPTIONS( "PqEpimorphism", "Pq" );
        elif IsRecord(arg[2])  then
    	    CR := ShallowCopy(arg[2]);
    	    x := Set( REC_NAMES(CR) );
    	    SubtractSet( x, Set( ANUPQoptions.Pq ) );
    	    if 0 < Length(x)  then
    	        ANUPQerrorPq(x);
    	    fi;
        else
    	    CR := ANUPQextractPqArgs( arg );
        fi;
    fi;

    # at least "Prime" and "Class" must be given
    if not IsBound(CR.Prime)  then
    	Error( "you must supply a prime" );
    fi;
    if not IsBound(CR.ClassBound)  then
    	Error( "you must supply a class bound" );
    fi;

    # set default values
    if not IsBound(CR.Exponent)  then 
    	CR.Exponent := 0;
    fi;
    if not IsBound(CR.Verbose) then 
    	CR.Verbose := false;
    fi;

    string := "#input file for pq\n";

    # setup input string
    Append( string, "1\n" );
    cmd := Concatenation( "prime ", String(CR.Prime), " \n" );
    Append( string, cmd );
    cmd := Concatenation( "class ", String(CR.ClassBound), " \n" );
    Append( string, cmd );
    if CR.Exponent <> 0  then
        cmd := Concatenation( "exponent ", String(CR.Exponent), "\n" );
        Append( string, cmd );
    fi;
    if IsBound(CR.Metabelian)  then 
        Append( string, "metabelian\n" );
    fi;
    if IsBound(CR.OutputLevel)  then
        cmd := Concatenation( "output ", CR.OutputLevel, " \n" );
    	Append( string, cmd );
    fi;

    # create generic generators "g1" ... "gn"
    Fgens := GeneratorsOfGroup( FreeGroupOfFpGroup(F) );
    gens := GeneratorsOfGroup( FreeGroup( Length( Fgens ), "g" ) );
    Append( string, "generators {" );
    for x  in gens  do
    	Append( string, String(x) );
        Append( string, ", " );
    od;
    Append( string, " }\n" );

    # write the presentation using these generators
    Append( string, "relations {" );
    for r  in RelatorsOfFpGroup(F)  do
        Append( string, String( MappedWord(r,Fgens,gens) ) );
        Append( string, ",\n" );
    od;
    Append( string, "}\n;\n" );
    
    # if we only want to setup the file we are ready now
    if IsBound(CR.SetupFile)  then
        Append( string, "8\n25\nPQ_OUTPUT\n2\n0\n0\n" );
    	Print( "#I  input file '", CR.SetupFile, "' written,\n",
    	       "#I    run 'pq' with '-k' flag, the result will be saved in ",
    	       "'PQ_OUTPUT'\n" );
        PrintTo( CR.SetupFile, string );
    	return true;
    fi;

    # otherwise append code to save the output in a temporary file
    outname := TmpName();
    Append( string, Concatenation( "8\n25\n", outname, "\n2\n0\n" ) );
    Append( string, "0\n" );

    # Find the pq executable
    pq := Filename( DirectoriesPackagePrograms( "anupq" ), "pq" );
    if pq = fail then
        Error( "Could not find the pq executable" );
    fi;

    # and finally start the pq
    input := InputTextString( string );
    if CR.Verbose  then 
        output := OutputTextFile( "*stdout*", false );
    else 
        output := OutputTextNone();
    fi;
    proc := Process( DirectoryCurrent(), pq, input, output, [ "-k",  ] );
    CloseStream( output );
    CloseStream( input );
    if proc <> 0 then
        Error( "process did not succeed" );
    fi;
    
    # read group and images from file
    result := ANUPQReadOutput( outname, ANUPQGlobalVariables );

    # remove intermediate files
    Exec( Concatenation( "rm -f ", outname ) );

    phi := GroupHomomorphismByImages( F, result.F, 
                   GeneratorsOfGroup( F ), result.MapImages );
    SetFeatureObj( phi, IsSurjective, true );

    return phi;

end );

#############################################################################
##
#F  Pq( <F> : <options> ) . . . . . . . . . . . . . . . . . .  prime quotient
##
InstallGlobalFunction( Pq, function( arg )
    local   phi,  x,  CR,  F;

    # Is it an interactive Pq call?
    if Length(arg) < 1 or IsInt( arg[1] ) then
    	return PQ_INTERACTIVE( arg );
    fi;

    F := arg[1];
    if not IsFpGroup( F ) then
    	Error( "first argument must be a finitely presented group" );
    fi;
    if Length(arg) = 1 then
        CR := SET_ANUPQ_OPTIONS( "Pq", "Pq" );
    elif IsRecord(arg[2])  then
    	CR := ShallowCopy(arg[2]);
    	x := Set( REC_NAMES(CR) );
    	SubtractSet( x, Set( ANUPQoptions.Pq ) );
    	if 0 < Length(x)  then
    	    ANUPQerrorPq(x);
    	fi;
    else
    	CR := ANUPQextractPqArgs( arg );
    fi;

    phi := PqEpimorphism( F, CR : PqChecked);
    return Image( phi );
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
