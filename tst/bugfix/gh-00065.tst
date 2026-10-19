gap> START_TEST( "gh-00065.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# Check that the stream gets closed also in early exit cases.
# See https://github.com/gap-packages/anupq/pull/65
gap> G:= ExtraspecialGroup( 3^3, "-" );;
gap> IsCapable( G );
false
gap> for i in [ 1 .. 100 ] do PqDescendants( G ); od;

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00065.tst", 1 );
