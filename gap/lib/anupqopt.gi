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
#V  PQ_FUNCTION . . . . . . . . . internal functions called by user functions 
##
##  A record whose fields are (function)  names  and  whose  values  are  the
##  internal functions called by the functions with those names.
##
InstallValue( PQ_FUNCTION, 
              rec( Pq                   := PQ_EPIMORPHISM,
                   PqDescendants        := PQ_DESCENDANTS,
                   StandardPresentation := PQ_EPIMORPHISM_STANDARD_PRESENTATION
                  )
             );

#############################################################################
##
#V  ANUPQoptions  . . . . . . . . . . . . . . . . . . . .  admissible options
##
##  is a record of lists of names of admissible {\ANUPQ} options,  such  that
##  each field is either the name of a ``key'' {\ANUPQ} function  or  `other'
##  (for a miscellaneous list of functions) and the  corresponding  value  is
##  the list of option  names  that  are  admissible  for  the  function  (or
##  miscellaneous list of functions).
##
InstallValue( ANUPQoptions, 
              rec( # options for `Pq' and `PqEpimorphism'
                   Pq  := [ "Prime", 
                            "ClassBound", 
                            "Exponent", 
                            "Metabelian", 
                            "OutputLevel", 
                            "Relators", 
                            "GroupName", 
                            "SetupFile",
                            "PqWorkspace" ],

                   # options for `PqDescendants'
                   PqDescendants
                       := [ "ClassBound", 
                            "OrderBound", 
                            "Relators", 
                            "GroupName", 
                            "StepSize", 
                            "PcgsAutomorphisms", 
                            "BasicAlgorithm", 
                            "RankInitialSegmentSubgroups", 
                            "SpaceEfficient", 
                            "CapableDescendants", 
                            "AllDescendants", 
                            "Exponent", 
                            "Metabelian", 
                            "SubList", 
                            "BasicAlgorithm",
                            "TailorOutput",
                            "SetupFile" ],

                   # options for `[Epimorphism][Pq]StandardPresentation'
                   StandardPresentation
                       := [ "Prime", 
                            "ClassBound", 
                            "Relators", 
                            "GroupName", 
                            "PcgsAutomorphisms", 
                            "Exponent", 
                            "Metabelian", 
                            "OutputLevel", 
                            "StandardPresentationFile", 
                            "SetupFile" ],

                   # miscellaneous options
                   other
                       := [ "QueueFactor", 
                            "Bounds" ]
                  )
             );

#############################################################################
##
#F  AllANUPQoptions() . . . . .  lists all options of the ANUPQ share package
##
##  lists all the {\GAP} options defined for functions of the {\ANUPQ}  share
##  package.
##
InstallGlobalFunction( AllANUPQoptions, function()
  return Set( Concatenation(
                  List( RecNames(ANUPQoptions), fld -> ANUPQoptions.(fld) )
                  ) );
end );

#############################################################################
##
#V  ANUPQGlobalOptions . . . . .  options that can be set globally by PqStart
##
##  A list of the options that `PqStart' can set and thereby  make  available
##  to any function  interacting  with  the  {\ANUPQ}  process  initiated  by
##  `PqStart'.
##
InstallValue( ANUPQGlobalOptions, [ "Prime", "Exponent", "Relators" ] );

#############################################################################
##
#V  ANUPQoptionChecks . . . . . . . . . . . the checks for admissible options
##
##  A record whose fields are the names of admissible ANUPQ options and whose
##  values are one-argument functions that return `true' when given  a  value
##  that is a valid value for the option, and `false' otherwise.
##
InstallValue( ANUPQoptionChecks,
              rec( Prime := x -> IsInt(x) and IsPrimeInt(x),
                   ClassBound := IsPosInt,
                   OrderBound := IsPosInt,
                   Exponent   := IsPosInt,
                   Metabelian := IsBool,
                   GroupName  := IsString,
                   OutputLevel := x -> x in [0..3],
                   Relators   := x -> IsList(x) and ForAll(x, IsString),
                   StandardPresentationFile := IsString,
                   SetupFile  := IsString,
                   PqWorkspace := IsPosInt,
                   StepSize := x -> IsPosInt(x) or
                                    (IsList(x) and ForAll(x, IsPosInt)), 
                   PcgsAutomorphisms := IsBool,
                   BasicAlgorithm := IsBool,
                   RankInitialSegmentSubgroups := x -> x = 0 or IsPosInt(x),
                   SpaceEfficient := IsBool,
                   CapableDescendants := IsBool,
                   AllDescendants := IsBool,
                   SubList := x -> IsPosInt(x) or
                                   (IsSet(x) and ForAll(x, IsInt)
                                    and IsPosInt(x[1])),
                   TailorOutput := IsRecord,
                   Bounds := x -> IsSet(x) and 2 = Length(x) and 
                                  ForAll(x, IsPosInt),
                   QueueFactor := IsPosInt,
                   OutputFile := IsString
                   )
             );

#############################################################################
##
#V  ANUPQoptionTypes . . . . . .  the types (in words) for admissible options
##
##  A record whose fields are the names of admissible ANUPQ options and whose
##  values are valid types of the options in plain words.
##
InstallValue( ANUPQoptionTypes,
              rec( Prime := "prime integer",
                   ClassBound := "positive integer",
                   OrderBound := "positive integer",
                   Exponent   := "positive integer",
                   Metabelian := "boolean",
                   GroupName  := "string",
                   OutputLevel := "integer in [0..3]",
                   Relators   := "list of strings",
                   StandardPresentationFile := "string",
                   SetupFile  := "string",
                   PqWorkspace := "positive integer",
                   StepSize := "positive integer or positive integer list",
                   PcgsAutomorphisms := "boolean",
                   BasicAlgorithm := "boolean",
                   RankInitialSegmentSubgroups := "nonnegative integer",
                   SpaceEfficient := "boolean",
                   CapableDescendants := "boolean",
                   AllDescendants := "boolean",
                   SubList 
                       := "pos've integer or increasing pos've integer list",
                   TailorOutput := "record",
                   Bounds := "pair of increasing positive integers",
                   QueueFactor := "positive integer",
                   OutputFile := "string"
                   )
             );

#############################################################################
##
#F  VALUE_PQ_OPTION( <optname> ) . . . . . . . . . enhancement of ValueOption
#F  VALUE_PQ_OPTION( <optname>, <defaultval> ) 
#F  VALUE_PQ_OPTION( <optname>, <datarec> ) 
#F  VALUE_PQ_OPTION( <optname>, <defaultval>, <datarec> ) 
##
##  If the value <optval> of <optname> is not `fail' and it is  an  ok  value
##  for <optname> then <optval> is returned; if <optval> is not an  ok  value
##  an error is  signalled.  If  <optval>  is  `fail'  and  <datarec>  on  an
##  interactive function call and <datarec>.(<optname>) is already bound then
##  that value is returned; otherwise, if <optval> is `fail'  and  a  default
##  value <defaultval> different from `fail' is supplied then <defaultval> is
##  returned. Supplying a <defaultval> of `fail'  is  special;  it  indicates
##  that option <optname> must have a value i.e. <optval> is not  allowed  to
##  be `fail' and if it is an error is signalled. If a <datarec> argument  is
##  supplied, which must be a record, then the return value,  if  not  `fail'
##  and a legal value, is also stored in `<datarec>.(<optname>)'.
##
##  *Note:* <defaultval> cannot be a record.
##
InstallGlobalFunction(VALUE_PQ_OPTION, function(arg)
local optname, optval, len;
  optname := arg[1];
  optval := ValueOption(optname);
  len := Length(arg);
  if optval = fail then
    if 1 = len then
      return optval;
    elif IsRecord( arg[len] ) and IsBound( arg[len].calltype ) and
         arg[len].calltype="interactive" and IsBound( arg[len].(optname) ) then
      # return the previously recorded value
      return arg[len].(optname);
    elif not IsRecord(arg[2]) then
      if arg[2] = fail then
        Error("you must supply a value for option: \"", optname, "\"\n");
      fi;
      optval := arg[2]; 
    fi;
  elif not ANUPQoptionChecks.(optname)(optval) then
    Error("\"", optname, "\" value must be a ", 
          ANUPQoptionTypes.(optname), "\n");
  fi;
  if (optval <> fail) and (2 <= len) and IsRecord(arg[len]) and 
     not( IsBound( arg[len].calltype ) and 
          (arg[len].calltype = "interactive") and
          optname in ANUPQGlobalOptions ) then
    arg[len].(optname) := optval;
  fi;
  return optval;
end);
  
#############################################################################
##
#F  SET_GLOBAL_PQ_OPTION(<optname>,<datarec>) .  set global option in PqStart
##
##  If  <optname>  is  passed  as  an   option   and   it   is   valid   then
##  `<datarec>.(<optname>)' is set. This is only called by `PqStart'.
##
InstallGlobalFunction(SET_GLOBAL_PQ_OPTION, function(optname, datarec)
local optval;
  optval := ValueOption(optname);
  if optval <> fail then
    if not ANUPQoptionChecks.(optname)(optval) then
      Error("\"", optname, "\" value must be a ", 
            ANUPQoptionTypes.(optname), "\n");
    fi;
    datarec.(optname) := optval;
  fi;
end);
  
#############################################################################
##
#F  PQ_BOOL( <optval> ) . .  convert a GAP boolean to a `pq' (i.e. C) boolean
##    
##  returns `"1 #do "' if <optval> is `true' or `"0  #do  not  "'  otherwise,
##  i.e. a string C boolean with the beginnings of a comment (we assume  that
##  <optval> is boolean ... `VALUE_PQ_OPTION'  should  already  have  checked
##  that).
##
InstallGlobalFunction( PQ_BOOL, function( optval )
  if optval = true then
    return "1  #do ";
  fi;
  return "0  #do not ";
end);
  
#############################################################################
##
#F  PQ_DO_TAILORED_OUTPUT(<datarec>, <subopt>, <suboptstring>, <suppstrings>)
##    
##  writes the requires output to the `pq' binary for the sub-option <subopt>
##  of the option `TailorOutput', the value of that option having  previously
##  been stored in `<datarec>.des.TailorOutput'; <suboptstring>  is  part  of
##  the  comment  written  to  the  `pq'  binary  for  the   sub-option   and
##  <suppstrings> is a list of such comments for the supplementary  questions
##  asked by the `pq' binary for the sub-option <subopt>.
##
InstallGlobalFunction( PQ_DO_TAILORED_OUTPUT, 
function(datarec, subopt, suboptstring, suppstrings)
local optrec, isOptionSet, i;
  optrec := datarec.des.TailorOutput;
  if IsEmpty(suppstrings) then
    isOptionSet := IsBound( optrec.(subopt) ) and optrec.(subopt) in [1, true];
    ToPQ(datarec, [ PQ_BOOL( isOptionSet ), suboptstring ]);
  elif IsBound( optrec.(subopt) ) and IsList( optrec.(subopt) ) then
    ToPQ(datarec, [ "0  #tailor ", suboptstring ]);
    for i in [1 .. Length(suppstrings)] do
      isOptionSet := IsBound( optrec.(subopt)[i] ) and
                     optrec.(subopt)[i] in [1, true];
      ToPQ(datarec, [ PQ_BOOL( isOptionSet ), suppstrings[i] ]);
    od;
  else
    ToPQ(datarec, [ "1  #default ", suboptstring ]);
  fi;
end);
  
#############################################################################
##
#F  SET_ANUPQ_OPTIONS( <funcname>, <fnname> )  . set options from OptionStack
##    
##  When called by a function with name  <funcname>  sets  the  options  from
##  `OptionsStack'    checking    that    they    are     a     subset     of
##  `ANUPQoptions.<fnname>'. Both <funcname> and <fnname> should be strings.
##
InstallGlobalFunction( SET_ANUPQ_OPTIONS, function( funcname, fnname )
    local optrec, optnames, opt;

    # there should be options
    if IsEmpty( OptionsStack ) then
        # no options??
        optrec := rec();
        Info( InfoANUPQ, 1, funcname, " called with no options!" );
    else
        optrec := ShallowCopy( OptionsStack[ Length( OptionsStack ) ] );
        optnames := Set( REC_NAMES(optrec) );
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
            Unbind( optrec.(opt) );
        od;
    fi;
    return optrec;
end );

#############################################################################
##
#F  ANUPQoptError( <funcname>, <illegal> )  . . . . . create an error message
##
##  creates an error message  for  the  function  with  name  <funcname>.  If
##  <illegal> is a string it is taken to be  the  first  line  of  the  error
##  message. Otherwise <illegal> should be alist of illegal options (strings)
##  found. The error message (string) returned also gives the list  of  valid
##  options together with the value types expected for function <funcname>.
##
InstallGlobalFunction( ANUPQoptError, function( funcname, illegal )
    local Optstring, Valstring, errmsg, optname;

    Optstring := optname -> Concatenation("\"", optname, "\"");
    Valstring := optval  -> Concatenation("<",  optval,  ">");

    if IsString(illegal) then
        errmsg := illegal;
    else # IsList(illegal)
        errmsg := Concatenation("Illegal ", funcname, " option");
        if Length(illegal) > 1 then
            Append(errmsg, "s");
        fi;
        Append(errmsg, ": ");
        Append(errmsg, JoinStringsWithSeparator( List(illegal, Optstring) ));
    fi;
    Append(errmsg, Concatenation(".\nValid ", funcname, " options:\n"));
    for optname in ANUPQoptions.(funcname) do
        Append(errmsg, "    ");
        Append(errmsg, Optstring(optname));
        if ANUPQoptionChecks.(optname) <> IsBool then
            Append(errmsg, ", ");
            Append(errmsg, Valstring( ANUPQoptionTypes.(optname) ));
        fi;
        Append(errmsg, "\n");
    od;
    return errmsg;
end );

#############################################################################
##
#F  ANUPQextractOptions( <funcname>, <args> ) . . . . . . . . extract options
##
##  extracts options from  <args>  for  function  with  name  <funcname>  and
##  returns a record suitable for use with `PushOptions'.  Abbreviations  are
##  allowed for option names so long as  each  abbreviates  a  unique  option
##  name.
##
InstallGlobalFunction( ANUPQextractOptions, function(funcname, args)
    local   Match, error, optrec, i, optname;

    # allow to give only a prefix
    Match := function( argi )
        local matches;
        if IsString(argi) then
            matches := Filtered(ANUPQoptions.(funcname), 
                                optname -> 0 < Length(argi) and
                                           Length(argi) <= Length(optname) and
                                           optname{[1..Length(argi)]} = argi);
            if 1 = Length(matches) then
                return matches[1];
            fi;
            error := Concatenation( "argument: \"", argi, 
                                    "\" doesn't abbreviate a unique option");
        else
            error := Concatenation( "argument: ", String(argi),
                                    " is not a (non-null) string (option name)"
                                    );
        fi;
        return fail;
    end;

    # extract options from args
    optrec := rec();
    i := 1;
    while i <= Length(args)  do
        optname := Match( args[i] );
        if optname = fail then 
            Error( ANUPQoptError( funcname, error ) );
        elif ANUPQoptionChecks.(optname) = IsBool then
            optrec.(optname) := true;
            i := i + 1;
        elif i = Length(args) then
            # all remaining options are non-boolean and expect a value to
            # follow
            Error( ANUPQoptError( 
                       funcname,
                       Concatenation( "Expected value for option: ", args[i] )
                       ) );
        else
            # checking values are ok is done later
            optrec.(optname) := args[i + 1];
            i := i + 2;
        fi;
    od;
    return optrec;

end );

#E  anupqopt.gi . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
