#!/bin/bash
# build docker image for emergency booking consumer simulator
TAG=0.4

if [[ "$1" == "" ]]
then
	USER_ID=1000
else
	USER_ID=$1
	TAG+=-$USER_ID
fi

if [[ ! -e TKWAutotestManager.jar ]]
then
	cp $TKWROOT/TKWAutotestManager.jar .
fi

if [[ ! -e TKWPropertiesEditor.jar ]]
then
	cp $TKWROOT/lib/TKWPropertiesEditor.jar .
fi

#Update the docker ignore sim link
ln -fs .dockerignore.consumer.simulator .dockerignore
#Build the docker image
docker build --build-arg USER_ID=$USER_ID -f Dockerfile.consumer.simulator $1 -t nhsdigitalmait/tkw_uec_consumer_simulator:$TAG .
echo Docker Image tagged with $TAG
