LoadPackage( "anupq" );
dirs := DirectoriesPackageLibrary( "anupq", "tst" );
TestDirectory(dirs, rec(exitGAP := true));
