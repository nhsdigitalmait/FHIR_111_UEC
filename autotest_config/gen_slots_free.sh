#!/bin/bash
# generate cfg files and names tdv files one per slot

for f in {5..19}
do
	echo $f
	sed -e s/__SLOT_NO__/s$f/ -e s/__POSITION__/$(($f-4))/ < slots_free_template.cfg > extractor_configs/slots_free$f.cfg
	cp slots.tdv extractor_configs/slot_$f.tdv
done
