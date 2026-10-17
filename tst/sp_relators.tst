gap> START_TEST( "sp_relators.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# With the option Relators, PqStandardPresentation took the rank from the
# group instead of from the relators given to pq, sent pq automorphisms
# of the wrong size, and hung
gap> F := FreeGroup( "a", "b" );;
gap> S := PqStandardPresentation( F : Prime := 2, Relators := [ "a^8", "b*a^-2" ] );;
gap> List( RelatorsOfFpGroup( S ), LetterRepAssocWord ) =
>    List( RelatorsOfFpGroup( PqStandardPresentation(
>        F / [ F.1^8, F.2*F.1^-2 ] : Prime := 2 ) ), LetterRepAssocWord );
true

#
gap> PqQuitAll();
gap> STOP_TEST( "sp_relators.tst", 1 );
