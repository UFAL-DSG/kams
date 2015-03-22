#!/bin/bash

if [ ! -d "$KALDI_ROOT" ] ; then
  echo "KALDI_ROOT need to be set to point to directory"
  exit 1
fi

# creating symlinks to scripts which wraps kaldi binaries
symlinks="$KALDI_ROOT/egs/wsj/s5/steps $KALDI_ROOT/egs/wsj/s5/utils"
for syml in $symlinks ; do
  name=`basename $syml`
  if [ ! -e "$name" ] ; then
    ln -f -s "$syml"
    if [ -e $name ] ; then
        echo "Created symlink $syml -> $name"
    else
        echo "Failed to create symlink $syml -> $name"
        exit 1
    fi
  elif [ "$syml"  != `readlink -f $name` ] ; then
    echo -e "Relinking symlink '$name' according to new KALDI_ROOT \n$KALDI_ROOT"
    ln -f -s "$syml"
  fi
  export PATH="$PWD/$name":$PATH
done

srilm_bin=$KALDI_ROOT/tools/srilm/bin/
if [ ! -e "$srilm_bin" ] ; then
  echo "SRILM is not installed in $KALDI_ROOT/tools."
  echo "May not be able to create LMs!"
fi
srilm_sub_bin=`find "$srilm_bin" -type d`
for d in $srilm_sub_bin ; do
    export PATH=$d:$PATH
done
