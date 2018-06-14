#!/bin/bash

source set-env.sh

# clone keras-yolo3
git clone https://github.com/qqwweee/keras-yolo3 $BASE_DIR/keras-yolo3

cd $BASE_DIR/keras-yolo3

if [ ! -f yolov3.weights ]; then
  # Download weights
  wget https://pjreddie.com/media/files/yolov3.weights
fi

# train model
python convert.py yolov3.cfg yolov3.weights model_data/yolo.h5
