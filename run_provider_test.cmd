@echo off
rem
rem invokes execution of tkw-x in autotest mode to test Emeregncy Booking providers
rem
docker-compose -f docker-compose_provider_test.yml run --rm tkw_uec_provider_test %*
