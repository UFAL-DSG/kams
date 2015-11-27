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
E_TRI4=$EXP/tri4_nnet2
E_TRI4SMBR=$EXP/tri4_nnet2_smbr
E_TRI5=$EXP/tri5_nnet2_ivector_online
E_TRI5SMBR=$EXP/tri5_nnet2_smbr_ivector_online

T_TRI2B=$TGT/tri2b_mmi_b0.05
T_TRI4=$TGT/tri4_nnet2
T_TRI4SMBR=$TGT/tri4_nnet2_smbr
T_TRI5=$TGT/tri5_nnet2_ivector_online
T_TRI5SMBR=$TGT/tri5_nnet2_smbr_ivector_online

mkdir -p $T_TRI2B
mkdir -p $T_TRI4
mkdir -p $T_TRI4SMBR
mkdir -p $T_TRI5
mkdir -p $T_TRI5SMBR

# Store also the results
cp -f $EXP/results.log $TGT/results.log

##################################################################################################################
echo "--- Exporting models to $T_TRI2B ..."
##################################################################################################################

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
cp -f $mfcc_config $T_TRI2B/conf
cat $E_TRI2B/splice_opts | sed 's/ --/\n--/g' > $T_TRI2B/conf/splice.conf

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

mkdir -p $T_TRI2B/dict
cp -f $WORK/local/dict/{lexicon.txt,silence_phones.txt,optional_silence.txt,nonsilence_phones.txt,extra_questions.txt} $T_TRI2B/dict

##################################################################################################################
echo "--- Exporting models to $T_TRI4 ..."
##################################################################################################################

cp -f $E_TRI4/graph_build2/{HCLG.fst,phones.txt,words.txt} $T_TRI4
cp -f $E_TRI4/final.mdl $T_TRI4
cp -f $E_TRI2B/final.mat $T_TRI4
cp -f $E_TRI4/tree $T_TRI4

cat > $T_TRI4/pykaldi.cfg<<- EOM
--model_type=nnet2
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

mkdir -p $T_TRI4/conf
cp -f $mfcc_config $T_TRI4/conf
cat $E_TRI2B/splice_opts | sed 's/ --/\n--/g' > $T_TRI4/conf/splice.conf

echo -n "--endpoint.silence_phones=" > $T_TRI4/conf/endpoint.conf
cat $E_TRI4/graph_build2/phones/silence.csl >> $T_TRI4/conf/endpoint.conf

cat > $T_TRI4/conf/decoder.conf<<- EOM
--max-active=2000
--min-active=200
--beam=12.0
--lattice-beam=5.0
EOM

cat > $T_TRI4/conf/decodable.conf<<- EOM
--acoustic-scale=0.1
EOM

mkdir -p $T_TRI4/dict
cp -f $WORK/local/dict/{lexicon.txt,silence_phones.txt,optional_silence.txt,nonsilence_phones.txt,extra_questions.txt} $T_TRI4/dict

##################################################################################################################
echo "--- Exporting models to $T_TRI4SMBR ..."
##################################################################################################################

cp -f $E_TRI4/graph_build2/{HCLG.fst,phones.txt,words.txt} $T_TRI4SMBR
cp -f $E_TRI4SMBR/final.mdl $T_TRI4SMBR
cp -f $E_TRI2B/final.mat $T_TRI4SMBR
cp -f $E_TRI4SMBR/tree $T_TRI4SMBR

cat > $T_TRI4SMBR/pykaldi.cfg<<- EOM
--model_type=nnet2
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

mkdir -p $T_TRI4SMBR/conf
cp -f $mfcc_config $T_TRI4SMBR/conf
cat $E_TRI2B/splice_opts | sed 's/ --/\n--/g' > $T_TRI4SMBR/conf/splice.conf

echo -n "--endpoint.silence_phones=" > $T_TRI4SMBR/conf/endpoint.conf
cat $E_TRI4SMBR/graph_build2/phones/silence.csl >> $T_TRI4SMBR/conf/endpoint.conf

cat > $T_TRI4SMBR/conf/decoder.conf<<- EOM
--max-active=2000
--min-active=200
--beam=12.0
--lattice-beam=5.0
EOM

cat > $T_TRI4SMBR/conf/decodable.conf<<- EOM
--acoustic-scale=0.1
EOM

mkdir -p $T_TRI4SMBR/dict
cp -f $WORK/local/dict/{lexicon.txt,silence_phones.txt,optional_silence.txt,nonsilence_phones.txt,extra_questions.txt} $T_TRI4SMBR/dict

##################################################################################################################
echo "--- Exporting models to $T_TRI5 ..."
##################################################################################################################

cp -f $EXP/tri4_nnet2/graph_build2/{HCLG.fst,phones.txt,words.txt} $T_TRI5
cp -f $E_TRI5/final.mdl $T_TRI5
cp -f $E_TRI2B/final.mat $T_TRI5
cp -f $E_TRI5/tree $T_TRI5
cp -fr $E_TRI5/ivector_extractor $T_TRI5
cat $E_TRI5/ivector_extractor/splice_opts | sed 's/ --/\n--/g' > $T_TRI5/ivector_extractor/splice_opts

cat > $T_TRI5/pykaldi.cfg<<- EOM
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

cp -fr $E_TRI5/conf $T_TRI5
cp -f $mfcc_config $T_TRI5/conf
cat $E_TRI2B/splice_opts | sed 's/ --/\n--/g' > $T_TRI5/conf/splice.conf

cat > $T_TRI5/conf/ivector_extractor.conf<<- EOM
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

echo -n "--endpoint.silence_phones=" > $T_TRI5/conf/endpoint.conf
cat $E_TRI4/graph_build2/phones/silence.csl >> $T_TRI5/conf/endpoint.conf


cat > $T_TRI5/conf/decoder.conf<<- EOM
--max-active=2000
--min-active=200
--beam=12.0
--lattice-beam=5.0
EOM

cat > $T_TRI5/conf/decodable.conf<<- EOM
--acoustic-scale=0.1
EOM

mkdir -p $T_TRI5/dict
cp -f $WORK/local/dict/{lexicon.txt,silence_phones.txt,optional_silence.txt,nonsilence_phones.txt,extra_questions.txt} $T_TRI5/dict

##################################################################################################################
echo "--- Exporting models to $T_TRI5SMBR ..."
##################################################################################################################

cp -f $EXP/tri4_nnet2/graph_build2/{HCLG.fst,phones.txt,words.txt} $T_TRI5SMBR
cp -f $E_TRI5SMBR/final.mdl $T_TRI5SMBR
cp -f $E_TRI2B/final.mat $T_TRI5SMBR
cp -f $E_TRI5SMBR/tree $T_TRI5SMBR
cp -fr $E_TRI5SMBR/ivector_extractor $T_TRI5SMBR
cat $E_TRI5SMBR/ivector_extractor/splice_opts | sed 's/ --/\n--/g' > $T_TRI5SMBR/ivector_extractor/splice_opts

cat > $T_TRI5SMBR/pykaldi.cfg<<- EOM
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

cp -fr $E_TRI5/conf $T_TRI5SMBR
cp -f $mfcc_config $T_TRI5SMBR/conf
cat $E_TRI2B/splice_opts | sed 's/ --/\n--/g' > $T_TRI5SMBR/conf/splice.conf

cat > $T_TRI5SMBR/conf/ivector_extractor.conf<<- EOM
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

echo -n "--endpoint.silence_phones=" > $T_TRI5SMBR/conf/endpoint.conf
cat $E_TRI4/graph_build2/phones/silence.csl >> $T_TRI5SMBR/conf/endpoint.conf


cat > $T_TRI5SMBR/conf/decoder.conf<<- EOM
--max-active=2000
--min-active=200
--beam=12.0
--lattice-beam=5.0
EOM

cat > $T_TRI5SMBR/conf/decodable.conf<<- EOM
--acoustic-scale=0.1
EOM

mkdir -p $T_TRI5SMBR/dict
cp -f $WORK/local/dict/{lexicon.txt,silence_phones.txt,optional_silence.txt,nonsilence_phones.txt,extra_questions.txt} $T_TRI5SMBR/dict
