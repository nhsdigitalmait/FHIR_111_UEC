#
#  Makefile for TKWATM test script generation and execution for GP Connect
#
#TSTP=EB_Common.tstp EB_SearchForFreeSlots.tstp
#TSTP=EB_Common.tstp EB_BookAppointment.tstp
#TSTP=EB_Common.tstp EB_Capability.tstp
#TSTP=EB_Common.tstp EB_CancelAppointment.tstp
TSTP=EB_Common.tstp EB_SearchForFreeSlots.tstp EB_BookAppointment.tstp EB_Capability.tstp EB_CancelAppointment.tstp

ROOT=$(TKWROOT)/config/FHIR_111_UEC/autotest_config
MERGEDTSTPFILE=$(ROOT)/mergedfile.tstp
MERGEDTSTFILE=$(ROOT)/tst/mergedfile.tst
AUTOTESTS=$(ROOT)/auto_tests

all: local

clean: 
	rm -f $(MERGEDTSTPFILE)

$(MERGEDTSTFILE) : $(MERGEDTSTPFILE) 

$(MERGEDTSTPFILE) : $(TSTP) Makefile
	#   <input folder> <output tst file> <script file name> <input tstp file>+
	java -cp $(TKWROOT)/TKWAutotestManager.jar TKWAutotestManager.TestFileMerger ./ $@ 111_uec $(TSTP)

local local_secure answer ingleborough xkcd xkcd_secure : $(MERGEDTSTPFILE)
	# change title of script
	sed -i $(MERGEDTSTPFILE) -r -e "s/SCRIPT .+/SCRIPT 111_uec_$@/"
	# transform the merged file to resolve substitution tags and run the script
	./transform.sh $@ $(MERGEDTSTPFILE)
	# copy the tst file to the auto_test folder
	export f=`ls -t $(AUTOTESTS) | head -n 1` ; \
	cp $(MERGEDTSTFILE) $(AUTOTESTS)/$${f}/
