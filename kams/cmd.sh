#!/bin/bash
# "queue.pl" uses qsub.  The options to it are
# options to qsub.  If you have GridEngine installed,
# change this to a queue you have access to.
# Otherwise, use "run.pl", which will run jobs locally
# (make sure your --num-jobs options are no more than
# the number of cpus on your machine.

# export train_cmd="queue.pl -q all.q@a*.clsp.jhu.edu"
# export decode_cmd="queue.pl -q all.q@a*.clsp.jhu.edu"

# UFAL settings
# This is a default setting, this can be changed by the trainin seeting scricpt, e.g. en_super.sh

export train_cmd="queue.pl -V -l mem_free=2G,h_vmem=4G"
export decode_cmd="queue.pl -V -l mem_free=4G,h_vmem=8G"
export njobs=100               # used when processing the train data 
export njobs_dev_test=100      # used when processing th dev and test data (it is usually significantly smaller comapared to the train data)

# This is a command to run the code on a CUDA enabled machine at UFAL. We do not have CUDA machines at the cluster.
# You must run the training from a CUDA enabled manchine!
export gpu_cmd=run.pl
export gpu_nj=16

