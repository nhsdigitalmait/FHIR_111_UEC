#!/bin/bash
#The argument is to label the container. If non is given then a date will be used
label=$1
if [ $# -eq 0 ]
  then
    echo "No arguments supplied - date will be used for label"
	label=`date +%Y%m%d`
fi
#Update the docker ignore sim link
ln -fs .dockerignore.simulator .dockerignore
#Build the docker image
docker build -f Dockerfile.simulator -t tkw_uec_provider_simulator .
#Tag the docker image with today's date
docker tag tkw_uec_provider_simulator nhsdigitalmait/tkw_uec_provider_simulator:$label
