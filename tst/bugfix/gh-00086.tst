gap> START_TEST( "gh-00086.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# No method for ClosureGroup when the automorphism group modulo its soluble
# part is soluble, since GAP returns that quotient as a pc group
# See https://github.com/gap-packages/anupq/pull/86
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
gap> STOP_TEST( "gh-00086.tst", 1 );
