#!/bin/bash
# generate cfg files and names tdv files one per slot

for f in {5..19}
do
	echo $f
	# configure each extractor config file file with correct indices
	sed -e s/__SLOT_NO__/s$f/ -e s/__POSITION__/$(($f-4))/ < slots_free_template.cfg > extractor_configs/slots_free$f.cfg

	#  append a field title and an underscore field data item to the associated tdv
	#sed -i -e "/__ID__/s/$/	__APPT_ID__/" -e "/^s/s/$/	_/" extractor_configs/slot_$f.tdv
done
