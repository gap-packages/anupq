gap> START_TEST( "gh-00006.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# After each step GAP asks pq to display the presentation, to read the
# class and order; at pq output level 2 or more pq answered with every
# non-trivial relation, and parsing that took hours in class 11 of #6.
# The internal display runs at level 1; output at InfoANUPQ level 3 shows it.
gap> procId := PqStart( FreeGroup( 2 ) : Exponent := 4, Prime := 2 );;
gap> PqPcPresentation( procId : ClassBound := 2, OutputLevel := 1 );
#I  Lower exponent-2 central series for [grp]
#I  Group: [grp] to lower exponent-2 central class 1 has order 2^2
#I  Group: [grp] to lower exponent-2 central class 2 has order 2^5
gap> PqSetOutputLevel( procId, 2 );
gap> SetInfoLevel( InfoANUPQ, 3 );
gap> PqSetupTablesForNextClass( procId );
#I  Setup performed for class 3
#I  Group: [grp] to lower exponent-2 central class 3 has order 2^5
gap> SetInfoLevel( InfoANUPQ, 1 );

# pq is back at level 2 afterwards
gap> PqTails( procId, 0 );
#I  Processing tails for generators of weight 2 and 1
#I  The number of new generators introduced for weight 3 is 8
#I  The number of new generators introduced for weight 2 is 0
gap> [ PqPClass( procId ), PqNrPcGenerators( procId ) ];
[ 3, 13 ]
gap> PqDoConsistencyChecks( procId, 0, 0 );
#I  Generator 8 is trivial
#I  Jacobi was 1 1 1
#I  Generator 11 is trivial
#I  Jacobi was 2 2 2
#I  Generator 10 is redundant
#I  Jacobi was 2 1 1
gap> PqCollectDefiningRelations( procId );
gap> PqEliminateRedundantGenerators( procId );
gap> [ PqPClass( procId ), PqNrPcGenerators( procId ),
>      PqFactoredOrder( procId ), ANUPQData.io[ procId ].ngens ];
[ 3, 10, [ 2, 10 ], [ 2, 5, 10 ] ]
gap> PqDisplayPcPresentation( procId );
#I  Group: [grp] to lower exponent-2 central class 3 has order 2^10
#I  Non-trivial powers:
#I   .1^2 = .4
#I   .2^2 = .5
#I   .3^2 = .6 .8
#I   .4^2 = .9
#I   .5^2 = .10
#I  Non-trivial commutators:
#I  [ .2, .1 ] = .3
#I  [ .3, .1 ] = .6
#I  [ .3, .2 ] = .7
#I  [ .4, .2 ] = .8
#I  [ .5, .1 ] = .6 .7 .8

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00006.tst", 1 );
