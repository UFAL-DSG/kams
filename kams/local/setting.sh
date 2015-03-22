export KALDI_ROOT=`readlink -f ../kaldi`
export CUDA_VISIBLE_DEVICES=0  # only card 0 (Tesla on Kronos) will be used for DNN training
