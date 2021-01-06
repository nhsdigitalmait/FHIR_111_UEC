# Autotest endpoint config file
#
# to local clear
to_ep=http://localhost:4434/STU3
#to_ep=http://localhost/STU3

# to local secure
#to_ep=https://localhost:4431/STU3
# to local via reverse proxy
#to_ep=http://192.168.1.112/STU3

# defaults
#toasid=200000000359
#fromasid=200000000359
sendtls=No
truststore=/TKW_ROOT/config/FHIR_111_UEC/autotest_config/endpoint_configs/certs/opentest.jks
keystore=/TKW_ROOT/config/FHIR_111_UEC/autotest_config/endpoint_configs/certs/vpn-client-1003.opentest.hscic.gov.uk.jks
