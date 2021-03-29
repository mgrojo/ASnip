# compare two files in binary mode (byte-wise, ignoring encodings)
#diff = fc /a /b
diff = cmp

# asnip executable
asnip = ..$(dirsep)obj$(dirsep)asnip

# plain old V7 regular expressions filter. Note on findstr: Space separates
# alternative between quotes unless preceded by /C: (which I don't do here)
#grep = findstr 
grep = grep -q

# For the "copy" test, that is, ASnip in identity mode. The "copy" test is
# not added to the "all" target, because the files mentioned in $(COPY-DIR)
# and $(COPY-FILES) need to be present, or, alternatively they need to be
# replaced with some other directory and files. Preferably some larger,
# rich Ada source files.
#COPY-DIR = N:/opt/AdaCore/GNAT/lib/gcc/pentium-mingw32msv/3.4.5/adainclude
COPY-DIR = /usr/lib/gcc/i386-redhat-linux/4.0.0/adainclude
#COPY-DIR = /opt/GNAT_GPL/lib/gcc/i686-pc-linux-gnu/3.4.5/adainclude
COPY-FILES = a-textio.adb g-spipat.adb

all: difftest driver check wiki
#all: copy

wiki: delimiters operators libpacks

.PHONY: driver operators delimiters check libpacks \
	rmtestfiles copy wiki difftest

difftest:
	@echo "----------------------------------------------------------------"
	@echo "Does the file comparision program, $(diff), work?"
	@echo "Be sure to adjust the top definitions in the Makefile"
	@echo "----------------------------------------------------------------"
	$(diff) text.8 text.8

driver: rmtestfiles ../obj/test-driver$(exe)
	..$(dirsep)obj$(dirsep)test-driver
	$(diff) text.8 text.8.test
	$(diff) text.16 text.16.test
	$(diff) text.16x text.16x.test
	-$(diff) asnip-testing.bdy asnip-testing.bdy.test
	echo IGNORING TRAILING CR CHARACTER FOR NOW...

check:
	echo "" | $(asnip) from Ada generate HTML
	echo x | $(asnip) from Ada generate HTML
	echo 6x | $(asnip) from Ada generate HTML
	echo x6 | $(asnip) from Ada generate HTML
	echo x y | $(asnip) from Ada generate HTML
	echo '"' | $(asnip) from Ada generate HTML
	echo '"a' | $(asnip) from Ada generate HTML
	echo '""a' | $(asnip) from Ada generate HTML
	echo '"""a' | $(asnip) from Ada generate HTML
	echo '"""a ' | $(asnip) from Ada generate HTML
	echo '"""a &' | $(asnip) from Ada generate HTML
	echo '"a"' | $(asnip) from Ada generate HTML
	echo '"""' | $(asnip) from Ada generate HTML
	echo '""""' | $(asnip) from Ada generate HTML
	echo '"a"""' | $(asnip) from Ada generate HTML
	echo '"""a"' | $(asnip) from Ada generate HTML
	echo '""a""' | $(asnip) from Ada generate HTML
	echo '"a""b"' | $(asnip) from Ada generate HTML


operators:
	echo '<' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator 2|less_than|<}}"
	echo '>' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator 2|greater_than|>}}"
	echo '=' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator|1==}}"
	echo '+' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator|+}}"
	echo '-' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator|-}}"
	echo '*' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator|\*}}"
	echo '/' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator|/}}"
	echo '&' | $(asnip) from Ada generate WiKiBook | $(grep) "\[\[Ada[ _]Programming/Delimiters/&|&\]\]"
	echo '**' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator|\*\*}}"
	echo '<=' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator 2|1=less_than_or_equal_to|2=<=}}"
	echo '>=' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator 2|1=greater_than_or_equal_to|2=>=}}"
	echo '/=' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/operator|1=/=}}"

delimiters:
	echo '|' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter 2|vertical_line|&#124;}}"
	echo '!' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter 2|vertical_line|&#124;}}"
	echo '(' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter|(}}"
	echo ')' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter|)}}"
	echo '.' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter 2|dot|\.}}"
	echo ',' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter|,}}"
	echo ';' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter|;}}"
	echo ':' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter|:}}"
	echo "'" | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter|'}}"
	echo '=>' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter 2|1=arrow|2==>}}"
	echo '<>' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter 2|box|<>}}"
	echo '<<' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter 2|left_label|<<}}"
	echo '>>' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter 2|right_label|>>}}"
	echo '..' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter 2|double_dot|\.\.}}"
	echo ':=' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/delimiter|1=:=}}"
	echo '#' | $(asnip) from Ada generate WiKiBook | $(grep) "^#$$"
	echo '{' | $(asnip) from Ada generate WiKiBook | $(grep) "^{$$"
	echo '}' | $(asnip) from Ada generate WiKiBook | $(grep) "^}$$"
	echo '[' | $(asnip) from Ada generate WiKiBook | $(grep) "^\[$$"
	echo ']' | $(asnip) from Ada generate WiKiBook | $(grep) "^\]$$"

# special cases for library package names with dots in them
ada-strings-fixed = $(subst .,{{Ada/delimiter 2|dot|.}},Ada.Strings.Fixed)
lib-ada-strings-fixed = {{Ada/keyword|package}} {{Ada/package 3|Ada|Strings|Fixed}}

libpacks:
	echo 'package Ada' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/keyword|package}} {{Ada/package|Ada}}"
	echo 'Ada.Strings.Fixed' | $(asnip) from Ada generate WiKiBook | $(grep) "$(ada-strings-fixed)"
	echo 'package Ada.Strings.Fixed' | $(asnip) from Ada generate WiKiBook | $(grep) "$(lib-ada-strings-fixed)"
	echo 'package Ada.6' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/keyword|package}} {{Ada/package|Ada}}{{Ada/delimiter 2|dot|.}}6"
	echo 'package Ada.6x' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/keyword|package}} {{Ada/package 2|Ada|6x}}"
	echo 'with Ada' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/keyword|with}} {{Ada/package|Ada}}"
	echo 'use Ada' | $(asnip) from Ada generate WiKiBook | $(grep) "{{Ada/keyword|use}} {{Ada/package|Ada}}"

################################################################
# asnip run that produces identical output from some big Ada input files

copy: $(COPY-FILES)

$(COPY-FILES): $(asnip) rmtestfiles
	$(asnip) from Ada generate text < $(COPY-DIR)/$@ > $@
	$(diff) $(COPY-DIR)/$@ $@

rmtestfiles:
	-$(delete) text.8.test
	-$(delete) text.16.test
	-$(delete) text.16x.test
	-$(delete) asnip-testing.bdy.test
	-$(foreach file,$(COPY-FILES),$(delete) $(file);)
