gap> START_TEST( "gh-00117.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# When the Frattini quotient has more than 10000 elements, the order of the
# automorphism group modulo its soluble part was computed as if every
# soluble relative order were p; for (C_101)^2 it came out as 1020000/1030301
# instead of |GL(2,101)|/100 = 1030200, AutPGrp cut its orbits short, and
# there were 112 descendants of order 101^4 instead of 12
gap> Length( PqDescendants( ElementaryAbelianGroup( 101^2 )
>                           : OrderBound := 4, ClassBound := 3 ) );
12

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00117.tst", 1 );
