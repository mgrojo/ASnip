# This GNU Makefile is mainly for setup, running tests, and producing
# doc files. After running make once, running the build tools of the
# respective compilers should be sufficient.
# For GNAT, there is a GNAT project file.
# If you have ObjectAda, see Makefile.OA.


# how to remove a file
delete = del /q
#delete = rm -f
dirsep=\\
#dirsep=/

exe=.exe

ADAC = GNAT
FLAVOR = Tricks
  # "Plain" or "Tricks". See file "asnip.gpr".

all: $(ADAC)
#all: $(ADAC) test

################################################################
export delete exe dirsep

test: $(ADAC) force test/asnip-testing.bdy vartest
	$(MAKE) -C test
vartest:
	@echo > xxx.xxx
	@echo "----------------------------------------------------------------"
	@echo "Does the file deletion command, $(delete), work?"
	@echo "Be sure to adjust the Makefile as explained in README.txt"
	@echo "----------------------------------------------------------------"
	$(delete) xxx.xxx

.PHONY: force clean $(ADAC) test vartest GNAT RELEASE

obj:
	-mkdir obj

doc: force
	xmlto -o doc html-nochunks asnip.xml
	xmlto -o doc man asnip.xml


# splitting a file with both spec and body in it so GNAT can process them:

spec-and-body = asnip-support binary_search
chopped = $(foreach name,$(spec-and-body),obj/$(name).ads obj/$(name).adb)

obj/%.ads obj/%.adb: %.ada
	gnatchop -r -w $< obj


GNAT: obj $(chopped)
	gnatmake -Pasnip -XFLAVOR=$(FLAVOR)

force:

clean:
	-$(delete) obj$(dirsep)*
	-$(delete) doc$(dirsep)asnip.l
	-$(delete) doc$(dirsep)asnip.html
	$(MAKE) -C test rmtestfiles

################
# Making a distribution zip

NAME = ASnip
 # Name of project, and of project directory

REL = test3
 # Major version identifier
 # Each release needs a differen realease identifier!

export NAME REL

RELEASE:
	$(MAKE) -C dist -f Makefile.dist zip binzip
	echo RELEASED >RELEASE

distclean: clean
	$(MAKE) -C dist -f Makefile.dist clean
