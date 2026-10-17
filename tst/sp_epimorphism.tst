gap> START_TEST( "sp_epimorphism.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# EpimorphismStandardPresentation paired GeneratorsOfGroup(G) with the
# images of the pcgs pq had been given, so for a pc group whose generators
# are not that pcgs it was not a homomorphism, or not bijective
gap> G := AbelianGroup( IsPcGroup, [ 4, 2 ] );;
gap> e := EpimorphismStandardPresentation( G );;
gap> Q := PcGroupFpGroup( Range( e ) );;
gap> h := GroupHomomorphismByImages( G, Q, MappingGeneratorsImages( e )[1],
>      List( MappingGeneratorsImages( e )[2], w -> MappedWord(
>        UnderlyingElement( w ), FreeGeneratorsOfFpGroup( Range( e ) ),
>        GeneratorsOfGroup( Q ) ) ) );;
gap> h <> fail and IsBijective( h );
true

#
gap> PqQuitAll();
gap> STOP_TEST( "sp_epimorphism.tst", 1 );
