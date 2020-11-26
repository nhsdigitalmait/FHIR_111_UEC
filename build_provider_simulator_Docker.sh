#!/bin/bash
DT=`date +%Y%m%d`
#Update the docker ignore sim link
ln -fs .dockerignore.simulator .dockerignore
#Build the docker image
docker build -f Dockerfile.simulator -t tkw_uec_provider_simulator .
#Tag the docker image with today's date
docker tag tkw_uec_provider_simulator nhsdigitalmait/tkw_uec_provider_simulator:$DT
