gap> START_TEST( "gh-00079.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# A non-interactive call interrupted by an error left its pq process running
# See https://github.com/gap-packages/anupq/issues/79
gap> F := FreeGroup( 2 );;
gap> Pq( F );
Error, you must supply a value for option: "Prime"

gap> s := ANUPQData.ni.stream;;
gap> Pq( F : Prime := 2, ClassBound := 1 );
<pc group of size 4 with 2 generators>
gap> IsClosedStream( s );
true

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00079.tst", 1 );
