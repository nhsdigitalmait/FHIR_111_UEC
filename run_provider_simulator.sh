#!/bin/bash
#
#
if [[ "$1" == "--version" ]]
then
	java -jar $TKWROOT/TKW-x.jar -version | grep -v "starting on"
	if [[ -e $TKWROOT/config/FHIR_111_UEC/version_string.txt ]]
	then
		cat $TKWROOT/config/FHIR_111_UEC/version_string.txt
	fi
	exit 0
else
	docker-compose -f docker-compose_provider_simulator.yml up -d
fi
