#!/bin/bash
# generate cfg files and names tdv files one per slot

TARGET=extractor_configs
NOW=`date`

for f in {6..12}
do
	echo $f
	# configure each extractor config file file with correct indices
	sed -e s/__SLOT_NO__/s$f/ \
		-e s/__POSITION__/$(($f-4))/ \
		-e "s/__NOW__/$NOW/" \
		< slots_free_template.cfg > $TARGET/slots_free$f.cfg

	#  append a field title and an underscore field data item to the associated tdv
	sed -i -e "/__ID__/s/$/	__APPT_SLOT_ID__	__APPT_IDENTIFIER_SYSTEM__	__APPT_IDENTIFIER_VALUE__	__APPT_SCHEDULE__	__APPT_STATUS__	__APPT_START_DATE__	__APPT_END_DATE__/" -e "/^s/s/$/	_	_	_	_	_	_	_/" $TARGET/slot_$f.tdv
done
