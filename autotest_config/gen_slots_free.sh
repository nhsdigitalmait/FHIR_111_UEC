#!/bin/bash
# generate cfg files and names tdv files one per slot

for f in {5..19}
do
	echo $f
	sed -e s/__SLOT_NO__/s$f/ -e s/__POSITION__/$(($f-4))/ < slots_free_template.cfg > extractor_configs/slots_free$f.cfg

	sed -i -e "/__ID__/s/$/	__APPT_ID__/" -e "/^s/s/$/	_/" \
		extractor_configs/slot_$f.tdv
done
