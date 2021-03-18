#/bin/bash
configDirectory=$PWD
if [ -z "$1" ]
  then
	echo "No config directory supplied. Assuming '" $configDirectory "' as config directory."
  else
    configDirectory=$1
fi

# Update all instances of local dir with docker image directories for all config/contrib entries
sed -i -e 's|TKW_ROOT/|/home/service/TKW/|g' ${configDirectory}/tkw-x_provider_simulator.properties

# Update all output directories with docker image volume directories
sed -i -e "/^tks.evidencemetadata.location/c\tks.evidencemetadata.location /home/service/data/all_evidence" ${configDirectory}/tkw-x_provider_simulator.properties
sed -i -e "/^tks.validator.reports/c\tks.validator.reports /home/service/data/all_evidence" ${configDirectory}/tkw-x_provider_simulator.properties
sed -i -e "/^tks.logdir/c\tks.logdir /home/service/data/logs" ${configDirectory}/tkw-x_provider_simulator.properties
sed -i -e "/^tks.savedmessages/c\tks.savedmessages /home/service/data/all_evidence" ${configDirectory}/tkw-x_provider_simulator.properties

# Update FHIR profile directory with docker image volume directories (This should be done in a more programatic fasion with a loop - run out of time :-)) 
#sed -i -e "/^tks.validator.hapifhirvalidator.assetdir.ignore/c\tks.validator.hapifhirvalidator.assetdir.ignore /home/service/fhir/examples/" ${configDirectory}/tkw-x_provider_simulator.properties
#sed -i -e "/^tks.validator.hapifhirvalidator.assetdir /c\tks.validator.hapifhirvalidator.assetdir /home/service/fhir" ${configDirectory}/tkw-x_provider_simulator.properties
#sed -i -e "/^tks.validator.hapifhirvalidator.profileversionfilelocation/c\tks.validator.hapifhirvalidator.profileversionfilelocation /home/service/fhir/package.json" ${configDirectory}/tkw-x_provider_simulator.properties

# Update Simulator ruleset with docker image directories
sed -i -e 's|TKW_ROOT/|/home/service/TKW/|g' ${configDirectory}/simulator_config/test_tks_rule_config.txt
# Update Validator ruleset with docker image directories
sed -i -e 's|TKW_ROOT/|/home/service/TKW/|g' ${configDirectory}/validator_config/validator_provider_simulator.conf

