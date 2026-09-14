#############################################################################
####
##
#A  anupq.gi                    ANUPQ package                  Eamonn O'Brien
#A                                                             & Frank Celler
##
#Y  Copyright 1992-1994,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  Copyright 1992-1994,  School of Mathematical Sciences, ANU,     Australia
##

#############################################################################
##
#F  ANUPQDirectoryTemporary( <dir> ) . . . . .  redefine ANUPQ temp directory
##
##  calls the UNIX command `mkdir' to create <dir>, which must be  a  string,
##  and if successful a directory  object  for  <dir>  is  both  assigned  to
##  `ANUPQData.tmpdir' and returned. The field  `ANUPQData.outfile'  is  also
##  set to be a file in `ANUPQData.tmpdir', and on exit from {\GAP} <dir>  is
##  removed.
##
InstallGlobalFunction(ANUPQDirectoryTemporary, function(dir)
local created;

  # check arguments
  if not IsString(dir) then
    Error(
      "usage: ANUPQDirectoryTemporary( <dir> ) : <dir> must be a string.\n");
  fi; 

  # create temporary directory
  CreateDir(dir);
  if not IsDirectoryPath(dir) then
    return fail;
  fi;

  Add( GAPInfo.DirectoriesTemporary, dir );
  ANUPQData.tmpdir  := Directory(dir);
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
#F  PQ_READ_AS_FUNC_WITH_VARS
##
BindGlobal("PQ_READ_AS_FUNC_WITH_VARS", function(files, vars)
    local f, s, stream, v;
    # FIXME: this function is not great if `file` is huge, because we read all
    # of it into memory first. A better way would be a dedicated
    # stream implementation that allows concatenating streams. Or else
    # a kernel variant of this function
    if Length(vars) > 50 then
        # TODO: Warn about this? it will be slow
    fi;
    s := Concatenation("local __TMP_RESULT__,", JoinStringsWithSeparator(vars), ";\n");
    for v in vars do
        Append(s, v); Append(s, " := fail;\n");
    od;
    if IsString(files) then
        Append(s, StringFile(files));
    else
        for f in files do
            Append(s, StringFile(f));
        od;
    fi;
    Append(s, "__TMP_RESULT__ := rec();\n");
    for v in vars do
        Append(s, Concatenation("if IsBound(",v,") then __TMP_RESULT__.",v,":=",v,"; fi;\n"));
    od;
    Append(s, "return __TMP_RESULT__;");
    stream := InputTextString(s);
    f := ReadAsFunction(stream);
    CloseStream(stream);
    return f();
end);


#############################################################################
##
#F  ANUPQReadOutput . . . . read pq output without affecting global variables
##
InstallGlobalFunction( ANUPQReadOutput, function( file )
    local globalvars, var, result;

    globalvars := [ "ANUPQmagic", "ANUPQautos", "ANUPQgroups" ];

    result := PQ_READ_AS_FUNC_WITH_VARS(file, globalvars);

    for var in globalvars do
        if not IsBound( result.(var) ) then
            result.(var) := fail;
        fi;
    od;

    return result;
end );

#############################################################################
##
#F  PqEpimorphism( <arg> : <options> ) . . . . .  epimorphism onto p-quotient
##
InstallGlobalFunction( PqEpimorphism, function( arg )
    return PQ_EPI_OR_PCOVER(arg : PqEpiOrPCover := "pQepi");
end );

#############################################################################
##
#F  Pq( <arg> : <options> ) . . . . . . . . . . . . . . . . . . .  p-quotient
##
InstallGlobalFunction( Pq, function( arg )
    return PQ_EPI_OR_PCOVER(arg : PqEpiOrPCover := "pQuotient");
end );

#############################################################################
##
#F  PqPCover( <arg> : <options> ) . . . . . .  p-covering group of p-quotient
##
InstallGlobalFunction( PqPCover, function( arg )
    return PQ_EPI_OR_PCOVER(arg : PqEpiOrPCover := "pCover");
end );

#############################################################################
##
#F  PQ_GROUP_FROM_PCP(<datarec>,<out>) . extract gp from pq pcp file into GAP
##
InstallGlobalFunction( PQ_GROUP_FROM_PCP, function( datarec, out )
    local result, gens;
    result := PQ_READ_AS_FUNC_WITH_VARS(datarec.outfname, [ "F", "MapImages" ]);
    if out = "pCover" then
      datarec.pCover := result.F;
      IsPGroup( datarec.pCover );
    else
      if IsBound(datarec.pcgs) then
        gens := datarec.pcgs;
      else
        gens := GeneratorsOfGroup( datarec.group );
      fi;
      datarec.pQepi := GroupHomomorphismByImagesNC( 
                           datarec.group,
                           result.F,
                           gens,
                           result.MapImages
                           );
      SetIsSurjective( datarec.pQepi, true );
      datarec.pQuotient := Image( datarec.pQepi );
      IsPGroup( datarec.pQuotient );
    fi;
end );

#############################################################################
##
#F  TRIVIAL_PQ_GROUP(<datarec>, <out>) . . . extract gp when trivial into GAP
##
InstallGlobalFunction( TRIVIAL_PQ_GROUP, function( datarec, out )
local Q;
    Q := TrivialGroup( IsPcGroup );
    if out = "pCover" then
      datarec.pCover := Q;
      IsPGroup( datarec.pCover );
    else
      datarec.pQepi := GroupHomomorphismByFunction( 
                           datarec.group, Q, g -> One(Q) );
      SetIsSurjective( datarec.pQepi, true );
      datarec.pQuotient := Image( datarec.pQepi );
      IsPGroup( datarec.pQuotient );
    fi;
end );

#############################################################################
##
#F  PQ_EPI_OR_PCOVER(<args>:<options>) .  p-quotient, its epi. or its p-cover
##
InstallGlobalFunction( PQ_EPI_OR_PCOVER, function( args )
    local   out, datarec, AtClass, trivial;

    out := ValueOption("PqEpiOrPCover");
    datarec := ANUPQ_ARG_CHK("Pq", args);
    datarec.filter := ["Output file in", "Group presentation"];
    VALUE_PQ_OPTION("Identities", [], datarec);
    if datarec.calltype = "GAP3compatible" then
        # ANUPQ_ARG_CHK calls PQ_EPI_OR_PCOVER itself in this case
        # (so datarec.(out) has already been computed)
        return datarec.(out);
    fi;
    trivial := IsEmpty( datarec.group!.GeneratorsOfMagmaWithInverses );
    if trivial then
        ; #the `pq' binary spits out nonsense if given a trivial pres'n
    elif datarec.calltype = "interactive" and 
         ( IsBound(datarec.pQuotient) or IsBound(datarec.pCover) ) then
        AtClass := function()
          return IsBound(datarec.complete) and datarec.complete or
                 IsBound(datarec.class) and datarec.class = datarec.ClassBound;
        end;

        if IsBound(datarec.pcoverclass) and 
           datarec.pcoverclass = datarec.class and not AtClass() then
            # ``reduce'' the p-cover to a p-class
            PQ_FINISH_NEXT_CLASS( datarec );
        fi;
        while not AtClass() do
            PQ_NEXT_CLASS( datarec );
        od;
        # the following is not executed if the while-loop is 
        # executed at least once
        if IsBound( datarec.(out) ) then
            return datarec.(out); # it had already been computed
        fi;
    else
        PQ_PC_PRESENTATION(datarec, "pQ");
        if datarec.class < Minimum(63, datarec.ClassBound) then
            datarec.complete := true;
        fi;
    fi;

    trivial := trivial or IsEmpty(datarec.ngens) or datarec.ngens[1] = 0;
    if not trivial then
        if out = "pCover" then
          PQ_P_COVER( datarec );
        fi;

        PushOptions( rec(nonuser := true) );
        PQ_WRITE_PC_PRESENTATION(datarec, datarec.outfname);
        PopOptions();
    fi;
    
    if datarec.calltype = "non-interactive" then
        PQ_COMPLETE_NONINTERACTIVE_FUNC_CALL(datarec);
        if IsBound( datarec.setupfile ) then
          if trivial then
            return fail;
          fi;
          return true;
        fi;
    fi;
            
    if trivial then
        TRIVIAL_PQ_GROUP( datarec, out );
    else
        # read group and images from file
        PQ_GROUP_FROM_PCP( datarec, out );
    fi;
    return datarec.(out);
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
    p      := PrimePGroup( G );
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
    SetIsBijective( phi, true );

    return phi;
end );

#############################################################################
##
#F  PqLeftNormComm( <words> ) . . . . . . . . . . . . .  left norm commutator
##
##  returns for a list <words> of words in the generators of a group the left
##  norm commutator of <words>, e.g.~if <w1>, <w2>, <w3>  are  words  in  the
##  generators of some free or fp group then  `PqLeftNormComm(  [<w1>,  <w2>,
##  <w3>] );' is equivalent to `Comm( Comm( <w1>, <w2> ), <w3> );'. Actually,
##  the only restrictions on <words> are that <words> must constitute a  list
##  of group elements of the  same  group  (so  a  list  of  permutations  is
##  allowed, for example) and that <words> must contain at least *two* words.
##
InstallGlobalFunction( PqLeftNormComm, function( words )
local fam, comm, word;
  if not IsList(words) or 2 > Length(words) or 
     not ForAll(words, IsMultiplicativeElementWithInverse) then
    Error( "<words> should be a list of at least 2 group elements\n" );
  else
    fam := FamilyObj(words[1]);
    if not ForAll(words, w -> IsIdenticalObj(FamilyObj(w), fam)) then
      Error( "<words> should belong to the same group\n" );
    fi;
  fi;
  comm := words[1];
  for word in words{[2 .. Length(words)]} do
    comm := Comm(comm, word);
  od;
  return comm;
end );

#############################################################################
##
#F  PqGAPRelators( <group>, <rels> ) . . . . . . . . pq relators as GAP words
##
##  returns a list of words that {\GAP} understands, given a list  <rels>  of
##  strings in the string representations of the generators of the  fp  group
##  <group> prepared as a list of relators for the `pq' program.
##
##  *Note:*
##  The `pq' program does not  use  `/'  to  indicate  multiplication  by  an
##  inverse and uses square brackets to represent (left normed)  commutators.
##  Also, even though the `pq' program accepts  relations,  all  elements  of
##  <rels> *must* be in relator form, i.e.~a relation of form `<w1>  =  <w2>'
##  must be written as `<w1>*(<w2>)^-1'.
##
##  Here is an example:
##
##  \beginexample
##  gap> F := FreeGroup("a", "b");
##  gap> PqGAPRelators(F, [ "a*b^2", "[a,b]^2*a", "([a,b,a,b,b]*a*b)^2*a" ]);
##  [ a*b^2, a^-1*b^-1*a*b*a^-1*b^-1*a*b*a, b^-1*a^-1*b^-1*a^-1*b*a*b^-1*a*b*a^
##      -1*b*a^-1*b^-1*a*b*a*b^-1*a^-1*b^-1*a^-1*b*a*b^-1*a*b^-1*a^-1*b*a^-1*b^
##      -1*a*b*a*b*a^-1*b*a*b^-1*a*b*a^-1*b*a^-1*b^-1*a*b*a*b^-1*a^-1*b^-1*a^
##      -1*b*a*b^-1*a*b^-1*a^-1*b*a^-1*b^-1*a*b*a*b^2*a*b*a ]
##  \endexample
##
InstallGlobalFunction( PqGAPRelators, function( group, rels )
local gens, relgens, diff, f;
  if not( IsFpGroup(group) ) then
    Error("<group> must be an fp group\n");
  fi;
  gens := List( FreeGeneratorsOfFpGroup(group), String );
  if not ForAll(rels, rel -> Position(rel, '/') = fail) then
    Error( "pq binary does not understand `/' in relators\n" );
  fi;
  relgens := Set( Concatenation( 
                      List( rels, rel -> Filtered(
                                             SplitString(rel, "", "*[]()^, "),
                                             str -> Int(str) = fail) ) ) );
  diff := Difference(relgens, gens);
  if not IsEmpty(diff) then
    Error( "generators: ", diff, 
           "\nare not among the generators of the group supplied\n" );
  fi;

  # The following is a HACK to cheaply evaluator the given relator expressions:
  # we first substitute commutator expressions in the given relator strings by
  # corresponding calls to the GAP function `PqLeftNormComm` ....
  rels := List( rels, rel -> ReplacedString(
                               ReplacedString(rel, "]", "])"),
                               "[", "PqLeftNormComm(["
                               ) );
  # and then use `ReadAsFunction` to create a function without arguments,
  # which when called returns a function taking the generators of `group` as
  # arguments, and evaluates the given relators on these.
  #
  # We have to create these two functions because `ReadAsFunction` does not
  # allow us to specify arguments for the function it creates (it would be
  # nice if it did).
  f := ReadAsFunction(InputTextString(Concatenation(
      "return {", JoinStringsWithSeparator(gens), "} -> [", JoinStringsWithSeparator(rels), "];"
      )))();

  return CallFuncList(f, FreeGeneratorsOfFpGroup(group));
end );

#############################################################################
##
#F  PqParseWord( <F>, <word> ) . . . . . . . . . . . . parse word through GAP
#F  PqParseWord( <n>, <word> )
##
##  parse <word> through {\GAP}, where <word> is a string representing a word
##  in the generators of <F> (the first form  of  `PqParseWord')  or  <n>  pc
##  generators `x1,...,x<n>'. `PqParseWord' is provided as a  rough-and-ready
##  check of <word> for syntax errors. A syntax error will cause the entering
##  of a `break'-loop,  in  which  the  error  message  may  or  may  not  be
##  meaningful (depending on whether the syntax  error  gets  caught  at  the
##  {\GAP} or kernel level).
##
##  *Note:*
##  The reason the generators *must* be `x1,...,x<n>' in the second  form  of
##  `PqParseWord' is that these are the pc generator names used by  the  `pq'
##  program (as distinct from the generator names for the group  provided  by
##  the user to a function like `Pq' that invokes the `pq' program).
##
InstallGlobalFunction( PqParseWord, function( n, word )
local ParseOnBreak, ParseOnBreakMessage, NormalOnBreak, NormalOnBreakMessage,
      parts, gens;

  if IsGroup(n) or
     Position(word, '[') <> fail or Position(word, '(') <> fail then
    #pass word through GAP's parser to see if it's ok
      
    NormalOnBreak := OnBreak;
    ParseOnBreak := function()
      Where(0);
      OnBreak := NormalOnBreak;
    end;
    OnBreak := ParseOnBreak;

    if IsFunction(OnBreakMessage) then
      NormalOnBreakMessage := OnBreakMessage;
      ParseOnBreakMessage := function()
        Print( " syntax error in: ", word, "\n" );
        Print( " you can type: 'quit;' to quit to outer loop.\n" );
        OnBreakMessage := NormalOnBreakMessage;
      end;
      OnBreakMessage := ParseOnBreakMessage;
    fi;

    if IsGroup(n) then
      PqGAPRelators(n, [ word ]);
    else
      PqGAPRelators(FreeGroup(n, "x"), [ word ]);
    fi;

    OnBreak := NormalOnBreak;
    if IsFunction(OnBreakMessage) then
      OnBreakMessage := NormalOnBreakMessage;
    fi;
    
  else
    parts := List( SplitString(word, "*"), part -> SplitString(part, "^") );
    if ForAny( parts, part -> 2 < Length(part) or
                              2 = Length(part) and not IsInt( Int(part[2]) ) )
       then
      Error( "detected invalid exponent in argument <word>: ", word, "\n");
    fi;
    if ForAny( parts, part -> IsEmpty( part[1] ) or part[1][1] <> 'x' ) then
      Error( "generators in argument <word> must all be of form:\n",
             "`x<i>' for some integer <i>\n" );
    fi;
    gens := List( parts, part -> Int( part[1]{[2 .. Length(part[1])]} ) );
    if not ForAll(gens, gen -> IsPosInt(gen) and gen <= n) then
      Error( "generators in argument <word> must be in the range: ",
             "x1,...,x", n, "\n" );
    fi;
  fi;
  return true;
end );

#############################################################################
##
#F  PqExample() . . . . . . . . . . execute a pq example or display the index
#F  PqExample( <example>[, PqStart][, Display] )
#F  PqExample( <example>[, PqStart][, <filename>] )
##
##  With no arguments,  or  with  single  argument  `"index"',  or  a  string
##  <example> that is not the name of a file in the `examples' directory,  an
##  index of available examples is displayed.
##
##  With just the one argument <example> that is the name of a  file  in  the
##  `examples' directory, the example contained in that file is  executed  in
##  its simplest form. Some examples accept options  which  you  may  use  to
##  modify some of the options used in the commands of the example.  To  find
##  out which options an example accepts,  use  one  of  the  mechanisms  for
##  displaying the example described below.
##
##  Some examples have both non-interactive and interactive forms; those that
##  are non-interactive only have a name ending  in  `-ni';  those  that  are
##  interactive only have a name ending in `-i'; examples with  names  ending
##  in  `.g'  also  have  only  one  form;  all  other  examples  have   both
##  non-interactive and interactive forms and for these giving  `PqStart'  as
##  second argument invokes `PqStart' initially  and  makes  the  appropriate
##  adjustments  so  that  the  example  is  executed  or   displayed   using
##  interactive functions.
##
##  If `PqExample' is called with last (second or third)  argument  `Display'
##  then the example  is  displayed  without  being  executed.  If  the  last
##  argument is a non-empty  string  <filename>  then  the  example  is  also
##  displayed without being executed but is also written to a file with  that
##  name. Passing an empty string as last argument has  the  same  effect  as
##  passing `Display'.
##
##  *Note:*
##  The  variables  used  in  `PqExample'  are  local  to  the   running   of
##  `PqExample', so there's no  danger  of  having  some  of  your  variables
##  over-written. However, they are not  completely  lost  either.  They  are
##  saved to a record `ANUPQData.examples.vars', i.e.~if `F'  is  a  variable
##  used in the example then you will be able to access it after  `PqExample'
##  has finished as `ANUPQData.examples.vars.F'.
##
InstallGlobalFunction(PqExample, function(arg)
local name, file, instream, line, doPqStart, lastarg, execute, logging,
      linewidth, sizescreen, vars, var, saved, input, depth, code, words,
      NextLine;

  sizescreen := SizeScreen();
  if sizescreen[1] < 80 then
    SizeScreen([80, sizescreen[2]]);
    linewidth := 80;
  else
    linewidth := sizescreen[1];
  fi;

  if IsEmpty(arg) then
    name := "index";
  else
    name := arg[1];
  fi;

  if name = "README" then
    file := fail;
  else
    file := Filename(DirectoriesPackageLibrary( "anupq", "examples"), name);
  fi;
  if file = fail then
    Info(InfoANUPQ + InfoWarning, 1,
         "Sorry! There is no ANUPQ example with name `", name, "'",
         " ... displaying index.");
    name := "index";
    file := Filename(DirectoriesPackageLibrary( "anupq", "examples"), name);
  fi;

  if name = "index" then
    instream := InputTextFile(file);
    FLUSH_PQ_STREAM_UNTIL(instream, 1, 10, ReadLine, line -> line = fail);
    CloseStream(instream);
    SizeScreen(sizescreen);
    return;
  fi;

  doPqStart := 1 < Length(arg) and arg[2] = PqStart;
  if doPqStart and 2 < Length(name) and
     name{[Length(name) - 1 .. Length(name)]} in ["-i", "ni", ".g"] then
    Error( "example does not have a (different) interactive form\n" );
  fi;

  # a last argument `Display' or a string displays the example instead of
  # executing it; a non-empty string also names a file to log the display to
  if 1 < Length(arg) then
    lastarg := arg[Minimum(3, Length(arg))];
  else
    lastarg := fail;
  fi;
  execute := not (lastarg = Display or IsString(lastarg));
  logging := IsString(lastarg) and not IsEmpty(lastarg);
  if logging then
    LogTo(lastarg);
  fi;
  if execute then
    ANUPQData.example := rec(options := rec());
  fi;

  # Returns the next line of the example to show, or fail at its end.
  # Directive lines are consumed here; see examples/README.
  NextLine := function()
    local line, directive, option, optname, value, from, to;
    while true do
      line := ReadLine(instream);
      if line = fail or line[1] <> '#' or IsMatchingSublist(line, "##") then
        return line;
      fi;

      if IsMatchingSublist(line, "#comment:") and not execute then
        line := ReplacedString(line, " supplying", "");
        from := Position(line, ' ');
        to   := Position(line, '<', from);
        Info(InfoANUPQ, 1,
             "In the next command, you may", line{[from .. to - 1]});
        from := to + 1;
        to   := Position(line, '>') - 1;
        Info(InfoANUPQ, 1, "supplying to `PqExample' the option: `",
                           line{[from .. to]}, "'");
      elif ForAny(["#alt", "#sub", "#add"], d -> StartsWith(line, d)) then
        # a directive applies to the line following it
        directive := SplitString(line, "", "# <>\n");
        line := ReadLine(instream);
        if directive[1] = "alt:" then
          if doPqStart and directive[2] = "do" then
            line := line{[2 .. Length(line)]};
          elif doPqStart then
            line := ReplacedString(line, directive[5], directive[3]);
          fi;
        elif execute then
          # an option with a trailing digit is checked like the option
          option := directive[2];
          optname := option;
          if IsDigitChar(option[Length(option)]) then
            optname := option{[1 .. Length(option) - 1]};
          fi;
          value := ValueOption(option);
          if value <> fail and not ANUPQoptionChecks.(optname)(value) then
            Info(InfoANUPQ, 1, "\"", option, "\" value must be a ",
                               ANUPQoptionTypes.(optname),
                               ": option ignored.");
          elif value <> fail then
            ANUPQData.example.options.(option) := value;
            if directive[1] = "add" then
              line[1] := ' ';
            fi;
            if IsString(value) then
              value := Concatenation("\"", value, "\"");
            else
              value := String(value);
            fi;
            line := ReplacedString(line, directive[4], value);
          fi;
        fi;
        if line = fail or line[1] <> '#' then
          return line;
        fi;
      fi;
    od;
  end;

  instream := InputTextFile(file);
  FLUSH_PQ_STREAM_UNTIL( instream, 10, 1, ReadLine,
                         line -> IsMatchingSublist(line, "#Example") );
  line := FLUSH_PQ_STREAM_UNTIL( instream, 1, 10, ReadLine,
                                 line -> IsMatchingSublist(line, "#vars:") );
  if Length(line) + 21 < linewidth then
    Info(InfoANUPQ, 1, line{[Position(line, ' ')+1..Position(line, ';')-1]},
                       " are local to `PqExample'");
  else
    #this assumes one has been careful to ensure the `#vars:' line is not
    #longer than 72 characters.
    Info(InfoANUPQ, 1, line{[Position(line, ' ')+1..Position(line, ';')-1]},
                       " are");
    Info(InfoANUPQ, 1, "local to `PqExample'");
  fi;
  vars := SplitString(line, "", " ,;\n");
  vars := DuplicateFreeList(vars{[2 .. Length(vars)]});

  # unbind the user's variables of the same names until the example is done
  if execute then
    saved := rec();
    for var in Filtered(vars, IsBoundGlobal) do
      saved.(var) := [ValueGlobal(var), IsReadOnlyGlobal(var)];
      if saved.(var)[2] then
        MakeReadWriteGlobal(var);
      fi;
      UnbindGlobal(var);
    od;
  fi;
  FLUSH_PQ_STREAM_UNTIL(instream, 1, 10, ReadLine,
                        line -> IsMatchingSublist(line, "#options:"));

  # Lines are echoed and collected in <input> until they form complete
  # statements: all blocks closed and the line's code ending in `;'.
  input := "";
  depth := 0;
  line := NextLine();
  while line <> fail do
    if execute and input = "" then
      Print("gap> ");
    elif execute then
      Print(">    ");
    fi;
    if IsMatchingSublist(line, "##") then
      line := line{[2 .. Length(line)]};
    fi;
    Print(ReplacedString(line, ";;", ";"));

    if execute and line[1] <> '#' and line <> "\n" then
      Append(input, line);
      code := line;
      if '#' in code then
        code := code{[1 .. Position(code, '#') - 1]};
      fi;
      words := SplitString(code, "", " \n;,()[]");
      depth := depth
               + Number(words, w -> w in ["do", "if", "repeat", "function"])
               - Number(words, w -> w in ["od", "fi", "until", "end"]);
      code := NormalizedWhitespace(code);
      if depth <= 0 and not IsEmpty(code) and code[Length(code)] = ';' then
        READ_ALL_COMMANDS(InputTextString(input), false, false,
                          function(value) View(value); Print("\n"); end);
        input := "";
        depth := 0;
      fi;
    fi;
    line := NextLine();
  od;
  CloseStream(instream);

  if execute then
    ANUPQData.example.vars := rec();
    for var in vars do
      if IsBoundGlobal(var) then
        ANUPQData.example.vars.(var) := ValueGlobal(var);
        if IsReadOnlyGlobal(var) then
          MakeReadWriteGlobal(var);
        fi;
        UnbindGlobal(var);
      fi;
      if IsBound(saved.(var)) then
        BindGlobal(var, saved.(var)[1]);
        if not saved.(var)[2] then
          MakeReadWriteGlobal(var);
        fi;
      fi;
    od;
    Info(InfoANUPQ, 1, "Variables used in `PqExample' are saved ",
                       "in `ANUPQData.example.vars'.");
  elif logging then
    LogTo();
  fi;
  SizeScreen(sizescreen);
end);

#############################################################################
##
#F  AllPqExamples() . . . . . . . . . .  list the names of all ANUPQ examples
##
InstallGlobalFunction( AllPqExamples, function()
  local dir,  files;

  dir   := DirectoriesPackageLibrary( "anupq", "examples" )[1];
  files := DirectoryContents( Filename( dir, "" ));
  # Remove certain files
  files := Difference( files, [".", "..", "index", "README", "CVS", 
                                         "5gp-PG-e5-i", "7gp-a-x-Rel-i"] );
  # Remove files ending with a tilde
  files := Filtered( files, file -> file[ Length(file) ] <> '~' );
  return files;
end );

#############################################################################
##
#F  GrepPqExamples( <string> ) . . . . . . . grep ANUPQ examples for a string
##
##  runs the UNIX command `grep <string>'  over  the  {\ANUPQ}  examples  and
##  returns the list of examples for which  there  is  a  match.  The  actual
##  matches are `Info'-ed at `InfoANUPQ' level 2.
##
InstallGlobalFunction( GrepPqExamples, function( string )
  local dir,  str,  grep,  out,  opts,  lines,  matches,  line;

  dir := DirectoriesPackageLibrary( "anupq", "examples" )[1];
  grep := Filename( DirectoriesSystemPrograms(), "grep" );
  str := "";
  out := OutputTextString( str, true );
  opts := Concatenation( [ string ], AllPqExamples() );
  Process( dir, grep, InputTextNone(), out, opts );
  CloseStream( out );
  lines := SplitString( str, "",  "\n" );
  matches := [];
  for line in lines do
    Info(InfoANUPQ, 2, line);
    Add( matches, SplitString(line, "", ":")[1] );
  od;
  return Set(matches);
end );

#E  anupq.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
