#!/bin/bash
SERVER_INPUT=$1
CMD=$2
SERVER_ENV=$3
METRICS_ENABLED=$4
TESTS_SKIP=$5
ENFORCER_SKIP=$6
MVN_PARAMS=$7
SERVICE_PARAMS=$8

SERVER_PORT="8080"
SERVER_DEBUG_PORT="8000"
DEFAULT_ENV="dev"
DEFAULT_MVN_PARAMS="-nsu -ff -T 1C -offline"

if [ -z "$SERVER_ENV" ]
then
    echo "No env provided, selecting dev"
    SERVER_ENV=$DEFAULT_ENV
fi

if [ -z "$METRICS_ENABLED" ]
then
    echo "No skipping metrics flags is provided, skipping by default"
    METRICS_ENABLED="false"
fi 

if [ -z "$TESTS_SKIP" ]
then
    echo "No skipping tests flags is provided, skipping by default"
    TESTS_SKIP="true"
fi

if [ -z "$MVN_PARAMS" ]
then
    echo "No maven params provided, using the default ones: $DEFAULT_MVN_PARAMS"
    MVN_PARAMS=$DEFAULT_MVN_PARAMS
fi

if [ -z "$SERVICE_PARAMS" ]
then
    echo "No Service params provided"
fi

case "$CMD" in
"build")
        mvn -f $SERVER_INPUT/pom.xml -Dgraphite.enabled=$METRICS_ENABLED -Dsignalfx.enabled=$METRICS_ENABLED -Dmaven.test.skip=$TESTS_SKIP clean install && mvn -Dbuild.env=$SERVER_ENV -f $SERVER_INPUT/configdata/pom.xml
    ;;
"start")
        
    ;;
"stop")
    ;;
"debug")
    ;;
esac