gap> START_TEST( "bugfix.tst" );
gap> SetInfoLevel(InfoANUPQ, 1);

#
gap> Gpc := PcGroupCode(68146375694269006194915807389502420706068560698170186858702642616271311983852576935888031169808724212486427842287695095990141448242086615015179035279810566253194821421235130797478228790709823744504959547811690291508815054696836089975338898421240232146485972558278354047942767460757806879902001011672205506677433540854819814334041631681046533290684225262516467449392593429627898,3^16);
<pc group of size 43046721 with 16 generators>
gap> epi   := PqEpimorphism(Gpc:Prime:=3);;
gap> Gpq   := Image(epi);
<pc group of size 43046721 with 16 generators>
gap> IsBijective(epi);
true
gap> gen  := GeneratorsOfGroup(Gpc);;
gap> im   := List(gen, x-> Image(epi,x));;
gap> hom := GroupHomomorphismByImages(Gpc,Gpq, gen, im);
[ f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16 ] -> 
[ f1, f2, f4, f3, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16 ]

# Fix crash in PqDescendantsTreeCoclassOne #54
gap> G := ElementaryAbelianGroup( 16 );
<pc group of size 16 with 4 generators>
gap> PqDescendantsTreeCoclassOne( PqStart( G ) : TreeDepth := 5, CapableDescendants );
#I  Number of descendants of group #1;1 to class 2: 1
#I  Number of descendants of group #1;1 #1;1 to class 3: 1
#I  Number of descendants of group #1;1 #1;1 #1;1 to class 4: 1
#I  Number of descendants of group #1;1 #1;1 #1;1 #1;1 to class 5: 1
#I  Number of descendants of group #2;1 to class 2: 1
#I  Number of descendants of group #1;1 #1;1 to class 3: 1
#I  Number of descendants of group #1;1 #1;1 #1;1 to class 4: 1
#I  Number of descendants of group #1;1 #1;1 #1;1 #1;1 to class 5: 1

# Check that the stream gets closed also in early exit cases.
gap> G:= ExtraspecialGroup( 3^3, "-" );;
gap> IsCapable( G );
false
gap> for i in [ 1 .. 100 ] do PqDescendants( G ); od;

#
gap> PqQuitAll();
gap> STOP_TEST( "bugfix.tst", 1 );
