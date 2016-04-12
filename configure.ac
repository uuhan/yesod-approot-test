#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([FULL-PACKAGE-NAME], [VERSION], [BUG-REPORT-ADDRESS])
AC_CONFIG_SRCDIR([src/Main.hs])
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_MACRO_DIR([m4])

PWD=$(pwd)

AC_CHECK_PROG(NGINX, nginx, yes)
if test x"$NGINX" != x"yes"; then
    AC_MSG_ERROR([This test suite need nginx, please install it])
fi

AC_SUBST(PWD)

AC_CONFIG_FILES([approot.buildinfo
                 nginx.conf])
AC_OUTPUT
