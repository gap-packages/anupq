#############################################################################
##
#W    init.g               share package 'anupq'
##
##    @(#)$Id$
##

##    Compatibility with GAP 4.2
if not IsBound( PolycyclicFactorGroupNC ) then
    PolycyclicFactorGroupNC := PolycyclicFactorGroup;
fi;

if not IsBound( PcGroupFpGroupNC ) then
    PcGroupFpGroupNC := PcGroupFpGroup;
fi;

# install the documentation
DeclarePackageAutoDocumentation( "anupq", "gap/doc" );

##
##    Announce the package version and test for the existence of the binary.
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

