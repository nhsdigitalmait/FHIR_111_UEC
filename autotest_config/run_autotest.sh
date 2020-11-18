#!/bin/bash
#  Script for TKWATM test script generation and execution for Emergency Booking
#
TSTP_FILES=EB_Common.tstp

case "$1" in
	A|a)
	TSTP_FILES+=' EB_Capability.tstp'
	;;

	S|s)
	TSTP_FILES+=' EB_SearchForFreeSlots.tstp'
	;;

	B|b)
	TSTP_FILES+=' EB_BookAppointment.tstp'
	;;

	C|c)
	TSTP_FILES+=' EB_CancelAppointment.tstp'
	;;

	*)
	TSTP_FILES+=' EB_Capability.tstp EB_SearchForFreeSlots.tstp EB_BookAppointment.tstp EB_CancelAppointment.tstp'
	;;
esac

ENVIRONMENT=local
SCRIPT_NAME=111_uec

ROOT=$TKWROOT/config/FHIR_111_UEC/autotest_config
MERGED_TSTP_FILE=$ROOT/mergedfile.tstp
AUTOTESTS=$ROOT/auto_tests
TSTP_FOLDER=./tstp/

#   <input folder> <output tst file> <script file name> <input tstp file>+
java -cp $TKWROOT/TKWAutotestManager.jar TKWAutotestManager.TestFileMerger $TSTP_FOLDER $MERGED_TSTP_FILE $SCRIPT_NAME $TSTP_FILES

# change title of script
sed -i $MERGED_TSTP_FILE -r -e 's/SCRIPT .+/SCRIPT '$SCRIPT_NAME'_'$ENVIRONMENT'/'

# transform the merged file to resolve substitution tags and run the script
./transform.sh $ENVIRONMENT $MERGED_TSTP_FILE
