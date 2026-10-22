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

# The pq program run on its own stops at the same point
gap> run := function( workspace )
>      local out;
>      out := "";
>      return [ Process( ANUPQData.tmpdir, ANUPQData.binary,
>                        InputTextString( Concatenation(
>                          "1\nprime 2\nclass 3\ngenerators {a, b}\n",
>                          "relations {[b,a]^3}\n;\n0\n" ) ),
>                        OutputTextString( out, true ),
>                        [ "-k", "-s", String( workspace ) ] ), out ];
>    end;;
gap> r := run( 210 );;
gap> r[1]; PositionSublist( r[2], "Ran out of space" ) <> fail;
1
true
gap> r := run( 100000 );;
gap> r[1]; PositionSublist( r[2], "class 3 has order 2^6" ) <> fail;
0
true

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00109.tst", 1 );
