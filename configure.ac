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
GAP="${GAP:-${GAPROOT}/bin/gap.sh}"
AC_SUBST(GAP)

# newer GAP versions may set GMP_PREFIX in sysinfo.gap, try to use that
GMP_PREFIX=${GMP_PREFIX:-yes}

dnl ##
dnl ## Check for GMP
dnl ##

AC_ARG_WITH([gmp],
  [AS_HELP_STRING([--with-gmp@<:@=PREFIX@:>@],
    [prefix of GMP installation. e.g. /usr/local])],
    [],[with_gmp=${GMP_PREFIX}])

GMP_CPPFLAGS=""
GMP_LDFLAGS=""
GMP_LIBS="-lgmp"

if test "x$with_gmp" = "xno" ; then
	AC_MSG_ERROR([GMP is required and cannot be disabled])
elif test "x$with_gmp" = "xyes" ; then
    # If a gaproot was specified, try to find GMP in there; otherwise, fall
    # back to whatever GMP may be found via user specified C/CPP/LDFLAGS
    if test "${with_gaproot+set}" = set; then
        echo "with_gaproot = $with_gaproot"
        if test -f ${with_gaproot}/extern/install/gmp/include/gmp.h && test -d ${with_gaproot}/extern/install/gmp/lib ; then
            echo "adjusting stuff based on gaproot"
            GMP_CPPFLAGS="-I${with_gaproot}/extern/install/gmp/include"
            GMP_LDFLAGS="-L${with_gaproot}/extern/install/gmp/lib"
        fi
    fi
else
	if test -d ${with_gmp}/include && test -d ${with_gmp}/lib ; then
		GMP_CPPFLAGS="-I${with_gmp}/include"
        GMP_LDFLAGS="-L${with_gmp}/lib"
	else
		AC_MSG_ERROR([Could not locate libgmp in the specified location])
	fi
fi;

save_CPPFLAGS="$CPPFLAGS"
save_LDFLAGS="$LDFLAGS"
save_LIBS="$LIBS"

CPPFLAGS="$CPPFLAGS $GMP_CPPFLAGS"
LDFLAGS="$LDFLAGS $GMP_LDFLAGS"
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
CPPFLAGS="$save_CPPFLAGS"
LDFLAGS="$save_LDFLAGS"
LIBS="$save_LIBS"

if test "x$have_gmp" != xyes; then
    AC_MSG_ERROR([Could not locate GMP, the GNU multiprecision library])
fi

AC_SUBST(GMP_CPPFLAGS)
AC_SUBST(GMP_LDFLAGS)
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
