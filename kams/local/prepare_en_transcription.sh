#!/bin/bash
set -e
this_local_dir=$(cd `dirname $0` && pwd)
if [ -z "$this_local_dir" ] || [ ! -d "$this_local_dir" ] ; then echo "Failed $0"; exit 1; fi

vocab_full=$1; shift
transcription=$1; shift

locdict=$this_local_dir/dic_common
cmu_dict=$locdict/cmudict.0.7a
cmu_ext=$locdict/cmudict.ext

mkdir -p $locdict

if [ ! -f $cmu_dict ] ; then
  echo "--- Downloading CMU dictionary ..."
  svn export http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict.0.7a \
     $cmu_dict || exit 1;
fi

# echo; echo "If common/cmudict.ext exists, add extra pronunciation to dictionary" ; echo
# You may want to concat cmu extension in future
cat $cmu_dict > $cmu_ext 2> /dev/null  # ignoring if no extension

echo "--- Striping stress and pronunciation variant markers from cmudict ..."
perl $this_local_dir/make_baseform.pl $cmu_ext /dev/stdout |\
  sed -e 's:^\([^\s(]\+\)([0-9]\+)\(\s\+\)\(.*\):\1\2\3:' > $transcription
