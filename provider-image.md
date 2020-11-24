# 111 UEC Booking Test Provider Test Suite
This configuration will run suites of tests related to iscenarios in the scenario spreadsheet: https://github.com/nhsdigitalmait/FHIR_111_UEC/blob/master/Scenario_Schedule_spreadsheet/Scenario%20Schedule%20for%20Care%20Connect%20NHS%20111%20UEC%20Booking.xlsx

The scenarios are based upon the specifications: https://developer.nhs.uk/apis/nhsbooking-2.0.0-beta/index.html


FHIR Validation is performed by HAPI FHIR Validator v5.1.0 (https://hapifhir.io/hapi-fhir/docs/validation/introduction.html). The base profile validation is extended by use of a locally stored NHS Digital FHIR Profiles.

This config repository is driven from the command line and can execute groups of tests to specific ASIDs.

## Docker Volumes
This image relies on volumes for persistence of evidence and logging data and for access to NHS Digital FHIR profiles for validation.
#### Data Volume
All logs and validation reports are written to disk using the 'autotest_config/auto_tests' volume, separated into directories defined by the incoming 'toASID' header.
  The container when executed creates an internal user "service" (user ID 1000) and writes its output to local disk (in this example at /TKWROOT/config/FHIR_111_UEC/autotests_config/auto_tests).
  If the user ID who is executing the container is not 1000 the ACL permissions must be set to allow this user:

  ```
setfacl -m u:1000:rwx /home/host/data
```

#### FHIR Profile Volume
The NHS Digital FHIR Profiles are stored and accessed from the 'fhir' volume. 
  These profiles can be downloaded from the NHS Digital Simplifier site https://simplifier.net/NHSDigitalSTU3Assets/~packages. 
  The image has been tested using the profiles downloaded via the npm installation and relies on the package.json file for version discovery
  The fhir volume should be linked to the 'NHSD.Assets.STU3' directory where it expects to find:
    - .json versions of FHIR Profiles
    - package.json file containing versioning information
    - a sub-directory called examples which it will ignore


  ## Execution
  To execute the container, create a docker-compose_provider_test.yml file containing the following, updating the xxx/... directories as appropriate
  The test suite can then be run by executing the wrapper script run_provider_test.sh [<toAsid> [A|S|B|C]**]

  The optional test group names are defined as below:

  |Initial|Test Group|
  |-------|----------|
  |A|cApability|
  |S|Search For Free Slots|
  |B|Book Appointment|
  |C|Cancel Apppointment|

  ```

  #
  #  docker-compose file supporting a docker stack comprised of a 
  #  111_uec provider test suite instance 
  #
  version: "3"
  services:
    tkw_uec_provider_test:
      image: nhsdigitalmait/tkw_uec_provider_test:0.1
  
      environment:
        - TZ=Europe/London
  
      network_mode : "host"
  
      volumes:
          # <host path to mount> : <mount point within docker>
          # auto_tests folder
          - xxx/auto_tests:/TKW_ROOT/config/FHIR_111_UEC/autotest_config/auto_tests
          # endpoint_configs folder
          - xxx/endpoint_configs:/TKW_ROOT/config/FHIR_111_UEC/autotest_config/endpoint_configs
          # autotest logs folder
          - xxx/autotest_logs:/TKW_ROOT/config/FHIR_111_UEC/autotest_config/autotest_logs

  ```

  ## Use

n.b. The FHIR validation is done using HAPI FHIR Validation libraries and loading the FHIR profiles (both core and NHS Digital ones) takes processing time, the majority of which happens on the first validation after starting the docker image. This can mean (depending on the speed of the hardware being used) that the log may report errors such as 
```
SEVERE: Location: uk.nhs.digital.mait.tkwx.http.RequestReader : Message: Exception creating request on socket 0.0.0.0:4434 from 172.18.0.1, request processing exiting: 
Socket is closed

SEVERE: Location: uk.nhs.digital.mait.tkwx.http.RequestReader : Message: ... socket output stream dead). 
```
These can be ignored as the validation is done in a separate thread and this error has no bearing on the server response or validation

  ## Versions:
  0.1: This is the initial build
