#!/bin/bash
set -e
this_local_dir=$(cd `dirname $0` && pwd)

vocab_full=$1; shift
transcription=$1; shift


perl $this_local_dir/phonetic_transcription_dummy.pl $vocab_full $transcription

