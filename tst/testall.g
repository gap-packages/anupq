LoadPackage( "anupq" );
dirs := DirectoriesPackageLibrary( "anupq", "tst" );
exclude := [
    "anupq1eg.tst", # output contains timings so not good for automated testing
];
TestDirectory(dirs, rec(exitGAP := true, exclude := exclude));
