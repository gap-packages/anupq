gap> START_TEST( "orbit_counters.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# The soluble orbit algorithm counted, per subgroup, the automorphisms
# fixing it in a char, which wrapped at 127 automorphisms; here AutPGrp
# gives 130, and pq returned 16384 descendants
gap> G := AbelianGroup( [ 2^3, 2^5, 2^7, 2^9, 2^11 ] );;
gap> Length( PqDescendants( G : StepSize := 1 ) );
26

#
gap> PqQuitAll();
gap> STOP_TEST( "orbit_counters.tst", 1 );
