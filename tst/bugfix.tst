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

# PqStandardPresentation hung, or the stabiliser of the allowable subgroup
# was wrong, when the soluble automorphisms act on the Frattini quotient #67
gap> G := PcGroupCode( 103045295174713575554546522863434350004438213623550127541012273, 512 );;  # SmallGroup(512, 383371)
gap> H := PcGroupCode( 43868419351818131989320407468466194305, 512 );;  # SmallGroup(512, 383419)
gap> PqStandardPresentation( G );
<fp group on the generators [ f1, f2, f3, f4, f5, f6, f7, f8, f9 ]>
gap> PqStandardPresentation( H );
<fp group on the generators [ f1, f2, f3, f4, f5, f6, f7, f8, f9 ]>
gap> K := PcGroupCode( 36021959920864, 64 );;  # SmallGroup(64, 241)
gap> PqStandardPresentation( K );
<fp group on the generators [ f1, f2, f3, f4, f5, f6 ]>

# No method for ClosureGroup when the automorphism group modulo its soluble
# part is soluble, since GAP returns that quotient as a pc group
gap> G := ElementaryAbelianGroup( 9 );;
gap> des := PqDescendants( G : OrderBound := 3, ClassBound := 2 );;
gap> SortedList( List( des, AbelianInvariants ) );
[ [ 3, 3 ], [ 3, 3 ], [ 3, 9 ] ]

# pq omitted automorphism group orders when configure did not define
# HAVE_GMP
gap> F := FreeGroup( "a", "b" );;
gap> procId := PqStart( F : Prime := 2, Relators := [ "a^4", "b^4", "[b, a, a]" ] );;
gap> PqSPComputePcpAndPCover( procId : ClassBound := 1 );
gap> PqSetOutputLevel( procId, 3 );
gap> PqSPStandardPresentation( procId, [ [[0,1],[1,1]], [[0,1],[1,0]] ]
>                              : ClassBound := 2, PcgsAutomorphisms );
#I  Starting group has order 2^2; its automorphism group order is 6 
#I  Non-standard label is 1
#I  Required step size is 3
#I  Relative step size is 1
#I  Rank of characteristic subgroup is 1
#I  The non-standard subgroup 1 has orbit representative 1
#I  The standard automorphism is:
#I  1 ---> 1 0 
#I  2 ---> 0 1 
#I  Non-standard label is 1
#I  Required step size is 3
#I  Relative step size is 3
#I  Rank of characteristic subgroup is 3
#I  The non-standard subgroup 1 has orbit representative 1
#I  The standard presentation for the class 2 2-quotient is
#I  Group: [grp] #1;3 to lower exponent-2 central class 2 has order 2^5
#I  Non-trivial powers:
#I   .1^2 = .4
#I   .2^2 = .5
#I  Non-trivial commutators:
#I  [ .2, .1 ] = .3
#I  Subset of automorphism group to check has order bound 96
#I  The standard automorphism is:
#I  1 ---> 1 0 0 0 0 
#I  2 ---> 0 1 0 0 0 
gap> PqQuit( procId );

# pq aborted in PqAPGSingleStage on assert(OutputFile), a file that
# construct opens itself
gap> F := FreeGroup( "a", "b" );;
gap> procId := PqStart( F : Prime := 5, Relators := [ "a^5", "b^5", "[b, a, b]" ] );;
gap> PqPcPresentation( procId : ClassBound := 3, OutputLevel := 1 );
#I  Lower exponent-5 central series for [grp]
#I  Group: [grp] to lower exponent-5 central class 1 has order 5^2
#I  Group: [grp] to lower exponent-5 central class 2 has order 5^3
#I  Group: [grp] to lower exponent-5 central class 3 has order 5^4
gap> PqComputePCover( procId );
#I  Group: [grp] to lower exponent-5 central class 4 has order 5^8
gap> PqSavePcPresentation( procId, ANUPQData.outfile );
gap> PqPGSupplyAutomorphisms( procId, [ [[1,0,0,0],[0,1,0,1]], [[1,1,0,0],[0,1,0,1]],
>      [[1,0,0,0],[0,4,0,0]], [[1,0,0,0],[0,2,0,0]], [[4,0,0,0],[0,1,0,0]],
>      [[2,0,0,0],[0,1,0,0]] ] );
gap> PqPGConstructDescendants( procId : ClassBound := 4, CapableDescendants,
>      StepSize := 1, PcgsAutomorphisms, RankInitialSegmentSubgroups := 4 );
#I  **************************************************
#I  Starting group: [grp]
#I  Order: 5^4
#I  Nuclear rank: 1
#I  5-multiplicator rank: 4
#I  # of immediate descendants of order 5^5 is 9
#I  # of capable immediate descendants is 2
#I  **************************************************
2
gap> PqPGSetDescendantToPcp( procId, 4, 1 );
gap> PqAPGDegree( procId, 2, 3 );
#I  Degree of permutation group is 25
25
gap> PqAPGPermutations( procId );
gap> PqAPGOrbits( procId : CustomiseOutput := rec( orbit := [ 1 ] ) );
#I    Orbit          Length      Representative
#I        1               5               1
#I        2              20               2
#I  Number of orbits is 2
2
gap> PqAPGOrbitRepresentatives( procId );
gap> PqPGSetDescendantToPcp( procId );
gap> PqAPGSingleStage( procId : StepSize := 2, BasicAlgorithm, CustomiseOutput := rec() );
#I  **************************************************
#I  Starting group: [grp] #1;1
#I  Order: 5^5
#I  Nuclear rank: 2
#I  5-multiplicator rank: 4
#I  # of immediate descendants of order 5^7 is 40
#I  # of capable immediate descendants is 5
gap> PqQuit( procId );

#
gap> PqQuitAll();
gap> STOP_TEST( "bugfix.tst", 1 );
