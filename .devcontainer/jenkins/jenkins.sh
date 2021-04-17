#! /bin/bash

#-----------------------------------------------
# .env REF
# apk add curl openjdk11
#  https://github.com/LazyTechW/jenkins    #
#---------------------------

USERNAME=${1:-"vscode"}
USER_GROUP=${2:-"vscode"}
REF=${3:-"/usr/share/jenkins/ref"}
JENKINS_HOME=${4:-"/var/jenkins_home"}

set -e

#-------------------------------------------
#                   JENKINS_HOME           #
#-------------------------------------------
mkdir -p $JENKINS_HOME
chown -R ${USERNAME}:${USER_GROUP} "$JENKINS_HOME"

#-------------------------------------------
#                   REF                   #
#-------------------------------------------
echo ">> create user and group"
mkdir -p "${REF}"
chown -R ${USERNAME}:${USER_GROUP} "$REF"

echo ">> create folders"
mkdir -p "${REF}/init.groovy.d"
chmod -R 777 ${REF}/init.groovy.d

chown -R ${USERNAME} "$JENKINS_HOME" "$REF"
#-------------------------------------------
#        jenkins.war                       #
#-------------------------------------------
JENKINS_VERSION=2.278
JENKINS_URL="https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war"
echo "$JENKINS_VERSION"
echo ">> download and check jenkins war file"
curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war
#-------------------------------------------
#       jenkins-plugin-manager             #
#-------------------------------------------
echo ">> download and check jenkins-plugin-manager war file"
PLUGIN_CLI_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.9.0/jenkins-plugin-manager-2.9.0.jar
curl -fsSL ${PLUGIN_CLI_URL} -o /usr/lib/jenkins-plugin-manager.jar
#-------------------------------------------
#       jenkins /usr/local/bin/            #
#-------------------------------------------
echo ">> jenkins-support"
curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support -o /usr/local/bin/jenkins-support
chmod +x /usr/local/bin/jenkins-support

echo ">> jenkins.sh"
curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh -o /usr/local/bin/jenkins.sh
chmod +x /usr/local/bin/jenkins.sh

echo ">> install-plugins.sh"
curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh -o /usr/local/bin/install-plugins.sh
chmod +x /usr/local/bin/install-plugins.sh


echo ">> chown /usr/local/bin/"
chown ${USERNAME}:${USER_GROUP} /usr/local/bin/*.sh
chown ${USERNAME}:${USER_GROUP} /usr/local/bin/jenkins-support
#-------------------------------------------
#               jenkins plugin             #
#-------------------------------------------
echo ">> chown /usr/share/jenkins"
chown -R ${USERNAME}:${USER_GROUP} /usr/share/jenkins

echo ">> copy plugins.txt"
cp /tmp/install/config/plugins.txt /usr/share/jenkins/plugins.txt
chown ${USERNAME}:${USER_GROUP} /usr/share/jenkins/plugins.txt

#chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins/
#chmod -R 777 /usr/share/jenkins/ref/plugins/
