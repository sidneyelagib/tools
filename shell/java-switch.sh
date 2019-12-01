#!/bin/bash
# This script is changing the java version and maven opts

# Colors
RED_COLOR="\033[0;31m"
NC="\033[0m"

# Java Versions
JDK7=$(/usr/libexec/java_home -v 1.7)
JDK8=$(/usr/libexec/java_home -v 1.8)
JDK11=$(/usr/libexec/java_home -v 11)

#JAVA_OPTS
BASE_JAVA_OPTS="-Xms256m -Xmx6g -XX:+PrintGCDetails -XX:+PrintClassHistogram -XX:+CMSPermGenSweepingEnabled -verbose:gc -XX:+HeapDumpOnOutOfMemoryError -XX:+UseStringCache -XX:+UseCompressedStrings -XX:+OptimizeStringConcat -XX:+AggressiveHeap -XX:+PrintVMOptions -XX:+UseGCLogFileRotation -d64 -XX:+UseStringDeduplication -XX:+UseStringCache -XX:+UseCompressedStrings -XX:+OptimizeStringConcat -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xss1m"

JAVA_OPTS_7="-Xms2g -Xmx6g -XX:PermSize=512m -XX:MaxPermSize=1g" 

JAVA_OPTS_DEFAULT="$BASE_JAVA_OPTS -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=1g  -XX:+UseG1GC"

MAVEN31_HOME="/opt/local/share/java/apache-maven-3.1.1"
MAVEN_DEFAULT_HOME="/opt/local/share/java/maven3"

#MVN_OPTS
JAVA7_MAVEN_OPTS="$BASE_MAVEN_OPTS -XX:PermSize=512m -XX:MaxPermSize=1g -Dhttps.protocols=TLSv1.2 -XX:+TieredCompilation -XX:TieredStopAtLevel=1"
DEFAULT_MAVEN_OPTS="$BASE_MAVEN_OPTS -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=1g -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

LAST_JAVA_HOME=$JAVA_HOME
LAST_M2_HOME=$M2_HOME

function finalizeSelection() {
    
    if [ -z "$LAST_JAVA_HOME" ];
    then
        export PATH="$JAVA_HOME/bin:$M2_HOME/bin:$PATH"    
    
    elif [ "$LAST_JAVA_HOME" != "$JAVA_HOME" ];
    then
        export PATH=${PATH//$LAST_JAVA_HOME/$JAVA_HOME}
        export PATH=${PATH//$LAST_M2_HOME/$M2_HOME}
    fi
    
    SELECTED_JAVA_VERSION=$(/usr/bin/java -version 2>&1 | grep -E "\d.\d.\d" | cut -d , -f 1 | colrm 1 13 | head -n 1| tr -d '"')
    SELECTED_MVN_VERSION=$(mvn -version | awk '{print $3}' | head -n 1)

    echo -e "Selected Java version is: ${RED_COLOR} $SELECTED_JAVA_VERSION ${NC}"
    echo -e "Selected Maven version is: ${RED_COLOR} $SELECTED_MVN_VERSION ${NC}"
}

case "$1" in
    "7")
        export JAVA_HOME=$JDK7
        export JAVA_OPTS=$JAVA_OPTS_7
        export MAVEN_OPTS=$JAVA7_MAVEN_OPTS
        export M2_HOME=$MAVEN31_HOME
        ;;
    "8")
        export JAVA_HOME=$JDK8
        export JAVA_OPTS=$JAVA_OPTS_DEFAULT
        export MAVEN_OPTS=$DEFAULT_MAVEN_OPTS
        export M2_HOME=$MAVEN_DEFAULT_HOME
        ;;    
    "custom")
        export JAVA_HOME=$(/usr/libexec/java_home -v $2)
        export JAVA_OPTS=$JAVA_OPTS_DEFAULT
        export MAVEN_OPTS=$DEFAULT_MAVEN_OPTS
        export M2_HOME=$MAVEN_DEFAULT_HOME
        ;;
    "ls")
        echo -e "Currently installed versions are:\n$(/usr/libexec/java_home -V 2>&1 | grep -E "\d.\d.\d" | cut -d , -f 1 | colrm 1 4 | grep -v Home)" 
        ;;
    *)
        echo "Unknown command, please type one of the follwoing":
        echo "java-switch 7 => to switch to java 7"
        echo "java-switch 8 => to switch to java 8"
        echo "java-switch 11 => to switch to java 11"
        echo "java-switch custom <number> => to switch to custom java version"
        echo "java-switch ls => to see the current java versions installed on the machine"
        ;;
esac 

finalizeSelection
