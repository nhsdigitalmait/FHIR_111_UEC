#!/bin/bash
# generate cfg files and names tdv files one per slot

TARGET=extractor_configs
NOW=`date`

for f in {5..20}
do
	echo $f
	# configure each extractor config file file with correct indices
	sed -e s/__SLOT_NO__/s$f/ \
		-e s/__POSITION__/$(($f-4))/ \
		-e "s/__NOW__/$NOW/" \
		< slots_free_template.cfg > $TARGET/slots_free$f.cfg

	#  append 7 field titles and underscores for field data item to the associated tdv
	#sed -i -e "/__ID__/s/$/	__APPT_SLOT_ID__	__APPT_IDENTIFIER_SYSTEM__	__APPT_IDENTIFIER_VALUE__	__APPT_SCHEDULE__	__APPT_STATUS__	__APPT_START_DATE__	__APPT_END_DATE__/" $TARGET/slot_$f.tdv
	#sed -i -e "/^s/s/$/	_	_	_	_	_	_	_/" $TARGET/slot_$f.tdv

	#  append 1 field title and underscore for field data item to the associated tdv
	#sed -i -e "/__ID__/s/$/	__APPT_CREATED__/" $TARGET/slot_$f.tdv
	#sed -i -e "/^s/s/$/	_/" $TARGET/slot_$f.tdv

	#  append 1 field title and underscore for field data item to the associated tdv
	#sed -i -e "/__ID__/s/$/	__CORRELATION_ID__/" $TARGET/slot_$f.tdv
	#sed -i -e "/^s/s/$/	_/" $TARGET/slot_$f.tdv
done
