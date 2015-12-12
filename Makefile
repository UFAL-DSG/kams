FSTDIR=kaldi/tools/openfst
OPENFST_VERSION=1.3.4
INSTALL_PREFIX=$(PWD)
KALDI_URL=https://github.com/kaldi-asr/kaldi.git
KALDI_COMMIT=95668a1e14315e3f2658b52d140e322ea3f06cf2

all: install
	@echo "running all should have run install"

$(INSTALL_PREFIX)/lib:
	mkdir -p $@

$(INSTALL_PREFIX)/bin:
	mkdir -p $@

kaldi/.git: Makefile
	git clone $(KALDI_URL) kaldi
	cd kaldi; git reset --hard $(KALDI_COMMIT) ; cd -


kaldi/src/kaldi.mk: kaldi/.git $(FSTDIR)/lib/libfst.a kaldi/tools/ATLAS/include/clapack.h
	@echo "kaldi configure"
	cd kaldi/src && ./configure

kaldi/tools/ATLAS/include/clapack.h: kaldi/.git
	$(MAKE) -C kaldi/tools  atlas ; echo "Installing atlas finished $?"

$(FSTDIR)/lib/libfst.a: kaldi/.git
	$(MAKE) -C kaldi/tools openfst OPENFST_VERSION=$(OPENFST_VERSION); echo "Installing OpenFST finished: $?"


kaldi/src/bin/lattice-oracle: $(FSTDIR)/lib/libfst.a kaldi/tools/ATLAS/include/clapack.h kaldi/src/kaldi.mk
	$(MAKE) -C kaldi/src

install: install-kaldi-binaries install-irstlm
	@echo running install: should have run install-kaldi-binaries install-irstlm

install-kaldi-binaries: kaldi/src/bin/lattice-oracle $(INSTALL_PREFIX)/bin $(INSTALL_PREFIX)/lib
	@echo running install kaldi libraries
	cp -f `find kaldi/src -executable -type f` $(INSTALL_PREFIX)/bin
	@echo "Kaldi binaries installed to $(INSTALL_PREFIX)/bin"
	cp -fr kaldi/tools/openfst-*/lib/* $(INSTALL_PREFIX)/lib
	@echo "Openfst (needed for Kaldi binaries) installed to $(INSTALL_PREFIX)/lib"

install-irstlm:
	git clone https://github.com/irstlm-team/irstlm.git  $(INSTALL_PREFIX)/irstlm
	sed -i 's:ADD_SUBDIRECTORY (doc)::' $(INSTALL_PREFIX)/irstlm/CMakeLists.txt
	cd $(INSTALL_PREFIX)/irstlm && cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$(INSTALL_PREFIX)"
	CC=gcc $(MAKE) -C $(INSTALL_PREFIX)/irstlm install
	@echo "IRSTLM installed to $(INSTALL_PREFIX)/{bin,lib}"

distclean:
	$(MAKE) -C kaldi/tools distclean
	$(MAKE) -C kaldi/src clean || echo -e '\n Error during cleaning kaldi/src \n'
	$(MAKE) -C irstlm clean || echo -e '\n Error during cleaning irstlm \n'
	rm -f irstlm/CMakeCache.txt

.PHONY: distclean install install-kaldi-binaries install-irstlm
