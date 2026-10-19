gap> START_TEST( "gh-00117.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# When the Frattini quotient has more than 10000 elements, the order of the
# automorphism group modulo its soluble part was computed as if every
# soluble relative order were p; for (C_101)^2 it came out as 1020000/1030301
# instead of |GL(2,101)|/100 = 1030200, and AutPGrp cut its orbits short
gap> orders := [];;
gap> stab := PGOrbitStabilizer;;
gap> MakeReadWriteGlobal( "PGOrbitStabilizer" );
gap> PGOrbitStabilizer := function( A, baseU, baseN, interrupt )
>      if IsBound( A.field ) then Add( orders, A.glOrder ); fi;
>      return stab( A, baseU, baseN, interrupt );
>    end;;
gap> Length( PqDescendants( ElementaryAbelianGroup( 101^2 )
>                           : OrderBound := 3 ) );
3
gap> PGOrbitStabilizer := stab;;
gap> MakeReadOnlyGlobal( "PGOrbitStabilizer" );
gap> Set( orders );
[ 1030200 ]

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00117.tst", 1 );
