[![Build Status](https://github.com/gap-packages/anupq/workflows/CI/badge.svg?branch=master)](https://github.com/gap-packages/anupq/actions?query=workflow%3ACI+branch%3Amaster)
[![Code Coverage](https://codecov.io/github/gap-packages/anupq/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/anupq)

# The ANUPQ package

The ANUPQ package is a GAP4 interface with the ANU pq C  program  written
by  Eamonn  O'Brien.  The  ANU  pq   C   program   provides   access   to
implementations of the following algorithms:

1. A p-quotient algorithm to compute a power-commutator presentation  for
a group of prime power order. The algorithm implemented here is based  on
that described in Newman and O'Brien (1996), Havas and Newman (1980), and
papers referred to there. Another description of the algorithm appears in
Vaughan-Lee (1990).  A  FORTRAN  implementation  of  this  algorithm  was
programmed by Alford  and  Havas.  The  basic  data  structures  of  that
implementation are retained.

2. A p-group generation algorithm to generate descriptions of  groups  of
prime power order.  The  algorithm  implemented  here  is  based  on  the
algorithms described in Newman  (1977)  and  O'Brien  (1990).  A  FORTRAN
implementation of this algorithm was  earlier  developed  by  Newman  and
O'Brien.

3. A  standard  presentation  algorithm  used  to  compute  a   canonical
power-commutator presentation of a  p-group.  The  algorithm  implemented
here is described in O'Brien (1994).

4. An algorithm which can be used to compute the automorphism group of  a
p-group. The algorithm implemented here is described in O'Brien (1994).

The following section describes the installation of the ANUPQ package.  A
description of the functions available in the ANUPQ package is  given  in
the  package  manual  in  the  doc  directory.  For  details  about   the
implementation and the standalone version see the README and guide.dvi in
the standalone-doc directory.


## Obtaining the ANUPQ package

Note  that, owing  to its  C  code component,  the ANUPQ  package can  be
installed  under UNIX or  in environments  similar to  UNIX. In particular
it is known to work on Linux and Mac OS X, and also on Windows equipped
with cygwin.

You can download `anupq-XXX.tar.gz` (where `XXX` is the  package  version
number) from the home page for the ANUPQ package

  <https://gap-packages.github.io/anupq/>

or via the GAP web site

  <https://www.gap-system.org/Packages/anupq.html>


## Installing the ANUPQ package

To install the ANUPQ package, move the file `anupq-<XXX>.tar.gz` into the
`pkg` directory in which you plan to install ANUPQ. Usually, this will be
the directory `pkg` in the hierarchy of your version of GAP 4.  (However,
it is also possible to keep an additional `pkg` directory in your private
directories, see section "ref:Installing  GAP  Packages"  of  the  GAP  4
reference manual for details on how to do this.)

ANUPQ package requires at least GAP 4.9 and AutPGrp 1.5, although we
recommend using the most recent versions of each. ANUPQ optionally
supports using GMP for large integer support.

Unpack the archive `anupq-<XXX>.tar.gz` in the `pkg` directory.

Change directory to the newly created `anupq` directory. Now you need to
call `configure`. If you installed ANUPQ into the main `pkg` directory,
simply do this:

    ./configure

If you installed ANUPQ in another directory than the usual `pkg`
subdirectory, do

    ./configure --with-gaproot=path

where `path` is a path to the GAP home directory. See

    ./configure --help

for further options.

Afterwards, you can simply call

    make

to compile the binary and to install it in the appropriate place.

The path of GAP (see *Note* below) used by the  `pq`  binary  (the  value
`GAP` is set to in the `make` command) may be over-ridden by setting  the
environment variable `ANUPQ_GAP_EXEC`. These values are only of  interest
when the `pq` program is run  as  a  standalone;  however,  the  `testPq`
script assumes you have set one of these correctly (see Section  "Testing
your ANUPQ installation"). When the `pq`  program  is  started  from  GAP
communication occurs via an iostream, so that the `pq`  binary  does  not
actually need to know a valid path for GAP is this case.

*Note.* By "path of GAP" we mean the path of the command used to invoke
GAP (which should be a script, e.g. the `gap.sh` script generated in  the
`bin` directory for the version of GAP when GAP was compiled). The  usual
strategy is to copy the `gap.sh` script  to  a  standard  location,  e.g.
`/usr/local/bin/gap`. It is a mistake to copy the  GAP  executable  `gap`
(in a directory  with  name  of  form  `bin/<compile-platform>`)  to  the
standard location, since direct invocation of the executable  results  in
GAP starting without being able to find its own library (a fatal error).


## The ANUPQ package documentation

The ANUPQ package documentation source files, now XML  (for GAPDoc),  are
found in the `doc` directory. There you should also find `manual.pdf`,  a
PDF version of the manual,  and  various  HTML files constituting the HTML
version of the manual (actually there are two HTML versions of the manual,
the  one with `_mj` files have MathJax  enabled).  The  initial  page  for
the HTML version of the manual is `chap0.html`  (or  `chap0_mj.html`  with
MathJax enabled), but you can toggle between the versions,  once you  have
opened either, with your favourite browser.


## Testing the ANUPQ package installation

Now it is time to test the  installation.  After  doing  `configure`  and
`make` you will have a `testPq` script. The script assumes that,  if  the
environment variable `ANUPQ_GAP_EXEC` is set, it is a  correct  path  for
GAP, or otherwise that the `make` call that compiled the `pq` program set
`GAP` to a correct path for GAP (see Section "Running the pq program as a
standalone" in the ANUPQ package manual for more  details).  To  run  the
tests, just type:

  ./testPq

Some of the tests the script runs take a while. Please be  patient.
The output you see should be something like the following:

    Made dir: /tmp/testPq
    Testing installation of ANUPQ Package (version 3.3.1)
  
    The first two tests check that the pq C program compiled ok.
    Testing the pq binary ... OK.
    Testing the pq binary's stack size ... OK.
    The pq C program compiled ok! We test it's the right one below.

    The next tests check that you have the right version of GAP
    for version 3.1 of the ANUPQ package and that GAP is finding
    the right versions of the ANUPQ and AutPGrp packages.
  
    Checking GAP ...
     pq binary made with GAP set to: /usr/local/bin/gap
     Starting GAP to determine version and package availability ...
      GAP version (4.13.1) ... OK.
      GAP found ANUPQ package (version 3.3.1) ... good.
      GAP found pq binary (version 1.9) ... good.
      GAP found AutPGrp package (version 1.11) ... good.
     GAP is OK.

    Checking the link between the pq binary and GAP ... OK.
    Testing the standard presentation part of the pq binary ... OK.
    Doing p-group generation (final GAP/ANUPQ) test ... OK.
    Tests complete.
    Removed dir: /tmp/testPq
    Enjoy using your functional ANUPQ package!


## Bug reports

For bug reports, feature requests and suggestions, please refer to

   <https://github.com/gap-packages/anupq/issues>

When sending a bug report, remember we will need to be able to  reproduce
the problem; so please include:

 * The version of GAP you are using; either look at  the  header  when
   you start up GAP, or at the gap> prompt type: GAPInfo.Version;
 * The operating system you are using e.g. Linux, Mac OS X, Windows,
   FreeBSD, Solaris...
 * The compiler you used to compile `pq` and  the  options  you  used.
   Type: gcc -v or: cc -version, and  look  in  Makefile  for  the
   value of CC to find out.
 * A script, either in GAP or standalone `pq`, that  demonstrates  the
   bug, along with a description of why it's a  bug  (e.g.  by  adding
   comments  to  the  script  -  recall,  comments,  both  in  GAP  or
   standalone `pq`, begin with a #).


## License

The ANUPQ package is licensed under the Artistic License 2.0.
For the exact terms of this license, please refer to the `LICENSE`
file provided to you as part of the ANUPQ package, or refer to
<https://opensource.org/licenses/artistic-license-2.0>.
