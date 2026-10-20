gap> START_TEST( "gh-00109.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# A defining relation [b,a]^k with k <> 1 needs more workspace than
# collect_relations reserved for it; near the limit pq overwrote its own
# data and, instead of running out of space, returned a quotient of
# order 2^7 rather than 2^6
gap> F := FreeGroup( "a", "b" );;
gap> G := F / [ Comm( F.2, F.1 )^3 ];;
gap> Size( Pq( G : Prime := 2, ClassBound := 3, Relators := [ "[b,a]^3" ] ) );
64
gap> Size( Pq( G : Prime := 2, ClassBound := 3, Relators := [ "[b,a]^3" ],
>                  PqWorkspace := 210 ) );
#I  Ran out of space during computation
Error, pq program terminated, with error condition:
  Ran out of space during computation

gap> if not IsEmpty( OptionsStack ) then ResetOptionsStack(); fi;
gap> PqQuitAll();
gap> STOP_TEST( "gh-00109.tst", 1 );
