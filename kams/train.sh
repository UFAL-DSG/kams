#!/bin/bash
# Copyright Ondrej Platek Apache 2.0
set -e
renice 20 $$

# Load training parameters (passed as a script)
. $1

# Source standard settings
. ./local/setting.sh

local/check_path.sh

# Set paths 
. ./path.sh

# If you have cluster of machines running GridEngine you may want to
# change the train and decode commands in the file below
. ./cmd.sh

local/train_base.sh
