gap> START_TEST( "stale_descendants.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# An interactive PqDescendants also returned the groups that an earlier
# command of the same process had written
gap> procId := PqStart( FreeGroup( 2 ) : Prime := 3 );;
gap> Pq( procId : ClassBound := 1 );;
gap> PqSetPQuotientToGroup( procId );
gap> PqComputePCover( procId );
gap> PqPGSupplyAutomorphisms( procId );
gap> PqPGConstructDescendants( procId : StepSize := 1 );
3
gap> List( PqDescendants( procId : StepSize := 2 ), Size );
[ 81, 81, 81 ]
gap> PqQuit( procId );

#
gap> PqQuitAll();
gap> STOP_TEST( "stale_descendants.tst", 1 );
