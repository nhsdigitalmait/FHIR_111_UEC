#!/bin/bash
# build docker image for emergency booking consumer simulator
# usage build_consumer_simulator_Docker.sh [<userid>]
# if no user id is provided it defaults to 1000 and the tag is just the version number
#
TAG=0.4

if [[ "$1" == "" ]]
then
	USER_ID=1000
else
	USER_ID=$1
	TAG+=-$USER_ID
fi

IMAGENAME=tkw_uec_consumer_simulator
PROJECT=FHIR_111_UEC

echo "Building $IMAGENAME:$TAG"
read -n 1 -p "Press any key to continue..."
echo building

# the source folder must be in uninstall mode (TKW_ROOTs) not install mode (with real paths)
cd $TKWROOT/config/$PROJECT
fixtkwroot.sh -u .
cd -

if [[ ! -e TKWAutotestManager.jar ]]
then
	cp $TKWROOT/TKWAutotestManager.jar .
fi

if [[ ! -e TKWPropertiesEditor.jar ]]
then
	cp $TKWROOT/lib/TKWPropertiesEditor.jar .
fi

echo "111 UEC Booking Consumer Simulator Version: $TAG"  > version_string.txt
# put the git commit hash and date into a text file
git show -s --format="$PROJECT %h %cI" >> version_string.txt

#Update the docker ignore sim link
ln -fs .dockerignore.consumer.simulator .dockerignore
#Build the docker image
docker build --build-arg USER_ID=$USER_ID -f Dockerfile.consumer.simulator -t nhsdigitalmait/$IMAGENAME:$TAG .
echo Docker Image tagged with $TAG
