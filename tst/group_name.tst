gap> START_TEST( "group_name.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# The class of the descendants was read from the name of the file pq saves
# them to, <name>_class<c>, by splitting it at "_", which failed when the
# group name (GroupName option or Name of the group) contained "_"
gap> G := ElementaryAbelianGroup( 4 );;
gap> List( PqDescendants( G : GroupName := "my_G", OrderBound := 4 ), Size );
[ 8, 8, 8, 16, 16, 16 ]

# pq cuts the name at white space, so the file of descendants was not found
# under the name GAP asked for, and pq died
gap> F := FreeGroup( "a", "b" );;
gap> id := PqStart( F : Prime := 5, Relators := [ "a^5", "b^5", "[b, a, b]" ] );;
gap> PqPcPresentation( id : ClassBound := 3, GroupName := "my G" );
gap> PqComputePCover( id );
gap> PqPGSupplyAutomorphisms( id, [ [[1,0,0,0],[0,1,0,1]], [[1,1,0,0],[0,1,0,1]],
>      [[1,0,0,0],[0,4,0,0]], [[1,0,0,0],[0,2,0,0]], [[4,0,0,0],[0,1,0,0]],
>      [[2,0,0,0],[0,1,0,0]] ] );
gap> PqPGConstructDescendants( id : ClassBound := 4, StepSize := 1 );
9
gap> PqPGSetDescendantToPcp( id, 4, 2 );
gap> Size( PqCurrentGroup( id ) );
3125

#
gap> PqQuitAll();
gap> STOP_TEST( "group_name.tst", 1 );
