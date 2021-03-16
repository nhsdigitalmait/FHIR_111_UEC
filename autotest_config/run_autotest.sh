#!/bin/bash
#
#  Script for TKWATM test script generation and execution for Emergency Booking
#
#  usage ./run_autotest.sh --version | ( -s  <environment> [<testname> *]) |  ( [<environment> <A|S|B|C|>*] )
#
#  A => Capability
#  S => Search for free slots
#  B => Book appointment
#  C => Cancel appointment
#  No Parameter => All
#

usage() 
{
	echo usage: $0 '--version |  ( -s  <environment> [<testname> *]) |  ( [<environment> <A|S|B|C|>*] )'
	exit 1
}

VERSION_FILE=$TKWROOT/config/FHIR_111_UEC/version_string.txt
if [[ "$1" == "--version" ]]
then
	if [[ -e $VERSION_FILE ]]
	then
		cat $VERSION_FILE
	fi
	java -jar $TKWROOT/TKW-x.jar -version | grep -v "starting on"
	exit 
fi

TSTP_FILES=EB_Common.tstp

if [[ "$1" == '-s' ]]
then
	OPTION=$1
	shift
fi

# local
ENVIRONMENT=200000000359   # acts as a label for an endpoint config in endpoint_configs
if [[ $# != 0 ]]
then
	ENVIRONMENT=$1
	shift
fi

if [[ "$OPTION" == '-s' || $# == 0 ]]
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
			*)
			echo "unrecognised group parameter $t"
			exit 1
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


if [[ "$OPTION" == '-s' ]]
then
	# create an exclamation mark separated string containging all the tests
	valid_tests=`sed -r -e '1,/BEGIN SCHEDULES/d' -e '/END SCHEDULES/,$d' -e 's/\s+.*$/!/' <  $MERGED_TSTP_FILE`
	valid_tests=`echo $valid_tests | sed -e 's/\s*//g'`
	#
	#  remove unselected tests
	#
	for test in $*
	do
		if [[  $valid_tests =~ ((^|!)$test($|!)) ]]
		then
			TESTS+='|'$test
		else
			echo "Unrecognised test $test"
			exit
		fi
	done
	# post edit to filter out any tests not specified
	sed -i -r -e '/BEGIN SCHEDULES/,/END SCHEDULES/s/^/#/' -e "s/^#(BEGIN|END$TESTS) /\1 /" $MERGED_TSTP_FILE
fi


# transform the merged file into a tst file to resolve substitution tags and then runs the script
$ROOT/apply_configs.sh $ENVIRONMENT $MERGED_TSTP_FILE
