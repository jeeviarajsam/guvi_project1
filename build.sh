#!/bin/bash
#scripting for installing docker and docker image build
apt-get update && apt install docker.io -y
docker --version
#read -p "Enter the version of docker image:" option
docker build -t jeeviarajsam/reactapp_dev:v1 .
docker images

