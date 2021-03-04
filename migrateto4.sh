#!/bin/bash
#
# migrate EB consumer configs to 0.4 
#
# added a backup suffix
OPTION=-i.old
OPTION=

SOURCE=/TKW_ROOT
DEST=/home/service/TKW

TAG_SUFFIX=              # local
TAG_SUFFIX=-1004         # eb server

find autotest_config/endpoint_configs -name '[0-9]*.sh' -print -exec sed $OPTION -e s!$SOURCE!$DEST! {} \;
find . -name docker-compose_consumer_simulator.yml -print -exec sed $OPTION -e s!$SOURCE!$DEST! -e s/0.3$TAG_SUFFIX/0.4$TAG_SUFFIX/ {} \;
