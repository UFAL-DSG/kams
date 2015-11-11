#!/bin/bash
# Copyright (c) 2013, Ondrej Platek, Ufal MFF UK <oplatek@ufal.mff.cuni.cz>
# Copyright (c) 2015, Filip Jurcicek, Ufal MFF UK <Jurcicek@ufal.mff.cuni.cz>
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

TGT=$1; shift
WORK=$1; shift

EXP=$WORK/exp

TGT=${TGT}-`date -u +"%Y-%m-%d--%H-%M-%S"`

mkdir -p $TGT

E_TRI2B=$EXP/tri2b_mmi_b0.05
E_NNET2=$EXP/tri4_nnet2_online
E_NNET2SMBR=$EXP/tri4_nnet2_smbr_online

T_TRI2B=$TGT/tri2b_mmi_b0.05
T_NNET2=$TGT/tri4_nnet2_online
T_NNET2SMBR=$TGT/tri4_nnet2_smbr_online

mkdir -p $T_TRI2B
mkdir -p $T_NNET2
mkdir -p $T_NNET2SMBR

# Store also the results
cp -f $EXP/results.log $TGT/results.log


##################################################################################################################
echo "--- Exporting models to $T_TRI2B ..."
##################################################################################################################

cp -f $WORK/local/dict/lexicon.txt $T_TRI2B
cp -f $EXP/tri2b/graph_build2/{HCLG.fst,phones.txt,words.txt} $T_TRI2B
cp -f $E_TRI2B/final.mdl $T_TRI2B
cp -f $E_TRI2B/final.mat $T_TRI2B
cp -f $E_TRI2B/tree $T_TRI2B

cat > $T_TRI2B/pykaldi.cfg<<- EOM
--model_type=gmm
--model=final.mdl
--hclg=HCLG.fst
--words=words.txt
--mat_lda=final.mat
--use_ivectors=false
--cfg_mfcc=conf/mfcc.conf
--cfg_splice=conf/splice.conf
--cfg_decoder=conf/decoder.conf
--cfg_decodable=conf/decodable.conf
--cfg_endpoint=conf/endpoint.conf
EOM

mkdir -p $T_TRI2B/conf
cp -f common/mfcc.conf $T_TRI2B/conf
cp -f $E_TRI2B/splice_opts  $T_TRI2B/conf/splice.conf

echo -n "--endpoint.silence_phones=" > $T_TRI2B/conf/endpoint.conf
cat $EXP/tri2b/graph_build2/phones/silence.csl >> $T_TRI2B/conf/endpoint.conf


cat > $T_TRI2B/conf/decoder.conf<<- EOM
--max-active=2000
--min-active=200
--beam=12.0
--lattice-beam=5.0
EOM

cat > $T_TRI2B/conf/decodable.conf<<- EOM
--acoustic-scale=0.1
EOM

##################################################################################################################
echo "--- Exporting models to $T_NNET2 ..."
##################################################################################################################

rm -fr $T_NNET2/conf
rm -fr $T_NNET2/ivector_extractor

cp -f $WORK/local/dict/lexicon.txt $T_NNET2
cp -f $EXP/tri4_nnet2/graph_build2/{HCLG.fst,phones.txt,words.txt} $T_NNET2
cp -f $E_NNET2/final.mdl $T_NNET2
cp -f $E_NNET2/tree $T_NNET2
cp -fr $E_NNET2/ivector_extractor $T_NNET2

cat > $T_NNET2/pykaldi.cfg<<- EOM
--model_type=nnet2
--model=final.mdl
--hclg=HCLG.fst
--words=words.txt
--mat_lda=final.mat
--use_ivectors=true
--cfg_mfcc=conf/mfcc.conf
--cfg_ivector=conf/ivector_extractor.conf
--cfg_splice=conf/splice.conf
--cfg_decoder=conf/decoder.conf
--cfg_decodable=conf/decodable.conf
--cfg_endpoint=conf/endpoint.conf
EOM

cp -fr $E_NNET2/conf $T_NNET2

cat > $T_NNET2/conf/ivector_extractor.conf<<- EOM
--splice-config=ivector_extractor/splice_opts
--cmvn-config=ivector_extractor/online_cmvn.conf
--lda-matrix=ivector_extractor/final.mat
--global-cmvn-stats=ivector_extractor/global_cmvn.stats
--diag-ubm=ivector_extractor/final.dubm
--ivector-extractor=ivector_extractor/final.ie
--num-gselect=5
--min-post=0.025
--posterior-scale=0.1
--max-remembered-frames=1000
--max-count=100
EOM

echo -n "--endpoint.silence_phones=" > $T_NNET2/conf/endpoint.conf
cat $EXP/tri4_nnet2/graph_build2/phones/silence.csl >> $T_NNET2/conf/endpoint.conf


cat > $T_NNET2/conf/decoder.conf<<- EOM
--max-active=2000
--min-active=200
--beam=12.0
--lattice-beam=5.0
EOM

cat > $T_NNET2/conf/decodable.conf<<- EOM
--acoustic-scale=0.1
EOM

##################################################################################################################
echo "--- Exporting models to $T_NNET2SMBR ..."
##################################################################################################################

rm -fr $T_NNET2SMBR/conf
rm -fr $T_NNET2SMBR/ivector_extractor

cp -f $WORK/local/dict/lexicon.txt $T_NNET2SMBR
cp -f $EXP/tri4_nnet2/graph_build2/{HCLG.fst,phones.txt,words.txt} $T_NNET2SMBR
cp -f $E_NNET2SMBR/final.mdl $T_NNET2SMBR
cp -f $E_NNET2SMBR/tree $T_NNET2SMBR
cp -fr $E_NNET2SMBR/ivector_extractor $T_NNET2SMBR


cat > $T_NNET2SMBR/pykaldi.cfg<<- EOM
--model_type=nnet2
--model=final.mdl
--hclg=HCLG.fst
--words=words.txt
--mat_lda=final.mat
--use_ivectors=true
--cfg_mfcc=conf/mfcc.conf
--cfg_ivector=conf/ivector_extractor.conf
--cfg_splice=conf/splice.conf
--cfg_decoder=conf/decoder.conf
--cfg_decodable=conf/decodable.conf
--cfg_endpoint=conf/endpoint.conf
EOM

cp -fr $E_NNET2/conf $T_NNET2SMBR

cat > $T_NNET2SMBR/conf/ivector_extractor.conf<<- EOM
--splice-config=ivector_extractor/splice_opts
--cmvn-config=ivector_extractor/online_cmvn.conf
--lda-matrix=ivector_extractor/final.mat
--global-cmvn-stats=ivector_extractor/global_cmvn.stats
--diag-ubm=ivector_extractor/final.dubm
--ivector-extractor=ivector_extractor/final.ie
--num-gselect=5
--min-post=0.025
--posterior-scale=0.1
--max-remembered-frames=1000
--max-count=100
EOM

echo -n "--endpoint.silence_phones=" > $T_NNET2SMBR/conf/endpoint.conf
cat $EXP/tri4_nnet2/graph_build2/phones/silence.csl >> $T_NNET2SMBR/conf/endpoint.conf


cat > $T_NNET2SMBR/conf/decoder.conf<<- EOM
--max-active=2000
--min-active=200
--beam=12.0
--lattice-beam=5.0
EOM

cat > $T_NNET2SMBR/conf/decodable.conf<<- EOM
--acoustic-scale=0.1
EOM
