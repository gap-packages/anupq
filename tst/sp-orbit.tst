gap> START_TEST( "sp-orbit.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# At class 2, SmallGroup(256, 30469) has 6347715 allowable subgroups, of
# which 26040 lie in the orbit a standard presentation needs, so pq acts
# on that orbit only; the presentation is the one pq computed before
gap> G := SmallGroup( 256, 30469 );;
gap> for r in RelatorsOfFpGroup( StandardPresentation( G ) ) do
>      Print( r, "\n" );
>    od;
f1^2
f2^2*f8^-1
f3^2*f8^-1*f6^-1
f4^2*f6^-1
f5^2*f6^-1
f6^2
f7^2
f8^2
f2^-1*f1^-1*f2*f1*f6^-1
f3^-1*f1^-1*f3*f1*f7^-1
f3^-1*f2^-1*f3*f2*f8^-1
f4^-1*f2^-1*f4*f2*f7^-1
f4^-1*f3^-1*f4*f3*f6^-1
f5^-1*f2^-1*f5*f2*f6^-1

# isomorphic groups get the same presentation, non-isomorphic ones do not
gap> pcgs := Pcgs( G );;
gap> H := PcGroupWithPcgs( PcgsByPcSequence( FamilyObj( One( G ) ),
>          Concatenation( [ pcgs[1] * pcgs[2], pcgs[2] * pcgs[5] ],
>                         pcgs{[3..8]} ) ) );;
gap> IsPqIsomorphicPGroup( G, H );
true
gap> IsPqIsomorphicPGroup( G, SmallGroup( 256, 46239 ) );
false

#
gap> PqQuitAll();
gap> STOP_TEST( "sp-orbit.tst", 1 );
