gap> START_TEST( "sp-transporter-space.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# The automorphism mapping the allowable subgroup to its orbit
# representative is a word of 10833 letters here, which pq copied into the
# workspace without a check: with PqWorkspace := 5000 it wrote past the end
# and died, instead of running out of space
gap> G := SmallGroup( 2187, 9100 );;
gap> StandardPresentation( G : PqWorkspace := 5000 );
#I  Ran out of space during computation
Error, pq program terminated, with error condition:
  Ran out of space during computation

gap> if not IsEmpty( OptionsStack ) then ResetOptionsStack(); fi;
gap> Length( RelatorsOfFpGroup(
>        StandardPresentation( G : PqWorkspace := 12000 ) ) );
10

#
gap> PqQuitAll();
gap> STOP_TEST( "sp-transporter-space.tst", 1 );
