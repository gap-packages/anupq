#############################################################################
##
#W  init.g                   ANUPQ package                      Werner Nickel
#W                                                                Greg Gamble
##
##  @(#)$Id$
##

##  ANUPQ package 1.2 requires GAP 4.3fix4 ... compatibility with 4.2 futile
##  Compatibility with GAP 4.2
#if not IsBound( PolycyclicFactorGroupNC ) then
#    PolycyclicFactorGroupNC := PolycyclicFactorGroup;
#fi;
#
#if not IsBound( PcGroupFpGroupNC ) then
#    PcGroupFpGroupNC := PcGroupFpGroup;
#fi;

ANUPQPackageVersion := function()
  local versionfile, version;
  versionfile := Filename( DirectoriesPackageLibrary("anupq", ""), "VERSION" );
  version := StringFile(versionfile);
  return version{[1..Length(version) - 1]};
end;

##  Install the documentation
DeclarePackageAutoDocumentation( "ANUPQ", "doc", "ANUPQ",
                                 "GAP Package for computing p-Quotients" );

##
##  Announce the package version and test for the existence of the binary.
##
DeclarePackage( "anupq", ANUPQPackageVersion(),
  function()
    local path;

    if not CompareVersionNumbers( VERSION, "4.3fix4" ) then
        Info( InfoWarning, 1,
              "Package ``ANUPQ'': requires at least GAP 4.3fix4" );
        return fail;
    fi;

    # test for existence of the compiled binary
    path := DirectoriesPackagePrograms( "anupq" );

    if Filename( path, "pq" ) = fail then
        Info( InfoWarning, 1,
              "Package ``ANUPQ'': the executable program is not available" );
        return fail;
    fi;

    return true;
  end );

##
##  This is needed for `lib/anustab.gi'
##
if TestPackageAvailability( "autpgrp", "1.1" ) <> fail then
    RequirePackage( "autpgrp", "1.1" );
fi;

#############################################################################
##
#R  Read the head file and declaration files.
##
ReadPkg( "anupq", "lib/anupqprop.gd" );
ReadPkg( "anupq", "lib/anupq.gd" );
ReadPkg( "anupq", "lib/anupga.gd" );
ReadPkg( "anupq", "lib/anusp.gd" );
ReadPkg( "anupq", "lib/anupqopt.gd" );
ReadPkg( "anupq", "lib/anupqios.gd" );
ReadPkg( "anupq", "lib/anupqi.gd" );
ReadPkg( "anupq", "lib/anupqid.gd" );
ReadPkg( "anupq", "lib/anustab.gd" );
ReadPkg( "anupq", "lib/anupqxdesc.gd" );
##  ANUPQ package 1.2 requires GAP 4.3fix4 ... compatibility with 4.2 futile
#if not CompareVersionNumbers( VERSION, "4.3" ) then
#    ReadPkg( "anupq", "lib/anupq4r2cpt.gd" );
#    ReadPkg( "anupq", "lib/anupq4r2cpt.gi" );
#fi;
ReadPkg( "anupq", "lib/anupqhead.g" );

#E  init.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
