#############################################################################
##
##  Tests PqExample: display, PqStart variants, option substitution, and
##  restoring the user's variables.
##
gap> START_TEST("pqexample.tst");
gap> SetInfoLevel(InfoANUPQ, 1);
gap> PqQuitAll();

# executed examples echo "gap> " lines, so show their output with a prefix
gap> ShowPqExample := function(arg)
>   local str, out, line;
>   str := "";
>   out := OutputTextString(str, true);
>   SetPrintFormattingStatus(out, false);
>   PrintTo1(out, function() CallFuncList(PqExample, arg); end);
>   CloseStream(out);
>   for line in SplitString(str, "\n") do
>     while line <> "" and line[Length(line)] = ' ' do
>       Remove(line);
>     od;
>     if line = "" then Print("|\n"); else Print("| ", line, "\n"); fi;
>   od;
> end;;

# display, with and without the #alt directives applied
gap> PqExample("PqEpimorphism", Display);
#I  #Example: "PqEpimorphism" . . . based on `PqEpimorphism' manual example
#I  F, procId, phi are local to `PqExample'
F := FreeGroup (2, "F");
phi := PqEpimorphism( F : Prime := 5, ClassBound := 2 );
Image( phi );
gap> PqExample("PqEpimorphism", PqStart, Display);
#I  #Example: "PqEpimorphism" . . . based on `PqEpimorphism' manual example
#I  F, procId, phi are local to `PqExample'
F := FreeGroup (2, "F");
procId := PqStart( F );
phi := PqEpimorphism( procId : Prime := 5, ClassBound := 2 );
Image( phi );
gap> PqExample("Pq-ni", PqStart);
Error, example does not have a (different) interactive form


# execution hides the user's variables and restores them afterwards
gap> F := "user's F";; procId := "user's procId";;
gap> if IsBoundGlobal("phi") then
>      if IsReadOnlyGlobal("phi") then MakeReadWriteGlobal("phi"); fi;
>      UnbindGlobal("phi");
>    fi;
gap> BindGlobal("phi", 42);
gap> ShowPqExample("PqEpimorphism");
| #I  #Example: "PqEpimorphism" . . . based on `PqEpimorphism' manual example
| #I  F, procId, phi are local to `PqExample'
| gap> F := FreeGroup (2, "F");
| <free group on the generators [ F1, F2 ]>
| gap> phi := PqEpimorphism( F : Prime := 5, ClassBound := 2 );
| [ F1, F2 ] -> [ f1, f2 ]
| gap> Image( phi );
| <pc group of size 3125 with 5 generators>
| #I  Variables used in `PqExample' are saved in `ANUPQData.example.vars'.
gap> [F, procId, phi, IsReadOnlyGlobal("phi")];
[ "user's F", "user's procId", 42, true ]
gap> SortedList(RecNames(ANUPQData.example.vars));
[ "F", "phi" ]
gap> ANUPQData.example.vars.phi;
[ F1, F2 ] -> [ f1, f2 ]
gap> MakeReadWriteGlobal("phi");

# the interactive variant
gap> ShowPqExample("PqEpimorphism", PqStart);
| #I  #Example: "PqEpimorphism" . . . based on `PqEpimorphism' manual example
| #I  F, procId, phi are local to `PqExample'
| gap> F := FreeGroup (2, "F");
| <free group on the generators [ F1, F2 ]>
| gap> procId := PqStart( F );
| 1
| gap> phi := PqEpimorphism( procId : Prime := 5, ClassBound := 2 );
| [ F1, F2 ] -> [ f1, f2 ]
| gap> Image( phi );
| <pc group of size 3125 with 5 generators>
| #I  Variables used in `PqExample' are saved in `ANUPQData.example.vars'.
gap> procId;
"user's procId"

# #sub substitutes option values passed to PqExample
gap> ShowPqExample("2gp-a-Rel-i" : ClassBound := 2);
| #I  #Example: "2gp-a-Rel-i" . . . based on: examples/keyword_2gp
| #I  F, rels, procId are local to `PqExample'
| gap> F := FreeGroup(3, "x");
| <free group on the generators [ x1, x2, x3 ]>
| gap> rels := ["x1^x2 * x3", "[x2, x1, x1]",
| >             "[x2 * [x2, x1] * x1^2, x1 * x2 ]"];
| [ "x1^x2 * x3", "[x2, x1, x1]", "[x2 * [x2, x1] * x1^2, x1 * x2 ]" ]
| gap> procId := PqStart(F : Prime := 2, Relators := rels);
| gap> PqPcPresentation(procId : ClassBound := 2,
| >                              OutputLevel := 1);
| #I  Lower exponent-2 central series for [grp]
| #I  Group: [grp] to lower exponent-2 central class 1 has order 2^2
| #I  Group: [grp] to lower exponent-2 central class 2 has order 2^4
| #I  Variables used in `PqExample' are saved in `ANUPQData.example.vars'.
gap> ANUPQData.example.options;
rec( ClassBound := 2 )

# a call without a value and a single ; is executed silently
gap> ShowPqExample("5gp-metabelian-Rel-i");
| #I  #Example: "5gp-metabelian-Rel-i" . . . based on: examples/metabelian
| #I  #Demonstrates usage of `PqSetMetabelian'.
| #I  F, rels, procId, class are local to `PqExample'
| gap> F := FreeGroup("a", "b");
| <free group on the generators [ a, b ]>
| gap> rels := ["a^625", "b^625", "[b, a, b]", "[b, a, a, a, a] * [b, a]^-5"];
| [ "a^625", "b^625", "[b, a, b]", "[b, a, a, a, a] * [b, a]^-5" ]
| gap> procId := PqStart(F : Prime := 5, Relators := rels);
| gap> PqPcPresentation(procId : ClassBound := 1,
| >                              OutputLevel := 1);
| #I  Lower exponent-5 central series for [grp]
| #I  Group: [grp] to lower exponent-5 central class 1 has order 5^2
| gap> PqSetMetabelian(procId);
| gap> for class in [2 .. 14] do
| >      PqNextClass(procId);
| >    od;
| #I  Group: [grp] to lower exponent-5 central class 2 has order 5^5
| #I  Group: [grp] to lower exponent-5 central class 3 has order 5^8
| #I  Group: [grp] to lower exponent-5 central class 4 has order 5^11
| #I  Group: [grp] to lower exponent-5 central class 5 has order 5^12
| #I  Group: [grp] to lower exponent-5 central class 6 has order 5^13
| #I  Group: [grp] to lower exponent-5 central class 7 has order 5^14
| #I  Group: [grp] to lower exponent-5 central class 8 has order 5^15
| #I  Group: [grp] to lower exponent-5 central class 9 has order 5^16
| #I  Group: [grp] to lower exponent-5 central class 10 has order 5^17
| #I  Group: [grp] to lower exponent-5 central class 11 has order 5^18
| #I  Group: [grp] to lower exponent-5 central class 12 has order 5^19
| #I  Group: [grp] to lower exponent-5 central class 13 has order 5^20
| #I  Group completed. Lower exponent-5 central class = 13, Order = 5^20
| #I  Group: [grp] to lower exponent-5 central class 13 has order 5^20
| gap> PqSavePcPresentation(procId, ANUPQData.outfile);
| #I  Variables used in `PqExample' are saved in `ANUPQData.example.vars'.
gap> PqQuitAll();
gap> STOP_TEST("pqexample.tst");
