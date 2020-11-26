#!/bin/bash
#
# invokes execution of tkw-x in autotest mode to test Emeregncy Booking providers
#
docker-compose -f docker-compose_provider_test.yml run --rm tkw_uec_provider_test $*
