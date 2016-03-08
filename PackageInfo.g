#############################################################################
##
#W  PackageInfo.g             ANUPQ Package                       Greg Gamble
#W                                                              Werner Nickel
#W                                                             Eamonn O'Brien
#W                                                                   Max Horn

SetPackageInfo( rec(

PackageName := "ANUPQ",
Subtitle    := "ANU p-Quotient",
Version     := "3.1.4",
Date        := "08/03/2016",

Persons := [ 
  rec( 
    LastName      := "Gamble",
    FirstNames    := "Greg",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "Greg.Gamble@uwa.edu.au",
    WWWHome       := "http://school.maths.uwa.edu.au/~gregg",
    PostalAddress := Concatenation(
                       "Greg Gamble\n",
                       "Department of Mathematics and Statistics\n",
                       "Curtin University\n",
                       "GPO Box U 1987\n",
                       "Perth WA 6845\n",
                       "Australia" ),
    Place         := "Perth",
    Institution   := "Curtin University"
  ),
  rec( 
    LastName      := "Nickel",
    FirstNames    := "Werner",
    IsAuthor      := true,
    IsMaintainer  := false,
     # MH: Werner rarely (if at all) replies to emails sent to this
     # old email address. To discourage users from sending bug reports
     # there, I have disabled it here.
     #Email         := "nickel@mathematik.tu-darmstadt.de",
     WWWHome       := "http://www.mathematik.tu-darmstadt.de/~nickel/",
  ),
  rec( 
    LastName      := "O'Brien",
    FirstNames    := "Eamonn",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "obrien@math.auckland.ac.nz",
    WWWHome       := "http://www.math.auckland.ac.nz/~obrien",
    PostalAddress := Concatenation(
                       "Department of Mathematics\n",
                       "University of Auckland\n",
                       "Private Bag 92019\n",
                       "Auckland\n",
                       "New Zealand\n" ),
    Place         := "Auckland",
    Institution   := "University of Auckland"
  ),
  rec(
   LastName      := "Horn",
   FirstNames    := "Max",
   IsAuthor      := false,
   IsMaintainer  := true,
   Email         := "max.horn@math.uni-giessen.de",
   WWWHome       := "http://www.quendi.de/math",
   PostalAddress := Concatenation(
                      "AG Algebra\n",
                      "Mathematisches Institut\n",
                      "Justus-Liebig-Universität Gießen\n",
                      "Arndtstraße 2\n",
                      "35392 Gießen\n",
                      "Germany" ),
   Place         := "Gießen, Germany",
   Institution   := "Justus-Liebig-Universität Gießen"
 ),
],  

Status         := "accepted",
CommunicatedBy := "Charles Wright (Eugene)",
AcceptDate     := "04/2002",

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/anupq",
),
IssueTrackerURL:= Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome := "https://gap-packages.github.io/anupq/",
README_URL     := Concatenation(~.PackageWWWHome, "README"),
PackageInfoURL := Concatenation(~.PackageWWWHome, "PackageInfo.g"),
ArchiveURL     := Concatenation(~.SourceRepository.URL,
                                "/releases/download/v", ~.Version,
                                "/anupq-", ~.Version),
ArchiveFormats := ".tar.gz .tar.bz2",

AbstractHTML := 
  "The <span class=\"pkgname\">ANUPQ</span> package provides an interactive \
   interface to the p-quotient, p-group generation and standard presentation \
   algorithms of the ANU pq C program.",

PackageDoc := rec(
  BookName  := "ANUPQ",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "ANU p-Quotient",
  Autoload := false
),

Dependencies := rec(
  GAP := ">= 4.5",
  NeededOtherPackages := [ [ "autpgrp", ">=1.5" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := []
),

AvailabilityTest := 
  function()
    # test for existence of the compiled binary
    if Filename( DirectoriesPackagePrograms( "anupq" ), "pq" ) = fail then
        return fail;
    fi;
    return true;
  end,

BannerString := Concatenation( 
  "---------------------------------------------------------------------------",
  "\n",
  "Loading    ", ~.PackageName, " (", ~.Subtitle, ") ", ~.Version, "\n",
  "GAP code by  ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,
        " <", ~.Persons[1].Email, "> (address for correspondence)\n",
  "           ", ~.Persons[2].FirstNames, " ", ~.Persons[2].LastName,
        " (", ~.Persons[2].WWWHome, ")\n",
  "           [uses ANU pq binary (C code program) version: 1.9]\n",
  "C code by  ", ~.Persons[3].FirstNames, " ", ~.Persons[3].LastName,
        " (", ~.Persons[3].WWWHome, ")\n",
  "Co-maintained by ", ~.Persons[4].FirstNames, " ", ~.Persons[4].LastName,
                " <", ~.Persons[4].Email, ">\n\n",
  "            For help, type: ?", ~.PackageDoc.BookName, "\n",
  "---------------------------------------------------------------------------",
  "\n" ),

Autoload := false,

TestFile := "tst/anupqeg.tst",

Keywords := [
  "p-quotient",
  "p-group generation",
  "descendant",
  "standard presentation",
  ]
));
