gap> START_TEST( "gh-00097.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# PqDescendants with an exponent or metabelian law that the group breaks
# crashed pq: its p-quotient under the law is smaller than the group, and
# the automorphisms sent did not fit it. There are no such descendants.
gap> PqDescendants( SmallGroup( 16, 5 ) : Exponent := 4 );
[  ]
gap> PqDescendants( SmallGroup( 256, 332 ) : Metabelian, StepSize := 1 );
[  ]

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00097.tst", 1 );
