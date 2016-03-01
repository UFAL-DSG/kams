#!/bin/bash
# Copyright Ondrej Platek Apache 2.0
#           Filip Jurcicek Apache 2.0

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
err_msg="You must specify a parameter file, e.g. train.sh LANG_COND_params.sh as argument."
if [ $# -lt 1 ] ; then
  echo "$err_msg"
fi

echo

for settings in "$@" ; do
  if [[ -f "$settings" ]] ; then
    echo Loading settings: $settings; echo
    . $settings
  else
    echo Error for file: $settings
    echo $err_msg
    exit 1
  fi
done

local/train_base_ms.sh
