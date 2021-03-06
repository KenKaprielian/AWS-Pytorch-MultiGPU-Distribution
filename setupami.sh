#!/bin/bash

cd /home/ec2-user/anaconda3/bin
source activate pytorch_latest_p36

cd /opt
mkdir nn
cd nn
git clone https://github.com/peci1/nvidia-htop
cd nvidia-htop
pip3 install .
cd /opt
git clone https://github.com/KenKaprielian/AWS-EMR-Pytorch-MultiGPU-Distribution.git

cd AWS-EMR-Pytorch-MultiGPU-Distribution

aws s3 cp s3://kens3bucketmm/deeplearning/data.zip data.zip
unzip data.zip # unzip the ant and bee pictures

nvidia-smi daemon -d 1 # start the nvidia-smi log daemo with a 1 second interval

python3 pytorch.py # start training

nvidia-smi daemon -t # stop the nvidia-smi log daemon

zip -r nvidia-smi-logs.zip /var/log/nvstats/  # zip smi the logs up
zip -r gpu-logs.zip /opt/AWS-EMR-Pytorch-MultiGPU-Distribution/gpulog*  # zip the h top gpu logs up
aws s3 cp  nvidia-smi-logs.zip s3://kens3bucketmm/deeplearning/nvidia-smi-logs.zip # send the logs to S3 for safekeeping, as this instance will be terminated
aws s3 cp  gpu-logs.zip s3://kens3bucketmm/deeplearning/gpu-logs.zip
