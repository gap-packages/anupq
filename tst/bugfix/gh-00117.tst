gap> START_TEST( "gh-00117.tst" );

# When the Frattini quotient has more than 10000 elements, the order of the
# automorphism group modulo its soluble part was computed as if every
# soluble relative order were p; for (C_101)^2 it came out as 1020000/1030301
# instead of |GL(2,101)|/100 = 1030200, and AutPGrp cut its orbits short
gap> SetInfoLevel( InfoANUPQ, 2 );
gap> Length( PqDescendants( ElementaryAbelianGroup( 101^2 )
>                           : OrderBound := 3 ) );
#I  Order of GL subgroup is 1030200
#I  No. of soluble autos is 4
#I    dim U = 1  dim N = 2  dim M = 2
#I    nice stabilizer with matr rep
#I  Order of GL subgroup is 1030200
#I  No. of soluble autos is 4
#I    dim U = 2  dim N = 3  dim M = 3
#I  Order of GL subgroup is 1030200
#I  No. of soluble autos is 4
#I    dim U = 2  dim N = 3  dim M = 3
#I    nice stabilizer with matr rep
3
gap> SetInfoLevel( InfoANUPQ, 1 );

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00117.tst", 1 );
