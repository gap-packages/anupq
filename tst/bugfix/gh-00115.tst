gap> START_TEST( "gh-00115.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# When pq computed a stabiliser with the soluble algorithm, it kept the
# number and relative orders of the soluble automorphisms of an earlier
# stage: des[4] has 3 automorphisms, and its relativeOrders began with the
# 5 entries [ 2, 2, 2, 3, 2 ] (pq also repeated the last entry)
gap> Q := Pq( FreeGroup( 3 ) : Prime := 2, ClassBound := 1 );;
gap> des := PqDescendants( Q : StepSize := 1 );;
gap> ForAll( des, function( G )
>      local a;
>      a := ANUPQAutomorphisms( G );
>      return Length( a.relativeOrders )
>             <= Length( a.centralAutos ) + Length( a.otherAutos );
>    end );
true
gap> a := ANUPQAutomorphisms( des[4] );;
gap> Length( a.centralAutos ) + Length( a.otherAutos );
3
gap> a.relativeOrders{ [ 1 .. 3 ] };
[ 2, 3, 2 ]

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00115.tst", 1 );
