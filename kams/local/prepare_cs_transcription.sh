#!/bin/bash
set -e
this_local_dir=$(cd `dirname $0` && pwd)
if [ -z "$this_local_dir" ] || [ ! -d "$this_local_dir" ] ; then echo "Failed $0"; exit 1; fi

vocab_full=$1; shift
transcription=$1; shift


perl $this_local_dir/phonetic_transcription_cs.pl $vocab_full $transcription
