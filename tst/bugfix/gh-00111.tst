gap> START_TEST( "gh-00111.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# For a pc group that is not a p-group, pq was given a presentation on a
# pcgs, but the epimorphism was built on GeneratorsOfGroup: B gave a map
# that is not a homomorphism, and PqEpimorphism for D failed with an error
# (gens and images of different lengths)
gap> P := Image( IsomorphismPcGroup(
>             DirectProduct( SymmetricGroup(3), CyclicGroup(4) ) ) );;
gap> B := Group( Reversed( GeneratorsOfGroup( P ) ) );;
gap> D := Group( P.2 * P.4, P.1 * P.3 );;
gap> CheckEpi := function( G )
>   local epi, hom;
>   epi := PqEpimorphism( G : Prime := 2, ClassBound := 3 );
>   # rebuild the map with the checking GroupHomomorphismByImages
>   hom := GroupHomomorphismByImages( G, Range( epi ),
>              MappingGeneratorsImages( epi )[1],
>              MappingGeneratorsImages( epi )[2] );
>   return hom <> fail and Image( hom ) = Range( epi );
> end;;
gap> CheckSP := function( G )
>   local epi, Q, R, imgs, hom;
>   epi := EpimorphismStandardPresentation( G : Prime := 2, ClassBound := 3 );
>   Q := Range( epi );
>   R := PcGroupFpGroup( Q ); # pq lists only the non-trivial pc relations
>   imgs := List( MappingGeneratorsImages( epi )[2],
>                 w -> MappedWord( UnderlyingElement( w ),
>                         FreeGeneratorsOfFpGroup( Q ), GeneratorsOfGroup( R ) ) );
>   hom := GroupHomomorphismByImages( G, R,
>              MappingGeneratorsImages( epi )[1], imgs );
>   return hom <> fail and Size( Image( hom ) ) = Size( R );
> end;;
gap> List( [ B, D ], CheckEpi );
[ true, true ]
gap> List( [ B, D ], CheckSP );
[ true, true ]

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00111.tst", 1 );
