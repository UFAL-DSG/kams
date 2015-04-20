FROM      ubuntu:14.04
MAINTAINER Ondrej Platek <ondrej.platek@gmail.com>

ENTRYPOINT ["/bin/bash"]

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
RUN apt-get update && apt-get install -y \
        build-essential \
        libatlas-base-dev \
        python-dev \
        python-pip \
        git \
        wget \
        zip \
        subversion \
        cmake \
        zlib1g-dev \
        texlive \
        texlive-latex-extra
# Get rid of texlive and texlive-latex-extra it is needed just by irstlm to build pdf manual ;-)!

RUN mkdir -p /app && cd /app && git clone --recursive https://github.com/UFAL-DSG/kams.git
WORKDIR /app/kams
# RUN pip install -r kams-requirements.txt


# install kaldi binaries and test it
RUN make install-kaldi-binaries && apply-cmvn --help 2> /dev/null && echo 'Kaldi binaries installed succesfully!'
RUN make install-irstlm && echo 'IRSTLM LM modelling toolkit installed successfully!'
