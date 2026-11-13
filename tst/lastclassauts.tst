gap> START_TEST( "lastclassauts.tst" );

# The descendants are the same; those of the last class come without
# automorphisms, the others with them
gap> code := H -> [ Size( H ), CodePcGroup( H ) ];;
gap> G := SmallGroup( 4, 2 );;
gap> L := PqDescendants( G : ClassBound := 3 );;
gap> M := PqDescendants( G : ClassBound := 3, LastClassAutomorphisms := false );;
gap> List( L, code ) = List( M, code );
true
gap> Collected( List( M, H -> [ PClassPGroup( H ), HasANUPQAutomorphisms( H ) ] ) );
[ [ [ 2, true ], 7 ], [ [ 3, false ], 129 ] ]
gap> ForAll( L, HasANUPQAutomorphisms );
true

# With an insoluble automorphism group, whose stabilisers GAP computes
gap> G := ElementaryAbelianGroup( 8 );;
gap> L := PqDescendants( G );;
gap> M := PqDescendants( G : LastClassAutomorphisms := false );;
gap> List( L, code ) = List( M, code );
true
gap> Length( M );  Number( M, HasANUPQAutomorphisms );
67
0

# A descendant of the last class can start a construction of its own
gap> H := First( M, IsCapable );;
gap> List( PqDescendants( H ), code ) = List( PqDescendants( First( L, IsCapable ) ), code );
true

# Refused for an interactive process, which keeps its files of descendants
gap> id := PqStart( G );;
gap> PqDescendants( id : LastClassAutomorphisms := false );
Error, LastClassAutomorphisms := false is for non-interactive calls
gap> if not IsEmpty( OptionsStack ) then ResetOptionsStack(); fi;
gap> PqQuit( id );

# A setup file says to run pq with -l
gap> file := Filename( DirectoryTemporary(), "setup" );;
gap> levels := [ InfoLevel( InfoANUPQ ), InfoLevel( InfoWarning ) ];;
gap> SetInfoLevel( InfoANUPQ, 0 );  SetInfoLevel( InfoWarning, 0 );
gap> PqDescendants( G : LastClassAutomorphisms := false, SetupFile := file );
true
gap> SetInfoLevel( InfoANUPQ, levels[1] );  SetInfoLevel( InfoWarning, levels[2] );
gap> StartsWith( SplitString( StringFile( file ), "\n" )[1], "#call pq with flags: '-i -k -g -l'" );
true

#
gap> STOP_TEST( "lastclassauts.tst", 1 );
