#!/bin/bash
# Copyright (c) 2015, Filip Jurcicek, Ufal MFF UK <jurcicek@ufal.mff.cuni.cz>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
# WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE,
# MERCHANTABLITY OR NON-INFRINGEMENT.
# See the Apache 2 License for the specific language governing permissions and
# limitations under the License. #
#

set -e
# set -x

every_n=1

[ -f path.sh ] && . ./path.sh # source the path.
. utils/parse_options.sh || exit 1;


if [ $# -ne 4 ] ; then
    echo "Usage: $0 <data-directory>  <local-directory> <LMs> <Test-Sets>";
    exit 1;
fi

DATA=$1; shift
locdata=$1; shift
LMs=$1; shift
test_sets=$1; shift


echo "LMs $LMs  test_sets $test_sets"

echo "--- Distributing the file lists to train and ($test_sets x $LMs) directories ..."
mkdir -p $WORK/train
cp -f $locdata/train/wav.scp $WORK/train/wav.scp || exit 1;
cp -f $locdata/train/trans.txt $WORK/train/text || exit 1;
cp -f $locdata/train/spk2utt $WORK/train/spk2utt || exit 1;
cp -f $locdata/train/utt2spk $WORK/train/utt2spk || exit 1;
cp -f $locdata/train/spk2gender $WORK/train/spk2gender || exit 1;
# utils/filter_scp.pl $WORK/train/spk2utt $locdata/spk2gender \
#   > $WORK/train/spk2gender || exit 1;
utils/validate_data_dir.sh --no-feats $WORK/train || exit 1;
echo DEBUG

for s in $test_sets ; do 
  for lm in $LMs; do
    tgt_dir=$WORK/${s}_`basename ${lm}`
    mkdir -p $tgt_dir
    cp -f $locdata/${s}/wav.scp $tgt_dir/wav.scp || exit 1;
    cp -f $locdata/${s}/trans.txt $tgt_dir/text || exit 1;
    cp -f $locdata/${s}/spk2utt $tgt_dir/spk2utt || exit 1;
    cp -f $locdata/${s}/utt2spk $tgt_dir/utt2spk || exit 1;
    # utils/filter_scp.pl $tgt_dir/spk2utt $locdata/spk2gender \
    #   > $tgt_dir/spk2gender || exit 1;  # fails here
    cp -f $locdata/${s}/spk2gender $tgt_dir/spk2gender || exit 1
    utils/validate_data_dir.sh --no-feats $tgt_dir || exit 1;
  done
done
