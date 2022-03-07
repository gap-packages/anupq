#############################################################################
##
#W  PackageInfo.g             ANUPQ Package                       Greg Gamble
#W                                                              Werner Nickel
#W                                                             Eamonn O'Brien
#W                                                                   Max Horn

SetPackageInfo( rec(

PackageName := "ANUPQ",
Subtitle    := "ANU p-Quotient",
Version     := "3.2.6",
Date        := "07/03/2022", # dd/mm/yyyy format
License     := "Artistic-2.0",

Persons := [ 
  rec( 
    LastName      := "Gamble",
    FirstNames    := "Greg",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "Greg.Gamble@uwa.edu.au",
    WWWHome       := "http://school.maths.uwa.edu.au/~gregg",
    PostalAddress := Concatenation(
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
     WWWHome       := "https://www2.mathematik.tu-darmstadt.de/~nickel/",
  ),
  rec( 
    LastName      := "O'Brien",
    FirstNames    := "Eamonn",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "obrien@math.auckland.ac.nz",
    WWWHome       := "https://www.math.auckland.ac.nz/~obrien",
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
   Email         := "horn@mathematik.uni-kl.de",
   WWWHome       := "https://www.quendi.de/math",
   PostalAddress := Concatenation(
                      "Fachbereich Mathematik\n",
                      "TU Kaiserslautern\n",
                      "Gottlieb-Daimler-Straße 48\n",
                      "67663 Kaiserslautern\n",
                      "Germany" ),
   Place         := "Kaiserslautern, Germany",
   Institution   := "TU Kaiserslautern"
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
README_URL     := Concatenation(~.PackageWWWHome, "README.md"),
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
),

Dependencies := rec(
  GAP := ">= 4.9",
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

# Show some extra info in the Banner
BannerFunction := function( info )
  local str, version;

  str := DefaultPackageBannerString( info );
  str := ReplacedString( str, "by Greg Gamble (", "by Greg Gamble (GAP code, " );
  str := ReplacedString( str, "Nickel (", "Nickel (GAP code, " );
  str := ReplacedString( str, "O'Brien (", "O'Brien (C code, " );
  str := ReplacedString( str, "\nHomepage", "\nuses ANU pq binary (C code program) version: 1.9\nHomepage" );
  return str;
end,

TestFile := "tst/testinstall.g",

Keywords := [
  "p-quotient",
  "p-group generation",
  "descendant",
  "standard presentation",
  ],


AutoDoc := rec(
    TitlePage := rec(
    Copyright := """
      &copyright; 2001-2016 by Greg Gamble<P/>
      &copyright; 2001-2005 by Werner Nickel<P/>
      &copyright; 1995-2001 by Eamon O'Brien<P/>

      The &GAP; package &ANUPQ; is licensed under the <URL Text="Artistic License 2.0">https://opensource.org/licenses/artistic-license-2.0</URL>.
      """,
    ),
),
));
