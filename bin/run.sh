#!/bin/bash

#export PYSPARK_PYTHON=/opt/anaconda3/bin/python3
#export PYSPARK_DRIVER_PYTHON=/opt/anaconda3/bin/python3
export HDP_VERSION='2.6.4.0-91'
export CONDA_PATH=/opt/anaconda3/bin/conda

BROKER_LIST="c34-node3.squadron-labs.com:6667,c34-node4.squadron-labs.com:6667,c34-node2.squadron-labs.com:6667"
TOPIC="tweets"

export DEPLOY_DIR=../deploy
export SOURCE_PATH=../src

conda list --export > $DEPLOY_DIR/requirements_conda.txt

if [ ! -f $DEPLOY_DIR/model_data.zip ]; then
    zip -R $DEPLOY_DIR/model_data.zip ../keras-yolo3/model_data/*
fi

if [ ! -f $DEPLOY_DIR/yolo3.zip ]; then
    zip -R $DEPLOY_DIR/yolo3.zip ../keras-yolo3/yolo3/*
fi

if [ ! -f $DEPLOY_DIR/font.zip ]; then
    zip -R $DEPLOY_DIR/font.zip ../keras-yolo3/font/*
fi

/usr/hdp/current/spark2-client/bin/spark-submit --master local --deploy-mode client \
--packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.2.0,com.hortonworks:shc-core:1.1.1-2.1-s_2.11 \
--repositories http://repo.hortonworks.com/content/groups/public/ \
--files /etc/spark2/conf/hbase-site.xml \
--conf spark.streaming.kafka.maxRatePerPartition=1 \
--conf spark.pyspark.virtualenv.enabled=true \
--conf spark.pyspark.virtualenv.type=conda \
--conf spark.pyspark.virtualenv.requirements=$DEPLOY_DIR/requirements_conda.txt \
--conf spark.pyspark.virtualenv.bin.path=$CONDA_PATH \
--archives $DEPLOY_DIR/model_data.zip#model_data,$DEPLOY_DIR/font.zip#font \
--py-files yolo3.zip,$SOURCE_PATH/yolo.py,$SOURCE_PATH/twitter.py,$SOURCE_PATH/twitter_secret.py,$SOURCE_PATH/helper.py \
main.py \
$BROKER_LIST $TOPIC
