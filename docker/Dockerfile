FROM      ubuntu:14.04
# FROM      debian:jessie # Change to debian:jessie save 100MB  over ubuntu:14:04 FIXME packages
MAINTAINER Ondrej Platek <ondrej.platek@gmail.com>

RUN apt-get update && apt-get install -y \
        build-essential \
        cmake \
        gawk \
        git \
        gcc-4.7 \
        g++-4.7 \
        libatlas-base-dev \
        locales \
        python-dev \
        python-pip \
        python-software-properties \
        software-properties-common \
        subversion \
        wget \
        zip \
        zlib1g-dev \
        && rm -rf /var/lib/apt/lists/*  && apt-get autoremove -y

# Set the locale.
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# using gcc-4.7. Gcc 4.8.2 is buggy
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7

# Installing the binaries system wide, so the huge number of object files can be cleaned.
ENV KALDI_ROOT=/app/kams_docker/kaldi \
    KAMS_ROOT=/app/kams_docker \
    INSTALL_PREFIX=/usr/local \
    IRSTLM=/usr/local

RUN mkdir -p $KAMS_ROOT /app/data  /app/kams

# depreceted
# # We suppose that the dockerfile is used from the repo root e.g. trough docker/build_development.sh
# ADD . $KAMS_ROOT

# We suppose that the dockerfile is used from the repo root e.g. trough docker/build_development.sh
WORKDIR $KAMS_ROOT
RUN echo commit_6d5dace1 && git clone --depth=1 --branch minor_fixes --recursive https://github.com/UFAL-DSG/kams.git $KAMS_ROOT \
    && make INSTALL_PREFIX=$INSTALL_PREFIX install && make distclean && rm -rf $KAMS_ROOT/kaldi/{src,tools} && rm -rf $KAMS_ROOT/irstlm
WORKDIR $KAMS_ROOT/kams
RUN echo && echo "DEBUGGING INFO and FEW TESTS" && echo && ls $INSTALL_PREFIX/bin && echo $PATH \
    && echo $LD_LIBRARY_PATH && ls $INSTALL_PREFIX/lib \
    && pwd && ls -l path.sh \
    && . ./path.sh \
    && lattice-oracle --help 2> /dev/null \
    && echo; echo "Kaldi binaries installed under $INSTALL_PREFIX/bin" \
    && [ -d $KALDI_ROOT/egs/wsj/s5/steps ] && [ -d $KALDI_ROOT/egs/wsj/s5/utils ] && [ -f $KALDI_ROOT/egs/wsj/s5/utils/mkgraph.sh ] \
    && echo; echo "Kaldi scripts installed under KALDI_ROOT=$KALDI_ROOT" \
    && build-lm.sh --help 2> /dev/null \
    && echo; echo "IRSTLM libraries and binaries are installed under $INSTALL_PREFIX/{bin,lib}" \
    && echo "/app/kams and /app/data are directories where the kams source code and data should be mapped (See docker run -v option)" \
    && echo "The directories are created with intention that the user of the container will modify the data there." \
    && echo "The directories are initialized empty."
WORKDIR /app/kams

