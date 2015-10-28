#!/bin/bash
set -e
this_path=$(cd `dirname $0`; pwd)
if [ -z "$this_path" ] || [ ! -d "$this_path" ] ; then echo "Failed $0"; exit 1; fi

vocab_full=$1; shift
transcription=$1; shift

perl this_path/phonetic_transcription_dummy.pl $vocab_full $transcription

