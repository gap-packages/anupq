PKG := "anupq";

# Make sure we look at the right version of our package
SetPackagePath(PKG, ".");

# Update the VERSION file with the current version (it is used by
# configure.ac).
PrintTo("VERSION", PackageInfo(PKG)[1].Version);

LoadPackage("GAPDoc");

if false and LoadPackage("AutoDoc", "2014.03.04") then
    # If available, use AutoDoc to regenerate the manual title page with data
    # from PackageInfo.g (i.e. make sure the author and version information is
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

else
    # No AutoDoc -> call GAPDoc directly
    package_info := PackageInfo(PKG)[1];
    if not IsBound(BOOKNAME) then
        if IsBound(package_info.PackageDoc[1].BookName) then
            BOOKNAME := package_info.PackageDoc[1].BookName;
        else
            BOOKNAME := PKG;
        fi;
    fi;
    MakeGAPDocDoc("doc", PKG, [], BOOKNAME);
    CopyHTMLStyleFiles("doc");
    GAPDocManualLab(PKG);

fi;

QUIT;
