gap> START_TEST( "aut_basis.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# pq read the images of the automorphisms of a pc group in its own pcp,
# which need not be the pcgs of the group: here these are copies of
# SmallGroup(128, 540) and SmallGroup(128, 773) with another pcgs, which
# gave 7 instead of 10 descendants, and crashed pq
gap> G := PcGroupCode( 3850294291458756985713877851, 128 );;
gap> D := PqDescendants( G : StepSize := 1 );;
gap> SortedList( List( D, IdGroup ) ) = SortedList( List(
>      PqDescendants( SmallGroup( 128, 540 ) : StepSize := 1 ), IdGroup ) );
true
gap> Length( D );
10
gap> G := PcGroupCode( 20922463594250774814923642549699, 128 );;
gap> IdGroup( G );
[ 128, 773 ]
gap> Length( PqDescendants( G : StepSize := 1 ) );
12

#
gap> PqQuitAll();
gap> STOP_TEST( "aut_basis.tst", 1 );
