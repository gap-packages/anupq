#############################################################################
####
##
#W  anupqhead.g                ANUPQ package                    Werner Nickel
#W                                                                Greg Gamble
##
##  `Head' file for the GAP interface to the ANU pq binary by Eamonn O'Brien.
#T  This should be split into `.gd' and `.gi' files.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqhead_g :=
    "@(#)$Id$";


#############################################################################
##
#V  ANUPQData . . record used by various functions of the ANUPQ package
##
##  The fields of ANUPQData are:
##
##    "binary"  . . the path of the pq binary
##    "tmpdir"  . . the path of the temporary directory for pq i/o files
##    "io"  . . . . list of data records for PqStart IO Streams
##    "outfile" . . the path of the pq output file
##    "SPimages"  . the path of the pq GAP_library file
##    "version" . . the version of the current pq binary
##
DeclareGlobalVariable( "ANUPQData",
  "A record containing various data associated with the ANUPQ package."
);
InstallValue( ANUPQData,
  rec( binary := Filename( DirectoriesPackagePrograms( "anupq" ), "pq"),
       tmpdir := DirectoryTemporary(),
       ni := rec(), # record for non-interactive functions
       io := []     # list of records for PqStart IO Streams,
                    #  of which, there are initially none
       )
);
ANUPQData.outfile  := Filename( ANUPQData.tmpdir, "PQ_OUTPUT" );
ANUPQData.SPimages := Filename( ANUPQData.tmpdir, "GAP_library" );

# Fire up the pq binary to get its version
Exec( Concatenation( ANUPQData.binary, " -v >", ANUPQData.outfile ) );
ANUPQData.version := StringFile( ANUPQData.outfile );
ANUPQData.version := 
    ANUPQData.version{[PositionSublist( ANUPQData.version, "Version" ) + 8 ..
                       Length(ANUPQData.version) - 1] };

#############################################################################
##  
#I  InfoClass
##
DeclareInfoClass( "InfoANUPQ" );

# Set the default level of InfoANUPQ
SetInfoLevel( InfoANUPQ, 1 );

#############################################################################
##
##  Print a banner . . . . . .  using InfoWarning (so a user can turn it off)
##
if not QUIET and BANNER then

Info(InfoWarning,1,"  Loading the ANUPQ (ANU p-Quotient) package");
Info(InfoWarning,1,"  C code by  Eamonn O'Brien <obrien@math.auckland.ac.nz>");
Info(InfoWarning,1,"              ANU pq binary version: ", ANUPQData.version);
Info(InfoWarning,1,"  GAP code by Werner Nickel <nickel@mathematik.tu-darmstadt.de>");
Info(InfoWarning,1,"          and   Greg Gamble  <gregg@math.rwth-aachen.de>");
Info(InfoWarning,1,"              ANUPQ package version: ",
                                    PACKAGES_VERSIONS.anupq);
Info(InfoWarning,1,"");
Info(InfoWarning,1,"              For help, type: ?ANUPQ");

fi;

#############################################################################
##
##  Ensure no zombie `pq' processes from interactive (`PqStart') sessions are 
##  left lying around when user quits GAP.
##
InstallAtExit( PqQuitAll );

#E  anupqhead.g . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
