#############################################################################
##
#W  init.g                   ANUPQ package                      Werner Nickel
#W                                                                Greg Gamble
##
##  @(#)$Id$
##

if not CompareVersionNumbers( VERSION, "4.4") then
  if not IsBound(GAPInfo) then
    BindGlobal( "GAPInfo", rec(DirectoriesTemporary := DIRECTORIES_TEMPORARY,
                               PackagesInfo := rec(),
                               PackagesLoaded := LOADED_PACKAGES) );
  fi;
  GAPInfo.PackagesInfo.anupq 
      := [rec(Version :=
          Chomp(StringFile(Filename( DirectoriesPackageLibrary("anupq", ""),
                                     "VERSION" ))))];
fi;

##  Install the documentation
DeclarePackageAutoDocumentation( "ANUPQ", "doc", "ANUPQ",
                                 "GAP Package for computing p-Quotients" );

##
##  Announce the package version and test for the existence of the binary.
##
DeclarePackage( "anupq", GAPInfo.PackagesInfo.anupq[1].Version,
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
ReadPkg( "anupq", "lib/anupqhead.g" );

#E  init.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
