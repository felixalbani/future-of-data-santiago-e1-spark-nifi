#!/bin/bash

source set-env.sh

conda create --prefix ../conda_virutal_env python=3.6

source activate ../conda_virutal_env

echo "Installing dependecies"

conda install -y tensorflow

conda install -y opencv
#conda install cv2
conda install -y keras

conda install -y requests
conda install -y pillow
conda install -y matplotlib

conda install -y configparser

conda config --append channels conda-forge
conda install -y -c conda-forge tweepy

# if you run into AttributeError: module 'tensorflow.python.ops.nn' has no attribute 'leaky_relu'
#
# pip install --ignore-installed --upgrade  https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-1.8.0-py3-none-any.whl
#
