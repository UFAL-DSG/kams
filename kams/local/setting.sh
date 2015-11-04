#!/bin/bash
repo_root=$(git rev-parse --show-toplevel)
export KALDI_ROOT=$repo_root/kaldi
export IRSTLM_ROOT=$repo_root
export CUDA_VISIBLE_DEVICES=0  # only card 0 (Tesla on Kronos) will be used for DNN training
