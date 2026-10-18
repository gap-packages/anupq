gap> START_TEST( "degree_overflow.tst" );
gap> SetInfoLevel( InfoANUPQ, 1 );

# Issue #32: the number of allowable subgroups (here 209386049731) does not
# fit in an int. pq reported this and, when run by GAP (option -G), went on
# with a partial count and crashed; GAP still raised the error below, so
# this test passes on both, and the crash is only visible standalone
# (pq -G with this input); now pq exits after the message
gap> G := PcGroupCode( 5720184869874057666191942025326282294078349057, 2^9 );;
gap> StandardPresentation( G );
#I  Evaluation in compute_degree may cause integer overflow
Error, pq program terminated, with error condition:
  Evaluation in compute_degree may cause integer overflow

gap> PqQuitAll();
gap> STOP_TEST( "degree_overflow.tst", 1 );
