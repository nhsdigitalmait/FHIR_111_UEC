#!/bin/bash
# generate cfg files and names tdv files one per slot

for f in {6..19}
do
	echo $f
	sed -e s/__SLOT_NO__/s$f/ -e s/__POSITION__/$(($f-4))/ < slots_free_template.cfg > extractor_configs/slots_free$f.cfg

	sed -i -e "/__ID__/s/.$/	__CONTENT_LENGTH__	__ETAG__	__LOCATION__	__LAST_MODIFIED__/" -e "/^s/s/.$/	_	_	_	_/" \
		extractor_configs/slot_$f.tdv
done
