#!/bin/bash
DT=`date +%Y%m%d`
#Update the docker ignore sim link
ln -fs .dockerignore.simulator .dockerignore
#Build the docker image
docker build -f Dockerfile.simulator -t 111_uec_booking_conf .
#Tag the docker image with today's date
docker tag 111_uec_booking_conf nhsdigitalmait/111_uec_booking_config:$DT
