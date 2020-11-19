#!/bin/bash
# generate cfg files and names tdv files one per slot

TARGET=extractor_configs
NOW=`date`

for f in {5..19}
do
	echo $f
	# configure each extractor config file file with correct indices
	sed -e s/__SLOT_NO__/s$f/ \
		-e s/__POSITION__/$(($f-4))/ \
		-e "s/__NOW__/$NOW/" \
		< slots_free_template.cfg > $TARGET/slots_free$f.cfg

	#  append a field title and an underscore field data item to the associated tdv
	#sed -i -e "/__ID__/s/$/	__APPT_ID__/" -e "/^s/s/$/	_/" $TARGET/slot_$f.tdv
done
