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

exit
while IFS=, read -r tag doc_ref doc_ref_identifier si sv sr ss se
do
	if [[ ! $tag =~ ^#.*$ ]]
	then
		echo $tag
		sed -e s/__DOC_REF__/$doc_ref/ \
			-e s/__DOC_REF_IDENTIFIER__/$doc_ref_identifier/ \
			-e s/__SI__/$si/ \
			-e s/__SV__/$sv/ \
			-e s/__SR__/$sr/ \
			-e s/__SS__/$ss/ \
			-e s/__SE__/$se/ \
			< 111_UEC_Booking/RetrieveAppointment_HappyPath_Response.xml  > 111_UEC_Booking/RetrieveAppointment_HappyPath_$tag.xml
	fi
done < RetrieveAppointment.csv

