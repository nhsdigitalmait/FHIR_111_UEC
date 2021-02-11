#!/bin/bash
#
#
if [[ "$1" == "--version" ]]
then
	if [[ -e $TKWROOT/config/FHIR_111_UEC/version_string.txt ]]
	then
		cat $TKWROOT/config/FHIR_111_UEC/version_string.txt
	fi
	java -jar $TKWROOT/TKW-x.jar -version | grep -v "starting on"
	exit 0
else
	if [[ "$1" == "-d" ]]
	then
	docker-compose -f docker-compose_provider_simulator.yml up -d
	else
		docker-compose -f docker-compose_provider_simulator.yml up
	fi
fi
