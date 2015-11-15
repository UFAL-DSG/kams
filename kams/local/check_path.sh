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

if [ ! -d "$IRSTLM_ROOT" ] ; then
  echo "IRSTLM_ROOT need to be set to point to directory"
  echo "May not be able to create LMs!"
fi
