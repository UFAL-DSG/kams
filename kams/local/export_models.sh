#!/bin/bash

# Copyright (c) 2013, Ondrej Platek, Ufal MFF UK <oplatek@ufal.mff.cuni.cz>
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

tgt=$1; shift
exp=$1; shift
work=$1; shift

tgt=${tgt}-`date -u +"%Y-%m-%d--%H-%M-%S"`

mkdir -p $tgt

echo "--- Exporting models to $tgt ..."

# Store also the results
cp -f $exp/results.log $tgt/results.log

cp -f common/mfcc.conf $tgt 

cp -f $exp/tri2b/final.mdl $tgt/tri2b.mdl
cp -f $exp/tri2b/tree $tgt/tri2b.tree
cp -f $exp/tri2b/final.mat $tgt/tri2b.mat
cp -f $exp/tri2b/graph_build2/HCLG.fst $tgt/HCLG_trib2b_bmmi.fst

cp -f $exp/tri2b_mmi_b*[0-9]/final.mdl $tgt/tri2b_bmmi.mdl
cp -f $exp/tri2b/tree $tgt/tri2b_bmmi.tree
cp -f $exp/tri2b_mmi_b*[0-9]/final.mat $tgt/tri2b_bmmi.mat


cp -f $work/local/dict/{lexicon.txt,silence_phones.txt,optional_silence.txt,extra_questions.txt} $tgt
cp -f $work/lang/phones.txt $work/lang/phones/silence.csl $tgt
