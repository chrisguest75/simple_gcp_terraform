#!/bin/bash
apt-get update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
docker network create --driver bridge esp_net
docker run --detach --name=echo --net=esp_net gcr.io/google-samples/echo-python:1.0
docker run  --name=esp  --detach  --publish=80:8080 --net=esp_net gcr.io/endpoints-release/endpoints-runtime:1  --service=${service_name} --rollout_strategy=managed  --backend=echo:8080

