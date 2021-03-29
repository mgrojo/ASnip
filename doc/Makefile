# GNU Makefile for making the sample files showing ASnip results.
# Needs: xsltproc, TeX

# ASnip executable
asnip = ../obj/asnip

delete = rm

################################################################
.PHONY: all clean

.SECONDARY: multi.xml single.xml

# The HTML example files #######################################
all: sample-antiq.html sample-rm.html


sample-%.html: sample.in ada-%.css single.xml multi.xml make-sample.xsl
	xsltproc --stringparam style-sheet ada-$*.css make-sample.xsl $< >$@

multi.xml: quicksort.stl $(asnip)
	$(asnip) from Ada generate HTML < $< | \
		(echo '<pre>'; cat - ; echo '</pre>') > $@

single.xml: hello.ada $(asnip)
	$(asnip) from Ada generate HTML < $< | \
		(echo '<pre>'; cat - ; echo '</pre>') > $@


# The TeX example ##############################################

sample.pdf: sample.tex hello_body.in quicksort_body.in
	pdftex  $<

%_body.in: %.ada $(asnip)
	$(asnip) from Ada generate TeX < $< > $@

%_body.in: %.stl $(asnip)
	$(asnip) from Ada generate TeX < $< > $@


# Do not remove files that are made for distribution, or are not
# generated at all (including sample.in)
clean:
	-$(delete) *_spec.in
	-$(delete) *_body.in
	-$(delete) *.log
	-$(delete) multi.xml
	-$(delete) single.xml
