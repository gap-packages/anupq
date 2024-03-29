dnl ##
dnl ## Process this file with autoconf to produce a configure script.
dnl ##
AC_PREREQ([2.68])
AC_INIT([ANU p-Quotient Program],
        [package],
        [https://github.com/gap-packages/anupq/issues],
        [anupq],
        [https://gap-packages.github.io/anupq/])
AC_CONFIG_SRCDIR([src/pquotient.c])
AC_CONFIG_HEADERS(include/config.h:include/config.hin)
AC_CONFIG_AUX_DIR(cnf)
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([1.11 -Wall foreign subdir-objects no-dist])
AM_SILENT_RULES([yes])

dnl For developer builds, maintainer mode is enabled by default. But for
dnl releases, the `.release` script changes this to "disabled by default".
dnl This avoids troubles during packaging, in particular when the GAP team
dnl repackages the source archive. Users can re-enable it by passing
dnl `--enable-maintainer-mode` to configure.
AM_MAINTAINER_MODE([enable])

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
AC_PROG_MKDIR_P
AC_PROG_SED

dnl ##
dnl ## Locate the GAP root dir
dnl ##
FIND_GAP

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
        GMP_HOME="$GAPROOT/extern/install/gmp"
	else
		GMP_HOME="$with_gmp"
	fi;
	if test -d ${GMP_HOME}/include && test -d ${GMP_HOME}/lib ; then
		GMP_CPPFLAGS="-I${GMP_HOME}/include"
		# gross hack follows
		if test -r "${GMP_HOME}/lib/libgmp.a" ; then
			GMP_LIBS="${GMP_HOME}/lib/libgmp.a"
		elif test -r "${GMP_HOME}/lib/libgmp.dylib" ; then
			GMP_LIBS="${GMP_HOME}/lib/libgmp.dylib"
		elif test -r "${GMP_HOME}/lib/libgmp.so" ; then
			GMP_LIBS="${GMP_HOME}/lib/libgmp.so"
		else
			# generic fallback -- unfortunately, this does not ensure that we
			# link against exactly that version of libgmp
			GMP_LIBS="-L${GMP_HOME}/lib -lgmp"
		fi
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
		AC_LINK_IFELSE(
			[AC_LANG_PROGRAM([[#include <gmp.h>]], [[__gmpz_init(0);]])],
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
else
GMP_CPPFLAGS=""
GMP_LIBS=""
fi

AC_SUBST(GMP_CPPFLAGS)
AC_SUBST(GMP_LIBS)

dnl ##
dnl ## Checks for library functions.
dnl ##
AC_HEADER_SYS_WAIT
AC_CHECK_FUNCS([gethostname strftime])

AC_SEARCH_LIBS([log10], [m], [], [
  AC_MSG_ERROR([unable to find the log10() function])
])


# hack for testPq:
GAP_EXEC="${GAP:-${GAPROOT}/bin/gap.sh}"
AC_SUBST(GAP_EXEC)


dnl ##
dnl ## Finally, generate the Makefiles and output everything
dnl ##
AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([testPq], [chmod +x testPq])
AC_OUTPUT
