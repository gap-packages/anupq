gap> START_TEST( "gh-00123.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# pq read past the end of its workspace when the class 1 quotient was cyclic;
# only an AddressSanitizer build of pq notices
# See https://github.com/gap-packages/anupq/pull/123
gap> List( PqDescendants( CyclicGroup( 2 ) : StepSize := 1 ), IdGroup );
[ [ 4, 1 ] ]

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00123.tst", 1 );
