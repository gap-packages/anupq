#!/bin/sh -e
#
# This script generates a .tar.gz, .tar.bz2 and -win.zip for ANUPQ.
# This requires that a tag has been set of the form "v3.1". You then
# may invoke this script like this:
#    ./make_dist.sh 3.1
# and the rest happens automatically.
# If a checkout of the website repository is present, this script
# also copies relevant files (PackageInfo.g, documentation) there.
#
# TODO: Right now this only works in a git clone of the repository;
#   make it possible to also use this in a Mercurial clone, by
#   using "hg export" instead of "git archive"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <version> [<tag-or-date>]"
  exit 1
fi

PKG="anupq"
VER=$1
if [ $# -lt 2 ]; then
    REF=v$VER  # a 'tag' by default, but allow overriding it
else
    REF=$2
fi

FULLPKG="$PKG-$VER"

# Clean any remains of previous export attempts
rm -rf ../$FULLPKG*

echo "Exporting repository content for ref '$REF'"
if [ -d .git ] ; then
    git archive --prefix=$FULLPKG/ $REF | tar xf - -C .. 
elif [ -d .hg ] ; then
    hg archive  -r $REF ../$FULLPKG
else
    echo "Error, only git and mercurial repositories are currently supported"
    exit 1
fi

echo "Creating tarball $FULLPKG.tar"
cd ../$FULLPKG
rm -f .git* .hg* .cvs*

# Build documentation and later remove aux files created by this.
echo "Building GAP package documentation"
cd doc
./make_doc > /dev/null 2> /dev/null
rm -f \
    manual.example*.tst \
    manual.aux \
    manual.bbl \
    manual.blg \
    manual.idx \
    manual.ilg \
    manual.ind \
    manual.lab \
    manual.log \
    manual.mst \
    manual.toc
cd ..

echo "Building documentation for standalone binary"
cd standalone-doc
for i in 1 2 3 ; do
    latex guide.tex > /dev/null 2> /dev/null
done
for i in 1 2 3 ; do
    pdflatex guide.tex > /dev/null 2> /dev/null
done
rm -f guide.aux guide.log guide.toc

cd ../..

tar cf $FULLPKG.tar $FULLPKG

echo "Compressing (using gzip) tarball $FULLPKG.tar.gz"
gzip -9c $FULLPKG.tar > $FULLPKG.tar.gz

echo "Compressing (using bzip2) tarball $FULLPKG.tar.gz"
bzip2 -9c $FULLPKG.tar > $FULLPKG.tar.bz2

echo "Zipping $FULLPKG-win.zip..."
zip -r9 --quiet $FULLPKG-win.zip $FULLPKG


# Update website repository if available
if  [ -d $PKG.gh-pages ] ; then
    echo "Updating website"
    cd $PKG.gh-pages
    cp ../$FULLPKG/README .
    cp ../$FULLPKG/PackageInfo.g .
    rm -rf doc/
    mkdir -p doc/
    cp ../$FULLPKG/htm/*.htm doc/
    cp ../$FULLPKG/doc/manual.pdf doc/
    cp ../$FULLPKG/doc/manual.dvi doc/
    cp ../$FULLPKG/standalone-doc/guide.pdf doc/
    cp ../$FULLPKG/standalone-doc/guide.dvi doc/
    cd ..
fi

echo "Done:"
ls -l $FULLPKG.tar.gz $FULLPKG.tar.bz2 $FULLPKG-win.zip

exit 0
