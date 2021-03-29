#! /bin/sh

# Adds licensing header and address information to the Ada source files

unalias -a
PATH=/usr/bin:/bin

typeset -r LICENSE_FILE=forum.txt
typeset -r copyright="Copyright (C) 2006, Georg Bauhaus"
typeset -r description="ASnip Source Code Decorator"
typeset -r contact='eMail: bauhaus@arcor.de'

line() {
    echo \
"--------------------------------------------------------------------------"
}

# write new files that have a license header
add_license_etc() {
    file=$1

    line >${file}.lic
    echo "-- "${description} >>${file}.lic
    cat $here/${LICENSE_FILE?} | \
	sed "s/Eiffel Forum License, version 2/${copyright}/
s/^/-- /" >>${file}.lic
    line >>${file}.lic
    printf '%s %70s' -- "${contact}" >>${file}.lic
    echo >>${file}.lic
    echo >>${file}.lic
    cat $file >>${file}.lic
}

# set the time stamp back to that of the original files
adjust_timestamp() {
    file=$1

    mv $file ${file}.orig
    mv ${file}.lic $file
    touch --reference=${file}.orig $file
}

cleanup() {
    file=$1

    test -e ${file}.orig && rm ${file}.orig
}

for dir in . Win32 UNIX test
do
    here=$(pwd)
    cd $dir
    for file in $(ls *.spc *.bdy *.ada 2>/dev/null)
    do
	add_license_etc $file
   adjust_timestamp $file
   cleanup $file
    done
    cd $here
done


# $Id: attach-license.sh 1.2 Tue, 23 May 2006 12:50:14 +0200 root $
# $Date: Tue, 23 May 2006 12:50:14 +0200 $
# $ProjectDate: Tue, 23 May 2006 12:50:14 +0200 $
