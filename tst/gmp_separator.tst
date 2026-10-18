gap> START_TEST( "gmp_separator.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# With GMP, pq wrote the automorphism group order as text with no separator
# before the binary record that starts with p; for p = 53 (low byte '5')
# the record was read back one byte off and pq crashed
gap> Set( List( PqDescendants( CyclicGroup( 53 ) : StepSize := 1 ), IdGroup ) );
[ [ 2809, 1 ] ]
gap> Set( List( PqDescendants( ElementaryAbelianGroup( 53^2 ) : StepSize := 1 ), IdGroup ) );
[ [ 148877, 2 ], [ 148877, 3 ], [ 148877, 4 ] ]

#
gap> PqQuitAll();
gap> STOP_TEST( "gmp_separator.tst", 1 );
