.PHONY: package cleanpackage clean installpackage install

OUTDIR=./out
LATEX=latexmk -output-directory=$(OUTDIR)
RM=trash

# make userdir=1 install will install to user's texmf. otherwise installs to local texmf.
ifdef userdir
INSTALLDIR=$(shell kpsewhich -var-value TEXMFHOME)
SUDO=
else
INSTALLDIR=$(shell kpsewhich -var-value TEXMFLOCAL)
SUDO=sudo
endif

PACKAGES=catcode package pzc ifmm uniformmargins


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

install: all
	for P in $(PACKAGES) ; do $(MAKE) PACKAGE=$${P} installpackage ; done