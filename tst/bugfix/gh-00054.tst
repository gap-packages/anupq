gap> START_TEST( "gh-00054.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# Fix crash in PqDescendantsTreeCoclassOne
# See https://github.com/gap-packages/anupq/pull/54
gap> G := ElementaryAbelianGroup( 16 );
<pc group of size 16 with 4 generators>
gap> PqDescendantsTreeCoclassOne( PqStart( G ) : TreeDepth := 5, CapableDescendants );
#I  Number of descendants of group #1;1 to class 2: 1
#I  Number of descendants of group #1;1 #1;1 to class 3: 1
#I  Number of descendants of group #1;1 #1;1 #1;1 to class 4: 1
#I  Number of descendants of group #1;1 #1;1 #1;1 #1;1 to class 5: 1
#I  Number of descendants of group #2;1 to class 2: 1
#I  Number of descendants of group #1;1 #1;1 to class 3: 1
#I  Number of descendants of group #1;1 #1;1 #1;1 to class 4: 1
#I  Number of descendants of group #1;1 #1;1 #1;1 #1;1 to class 5: 1

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00054.tst", 1 );
