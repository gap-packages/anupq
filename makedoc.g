if fail = LoadPackage("AutoDoc", ">= 2022.07.10") then
    Error("AutoDoc 2022.07.10 or newer is required");
fi;

# Use AutoDoc to regenerate the manual title page with data from
# PackageInfo.g (i.e. make sure the author and version information is
# up-to-date).
AutoDoc(rec(
    scaffold := rec(
        TitlePage := false,
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
    )
));

QUIT;
