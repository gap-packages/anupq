#############################################################################
##
#W  init.g                ANUPQ share package                   Werner Nickel
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

##  Install the documentation
DeclarePackageAutoDocumentation( "anupq", "doc" );

##
##  Announce the package version and test for the existence of the binary.
##
DeclarePackage( "anupq","1.0", 
function()
    local path;

    # test for existence of the compiled binary
    path := DirectoriesPackagePrograms( "anupq" );

    if Filename( path, "pq" ) = fail then
        Info( InfoWarning, 1,
              "Package ``anupq'': The executable program is not available" );
        return fail;
    fi;

    return true;
end );


#############################################################################
##
#R  Read the head file and declaration files.
##
ReadPkg( "anupq", "gap/lib/anupqhead.g" );
ReadPkg( "anupq", "gap/lib/anupqprop.gd" );
ReadPkg( "anupq", "gap/lib/anupq.gd" );
ReadPkg( "anupq", "gap/lib/anupga.gd" );
ReadPkg( "anupq", "gap/lib/anusp.gd" );
ReadPkg( "anupq", "gap/lib/anupqopt.gd" );

#E  init.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
