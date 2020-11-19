#!/bin/bash
#
# take the 111 Emergency Booking tstp files and perform substitutions to generate tst files in the correct location
# then run the tst file
#

tst=$TKWROOT/config/FHIR_111_UEC/autotest_config/tst


if [[ $# == 2 ]]
then
	dest=$1
	tstfile=$2
else
	echo usage $0 '<endpoint_label> <tst filename>'
	exit
fi

# endpoint defaults
toasid=200000000359
fromasid=200000000359
sendtls=No
truststore=NONE
keystore=NONE

# not required for EB since it relates to async but is required for TKW
from_ep=http://127.0.0.1
from_ep_port=4000

#============================================================================================================

date_format=+%Y-%m-%dT00:00:00%:z

today=`date $date_format`
today1=`date $date_format --date='+ 1 days'`
today4=`date $date_format --date='+ 4 days'`
todayl1=`date $date_format --date='- 1 days'`

# read in the endpoint config
if [[ -e endpoint_configs/$dest.sh ]]
then
	. endpoint_configs/$dest.sh
else
	echo "Unrecognised endpoint $dest"
	read -n 1 -p "Press any key to exit..."
	echo
	exit
fi

prefix=`basename $tstfile .tstp`
prefix=$prefix'_'`date +%Y%m%d%H%M%S`

echo Writing transformed $tstfile to $tst/$prefix'.tst'

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
sed -e s!__TKWROOT__!$TKWROOT!g \
	-e s!__FROM_ASID__!$fromasid!g \
	-e s!__TO_ASID__!$toasid!g \
	-e s!__TO_ENDPOINT__!$to_ep!g \
	-e s!__FROM_ENDPOINT__!$from_ep!g \
	-e s!__FROM_ENDPOINT_PORT__!$from_ep_port!g \
	-e s!__TRUSTSTORE__!$truststore!g \
	-e s!__KEYSTORE__!$keystore!g \
	-e s!__SEND_TLS__!$sendtls!g \
	-e s!__TODAY1__!$today1!g \
	-e s!__TODAY4__!$today4!g \
	-e s!__TODAYl1__!$todayl1!g \
	< $tstfile  > $tst/$prefix'.tst'

read -n 1 -p "Press any key to continue..."
echo

# run the tests
./run_tst.sh $tst/$prefix'.tst'

# copy the tst file to the latest autotests folder
latest_autotest_folder=`ls -t auto_tests | head -n 1`
cp $tst/$prefix'.tst' auto_tests/$latest_autotest_folder/
# copy a statically named version for ease of debugging
cp $tst/$prefix'.tst' tst/mergedfile.tst

# if there's a browser configured display the results
if [[ "$TKW_BROWSER" != "" ]]
then
	$TKW_BROWSER auto_tests/$latest_autotest_folder/test_log.html
fi
