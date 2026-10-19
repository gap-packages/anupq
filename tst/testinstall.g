LoadPackage( "anupq" );
dirs := DirectoriesPackageLibrary( "anupq", "tst" );
tests := [
    "anupga.tst",
    "anupqsmgp.tst",
    "anusp.tst",
];
tests := List(tests, f -> Filename(dirs,f));
Append(tests, DirectoriesPackageLibrary( "anupq", "tst/bugfix" ));

TestDirectory(tests, rec(exitGAP := true));
