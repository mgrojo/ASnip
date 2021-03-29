#! /bin/sh

# A simple interactive guide to configuring ASnip's Makefile(s) for
# use with GNAT.

unalias -a

prompt() {
    msg="$*"

    if [ -z "$msg" ]
    then
	msg="Press ENTER to continue... "
    fi

    echo -n $msg
    read
    clear
}

top_level_Makefile() {
    cat<<EOF
You may have to adjust the following variables in the top level Makefile:

\$(delete) must expand to a file deletion command.
          Default: del /q
\$(dirsep) must expand to your system's directory separator.
          Default: \\\\
\$(exe)    must expand to the file name extension of executable files, if any.
          Default: .exe

FLAVOR    must be set to either 'Plain' or 'Tricks'.
          This shifts compilation settings from standard compliance
          and debugging to less checking and more optimization.
          Default: Tricks

EOF
}


testing() {
    cat<<EOF
If you like, you can run ASnip's test suite, preferably on a UNIX system.

You may have to adjust the following variables in the Makefile in
subdirectory 'test':

\$(diff)  must expand to a file comparison command (binary, byte-wise).
         Default: diff -q

\$(grep)  must expand to a string search program (V7 regular expressions).
         Default: grep -q

EOF
}


echo |prompt
cat<<EOF
Welcome to ASnip's configuration!

This script serves as a guide to adjusting Makefiles for use with the
GNU Ada compilers. (For ObjectAda, see Makefile.OA.) It does not change
any files, so you can freely edit the Makefile(s) while the script is
running. The Makefile variables have been preset for use with GNAT GPL
edition on Windows. You shouldn't have to change anything if you have
this setup.

There is one exception: If your Windows box has half of UNIX installed
this can have two effects:

  (a) Your make program starts using UNIX commands in place of
      Windows comands of the same name. In this case use UNIX
      settings as explained on the next screen.

  (b) You will be able to run the test suite as is.
EOF
prompt

top_level_Makefile
prompt

testing
prompt This is the last screen...


# $ProjectVersion: R1.1 $

