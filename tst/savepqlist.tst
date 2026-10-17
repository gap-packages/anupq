gap> START_TEST( "savepqlist.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# SavePqList wrote a call of ANUPQSetAutomorphismGroup with 4 arguments
# instead of 6, so PqList could not read the file back
gap> des := PqDescendants( ElementaryAbelianGroup( 9 ) : StepSize := 1 );;
gap> List( des, AutomorphismGroup );;
gap> file := Filename( DirectoryTemporary(), "des" );;
gap> SavePqList( file, des );
gap> L := PqList( file );;
gap> List( L, IdGroup ) = List( des, IdGroup );
true
gap> List( L, G -> ANUPQAutomorphisms( G ).relativeOrders )
>    = List( des, G -> ANUPQAutomorphisms( G ).relativeOrders );
true

#
gap> PqQuitAll();
gap> STOP_TEST( "savepqlist.tst", 1 );
