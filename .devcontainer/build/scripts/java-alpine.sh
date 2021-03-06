#!/bin/ash
#-------------------------------------------------------------------------------------------------------------
#    Syntax: ./java-alpine  #
#-------------------------------------------------------------------------------------------------------------
set -e

# Загрузите маркеры, чтобы увидеть, какие шаги уже выполнены
source "`dirname $0`"/marker_file.sh

#-------------------------------------------
#                   java 11                #
#-------------------------------------------
if [ "${JAVA_INSTALLED}" != "true" ]; then
  apk add --upgrade openjdk8-jre
  java -version
  Add_MARKER_FILE "JAVA_INSTALLED=true"
fi

echo "✔️  java-alpine Done!"
