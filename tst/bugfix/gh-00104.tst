gap> START_TEST( "gh-00104.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# IsIsomorphicPGroup raised "<G> must be a p-group" for trivial groups
gap> IsIsomorphicPGroup( TrivialGroup( IsPcGroup ), TrivialGroup( IsPcGroup ) );
true

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00104.tst", 1 );
