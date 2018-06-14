#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$(dirname $CURRENT_DIR)"

AUX_PATH=/opt/anaconda3/bin

if [ ! -f $HOME_DIR/conda_virutal_env ]; then
  export VIRTUAL_ENV_PATH=$HOME_DIR/conda_virutal_env

  source activate $VIRTUAL_ENV_PATH

  AUX_PATH=$VIRTUAL_ENV_PATH/bin  
fi

export PATH=$AUX_PATH:$PATH
