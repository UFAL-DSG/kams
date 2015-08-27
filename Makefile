FSTDIR=kaldi/tools/openfst
OPENFST_VERSION=1.3.4
INSTALL_PREFIX=$(PWD)

all: install
	@echo "running all should have run install"

$(INSTALL_PREFIX)/lib:
	mkdir -p $@

$(INSTALL_PREFIX)/bin:
	mkdir -p $@

kaldi/.git: .gitmodules
	git submodule init kaldi
	git submodule sync -- kaldi
	git submodule update kaldi

kaldi/src/kaldi.mk: kaldi/.git $(FSTDIR)/lib/libfst.a kaldi/tools/ATLAS/include/clapack.h
	@echo "kaldi configure"
	cd kaldi/src && ./configure

kaldi/tools/ATLAS/include/clapack.h: kaldi/.git
	$(MAKE) -C kaldi/tools  atlas ; echo "Installing atlas finished $?"

$(FSTDIR)/lib/libfst.a: kaldi/.git
	$(MAKE) -C kaldi/tools openfst OPENFST_VERSION=$(OPENFST_VERSION); echo "Installing OpenFST finished: $?"


kaldi/src/bin/compute-wer: $(FSTDIR)/lib/libfst.a kaldi/tools/ATLAS/include/clapack.h kaldi/src/kaldi.mk
	$(MAKE) -C kaldi/src

install: install-kaldi-binaries install-irstlm
	@echo running install: should have run install-kaldi-binaries install-irstlm

install-kaldi-binaries: kaldi/src/bin/compute-wer $(INSTALL_PREFIX)/bin $(INSTALL_PREFIX)/lib
	@echo running install kaldi libraries
	cp -f `find kaldi/src -executable -type f` $(INSTALL_PREFIX)/bin
	@echo "Kaldi binaries installed to $(INSTALL_PREFIX)/{bin}"

irstlm:
	svn -r 884 co --non-interactive --trust-server-cert https://svn.code.sf.net/p/irstlm/code/trunk irstlm

irstlm/Makefile: irstlm
	cd irstlm && cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$(INSTALL_PREFIX)"

install-irstlm: irstlm/Makefile $(INSTALL_PREFIX)/bin $(INSTALL_PREFIX)/lib
	$(MAKE) -C irstlm
	$(MAKE) -C irstlm install
	@echo "IRSTLM installed to $(INSTALL_PREFIX)/{bin,lib}"

distclean:
	$(MAKE) -C kaldi/tools distclean
	$(MAKE) -C kaldi/src clean || echo -e '\n Error during cleaning kaldi/src \n'
	$(MAKE) -C irstlm clean || echo -e '\n Error during cleaning irstlm \n'
	rm -f irstlm/CMakeCache.txt

.PHONY: distclean install install-kaldi-binaries install-irstlm

