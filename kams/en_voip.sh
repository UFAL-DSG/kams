#!/bin/bash

# set what models to train
export TRI2B_BMMI=true
export TRI3B=false
export TRI4_NNET2=true
export TRI4_NNET2_SMBR=true

# EVERY_N utterance is used for training
# EVERY_N=3    ->   we use one third of training data
export EVERY_N=1
export TEST_SETS="dev test"

# Directories set up
export DATA_ROOT=/net/me/merkur2/vystadial/asr-mixer/en-voip  # expects subdirectories train + $TEST_SETS
export WORK=`pwd`/model_en_voip
export EXP=$WORK/exp
export TGT_MODELS=exported/en_voip
export TGT_MODELS2=exported2/en_voip

# Specify paths to arpa models. Paths may not contain spaces.
# Specify build0 or build1 or build2, .. for building (zero|uni|bi)-gram LM.
# Note: The LM file name should not contain underscore "_"! 
# Otherwise the results will be reported without the LM with underscore."
export LM_paths="build0 build2"
export LM_names="build0 build2"

# Use path to prebuilt dictionary or 'build' command in order to build dictionary
# export DICTIONARY="../xxx/dict"
export DICTIONARY="build"


# Borders for estimating LM model weight.
# LMW is tuned on development set and applied on test set.
export min_lmw=4
export max_lmw=20

# Number of states for phonem training
export pdf=1200

# Maximum number of Gaussians used for training
export gauss=19200

export train_mmi_boost=0.05

export mmi_beam=16.0
export mmi_lat_beam=10.0

export smbr_beam=16.0
export smbr_lat_beam=10.0

# --fake -> NO CMVN; empty -> CMVN (pykaldi decoders can not handle CMVN -> fake)
export fake="--fake"

export g2p="local/prepare_en_transcription.sh"

# set paralelisation
# for standard training using using CPU
export train_cmd="queue.pl -V -l mem_free=2G,h_vmem=4G -p -20"
export decode_cmd="queue.pl -V -l mem_free=4G,h_vmem=8G -p -20"
export njobs=100
export njobs_mfcc=40
export njobs_dev_test=100

# This is a command to run the code on a CUDA enabled machine at UFAL. We do not have CUDA machines at the cluster.
# You must run the training from a CUDA enabled manchine!
export gpu_cmd=run.pl
export gpu_nj=16

mkdir -p $WORK
