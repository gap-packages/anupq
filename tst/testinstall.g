LoadPackage( "anupq" );
dirs := DirectoriesPackageLibrary( "anupq", "tst" );
tests := [
    "anupga.tst",
    "anupq1eg.tst",
    "anupqsmgp.tst",
    "anusp.tst",
    "bugfix.tst",
    #"anupqeg.tst", # VERY slow
];
tests := List(tests, f -> Filename(dirs,f));

TestDirectory(tests, rec(exitGAP := true));
