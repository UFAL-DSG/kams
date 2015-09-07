#!/bin/bash
set -e

vocab_full=$1; shift
transcription=$1; shift

cmu_dict=common/cmudict.0.7a
cmu_ext=common/cmudict.ext

mkdir -p common || echo "common directory for storing English pronunciation for $0 is already created"

if [ ! -f $cmu_dict ] ; then
  echo "--- Downloading CMU dictionary ..."
  svn export http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict.0.7a \
     $cmu_dict || exit 1;
fi

echo; echo "If common/cmudict.ext exists, add extra pronunciation to dictionary" ; echo
#cat $cmu_dict  $cmu_ext > $locdict/cmudict_ext.txt 2> /dev/null  # ignoring if no extension
cat $cmu_dict > $locdict/cmudict_ext.txt 2> /dev/null  # ignoring if no extension

echo "--- Striping stress and pronunciation variant markers from cmudict ..."
perl local/make_baseform.pl \
  $locdict/cmudict_ext.txt /dev/stdout |\
  sed -e 's:^\([^\s(]\+\)([0-9]\+)\(\s\+\)\(.*\):\1\2\3:' > $vocab_full
