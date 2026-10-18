gap> START_TEST( "step_size_dialogue.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# For a step size larger than the nuclear rank pq asked again for the step
# size, while GAP went on sending its next answers, which pq then read as
# step sizes; here it constructed the descendants of step 1 instead of none
gap> G := SmallGroup( 4, 2 );;  # nuclear rank 3
gap> PqDescendants( G : StepSize := 4, PcgsAutomorphisms );
[  ]

# An interactive process was left out of step, and its next call failed
gap> F := FreeGroup( "a", "b" );;
gap> id := PqStart( F : Prime := 5, Relators := [ "a^5", "b^5", "[b, a, b]" ] );;
gap> PqPcPresentation( id : ClassBound := 3 );
gap> PqComputePCover( id );  # nuclear rank 1
gap> PqPGSupplyAutomorphisms( id, [ [[1,0,0,0],[0,1,0,1]], [[1,1,0,0],[0,1,0,1]],
>      [[1,0,0,0],[0,4,0,0]], [[1,0,0,0],[0,2,0,0]], [[4,0,0,0],[0,1,0,0]],
>      [[2,0,0,0],[0,1,0,0]] ] );
gap> PqPGConstructDescendants( id : ClassBound := 4, StepSize := 2 );
0
gap> PqPGConstructDescendants( id : ClassBound := 4, StepSize := 1 );
9

#
gap> PqQuitAll();
gap> STOP_TEST( "step_size_dialogue.tst", 1 );
