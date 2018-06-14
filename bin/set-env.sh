#!/bin/bash

export PATH=/opt/anaconda3/bin:$PATH

if [ ! -f ../conda_virutal_env ]; then
  export VIRTUAL_ENV_PATH=../conda_virutal_env

  source activate $VIRTUAL_ENV_PATH
fi
