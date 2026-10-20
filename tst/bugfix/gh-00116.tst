gap> START_TEST( "gh-00116.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# The pq stores exponents in 15 bits, so p - 1 >= 2^15 wrapped around:
# for p = 32771 the epimorphism below mapped b to a^31914 and c to a^7068
# (it should be a^10923 and the identity), and the relators did not hold
gap> F := FreeGroup( "a", "b", "c" );; a := F.1;; b := F.2;; c := F.3;;
gap> G := F / [ a^2*b^3*c^5, Comm(a,b)^7*Comm(b,c)^11*c^2 ];;
gap> epi := PqEpimorphism( G : Prime := 32749, ClassBound := 1 );;
gap> List( GeneratorsOfGroup( G ),
>          g -> ExponentsOfPcElement( Pcgs( Image( epi ) ), Image( epi, g ) ) );
[ [ 1 ], [ 21832 ], [ 0 ] ]
gap> PqEpimorphism( G : Prime := 32771, ClassBound := 1 );
Error, "Prime" value must be a prime integer less than 2^15

gap> if not IsEmpty( OptionsStack ) then ResetOptionsStack(); fi;
gap> PqPCover( ElementaryAbelianGroup( 32771^2 ) );
Error, the pq program requires a prime p < 2^15, not 32771
gap> if not IsEmpty( OptionsStack ) then ResetOptionsStack(); fi;

# The pq program itself rejects such primes, and composite ones: from the
# menu it asks again, and a keyword presentation with an invalid prime
# stops it with INPUT_ERROR (exit status 2)
gap> run := function( input, opts )
>      local out;
>      out := "";
>      return [ Process( ANUPQData.tmpdir, ANUPQData.binary,
>                        InputTextString( input ),
>                        OutputTextString( out, true ), opts ), out ];
>    end;;
gap> r := run( "1\nc3\n65537\n9\n3\n1\n1\n{a, b}\n{}\n0\n0\n", [ ] );;
gap> r[1];
0
gap> List( [ "less than 2^15", "9 is not a prime", "has order 3^2" ],
>          s -> PositionSublist( r[2], s ) <> fail );
[ true, true, true ]
gap> List( [ 3, 1, 9, 65537 ], p -> run( Concatenation( "1\nprime ",
>          String( p ), "\ngenerators {a, b}\n;\n0\n" ), [ "-k" ] )[1] );
[ 0, 2, 2, 2 ]

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00116.tst", 1 );
