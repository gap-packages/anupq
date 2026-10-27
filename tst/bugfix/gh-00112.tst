gap> START_TEST( "gh-00112.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# With automorphisms supplied, PqNextClass tests the exponent law only on a
# reduced list of words, which is enough only if the automorphisms induce
# all of GL(d, p) on a relatively free group; with fewer automorphisms the
# group came out too big (2^13 and 2^18 below instead of 2^4 and 2^12), so
# such automorphisms are refused
gap> procId := PqStart( FreeGroup( 4 ) : Prime := 2, Exponent := 2 );;
gap> PqPcPresentation( procId : ClassBound := 1 );;
gap> PqSupplyAutomorphisms( procId, [ IdentityMat( 4 ) ] );
Error, with an exponent law, the automorphisms must induce GL(4, 2) on the
Frattini quotient of a group without relators or metabelian law
gap> procId := PqStart( FreeGroup( 2 ) : Prime := 2, Exponent := 4 );;
gap> PqPcPresentation( procId : ClassBound := 1 );;
gap> PqSupplyAutomorphisms( procId, [ [ [ 0, 1 ], [ 1, 0 ] ] ] );
Error, with an exponent law, the automorphisms must induce GL(2, 2) on the
Frattini quotient of a group without relators or metabelian law

# Generators of GL(2, 2) give B(2, 4)
gap> PqSupplyAutomorphisms( procId, [ [ [ 0, 1 ], [ 1, 0 ] ],
>                                     [ [ 1, 1 ], [ 0, 1 ] ] ] );;
gap> for class in [ 2 .. 6 ] do PqNextClass( procId ); od;
gap> PqFactoredOrder( procId );
[ 2, 12 ]

# With relators the reduced list is not enough either
gap> F := FreeGroup( 2 );;
gap> procId := PqStart( F / [ Comm( F.1, F.2 )^2 ] : Prime := 2,
>                       Exponent := 4 );;
gap> PqPcPresentation( procId : ClassBound := 1 );;
gap> PqSupplyAutomorphisms( procId, [ [ [ 0, 1 ], [ 1, 0 ] ],
>                                     [ [ 1, 1 ], [ 0, 1 ] ] ] );
Error, with an exponent law, the automorphisms must induce GL(2, 2) on the
Frattini quotient of a group without relators or metabelian law

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00112.tst", 1 );
