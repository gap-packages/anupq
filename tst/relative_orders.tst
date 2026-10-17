gap> START_TEST( "relative_orders.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# PqPGSupplyAutomorphisms used the entries of RelativeOrders as indices
# into it: [ 3, 2 ] gave an error, and [ 2, 3, 3 ] sent 3, 3, 3
gap> procId := PqStart( FreeGroup( 2 ) : Prime := 3 );;
gap> Pq( procId : ClassBound := 1 );;
gap> PqSetPQuotientToGroup( procId );
gap> PqComputePCover( procId );
gap> PqPGSupplyAutomorphisms( procId, [ [[1,0],[1,1]], [[2,0],[0,2]] ]
>        : NumberOfSolubleAutomorphisms := 2, RelativeOrders := [ 3, 2 ] );
gap> PqQuit( procId );

#
gap> PqQuitAll();
gap> STOP_TEST( "relative_orders.tst", 1 );
