gap> START_TEST( "descendants_law.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# PqDescendants with an exponent law that the group breaks crashed pq:
# its p-quotient under the law is smaller than the group, and the
# automorphisms sent did not fit it. There are no such descendants.
gap> PqDescendants( SmallGroup( 16, 5 ) : Exponent := 4 );
[  ]

#
gap> PqQuitAll();
gap> STOP_TEST( "descendants_law.tst", 1 );
