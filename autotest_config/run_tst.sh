#!/bin/bash
#
# run tst tests
# usage $0 <tstfile>+
#
#OPTIONS=-Djavax.net.debug=all
# need more heap space
OPTIONS=-Xmx2048m

for f in $*
do
	echo $f
	$JAVA_HOME/bin/java $OPTIONS -jar $TKWROOT/TKW-x.jar -autotest $TKWROOT/config/FHIR_111_UEC/autotest_config/tkw-x-autotest.properties $f
done
