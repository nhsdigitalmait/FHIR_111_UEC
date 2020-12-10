#!/bin/bash
#
# invokes execution of tkw-x in autotest mode to test Emergency Booking providers
#
docker-compose -f docker-compose_consumer_simulator.yml run --rm tkw_uec_consumer_simulator $*
