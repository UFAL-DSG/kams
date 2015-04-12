#!/bin/bash
# Copyright Ondrej Platek Apache 2.0
set -e
renice 20 $$

# Source standard settings
. ./local/setting.sh

local/check_path.sh

# Set paths 
. ./path.sh

# If you have cluster of machines running GridEngine you may want to
# change the train and decode commands in the file below
. ./cmd.sh

# Load training parameters (passed as a script)
if [[ ! -z "$1" ]] ; then
  . $1
else
  echo "You mush specify a parameter file, e.g. train.sh LANG_COND_params.sh"
fi

local/train_base.sh
