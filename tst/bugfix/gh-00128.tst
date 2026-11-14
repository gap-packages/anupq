gap> START_TEST( "gh-00128.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# For a cyclic 2-group the class 1 quotient C2 has trivial automorphism group,
# so with PcgsAutomorphisms no automorphisms are sent; pq then freed the array
# it had not allocated for them and died
# See https://github.com/gap-packages/anupq/pull/128
gap> S := StandardPresentation( CyclicGroup( IsPcGroup, 4 ) : PcgsAutomorphisms );
<fp group on the generators [ f1, f2 ]>
gap> RelatorsOfFpGroup( S );
[ f1^2*f2^-1, f2^2 ]
gap> rels := G -> List( RelatorsOfFpGroup( G ), String );;
gap> groups := Concatenation(
>      List( [ 2, 8, 16, 32, 64 ], n -> CyclicGroup( IsPcGroup, n ) ),
>      [ SmallGroup( 64, 1 ) ] );;
gap> ForAll( groups, G -> rels( StandardPresentation( G : PcgsAutomorphisms ) )
>                         = rels( StandardPresentation( G ) ) );
true

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00128.tst", 1 );
