gap> START_TEST( "gh-00067.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# PqStandardPresentation hung, or the stabiliser of the allowable subgroup
# was wrong, when the soluble automorphisms act on the Frattini quotient
# See https://github.com/gap-packages/anupq/issues/67
gap> G := PcGroupCode( 103045295174713575554546522863434350004438213623550127541012273, 512 );;  # SmallGroup(512, 383371)
gap> H := PcGroupCode( 43868419351818131989320407468466194305, 512 );;  # SmallGroup(512, 383419)
gap> PqStandardPresentation( G );
<fp group on the generators [ f1, f2, f3, f4, f5, f6, f7, f8, f9 ]>
gap> PqStandardPresentation( H );
<fp group on the generators [ f1, f2, f3, f4, f5, f6, f7, f8, f9 ]>
gap> K := PcGroupCode( 36021959920864, 64 );;  # SmallGroup(64, 241)
gap> PqStandardPresentation( K );
<fp group on the generators [ f1, f2, f3, f4, f5, f6 ]>

#
gap> PqQuitAll();
gap> STOP_TEST( "gh-00067.tst", 1 );
