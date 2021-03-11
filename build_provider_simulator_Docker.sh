#!/bin/bash
# build docker image for emergency booking consumer simulator
# usage build_provider_simulator_Docker.sh [<userid>]
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

IMAGENAME=tkw_uec_provider_simulator
PROJECT=FHIR_111_UEC

echo "Building $IMAGENAME:$TAG"
read -n 1 -p "Press any key to continue..."
echo building

# the source folder must be in install mode (with real paths) not uninistall mode (TKW_ROOT)
cd $TKWROOT/config/$PROJECT
fixtkwroot.sh -u .
cd -

# put the git commit hash and date into a text file
echo "111 UEC Booking Provider Simulator Version: $TAG"  > version_string.txt
echo "111 UEC Booking Github repository shortcode:" `git show -s --format="$PROJECT %h %cI"` >> version_string.txt


#Update the docker ignore sim link
ln -fs .dockerignore.provider.simulator .dockerignore
#Build the docker image
docker build --build-arg USER_ID=$USER_ID -f Dockerfile.provider.simulator -t nhsdigitalmait/$IMAGENAME:$TAG .
echo Docker Image tagged with $TAG
