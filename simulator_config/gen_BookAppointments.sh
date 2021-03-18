#!/bin/bash

while IFS=, read -r tag message_id
do
	if [[ ! $tag =~ ^#.*$ ]]
	then
		echo $tag
		sed -e s/__MESSAGEID__/$message_id/ \
			< 111_UEC_Booking/BookAppointment_HappyPath_Response.xml  > 111_UEC_Booking/BookAppointment_HappyPath_$tag.xml
	fi
done < BookAppointment.csv
