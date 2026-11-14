gap> START_TEST( "gh-00125.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# a copy of a Sylow 5-subgroup of PSp(4, 25) with the pcgs that
# IsomorphismPcGroup gave it from a permutation group: pq read the
# automorphisms in its own pcp instead (fixed by #96), and found 13
# instead of 60 descendants
gap> G := PcGroupCode(
> 677636766166503838357166408114169931500488508438733603362824608830998635875518369536,
>   5^8 );;
gap> Length( PqDescendants( G : StepSize := 2, Exponent := 5 ) );
60

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00125.tst", 1 );
