FROM      ubuntu:14.04
MAINTAINER Ondrej Platek <ondrej.platek@gmail.com>

# Set the locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
RUN apt-get update && apt-get install -y \
        build-essential \
        cmake \
        gawk \
        git \
        gcc-4.7 \
        g++-4.7 \
        libatlas-base-dev \
        python-dev \
        python-pip \
        python-software-properties \
        software-properties-common \
        subversion \
        wget \
        zip \
        zlib1g-dev

# using gcc-4.7. Gcc 4.8.2 is buggy
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7

RUN mkdir -p /kaldi_uproot ; cd /kaldi_uproot; git clone --recursive https://github.com/UFAL-DSG/kams.git
WORKDIR /kaldi_uproot/kams
RUN make
WORKDIR /kaldi_uproot/kams/kams
ENV KALDI_ROOT=/kaldi_uproot/kams/kaldi
RUN . local/setting.sh ; ls -l path.sh ; . ./path.sh ; \
    apply-cmvn --help 2> /dev/null \
    && build-lm.sh --help > /dev/null \
    && echo -e "\n\nKaldi binaries and irstlm are installed under KALDI_ROOT=$KALDI_ROOT\n"

# Directories where the kams source code and data should be mapped (See docker run -v option)
# The directories are created with intention that the user of the container will modify the data there.
# The directories are initialized empty.
RUN mkdir -p /app/kams /app/data   
WORKDIR /app/kams
