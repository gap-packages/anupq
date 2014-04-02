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

SRC_DIR=$PWD
DEST_DIR=$PWD/..
#DEST_DIR=/tmp
WEB_DIR=$SRC_DIR/$PKG.gh-pages

# Clean any remains of previous export attempts
rm -rf $DEST_DIR/$FULLPKG*

echo "Exporting repository content for ref '$REF'"
if [ -d .git ] ; then
    git archive --prefix=$FULLPKG/ $REF | tar xf - -C $DEST_DIR/
elif [ -d .hg ] ; then
    hg archive  -r $REF $DEST_DIR/$FULLPKG
else
    echo "Error, only git and mercurial repositories are currently supported"
    exit 1
fi

echo "Creating tarball $FULLPKG.tar"
cd $DEST_DIR/$FULLPKG
rm -f .git* .hg* .cvs*

# Build documentation and later remove aux files created by this.
echo "Building GAP package documentation"
cd $DEST_DIR/$FULLPKG/doc
./make_doc #> /dev/null 2> /dev/null
rm -f \
    manual.example*.tst \
    manual.aux \
    manual.bbl \
    manual.blg \
    manual.idx \
    manual.ilg \
    manual.ind \
    manual.log \
    manual.mst \
    manual.toc

echo "Building documentation for standalone binary"
cd $DEST_DIR/$FULLPKG/standalone-doc
for i in 1 2 3 ; do
    latex guide.tex > /dev/null 2> /dev/null
done
for i in 1 2 3 ; do
    pdflatex guide.tex > /dev/null 2> /dev/null
done
rm -f guide.aux guide.log guide.toc

cd $DEST_DIR
tar cf $FULLPKG.tar $FULLPKG

echo "Compressing (using gzip) tarball $FULLPKG.tar.gz"
gzip -9c $FULLPKG.tar > $FULLPKG.tar.gz

echo "Compressing (using bzip2) tarball $FULLPKG.tar.gz"
bzip2 -9c $FULLPKG.tar > $FULLPKG.tar.bz2

# TODO: The name "-win.zip" may carries additional meaning, such as text
# files converted to windows line endings; or it might be expected to
# contained pre-compiled binaries.
# However, GAP insists on the suffix "-win.zip", so we keep using that for now
# (instead of plain .zip).
echo "Zipping $FULLPKG-win.zip..."
zip -r9 --quiet $FULLPKG-win.zip $FULLPKG


# Update website repository if available
if  [ -d $WEB_DIR ] ; then
    echo "Updating website"
    cd $WEB_DIR
    cp $DEST_DIR/$FULLPKG/README .
    cp $DEST_DIR/$FULLPKG/PackageInfo.g .
    rm -rf doc/
    mkdir -p doc/
    cp $DEST_DIR/$FULLPKG/htm/*.htm doc/
    cp $DEST_DIR/$FULLPKG/doc/manual.pdf doc/
    cp $DEST_DIR/$FULLPKG/doc/manual.dvi doc/
    cp $DEST_DIR/$FULLPKG/standalone-doc/guide.pdf doc/
    cp $DEST_DIR/$FULLPKG/standalone-doc/guide.dvi doc/
fi

echo "Done:"
cd $DEST_DIR
ls -l $FULLPKG.tar.gz $FULLPKG.tar.bz2 $FULLPKG-win.zip

exit 0
