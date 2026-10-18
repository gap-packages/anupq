gap> START_TEST( "exponent_queue.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# With automorphisms supplied to the p-quotient, enforcing an exponent law
# at class 2 overflowed the queue of redundant generators, which had room
# for 4 of the d(d+1)/2 new generators.  pq wrote past a heap block and, in
# most runs, kept some generators that the law kills: the next class came
# out as class 2 of order 2^26 instead of 2^8 for d = 8; it also crashed
# now and then, and always under AddressSanitizer
gap> for d in [ 7 .. 10 ] do
>      procId := PqStart( FreeGroup( d ) : Prime := 2, Exponent := 2 );
>      PqPcPresentation( procId : ClassBound := 1 );
>      t := MutableCopyMat( IdentityMat( d ) );
>      t[1][2] := 1;
>      PqSupplyAutomorphisms( procId,
>          [ PermutationMat( CycleFromList( [ 1 .. d ] ), d ), t ] );
>      PqNextClass( procId );
>      Print( PqFactoredOrder( procId ), "\n" );
>      PqQuit( procId );
>    od;
[ 2, 7 ]
[ 2, 8 ]
[ 2, 9 ]
[ 2, 10 ]

#
gap> PqQuitAll();
gap> STOP_TEST( "exponent_queue.tst", 1 );
