gap> START_TEST( "pc_generator_limit.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# pc generator numbers are packed into 16 bits, and the limit of 65535
# was only checked before a class; class 2 of this group needs 65702
# generators, and pq silently returned a corrupted presentation
gap> procId := PqStart( FreeGroup( 361 ) : Prime := 2 );;
gap> PqPcPresentation( procId : ClassBound := 1 );
gap> PqNextClass( procId );
#I  The number of pc generators would exceed the limit 65535
Error, pq program terminated, with error condition:
  The number of pc generators would exceed the limit 65535


#
gap> PqQuitAll();
gap> STOP_TEST( "pc_generator_limit.tst", 1 );
