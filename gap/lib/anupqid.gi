#############################################################################
####
##
#W  anupqid.gi              ANUPQ package                       Werner Nickel
#W                                                                Greg Gamble
##
##  This file installs functions to do with evaluating identities.
##
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqid_gi :=
    "@(#)$Id$";


#############################################################################
##
#F  PqEvalSingleRelation( <proc>, <r>, <instances> )
##
InstallGlobalFunction( PqEvalSingleRelation, function( proc, r, instances )
    local   w, datarec;

#    Print( instances, "\n" );

    datarec := ANUPQDataRecord(proc);
    datarec.nwords := datarec.nwords + 1;
    w := CallFuncList( r, instances );
    if w <> w^0 then 
#        Print( w );
#        Print( "\n" );
#        PqSetOutputLevel( proc, 3 );
        PqCollect( proc, String(w) ); 
        PqEchelonise( proc );
#        PqSetOutputLevel( proc, 0 );
    fi;
    return false;
end );

#############################################################################
##
#F  PqEnumerateWords( <proc>, <data>, <r> )
##
##    The parameters of PqEnumerateWords() have the following meaning:
##
##    <r>          a relation involving identical generators.
##    <instances>  the list of instances to be built up corresponding the
##                 identical generators. 
##    <n>          the index of the current word in <instances>
##    <g>          the next generator in the current word
##    <wt>         the weight that can be spent on the next generators.
##
InstallGlobalFunction( PqEnumerateWords, function( proc, data, r )
    local   n,  g,  wt,  u,  save_wt,  save_u,  save_g;

    n  := data.currentinst;
    g  := data.currentgen;
    wt := data.weightleft;
    u  := data.instances[ n ];

    save_wt := wt;
    save_u  := u;
    save_g  := g;

    if wt = 0 then
        if PqEvalSingleRelation( proc, r, data.instances ) then
            Info( InfoANUPQ, 1, "essential: ", data ); 
        fi;
        return;
    fi;
    
    if g > Length( data.pcgens ) then return; fi;

    while g <= data.nrpcgens and data.pcweights[g] <= wt do
        while data.pcweights[g] <= wt do
            u := u * data.pcgens[g];
            wt := wt - data.pcweights[g];

            data.instances[ n ] := u;
            data.weightleft     := wt;
            data.currentgen     := g+1; 
            PqEnumerateWords( proc, data, r );

            if n < Length(data.instances) then
                data.currentinst := n+1;
                data.currentgen  := 1;
                PqEnumerateWords( proc, data, r );
                data.currentinst := n;
            fi;
        od;
        u  := save_u; wt := save_wt; g := g+1;
    od;
    data.instances[ n ] := save_u;
    data.weightleft     := save_wt;
    data.currentgen     := save_g;
end );

#############################################################################
##
#F  PqEvaluateIdentity( <proc>, <r>, <nridgens> )
##
InstallGlobalFunction( PqEvaluateIdentity, function( proc, r, nridgens )
    local   n,  class,  gens,  data,  c;

    n     := PqNrPcGenerators( proc );
    class := PqWeight( proc, n );
    if class > 1 then
        while n > 0 and PqWeight( proc, n ) = class do n := n-1; od;
    fi;

    if n = 0 then return; fi;

    gens := GeneratorsOfGroup( FreeGroup( n, "x" ) );
    data := rec( instances   := List( [1..nridgens], i->gens[1]^0 ),
                 currentinst := 1,
                 currentgen  := 1,
                 weightleft  := 0,
                 pcgens      := gens,
                 nrpcgens    := n,
                 pcweights   := List( [1..n], i->PqWeight( proc, i ) )
                 );
    
    for c in [1..class] do
#        Print( "words of class ", c, "\n" );
        data.weightleft := c;
        PqEnumerateWords( proc, data, r );
    od;

end );

#############################################################################
##
#F  PqIdentity( <G>, <p>, <Cl>, <identity> )
##
InstallGlobalFunction( PqIdentity, function( G, p, Cl, identity )
    local   proc,  datarec,  prev_n,  class,  grp, arity;

    arity := NumberArgumentsFunction( identity );

    proc := PqStart( G : Prime := p );
    datarec := ANUPQData.io[ proc ];
    datarec.nwords := 0;

    prev_n := 0;
    Pq( proc : ClassBound := 1 );    class := 1;
    
    PqEvaluateIdentity( proc, identity, arity );
    PqEliminateRedundantGenerators( proc );

    if PqNrPcGenerators( proc ) = 0 then
        return TrivialGroup( IsPcGroup );
    fi;

    while class < Cl and prev_n <> PqNrPcGenerators( proc ) do
        prev_n := PqNrPcGenerators( proc );

        PqSetupTablesForNextClass( proc );
        PqTails( proc, 0 );
        PqDoConsistencyChecks( proc, 0, 0 );
        PqCollectDefiningRelations( proc );

        PqDoExponentChecks( proc );
        
        datarec.nwords := 0;
        PqEvaluateIdentity( proc, identity, arity );
        Info(InfoANUPQ, "evaluated ", datarec.nwords, " instances." );

        PqEliminateRedundantGenerators( proc );

        class := class + 1;
        
        Print( "#  class ", class, " with ", PqNrPcGenerators(proc),
               " generators\n" );

    od;

    grp := PqCurrentGroup( proc );

    PqQuit( proc );

    return grp;
end );
    
#E  anupqid.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
