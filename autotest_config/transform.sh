#!/bin/bash
#
# take the 111 Emergency Booking tstp files and perform substitutions to generate tst files in the correct location
# then run the tst file
#
#   usage $0 <endpoint_label> <tst filename>
#

from_ep=http://127.0.0.1
tst=$TKWROOT/config/FHIR_111_UEC/autotest_config/tst


if [[ "$1" != "" ]]
then
	dest=$1
else
	#dest=int
	#dest=answer
	dest=local
	#dest=ingleborough
fi

sendtls=No

# Answer Demonstrator and default
truststore=$tst/amazon.jks
# not really a keystore but not used anyway
keystore=$tst/amazon.jks

# ingleborough
toasid=200000000375
# whernside
fromasid=200000000376

from_ep_port=4000

date_format=+%Y-%m-%dT%H:%M:%S%:z
today=`date $date_format`
today1=`date $date_format --date='+ 1 days'`
today4=`date $date_format --date='+ 4 days'`
todayl1=`date $date_format --date='- 1 days'`

case $dest in
	int)
	# to int
	to_ep=https://proxy.int.spine2.ncrs.nhs.uk

	truststore=$HOME/Documents/SSP/whernside/SSP_whernside_20170719/certs/trust.jks
	keystore=$HOME/Documents/certs/INT_Certs/whernside_ssp/rhm-whernside.cfh-nic.nhs.uk.jks

	sendtls=Yes
	;;

	ingleborough)
	# direct to ingleborough
	to_ep=https://rhm-ingleborough.cfh-nic.nhs.uk

	truststore=$HOME/Documents/SSP/whernside/SSP_whernside_20170719/certs/trust.jks
	keystore=$HOME/Documents/certs/INT_Certs/whernside_ssp/rhm-whernside.cfh-nic.nhs.uk.jks

	sendtls=Yes
	;;

	local)
	# to local 
	toasid=200000000359
	fromasid=200000000359
	to_ep=http://127.0.0.1/A20047/STU3/1/appointments
	;;

	xkcd)
	# to xkcd 
	toasid=200000000359
	fromasid=200000000359
	to_ep=http://xkcd:19191
	;;

	xkcd_secure)
	# to xkcd
	toasid=200000000359
	fromasid=200000000359
	to_ep=https://xkcd:19192
	truststore=$HOME/Documents/OpenTest/OpenTestCerts_3/opentest.jks
	keystore=$HOME/Documents/OpenTest/OpenTestCerts_3/vpn-client-1003.opentest.hscic.gov.uk.jks
	sendtls=Yes
	;;

	*)
	echo "Unrecongnised endpoint $1"
	read -n 1 -p "Press any key to exit..."
	echo
	exit
	;;

esac


for f in $2
do
	prefix=`basename $f .tstp`
	prefix=$prefix'_'`date +%Y%m%d%H%M%S`

	echo Writing transformed $f to $tst/$prefix'.tst'

# __TO_URL__ is the whole thing in normal tstp files but it excludes the context path here
# __FROM_URL__ excludes the context path


#	sed -e s!$TKWROOT!__TKWROOT__!g \
#	    -e s!$to_ep!__TO_ENDPOINT__!g \
#	    -e s!$from_ep!__FROM_ENDPOINT__!g \
#	    -e s!$from_ep_port!__FROM_ENDPOINT_PORT__!g \
#	    -e s!$truststore!__TRUSTSTORE__!g \
#	    -e s!$keystore!__KEYSTORE__!g \
#	    -e s!$sendtls!__SEND_TLS__!g \
#	    -e s!$fromasid!__FROM_ASID__!g \
#	    -e s!$toasid!__TO_ASID__!g \
#		< $f  > $tst/$prefix".tst"

# these need preserving they are handled by substitution tags
#	    -e s!__FROM_ASID__!$fromasid!g \
#	    -e s!__TO_ASID__!$toasid!g \
	sed -e s!__TKWROOT__!$TKWROOT!g \
	    -e s!__TO_ENDPOINT__!$to_ep!g \
	    -e s!__FROM_ENDPOINT__!$from_ep!g \
	    -e s!__FROM_ENDPOINT_PORT__!$from_ep_port!g \
	    -e s!__TRUSTSTORE__!$truststore!g \
	    -e s!__KEYSTORE__!$keystore!g \
	    -e s!__SEND_TLS__!$sendtls!g \
	    -e s!__TODAY1__!$today1!g \
	    -e s!__TODAY4__!$today4!g \
	    -e s!__TODAYl1__!$todayl1!g \
		< $f  > $tst/$prefix'.tst'

	read -n 1 -p "Press any key to continue..."
	echo

	./run_tst.sh $tst/$prefix'.tst'

	# copy the tst file to the latest autotests folder
	latest_autotest_folder=`ls -t auto_tests | head -n 1`
	cp $tst/$prefix'.tst' auto_tests/$latest_autotest_folder/
done

