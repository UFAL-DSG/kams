FSTDIR=kaldi/tools/openfst
OPENFST_VERSION=1.3.4
INSTALL_PREFIX=/usr/local/

all: kaldi

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


kaldi: $(FSTDIR)/lib/libfst.a kaldi/tools/ATLAS/include/clapack.h kaldi/src/kaldi.mk
	$(MAKE) -C kaldi/src

install: kaldi
	echo "Kaldi compiled"


install-kaldi-binaries: kaldi/src/kaldi.mk
	cp -r kaldi/src/lib/* $(INSTALL_PREFIX)/lib
	cp `find kaldi/src -executable -type f` $(INSTALL_PREFIX)/bin

irstlm:
	svn -r 769 co --non-interactive --trust-server-cert https://svn.code.sf.net/p/irstlm/code/trunk irstlm

irstlm/Makefile: irstlm
	cd irstlm && cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$(INSTALL_PREFIX)"

install-irstlm: irstlm/Makefile
	$(MAKE) -C irstlm
	$(MAKE) -C irstlm install
	
distclean:
	$(MAKE) -C kaldi/tools distclean
	$(MAKE) -C kaldi/src clean
	rm -f kaldi/decoders.{cpp,so}
