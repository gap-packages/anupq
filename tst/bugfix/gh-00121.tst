gap> START_TEST( "gh-00121.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# ANUPQDirectoryTemporary moved the working directory of pq but not
# ANUPQData.SPimages, so PqStandardPresentation read the standard
# presentation from an empty file in the old directory and failed
gap> old := ShallowCopy( ANUPQData );;
gap> ANUPQDirectoryTemporary(
>        Filename( DirectoryTemporary(), "sp_tmpdir" ) ) <> fail;
true
gap> F := FreeGroup( 2 );; G := F / [ F.1^4, F.2^4, Comm( F.1, F.2 ) ];;
gap> Q := PqStandardPresentation( G : Prime := 2, ClassBound := 3 );;
gap> IdGroup( PcGroupFpGroup( Q ) );
[ 16, 2 ]
gap> ANUPQData.tmpdir := old.tmpdir;;
gap> ANUPQData.outfile := old.outfile;;
gap> ANUPQData.SPimages := old.SPimages;;

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00121.tst", 1 );
