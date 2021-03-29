This file explains building ASnip. ASnip decorates source code with
markup. See doc/asnip.html for how to use it. The license text is in
file "forum.txt".

    WHAT
    BINARY DISTRIBUTION
    BUILDING
      Requirements
      Documentation
      Using ObjectAda
      Using GNAT
      Using AppletMagic
      Using an Ada 95 compiler
    INSTALLATION
    MISCELLANEOUS NOTES

* WHAT

ASnip reads snippets of Ada source text, correct or incorrect, and
produces output suitable for printing, viewing, or including.

   * HTML     - use your own style sheets, or the ones provided
   * Text     - for regression testing, really
   * TeX      - via Knuth's WEB macros (Try lgrind with LaTeX)
   * WiKiBook - adds markup used for the Ada Wikibook,
                automatically links tokens to the Ada reference
  (* RTF      - time permitting)
  (* XML      - time permitting, using Simon Wright's ASIS based GIs.)

The asnip program operates on a stream of characters, so you can use it
as an external tool with a number of text editors, in scripts, etc. It
tries to read the character encoding from the environment, but you can
also specify one, per run.

Adding or changing output formats is fairly easy. There is a small
section in the manual about this.


* BINARY DISTRIBUTION

The binary distribution is a ZIP archive of a Windows executable,
documentation files including this one, and licensing information. Copy
the executable to some directory listed in your the program search path.
The file "asnip.html" contains the manual as a hypertext. It has links
to more files from the distribution archive.


* BUILDING

** Requirements

ASnip needs a container package from Ada.Containers or from an Ada 95
edition of the reference implementation, Indefinite_Vectors.

GNU make or nmake will make things easier. Building does not strictly
depend on make programs as their main task is setting things up for Ada
build tools.

If you want to produce the documentation the same way as I did,
you will need xmlto.


** Documentation

The manual page is doc/asnip.html or doc/asnip.l. The text links
to some prebuild examples, and their sources, which provide further
explanation.

(The manual page is made from asnip.xml. Running "make doc" will produce
the HTML and a Unix man page, both in the "doc" subdirectory. (You need
xmlto.)The Makefile in the doc subdirectory is used for making the
different example output files. It requires some more tools, namely TeX
and an XSL transformer (tested with GNU/Linux only).


** Using ObjectAda

*** From the Windows command line

There is an Nmake Makefile.OA for initial setup and building. (It uses
only traditional features, so hopefully other make programs can use it
as well.) Adjust a few variables (macros) at the start of the make file,
to reflect your installation. Then run

[\] nmake /f Makefile.OA

This is what should happen:

First, creates a libary for the Ada 95 version of Ada.Containers. For
example, assuming the container sources reside in X:\Containers, changes
to a fresh directory, Y:\Containers\ProjectDir. Runs

	adaopts -sd X:\Containers
	adacomp -O2 -sr X:\Containers\a-coinve.adb
	adamake -O2 -sr X:\Containers\a-coinve.adb

Adds this library to ASnip's library search path. ASnip also needs the
POSIX function getenv(2), and SetEnvironmentVariableA or setenv(2),
resp.. Assuming ObjectAda is installed in directory O:\opt\ObjectAda,

	adaopts -p Y:\Containers\ProjectDir
	adaopts -lp O:\opt\ObjectAda\apilib

Assuming the ASnip source files are in S:\ASnip, and a Win32 version is
to be built,

	adareg S:\ASnip\*.spc S:\ASnip\*.bdy S:\ASnip\*.ada
	adareg S:\ASnip\Win32\*.spc S:\ASnip\Win32\*.bdy


Finally,

	adabuild ASnip.main

If you want to run some tests, add units from the "test" subdirectory,
and build them.


*** Using the (traditional) ObjectAda IDE

First, make a library from the Ada 95 version of Ada.Containers. In
particular, the indefinite vectors package, and its dependences must
be compiled. Once you have the library, you can create a project for
ASnip. Add the Ada files from the top level distribution directory
and, optionally, from the "test" subdirectory, plus the Ada files from
the UNIX or Win32 directories, whichever fits best. Add the containers
library to the search path, and add a link path for getenv(2), which
should be .\apilib in the ObjectAda installation directory. The Build
menu will then show up to three main units. ASnip.main is the one to
become the "asnip" program.


** Using GNAT

You will need a fairly recent GNAT, or follow the generic instructions
below. GNAT GPL Edition 2005, GCC 4.0.x, or GCC 4.1.0 (more or less, see
GCC Bug #27225) work. For building on Unix-like systems, adjust a few
settings in the Makefile. The program configure.sh will help doing this.
Thus

$ sh configure
$ make
$ make doc
$ make test # optional

Make needs to be run only once if you just want to build an asnip
executable. It needs to be re-run if you change files that have more than
one unit in them. (The author runs it routinely, though.) The Makefile
eventually calls gnatmake with a GNAT project file, "asnip.gpr". Two
external variables influence the configuration, "OS", and "FLAVOR". See
the comments in the project file.



** Using AppletMagic

Setup is very similar to ObjectAda setup. ASnip's I/O is implemented
differently, though, and different containers are used. TBD



** Using an Ada 95 compiler

The sources are plain Ada 95, provided you can use an Ada 95 version
of Ada 2005's indefinite vectors container package, or a replacement.
Add the needed container units into the library. For building the
asnip executable, it should be sufficient to add all source files from
the top distribution directory to the library, and a suitable choice
of bodies from the Win32 or UNIX subdirectory. (With Janus/Ada, I/O
might be speedier if you prepare bodies of `standard_input_stream` and
`standard_output_stream` using Stream_IO with STI: and STO:, similar
to how it is done in the UNIX version. The author hasn't tried this,
though. See MISCELLANEOUS NOTES below.) ASnip's main unit, ASnip.main,
resides in the file "asnip-main.ada".

Files in the "test" directory are for testing parts of the program.
There are two more main units, contained in the files "driver.ada",
and "test_binsearch.ada", respectively.



* INSTALLATION

The executable will be found where your tools place it. For GNAT
this will be the ./obj directory as requested in the project file. For
ObjectAda, it will be in the project directory. In any case, you may
want to copy the executable to a directory in your program search
path, using the name "asnip", or "asnip.exe", depending on the operating
system's conventions.

"make doc" creates both an HTML file and a UNIX man page. They
are also part of the distribution, in directory "doc".


* MISCELLANEOUS NOTES

Janus/Ada on Windows:
Usenet article <ILmdnWHx29q5VMrZnZ2dnUVZ_sednZ2d@megapath.net>,
2006-05-02, has some tips for writing the `standard_input_stream` and
`standard_output_stream` functions taking advantage of Janus/Ada's
STI: and STO: standard file names. IIUC, you could try them in
a way similar to the UNIX implementations that use Stream_IO instead
of Text_Streams.

Speed:
In this release, ASnip relies on standard Ada streams reading and
writing characters (or bytes), one at a time. This is slow.

--
$ProjectDate: Tue, 23 May 2006 12:50:14 +0200 $

