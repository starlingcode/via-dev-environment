# Copied nearly verbatim from https://github.com/pichenettes/mutable-dev-environment
# See LICENSE for details

#!/usr/bin/env bash

# set -x

# Code is stored in the VM itself
# CODE_ROOT=/home/vagrant

# Code is stored in a directory shared between the VM and the host.
CODE_ROOT=/vagrant
WORKING_DIR_NAME=via_hardware_executables
DEV_ENV="${CODE_ROOT}/${WORKING_DIR_NAME}"
STARLING_REPO="https://github.com/starlingcode/via_hardware_executables.git"

# test if the dev_env directory already exists
if [ -d "$DEV_ENV" ]; then
    echo "WARNING: Working directory ${DEV_ENV} already exists, skipping git clone"
else
    # Clone the modules source code. If there was a alternative git URL
    # provided as an argument to this script, than it will be clone.
    # Otherwise, the default MI repo will be cloned.
    cd $CODE_ROOT
    USER_GITHUB_URL=$1
    if [ $USER_GITHUB_URL ]; then
        # Get from a clone of the custom repo.
        git clone $USER_GITHUB_URL $WORKING_DIR_NAME
        cd $DEV_ENV
        git remote add starlingcode $STARLING_REPO
    else
        # Get from the original repo.
        git clone $STARLING_REPO $WORKING_DIR_NAME
        cd $DEV_ENV
    fi
    git submodule update --init --recursive
fi

# after logging in, cd directly to the code directory
echo "cd $DEV_ENV" >> ~/.bashrc
