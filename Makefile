.PHONY: package cleanpackage clean installpackage inst install

OUTDIR=./out
LATEX=latexmk -output-directory=$(OUTDIR)
RM=rm

PACKAGES=catcode package defcommand ifmm gcommand gbox gsymb gaccent mathscsl pzc uniformmargins kern overstrike


all:
	for P in $(PACKAGES) ; do $(MAKE) PACKAGE=$${P} package ; done

package: $(PACKAGE).pdf

$(OUTDIR):
	mkdir $(OUTDIR)

cleanpackage:
	$(LATEX) -C $(PACKAGE).dtx
	if [ -e "${OUTDIR}/README-${PACKAGE}.txt" ]; \
	then \
		$(RM) $(OUTDIR)/README-$(PACKAGE).txt ; \
	fi;

clean:
	for P in $(PACKAGES) ; do $(MAKE) PACKAGE=$${P} cleanpackage ; done

$(PACKAGE).pdf: $(OUTDIR)
	$(LATEX) $(PACKAGE).dtx

installpackage:
	$(SUDO) mkdir -p $(INSTALLDIR)/{tex,source,doc}/latex/mctools
	$(SUDO) cp $(PACKAGE).dtx $(INSTALLDIR)/source/latex/mctools
	$(SUDO) cp $(OUTDIR)/$(PACKAGE).sty $(INSTALLDIR)/tex/latex/mctools
	$(SUDO) cp $(OUTDIR)/$(PACKAGE).pdf $(INSTALLDIR)/doc/latex/mctools

inst: all
	for P in $(PACKAGES) ; do $(MAKE) PACKAGE=$${P}	INSTALLDIR=$(shell kpsewhich -var-value TEXMFHOME) SUDO='' installpackage ; done

install: all
	for P in $(PACKAGES) ; do $(MAKE) PACKAGE=$${P} INSTALLDIR=$(shell kpsewhich -var-value TEXMFLOCAL) SUDO='sudo' installpackage ; done
