#!/bin/bash
repo_root=$(git rev-parse --show-toplevel)
export KALDI_ROOT=$repo_root/kaldi
export IRSTLM_ROOT=$repo_root
export IRSTLM=$repo_root
