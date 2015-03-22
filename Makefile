# TODO cython does not recompile because of the templates and sourcefiles
FSTDIR=kaldi/tools/openfst
# OPENFST_VERSION=1.4.1 # fails with pyfst
OPENFST_VERSION=1.3.4

all: kaldi

kaldi/.git: .gitmodules
	git submodule init kaldi
	git submodule sync -- kaldi
	git submodule update kaldi

kaldi/src/kaldi.mk: kaldi/.git $(FSTDIR)/lib/libfst.a kaldi/tools/ATLAS/include/clapack.h
	@echo "kaldi configure"
	cd kaldi/src && \
		./configure --shared

kaldi/tools/ATLAS/include/clapack.h: kaldi/.git
	$(MAKE) -C kaldi/tools  atlas ; echo "Installing atlas finished $?"

$(FSTDIR)/lib/libfst.a: kaldi/.git
	$(MAKE) -C kaldi/tools openfst OPENFST_VERSION=$(OPENFST_VERSION); echo "Installing OpenFST finished: $?"


kaldi: $(FSTDIR)/lib/libfst.a kaldi/tools/ATLAS/include/clapack.h kaldi/src/kaldi.mk
	$(MAKE) -C kaldi/src

install: kaldi
	echo "Kaldi compiled"
	
distclean:
	$(MAKE) -C kaldi/tools distclean
	$(MAKE) -C kaldi/src clean
	rm -f kaldi/decoders.{cpp,so}

