dnl ##
dnl ## Process this file with autoconf to produce a configure script.
dnl ## 
AC_PREREQ([2.68])
AC_INIT([ANU p-Quotient Program], [3.1.1], [support@gap-system.org], [anupq])
AC_CONFIG_AUX_DIR(cnf)
AC_CONFIG_SRCDIR([src/pquotient.c])
AC_CONFIG_HEADER(include/config.h:include/config.hin)

dnl ##
dnl ## determine the system name
dnl ##
AC_CANONICAL_HOST

dnl ##
dnl ## C is the language 
dnl ##
AC_LANG([C])

dnl ##
dnl ## Checks for programs.
dnl ##
AC_PROG_AWK
AC_PROG_CC
AC_PROG_MAKE_SET

dnl ##
dnl ## Checks for system header files.
dnl ##
AC_CHECK_HEADERS([stdlib.h string.h sys/time.h])


dnl ##
dnl ## Check which GAP configuration to use
dnl ##
AC_ARG_VAR(CONFIGNAME, [Set this to the CONFIGNAME of the GAP compilation
    against which you want to compile this package.])

AC_MSG_CHECKING([GAP config name])
if test "x$CONFIGNAME" = "x"; then
    SYSINFO="sysinfo.gap"
    AC_MSG_RESULT([none])
else
    SYSINFO="sysinfo.gap-$CONFIGNAME"
    AC_MSG_RESULT([$CONFIGNAME])
fi


dnl ##
dnl ## Locate the GAP root dir
dnl ##
dnl ## If no directory is specified, then this defaults to ../..
AC_ARG_WITH([gaproot],
	[AS_HELP_STRING([--with-gaproot=PATH],
		[directory where GAP is installed @<:@default=../..@:>@])],
	[GAP_ROOT="$with_gaproot" ; GAP_ROOT_real="$with_gaproot"; GAP_ROOT_display="$with_gaproot"],
	[GAP_ROOT='${top_srcdir}/../..' ; GAP_ROOT_real="${srcdir}/../.."; GAP_ROOT_display=../..])
AC_MSG_CHECKING([for GAP root directory])

if test ! -d $GAP_ROOT_real ; then
	AC_MSG_ERROR(["$GAP_ROOT_display" is not a directory])
fi

# Try and turn GAP_ROOT_real into an absolute path 
GAP_ROOT_real=`cd $GAP_ROOT_real > /dev/null 2>&1 && pwd`

SYSINFO_GAP="$GAP_ROOT_real/$SYSINFO"
if test -f $SYSINFO_GAP ; then
	AC_MSG_RESULT([$GAP_ROOT_display])
	#AC_SUBST(CONFIGNAME)
else
    AC_MSG_RESULT([Not found])
    
    echo ""
    echo "********************************************************************"
    echo "  ERROR"
    echo ""
    echo "  Cannot find your GAP installation. Please specify the location of"
    echo "  GAP's root directory using --with-gaproot=<path>"
    echo ""
    echo "  The GAP root directory (as far as this package is concerned) is"
    echo "  the one containing the file sysinfo.gap and the subdirectories "
    echo "  src/ and bin/."
    echo "********************************************************************"
    echo ""
    
    AC_MSG_ERROR([Unable to find GAP root directory])
fi
AC_SUBST(GAP_ROOT)


dnl ##
dnl ## Parse the GAParch from sysinfo.gap
dnl ##

AC_MSG_CHECKING([for GAP architecture])
GAPARCH=`fgrep "GAParch=" $SYSINFO_GAP | sed -e 's/^GAParch=\(.*\)$/\1/'`
if test "x$GAPARCH" = "x" ; then
	AC_MSG_ERROR([GAParch not found in $GAP_ROOT_display/sysinfo.gap])
else
	AC_MSG_RESULT([$GAPARCH])
fi
AC_SUBST(GAPARCH)

dnl ##
dnl ## Check for GMP
dnl ## If the user specified a specific GMP, try to use that.
dnl ## Otherwise, first try to use the GMP provided by GAP, or
dnl ## any GMP version installed globally by the user.
dnl ##

GMP_CPPFLAGS=
GMP_LIBS=

AC_ARG_WITH([gmp], 
	[AS_HELP_STRING([--with-gmp=PATH],
	  [ Use GMP library.
        If the argument you supply is "yes" or <empty>, then the version of GMP bundled with GAP will be used (default).
        If the argument is "system" that means the library is reachable with the standard
        search path "/usr" or "/usr/local".
        Otherwise you give the <path> to the directory which contains the library. 
        [[default=yes]]
    ])],
  [], [ with_gmp=yes ]
)

if test "x$with_gmp" = "xno" ; then
	AC_MSG_NOTICE([Building without GMP support])
elif test "x$with_gmp" = "xsystem" ; then
	# Try using system GMP
	GMP_CPPFLAGS=""
	GMP_LIBS="-lgmp"
else
	# Try using static linked GMP in the specified location
	if test "x$with_gmp" = "xyes" ; then
		# Try to use GAP's GMP, if available
		GMP_HOME="$GAP_ROOT_real/bin/$GAPARCH/extern/gmp"
	else
		GMP_HOME="$with_gmp"
	fi;
	if test -d ${GMP_HOME}/include && test -f ${GMP_HOME}/lib/libgmp.a ; then
		GMP_CPPFLAGS="-I${GMP_HOME}/include"
		GMP_LIBS="${GMP_HOME}/lib/libgmp.a"
	elif test "x$with_gmp" = "xyes" ; then
		# fallback to trying system wide GMP
		GMP_CPPFLAGS=""
		GMP_LIBS="-lgmp"
	else
		AC_MSG_ERROR([Could not locate libgmp.a in the specified location])
	fi
fi;

have_gmp=no
if test "x$with_gmp" != xno; then
	pq_save_CPPFLAGS="$CPPFLAGS"
	CPPFLAGS="$CPPFLAGS $GMP_CPPFLAGS"
	pq_save_LIBS="$LIBS"
	LIBS="$LIBS $GMP_LIBS"

	AC_CHECK_HEADER( [gmp.h],
		[
		# TODO: Disable linker check for now: It causes problems on Linux, because
		# libgmp.a is in the linker command line before the test C file. On the long
		# run, this should be re-enabled, though perhaps in a different form.
		AC_MSG_CHECKING([whether linking against GMP works])
		AC_TRY_LINK(
			[#include <gmp.h>],
			[__gmpz_init(0);], 
			[have_gmp=yes],
			[]
			)
		AC_MSG_RESULT([$have_gmp])
		],
		[]
		)

	# restore FLAGS
	CPPFLAGS="$pq_save_CPPFLAGS"
	LIBS="$pq_save_LIBS"

fi;

if test "x$have_gmp" = xyes; then
	AC_DEFINE(HAVE_GMP, 1, [Define if GMP is installed and usable])

	AC_SUBST(GMP_CPPFLAGS)
	AC_SUBST(GMP_LIBS)
fi

dnl ##
dnl ## Checks for library functions.
dnl ##
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_FUNC_FORK
AC_HEADER_SYS_WAIT
AC_CHECK_FUNCS([gethostname waitpid wait4 tmpnam tempnam strftime])

dnl ##
dnl ## Finally, generate the Makefiles and output everything
dnl ##
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
