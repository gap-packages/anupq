LoadPackage( "anupq" );
dirs := DirectoriesPackageLibrary( "anupq", "tst" );
tests := [
    "anupga.tst",
    "anupqsmgp.tst",
    "anusp.tst",
    "bugfix.tst",
];
tests := List(tests, f -> Filename(dirs,f));

TestDirectory(tests, rec(exitGAP := true));
