#!/bin/bash
#
# take the 111 Emergency Booking tstp files and perform substitutions to generate tst files in the correct location
# then run the tst file
#

autotest=$TKWROOT/config/FHIR_111_UEC/autotest_config
tst=$autotest/tst


if [[ $# == 2 ]]
then
	dest_asid=$1
	tstfile=$2
else
	echo usage $0 '<destination asid> <tst filename>'
	exit 1
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
if [[ -e $autotest/endpoint_configs/$dest_asid.sh ]]
then
	# The script does not expect dos format files
	dos2unix -n $autotest/endpoint_configs/$dest_asid.sh $autotest/endpoint_configs/temp.sh
	. $autotest/endpoint_configs/temp.sh
	rm $autotest/endpoint_configs/temp.sh
	#. $autotest/endpoint_configs/$dest_asid.sh
else
	echo "Unrecognised endpoint $dest_asid"
	if [[ "$TKW_BROWSER" != "" ]]
	then
		read -n 1 -p "Press any key to exit..."
		echo
	fi
	exit 1
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

if [[ "$TKW_BROWSER" != "" ]]
then
	read -n 1 -p "Press any key to continue..."
	echo
fi

# run the tests
$autotest/run_tst.sh $tst/$prefix'.tst'

# copy the tst file to the latest autotests folder
latest_autotest_folder=`ls -t $autotest/auto_tests | head -n 1`
cp $tst/$prefix'.tst' $autotest/auto_tests/$latest_autotest_folder/
# copy a statically named version for ease of debugging
cp $tst/$prefix'.tst' $autotest/tst/mergedfile.tst

# move the folder into a folder named for the asid
if [[ ! -e $autotest/auto_tests/$dest_asid ]]
then
	mkdir $autotest/auto_tests/$dest_asid
fi

mv $autotest/auto_tests/$latest_autotest_folder $autotest/auto_tests/$dest_asid/

cd $autotest/auto_tests/$dest_asid/
zip -qr $latest_autotest_folder'.zip'  $latest_autotest_folder/
cd -

# if there's a browser configured display the results
if [[ "$TKW_BROWSER" != "" ]]
then
	if [[ -e $autotest/auto_tests/$dest_asid/$latest_autotest_folder/test_log.html ]]
	then
		$TKW_BROWSER $autotest/auto_tests/$dest_asid/$latest_autotest_folder/test_log.html
	else
		echo Test log file $autotest/auto_tests/$dest_asid/$latest_autotest_folder/test_log.html not found
	fi
fi
