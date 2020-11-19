#!/bin/bash
#
#  convert a tstp file into a tst file
#

for f in $*
do
	echo $f
	sed -e s!__TKWROOT__!$TKWROOT!g < $f > `basename $f .tstp`.tst
done
