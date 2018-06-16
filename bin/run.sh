#!/bin/bash

source set-env.sh

#export PYSPARK_PYTHON=/opt/anaconda3/bin/python3
#export PYSPARK_DRIVER_PYTHON=/opt/anaconda3/bin/python3
export HDP_VERSION='2.6.4.0-91'
export CONDA_PATH=/opt/anaconda3/bin/conda

BROKER_LIST="c34-node3.squadron-labs.com:6667,c34-node4.squadron-labs.com:6667,c34-node2.squadron-labs.com:6667"
TOPIC="tweets"

export DEPLOY_DIR=$BASE_DIR/deploy
export SOURCE_PATH=$BASE_DIR/src

if [ ! -d $DEPLOY_DIR ]; then
  mkdir -p $DEPLOY_DIR
fi

conda list --export > $DEPLOY_DIR/requirements_conda.txt

if [ ! -f $DEPLOY_DIR/model_data.zip ]; then
    zip -r -j $DEPLOY_DIR/model_data.zip $BASE_DIR/keras-yolo3/model_data/*
fi

if [ ! -f $DEPLOY_DIR/yolo3.zip ]; then
    cd $BASE_DIR/keras-yolo3
    zip -r $DEPLOY_DIR/yolo3.zip yolo3/*
fi

if [ ! -f $DEPLOY_DIR/font.zip ]; then
    zip -r -j $DEPLOY_DIR/font.zip $BASE_DIR/keras-yolo3/font/*
fi

# Copy new source code to deploy dir
cp -rf $SOURCE_PATH/* $DEPLOY_DIR/
cp -rf $BASE_DIR/keras-yolo3/model_data $DEPLOY_DIR/
cp -rf $BASE_DIR/keras-yolo3/font $DEPLOY_DIR/



cd $DEPLOY_DIR
export HADOOP_CONF_DIR=/etc/spark-hadoop/conf

/usr/hdp/current/spark2-client/bin/spark-submit --master yarn --deploy-mode client \
--executor-memory 4G --driver-memory 1G \
--packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.2.0,com.hortonworks:shc-core:1.1.1-2.1-s_2.11 \
--repositories http://repo.hortonworks.com/content/groups/public/ \
--files /etc/spark2/conf/hbase-site.xml \
--conf spark.streaming.kafka.maxRatePerPartition=1 \
--conf spark.pyspark.virtualenv.enabled=true \
--conf spark.pyspark.virtualenv.type=conda \
--conf spark.pyspark.virtualenv.requirements=requirements_conda.txt \
--conf spark.pyspark.virtualenv.bin.path=$CONDA_PATH \
--archives model_data.zip#model_data,font.zip#font \
--py-files yolo3.zip,yolo.py,twitter.py,twitter_secret.py,helper.py \
main.py \
$BROKER_LIST $TOPIC

