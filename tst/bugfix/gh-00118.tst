gap> START_TEST( "gh-00118.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# With option pQuotient, the automorphisms of the given quotient were sent
# to pq in its pcgs, while pq reads them in its own pcp of the quotient;
# for these isomorphic copies of the class 2 quotients the standard
# presentation came out different, or pq crashed
gap> Key := F -> List( RelatorsOfFpGroup( F ), LetterRepAssocWord );;
gap> G := SmallGroup( 64, 6 );;
gap> Q := PcGroupCode( 33300, 16 );;
gap> IdGroup( Q ) = IdGroup( Pq( G : Prime := 2, ClassBound := 2 ) );
true
gap> Key( StandardPresentation( G : pQuotient := Q, ClassBound := 3 ) )
>  = Key( StandardPresentation( G : ClassBound := 3,
>           pQuotient := Pq( G : Prime := 2, ClassBound := 2 ) ) );
true
gap> H := SmallGroup( 64, 112 );;
gap> Q := PcGroupCode( 2768831001, 32 );;
gap> IdGroup( Q ) = IdGroup( Pq( H : Prime := 2, ClassBound := 2 ) );
true
gap> Key( StandardPresentation( H : pQuotient := Q, ClassBound := 3 ) )
>  = Key( StandardPresentation( H : ClassBound := 3,
>           pQuotient := Pq( H : Prime := 2, ClassBound := 2 ) ) );
true

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00118.tst", 1 );
