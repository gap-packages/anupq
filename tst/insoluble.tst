#############################################################################
##
##  The descendants of an elementary abelian p-group are computed with its
##  full automorphism group GL(d, p), which is insoluble, so pq finds the
##  orbits on the allowable subgroups with its insoluble machinery.  Every
##  p-group of rank d is a descendant of (C_p)^d, so the result can be
##  checked against the small groups library.
##
gap> START_TEST( "Testing ANUPQ descendants with an insoluble automorphism group" );
gap> RankDescendantIds := function( p, d, n )
>      return Concatenation( List( [ d + 1 .. n ], k -> List( Filtered(
>               AllSmallGroups( p^k ), G -> RankPGroup( G ) = d ), IdGroup ) ) );
>    end;;
gap> des := PqDescendants( ElementaryAbelianGroup( 8 ) : OrderBound := 5,
>                                                       ClassBound := 3 );;
gap> Length( des );
28
gap> SortedList( List( des, IdGroup ) ) = SortedList( RankDescendantIds( 2, 3, 5 ) );
true
gap> des := PqDescendants( ElementaryAbelianGroup( 27 ) : OrderBound := 5,
>                                                        ClassBound := 3 );;
gap> Length( des );
34
gap> SortedList( List( des, IdGroup ) ) = SortedList( RankDescendantIds( 3, 3, 5 ) );
true
gap> STOP_TEST( "insoluble.tst", 10000 );
