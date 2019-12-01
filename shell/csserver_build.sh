#!/bin/bash
# This scripts builds CS

CMD=${1:=build}
MVN_PARAMS=${2:-"-ff -T 1C"}
VERBOSE=${3:-/dev/stdout}
BUILD_ENV=${4:-"beta"}
SKIP_TESTS=${5:-true}
ENFORCER_SKIP=${6:-true}
PUPPET_SKIP=${6:-true}

SERVER_NAME="csserver"
JDK_VERSION=7
BOOT2SFLY_EXEC="/dist/ws/release/boot2shutterfly/b2s"
PERFORCE_HOME="/dist/source"
CSTOOL_SOURCE="$PERFORCE_HOME/SFLY/main/cstool/pom.xml"
CSSERVER_HOME="$PERFORCE_HOME/Web/Server/main/pom.xml"
RED_COLOR="\033[0;31m"
NC="\033[0m"

function init() {
    echo "Verbose dir is: $VERBOSE"

    # Setting Java
    source `dirname $0`/java-switch.sh $JDK_VERSION

    JDK_VERSION=$(/usr/bin/java -version 2>&1 | grep -E "\d.\d.\d" | cut -d , -f 1 | colrm 1 13 | head -n 1)

    if [[ "$VERBOSE" == "/dev/null" ]];
    then
        echo "No verbose param is selected, it won't show details"
        VERBOSE="/dev/null"
    fi
}

function build() {
    echo "Building CSServer with following params: -Dserver.name=$SERVER_NAME, -Dserver.env=$BUILD_ENV, -Dmaven.test.skip=$SKIP_TESTS, -Denforcer.skip=$ENFORCER_SKIP, JDK_VERSION=$JDK_VERSION, JAVA_OPTS=($JAVA_OPTS), MAVEN_OPTS=($MAVEN_OPTS)"

    mvn $MVN_PARAMS -Dmaven.test.skip=$SKIP_TESTS -Denforcer.skip=$ENFORCER_SKIP -f $CSTOOL_SOURCE clean install &> $VERBOSE && mvn $MVN_PARAMS -Dmaven.test.skip=$SKIP_TESTS -Denforcer.skip=$ENFORCER_SKIP -Dserver.name=$SERVER_NAME -Dserver.env=$BUILD_ENV -Dpuppet.skip=$PUPPET_SKIP -f $CSSERVER_HOME clean install &> $VERBOSE
}

function cleanup() {
    # Setting Java8
    source `dirname $0`/java-switch.sh 8
}

function menu() {
    case "$CMD" in
    "build")

        # Initializing variables and the required java version
        init
        build
        
        if [ $? -eq 0 ]; then
            echo "Build was successful"
        else
            echo "Something went wrong."
            exit 1
        fi
        ;;
    "start") 
        sudo $BOOT2SFLY_EXEC start cs remote
        ;;
    "run")
         build
         sudo $BOOT2SFLY_EXEC start cs remote 
        ;;     
    *)
        echo -e "${RED_COLOR}csserver build dev true true${NC} will run the build of cstool and csserver with the skipping the tests, and skipping the enforcer plugin"
        ;;
esac
}

menu
cleanup
