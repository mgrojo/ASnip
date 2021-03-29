@echo off
rem A simple interactive guide to configuring ASnip's Makefile(s) for
rem use with GNAT.

setlocal

rem GLOBAL VARIABLES
rem A Text-Variable that can hold additional information to be displayed
rem by the "prompt" procedure
SET msg=

rem return address of procedures
SET backaddress=


GOTO start

rem PROCEDURES
rem Display %msg% unless empty, and pause
:prompt
echo.
IF x%msg%==x GOTO P1
echo %msg%
:P1
pause
GOTO %backaddress%

rem Describe toplevel Makefile for GNAT
:topgnat
echo You may have to adjust the following variables in the top level
echo Makefile:
echo.
echo $(delete) must expand to a file deletion command.
echo           Default: del /q
echo $(dirsep) must expand to your system's directory separator.
echo           Default: \\
echo $(exe)    must expand to the file name extension of executable
echo           files, if any.
echo           Default: .exe
echo.

echo FLAVOR    must be set to either 'Plain' or 'Tricks'.
echo           This shifts compilation settings from standard
echo           compliance and debugging to less checking and
echo           more optimization.
echo           Default: Tricks

GOTO %backaddress%

rem Display the welcome text
:welcome
echo Welcome to ASnip's configuration!
echo. 
echo This script serves as a guide to adjusting Makefiles for use
echo with the GNU Ada compilers. (For ObjectAda, see Makefile.OA.)
echo It does not change any files, so you can freely edit the
echo Makefile(s) while the script is running. The Makefile variables
echo have been preset for use with GNAT GPL edition on Windows. You
echo shouldn't have to change anything if you have this setup.

echo.
echo There is one exception: If your Windows box has half of UNIX
echo installed this can have two effects:

echo.
echo  (a) Your make program starts using UNIX commands in place of
echo      Windows comands of the same name. In this case use UNIX
echo      settings as explained on the next screen.

echo  (b) You will be able to run the test suite as is.
GOTO %backaddress%

rem main control procedure
:start
SET backaddress=:endwelcome
cls
GOTO welcome
:endwelcome
SET backaddress=:endmakefileprompt
GOTO prompt
:endmakefileprompt
SET backaddress=:endtopgnat
cls
GOTO topgnat
:endtopgnat
SET msg="This is the last screen"
set backaddress=:endtopgnatprompt
GOTO prompt
:endtopgnatprompt

rem $ProjectVersion: R1.1 $

