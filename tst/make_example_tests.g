#############################################################################
##
##  Generates tst/examples/<name>.tst for the examples in examples/:
##
##      gap -A -q tst/make_example_tests.g
##
##  A test runs the statements that PqExample( <name> ) runs and, for an
##  example with an interactive form, those of PqExample( <name>, PqStart ),
##  in both cases without options. Test's rewriteToFile option fills in the
##  expected output, so check the diff before committing.
##

LoadPackage( "anupq" );

# prints timing data
EXCLUDED := [ "EpimorphismStandardPresentation-i" ];

# the manual examples in tst/anupq0*.tst run the same statements
COVERED_BY_MANUAL := rec(
    plain := [ "B5-5-Engel3-Id", "EpimorphismStandardPresentation",
               "IsIsomorphicPGroup-ni", "Pq", "Pq-ni", "PqDescendants-1",
               "PqDescendants-1-i", "PqDescendants-2", "PqDescendants-3",
               "PqDescendants-treetraverse-i", "PqEpimorphism", "PqPCover",
               "PqSupplementInnerAutomorphisms", "StandardPresentation" ],
    interactive := [ "PqDescendants-1", "PqDescendants-2",
                     "PqDescendants-3" ] );

#############################################################################
##
##  ExampleStatements( <file>, <interactive> )
##
##  returns the statements of an example file as test input, and the names
##  from its #vars: line. Lines are treated as PqExample treats them when no
##  options are given, and statements end where PqExample ends them.
##
ExampleStatements := function( file, interactive )
    local CompoundKeywords, lines, i, line, vars, action, words, input,
          isCompound, depth, out;

    CompoundKeywords := line -> Filtered( SplitString( line, "", "( ;\n" ),
        w -> w in [ "do", "od", "if", "fi", "repeat", "until", "function",
                    "end" ] );

    lines := SplitString( StringFile( file ), "\n" );
    if Last( lines ) = "" then
        Remove( lines );
    fi;
    lines := List( lines, l -> Concatenation( l, "\n" ) );
    i := PositionProperty( lines, l -> IsMatchingSublist( l, "#vars:" ) );
    vars := SplitString( lines[i]{[ 7 .. Position( lines[i], ';' ) - 1 ]},
                         "", " ," );
    i := PositionProperty( lines, l -> IsMatchingSublist( l, "#options:" ) );

    out := "";
    input := "";
    action := fail;
    for line in lines{[ i + 1 .. Length( lines ) ]} do
        if IsMatchingSublist( line, "#comment:" ) then
            continue;
        fi;

        # #alt lines act on the interactive form only; without options,
        # #sub leaves the next line unchanged and #add leaves it commented
        if action <> fail then
            if interactive and IsMatchingSublist( action, "#alt: do" ) then
                line := line{[ 2 .. Length( line ) ]};
            elif interactive and IsMatchingSublist( action, "#alt: sub" ) then
                words := SplitString( action, "", "# <>\n" );
                line := ReplacedString( line, words[5], words[3] );
            fi;
            action := fail;
        elif Length( line ) > 3 and
             line{[ 1 .. 4 ]} in [ "#sub", "#add", "#alt" ] then
            action := line;
            continue;
        fi;

        if IsMatchingSublist( line, "##" ) then
            # a comment PqExample shows
            if input = "" then
                Append( out, "gap> " );
            else
                Append( out, "> " );
            fi;
            Append( out, line{[ 2 .. Length( line ) ]} );
            continue;
        elif line[1] = '#' or ( line = "\n" and input = "" ) then
            continue;
        fi;

        if input = "" then
            Append( out, "gap> " );
            words := CompoundKeywords( line );
            isCompound := not IsEmpty( words );
            depth := 0;
        else
            Append( out, "> " );
            words := [];
            if isCompound and depth > 0 then
                words := CompoundKeywords( line );
            fi;
        fi;
        depth := depth + Number( words, w -> w in [ "do", "if", "repeat",
                                                    "function" ] )
                       - Number( words, w -> w in [ "od", "fi", "until",
                                                    "end" ] );
        Append( out, line );
        if line = "\n" then
            continue;
        fi;
        Append( input, line );
        if Position( input, ';' ) <> fail and
           ( not isCompound or depth = 0 ) then
            input := "";
        fi;
    od;
    return rec( input := out, vars := vars );
end;

#############################################################################
##
##  UnbindVars( <vars> )
##
##  returns test input unbinding <vars>, so that output such as the warnings
##  of AssignGeneratorVariables does not depend on the tests run before.
##
UnbindVars := vars -> Concatenation(
    "gap> Perform( ", String( vars ), ",\n",
    ">      function( v ) if IsBoundGlobal( v ) then UnbindGlobal( v ); ",
    "fi; end );\n" );

MakeExampleTests := function()
    local exdir, tstdir, generated, name, hasInteractive, parts, s, file,
          stale;

    exdir := DirectoriesPackageLibrary( "anupq", "examples" );
    tstdir := Filename( DirectoriesPackageLibrary( "anupq", "tst" ),
                        "examples" );
    if tstdir = fail then
        Error( "tst/examples does not exist" );
    fi;

    generated := [];
    for name in Difference( AllPqExamples(), EXCLUDED ) do
        hasInteractive := not ( Length( name ) > 2 and
            name{[ Length( name ) - 1 .. Length( name ) ]} in
            [ "-i", "ni", ".g" ] );
        parts := [];
        if not name in COVERED_BY_MANUAL.plain then
            s := ExampleStatements( Filename( exdir, name ), false );
            Add( parts, Concatenation( "gap> PqQuitAll();\n",
                                       UnbindVars( s.vars ), s.input ) );
        fi;
        if hasInteractive and not name in COVERED_BY_MANUAL.interactive then
            s := ExampleStatements( Filename( exdir, name ), true );
            Add( parts, Concatenation(
                "\n# interactive form: PqExample( \"", name, "\", PqStart )\n",
                "gap> PqQuitAll();\n", UnbindVars( s.vars ), s.input ) );
        fi;
        if IsEmpty( parts ) then
            continue;
        fi;

        file := Concatenation( tstdir, "/", name, ".tst" );
        FileString( file, Concatenation(
            "# Generated by tst/make_example_tests.g from examples/", name,
            "\ngap> START_TEST( \"", name, ".tst\" );\n",
            "gap> SetInfoLevel( InfoANUPQ, 1 );\n",
            Concatenation( parts ),
            "\n#\ngap> PqQuitAll();\n",
            "gap> STOP_TEST( \"", name, ".tst\", 1 );\n" ) );
        Test( file, rec( rewriteToFile := true, reportDiff := Ignore ) );
        Add( generated, Concatenation( name, ".tst" ) );

        if PositionSublist( StringFile( file ), "\nError" ) <> fail then
            Print( "#W  ", file, " expects an error\n" );
        fi;
    od;

    stale := Difference( Filtered( DirectoryContents( tstdir ),
                                   f -> EndsWith( f, ".tst" ) ),
                         generated );
    if not IsEmpty( stale ) then
        Print( "#W  not generated, remove: ", stale, "\n" );
    fi;
    Print( "#I  generated ", Length( generated ), " test files\n" );
end;

MakeExampleTests();
QUIT;
