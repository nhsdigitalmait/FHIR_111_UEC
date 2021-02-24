@echo off
rem
rem
if "%1" == "--version" (
	docker-compose -f docker-compose_provider_simulator.yml run --rm tkw_uec_provider_simulator %1
	exit 0
) else (
	if "%1" == "-d" (
		docker-compose -f docker-compose_provider_simulator.yml up -d
	) else (
		docker-compose -f docker-compose_provider_simulator.yml up
	)
)
