#############################################################################
####
##
#W  anupqi.gi           ANUPQ Share Package                       Greg Gamble
##
##  This file installs interactive functions that execute individual pq  menu
##  options.
##
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqi_gi :=
    "@(#)$Id$";

#############################################################################
##
#F  PQ_PC_PRESENTATION( <datarec> : <options> ) . . . . . . p-Q menu option 1
##
##  inputs  data  given  by  <options>  to  the   `pq'   binary   for   group
##  `<datarec>.group' to compute a pc presentation  (option  1  of  the  main
##  p-Quotient menu).
##
InstallGlobalFunction( PQ_PC_PRESENTATION, function( datarec )
local gens, rels;

  PQ_MENU(datarec, "pQ");

  # at least "Prime" and "Class" must be given
  if not IsInt( ValueOption( "Prime" ) ) then
    Error( "you must supply a prime" );
  fi;
  if not IsInt( ValueOption( "ClassBound" ) ) then
    Error( "you must supply a class bound" );
  fi;

  # Option 1 of p-Quotient Menu: defining the group
  ToPQk(datarec, [ "1  #define group" ]);
  ToPQk(datarec, [ "prime ",    ValueOption( "Prime") ]);
  ToPQk(datarec, [ "class ",    ValueOption( "ClassBound") ]);
  ToPQk(datarec, [ "exponent ", VALUE_PQ_OPTION( "Exponent", 0) ]);
  if ValueOption( "Metabelian" ) = true then
    ToPQk(datarec, [ "metabelian" ]);
  fi;
  if IsInt( ValueOption( "OutputLevel" ) ) then
    ToPQk(datarec, [ "output ", ValueOption( "OutputLevel" ) ]);
  fi;
  gens := JoinStringsWithSeparator(
              List( FreeGeneratorsOfFpGroup( datarec.group ), String ) );
  ToPQk(datarec, [ "generators { ", gens, " }" ]);
  rels := JoinStringsWithSeparator(
              List( Filtered( RelatorsOfFpGroup( datarec.group ), 
                              rel -> not IsOne(rel) ), String ) );
  ToPQ(datarec, [ "relations  { ", rels, " };" ]);
end );

#############################################################################
##
#F  PqPcPresentation( <i> : <options> ) . . user version of p-Q menu option 1
#F  PqPcPresentation( : <options> )
##
##  for the <i>th or default interactive {\ANUPQ} process, inputs data  given
##  by <options> for the group of  that  process  so  that  the  `pq'  binary
##  computes a pc presentation, where the group of a process is the one given
##  as first argument when `PqStart' was called to initiate that process (for
##  process <i> the group is stored as `ANUPQData.io[<i>].group').
##
##  *Note:* For those  familiar  with  the  `pq'  binary,  `PqPcPresentation'
##  performs option 1 of the main p-Quotient menu.
##
InstallGlobalFunction( PqPcPresentation, function( arg )
local datarec;
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  PQ_PC_PRESENTATION( datarec );
  datarec.haspcp := true;
end );

#############################################################################
##
#F  PQ_WRITE_PC_PRESENTATION( <datarec>, <outfile> ) . . I p-Q menu option 25
##
##  tells the `pq' binary to write a pc presentation to <outfile>  for  group
##  `<datarec>.group' (option 25 of the interactive p-Quotient menu).
##
InstallGlobalFunction( PQ_WRITE_PC_PRESENTATION, function( datarec, outfile )
  PrintTo(outfile, ""); #to ensure it's empty
  PQ_MENU(datarec, "IpQ"); #we need options from the Interactive p-Q Menu
  ToPQ(datarec, [ "25 #set output file" ]);
  ToPQ(datarec, [ outfile ]);
  ToPQ(datarec, [ "2  #output in GAP format" ]);
end );

#############################################################################
##
#F  PqWritePcPresentation( <i>, <outfile> ) .  user ver. of I p-Q menu op. 25
#F  PqWritePcPresentation( <outfile> )
##
##  for the <i>th or default interactive {\ANUPQ}  process,  tells  the  `pq'
##  binary to write a pc presentation to <outfile>  for  the  group  of  that
##  process for which a pc presentation has been previously  computed,  where
##  the group of a process is the one given as first argument when  `PqStart'
##  was called to initiate that process (for process <i> the group is  stored
##  as  `ANUPQData.io[<i>].group').  If  a  pc  presentation  has  not   been
##  previously computed by the `pq' binary, then `pq' is called to compute it
##  first, effectively invoking `PqPcPresentation' (see~"PqPcPresentation").
##
##  *Note:* For those familiar with the `pq' binary,  `PqPcWritePresentation'
##  performs option 25 of the interactive p-Quotient menu.
##
InstallGlobalFunction( PqWritePcPresentation, function( arg )
local outfile, datarec;
  if 2 < Length(arg) or IsEmpty(arg) then
    Error("expected one or two arguments.\n");
  fi;
  outfile := arg[ Length(arg) ];
  if not IsString(outfile) then
    Error("last argument must be a string (filename).\n");
  fi;
  Unbind( arg[ Length(arg) ] );
  ANUPQ_IOINDEX_ARG_CHK(arg);
  datarec := ANUPQData.io[ ANUPQ_IOINDEX(arg) ];
  if not IsBound(datarec.haspcp) or not datarec.haspcp then
    Info(InfoANUPQ, 1, "pq had not previously computed a pc presentation");
    Info(InfoANUPQ, 1, "... remedying that now.");
    PQ_PC_PRESENTATION( datarec );
    datarec.haspcp := true;
  fi;
  PQ_WRITE_PC_PRESENTATION( datarec, outfile );
end );

#E  anupqi.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
