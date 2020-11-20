#!/bin/bash
#
#  Script for TKWATM test script generation and execution for Emergency Booking
#
#  usage ./run_autotest.sh [<environment> <A|S|B|C|>*]
#
#  A => Capability
#  S => Search for free slots
#  B => Book appointment
#  C => Cancel appointment
#  No Parameter => All
#
TSTP_FILES=EB_Common.tstp

ENVIRONMENT=local   # acts as a label for an endpoint config in endpoint_configs
if [[ $# != 0 ]]
then
	ENVIRONMENT=$1
	shift
fi

if [[ $# == 0 ]]
then
	TSTP_FILES+=' EB_Capability.tstp EB_SearchForFreeSlots.tstp EB_BookAppointment.tstp EB_CancelAppointment.tstp'
else
	for t in $*
	do
		case "$t" in
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
		esac
	done
fi

SCRIPT_NAME=111_uec

ROOT=$TKWROOT/config/FHIR_111_UEC/autotest_config
MERGED_TSTP_FILE=$ROOT/mergedfile.tstp
TSTP_FOLDER=$ROOT/tstp/

# merge the tstp files into a single file
#   <input folder> <output tst file> <script file name> <input tstp file>+
java -cp $TKWROOT/TKWAutotestManager.jar TKWAutotestManager.TestFileMerger $TSTP_FOLDER $MERGED_TSTP_FILE $SCRIPT_NAME $TSTP_FILES

# change title of merged tstp script
sed -i $MERGED_TSTP_FILE -r -e 's/SCRIPT .+/SCRIPT '$SCRIPT_NAME'_'$ENVIRONMENT'/'

# transform the merged file into a tst file to resolve substitution tags and then runs the script
$ROOT/apply_configs.sh $ENVIRONMENT $MERGED_TSTP_FILE
