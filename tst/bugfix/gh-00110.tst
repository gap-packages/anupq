gap> START_TEST( "gh-00110.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# With PcgsAutomorphisms the pq program takes the automorphisms for a
# PAG-generating sequence, but AutPGrp gives two involutions for the soluble
# Aut(C2^2) = GL(2,2); pq returned 161 descendants, many of them isomorphic
gap> G := ElementaryAbelianGroup( 4 );;
gap> Length( PqDescendants( G : ClassBound := 3 ) );
136
gap> Length( PqDescendants( G : ClassBound := 3, PcgsAutomorphisms ) );
136

# For SmallGroup(81,2) one element of the pcgs replacing the `glAutos' lies
# in the group of the soluble automorphisms; it is dropped rather than sent
# to pq with relative order 1
gap> orders := [];;
gap> topq := ToPQ;;
gap> MakeReadWriteGlobal( "ToPQ" );
gap> ToPQ := function( arg )
>      if Length( arg ) = 3 and not IsEmpty( arg[3] ) and
>         IsString( arg[3][1] ) and
>         PositionSublist( arg[3][1], "rel order" ) <> fail then
>        Add( orders, arg[2][1] );
>      fi;
>      CallFuncList( topq, arg );
>    end;;
gap> Length( PqDescendants( SmallGroup( 81, 2 ) : PcgsAutomorphisms ) );
4
gap> ToPQ := topq;;
gap> MakeReadOnlyGlobal( "ToPQ" );
gap> 1 in orders;
false

# Supplied automorphisms that are not a PAG-generating sequence (the two
# involutions of #92) gave 137 descendants; now this is an error
gap> F := FreeGroup( 2 );;
gap> procId := PqStart( F / [ F.1^2, F.2^2, Comm( F.1, F.2 ) ] : Prime := 2 );;
gap> Pq( procId : ClassBound := 1 );;
gap> PqPCover( procId );;
gap> PqPGSupplyAutomorphisms( procId, [ [[1,0],[1,1]], [[0,1],[1,0]] ] );
gap> PqPGConstructDescendants( procId : ClassBound := 3,
>                                       PcgsAutomorphisms );
Error, option "PcgsAutomorphisms" needs the automorphisms to be
a PAG-generating sequence of a soluble group, and they are not
gap> if not IsEmpty( OptionsStack ) then ResetOptionsStack(); fi;

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00110.tst", 1 );
