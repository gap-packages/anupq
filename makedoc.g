PKG := "anupq";

# Make sure we look at the right version of our package
SetPackagePath(PKG, ".");

# Update the VERSION file with the current version (it is used by
# configure.ac).
PrintTo("VERSION", PackageInfo(PKG)[1].Version);

if fail = LoadPackage("AutoDoc", "2014.03.27") then
    Error("AutoDoc version 2014.03.27 or newer is required.");
fi;

# Use AutoDoc to regenerate the manual title page with data from
# PackageInfo.g (i.e. make sure the author and version information is
# up-to-date).
AutoDoc(PKG :
    scaffold := rec(
        includes := [
            "intro.xml",
            "basics.xml",
            "infra.xml",
            "non-interact.xml",
            "interact.xml",
            "options.xml",
            "install.xml",
            ],
        appendix := [ "examples.xml" ],
        entities := [
            "ANUPQ",
            "AutPGrp",
        ],
    )
);

QUIT;
