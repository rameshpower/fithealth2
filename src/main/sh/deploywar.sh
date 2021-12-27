#!/bin/bash
function deploywar() {
    sudo systemctl stop tomcat
    rm -rf $HOME/middleware/apache-tomcat-10.0.14/webapps/fithealth2*
    cp /tmp/fithealth2.war $HOME/middleware/apache-tomcat-10.0.14/webapps
    sudo systemctl start tomcat
    local DEPLOY_WAR_STATUS=$?
    return $DEPLOY_WAR_STATUS
}

#main program
deploywar
DEPLOY_WAR_STATUS=$?
if [ $DEPLOY_WAR_STATUS -ne 0 ]; then
echo "ERROR:failed deploying the war"
exit 103
fi