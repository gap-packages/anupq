#############################################################################
####
##
#W  anupqopt.gi             ANUPQ Share Package                 Werner Nickel
#W                                                                Greg Gamble
##
##  Install file for functions to do with option manipulation.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqopt_gi :=
    "@(#)$Id$";

#############################################################################
##
#V  ANUPQoptions  . . . . . . . . . . . . . . . . . . . .  admissible options
##
##  A record of lists of names of admissible ANUPQ options. Each field is the
##  name of an ANUPQ function and the corresponding  value  is  the  list  of
##  names of admissible for the function.
##
InstallValue( ANUPQoptions, 
              rec( # options for `Pq' and `PqEpimorphism'
                   Pq  := [ "Prime", 
                            "ClassBound", 
                            "Exponent", 
                            "Metabelian", 
                            "OutputLevel", 
                            "Verbose", 
                            "SetupFile",
                            "PqWorkspace" ],

                   # options for `PqDescendants'
                   PqDescendants
                       := [ "ClassBound", 
                            "OrderBound", 
                            "StepSize", 
                            "PcgsAutomorphisms", 
                            "RankInitialSegmentSubgroups", 
                            "SpaceEfficient", 
                            "AllDescendants", 
                            "Exponent", 
                            "Metabelian", 
                            "SubList", 
                            "TmpDir", 
                            "Verbose", 
                            "SetupFile" ],

                   # options for `[Epimorphism][Pq]StandardPresentation'
                   StandardPresentation
                       := [ "Prime", 
                            "ClassBound", 
                            "PcgsAutomorphisms", 
                            "Exponent", 
                            "Metabelian", 
                            "OutputLevel", 
                            "TmpDir",
                            "Verbose", 
                            "SetupFile" ]
                  )
             );

#############################################################################
##
#F  SET_ANUPQ_OPTIONS( <funcname>, <fnname> )  . set options from OptionStack
##    
##  When called by a function with name  <funcname>  sets  the  options  from
##  `OptionsStack'    checking    that    they    are     a     subset     of
##  `ANUPQoptions.<fnname>'. Both <funcname> and <fnname> should be strings.
##
InstallGlobalFunction( SET_ANUPQ_OPTIONS, function( funcname, fnname )
    local CR, optnames, opt;

    # there should be options
    if IsEmpty( OptionsStack ) then
        # no options??
        CR := rec();
        Info( InfoANUPQ, 1, funcname, " called with no options!" );
    else
        CR := ShallowCopy( OptionsStack[ Length( OptionsStack ) ] );
        optnames := Set( REC_NAMES(CR) );
        SubtractSet( optnames, Set( ANUPQoptions.(fnname) ) );
        Info( InfoANUPQ, 2, funcname, " called with options: ", 
                            OptionsStack[ Length( OptionsStack ) ] );
        if 0 < Length(optnames) then
            # it's not an error to have unknown options,
            # function may have been called recursively and the 
            # options may be intended for some other function
            Info( InfoWarning + InfoANUPQ, 2,
                  funcname, " called with unknown options: ", optnames);
        fi;
        for opt in optnames do
            Unbind( CR.(opt) );
        od;
    fi;
    return CR;
end );

#E  anupqopt.gi . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
