#############################################################################
##
#W  init.g                   ANUPQ package                      Werner Nickel
##
##  @(#)$Id$
##

##  Compatibility with GAP 4.2
if not IsBound( PolycyclicFactorGroupNC ) then
    PolycyclicFactorGroupNC := PolycyclicFactorGroup;
fi;

if not IsBound( PcGroupFpGroupNC ) then
    PcGroupFpGroupNC := PcGroupFpGroup;
fi;

ANUPQPackageVersion := function()
  local versionfile, stream, version;
  versionfile := Filename( DirectoriesPackageLibrary("anupq", ""), "VERSION" );
  stream := InputTextFile( versionfile );
  version := ReadAll(stream);
  CloseStream(stream);
  return version{[1..Length(version) - 1]};
end;

##  Install the documentation
DeclarePackageAutoDocumentation( "anupq", "doc" );

##
##  Announce the package version and test for the existence of the binary.
##
DeclarePackage( "anupq", ANUPQPackageVersion(),
  function()
    local path;

    if not CompareVersionNumbers( VERSION, "4.2" ) then
        Info( InfoWarning, 1,
              "Package ``ANUPQ'': requires at least GAP 4.2" );
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
if TestPackageAvailability( "autpgrp", "1.0" ) <> fail then
    RequirePackage( "autpgrp" );
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
if not CompareVersionNumbers( VERSION, "4.3" ) then
    ReadPkg( "anupq", "lib/anupq4r2cpt.gd" );
    ReadPkg( "anupq", "lib/anupq4r2cpt.gi" );
fi;
ReadPkg( "anupq", "lib/anupqhead.g" );

#E  init.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
