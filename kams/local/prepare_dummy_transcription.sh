#!/bin/bash
set -e

vocab_full=$1; shift
transcription=$1; shift


perl local/phonetic_transcription_dummy.pl $vocab_full $transcription

