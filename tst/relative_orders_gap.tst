gap> START_TEST( "relative_orders_gap.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# pq wrote the relative orders of the soluble automorphisms of each
# descendant for GAP with the last one repeated: here there are two
# soluble automorphisms, and relativeOrders was [ 3, 2, 2 ]
gap> Q := Pq( FreeGroup( 2 ) : Prime := 3, ClassBound := 1 );;
gap> des := PqDescendants( Q : StepSize := 1 );;
gap> a := ANUPQAutomorphisms( des[3] );;
gap> Length( a.centralAutos ) + Length( a.otherAutos );
2
gap> a.relativeOrders;
[ 3, 2 ]

#
gap> PqQuitAll();
gap> STOP_TEST( "relative_orders_gap.tst", 1 );
