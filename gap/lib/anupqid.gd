#############################################################################
####
##
#W  anupqid.gd              ANUPQ package                       Werner Nickel
#W                                                                Greg Gamble
##
##  This file declares functions to do with evaluating identities.
##
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqid_gd :=
    "@(#)$Id$";


#############################################################################
##
#F  PqEvalSingleRelation( <proc>, <r>, <instances> )
##
DeclareGlobalFunction( "PqEvalSingleRelation" );
    
#############################################################################
##
#F  PqEnumerateWords( <proc>, <data>, <r> )
##
DeclareGlobalFunction( "PqEnumerateWords" );

#############################################################################
##
#F  PqEvaluateIdentity( <proc>, <r>, <nridgens> )
##
DeclareGlobalFunction( "PqEvaluateIdentity" );

#############################################################################
##
#F  PqIdentity( <G>, <p>, <Cl>, <identity> )
##
DeclareGlobalFunction( "PqIdentity" );
    
#E  anupqid.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
