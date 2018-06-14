#!/bin/bash

# clone keras-yolo3
git clone https://github.com/qqwweee/keras-yolo3 ../keras-yolo3

cd ../keras-yolo3

# Download weights
wget https://pjreddie.com/media/files/yolov3.weights

# train model
python convert.py yolov3.cfg yolov3.weights model_data/yolo.h5
